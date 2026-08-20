# Azeem Publications — Backend Design Doc (Django + DRF)

> Design doc only — no runnable Python code. This is the contract a from-scratch Django/DRF backend must satisfy so that flipping `AppConfig.isMockMode` from `true` to `false` in the existing Flutter app is a **zero-Dart-code-change** operation. Every model, endpoint, and JSON shape below is cross-referenced against the actual implemented Flutter code (`lib/domain/**/entities`, `lib/data/**/models/*_dto.dart`, `lib/core/network/api_endpoints.dart`, `lib/domain/common/failure.dart`), not just `project_spec.md` prose — see the **Gaps & Risks** callouts throughout for places where the two disagree today.

---

## 1. App Breakdown

| Django app | Owns (§9.2 entities) | Notes |
|---|---|---|
| `accounts` | `User` (abstract base, not a table — see §2.1), `Teacher`, `Student`, `Salesman`, `Admin` | OTP auth lives here too — it's a `User`-scoped concern, not a separate app |
| `catalog` | `BoardClass`, `Subject`, `Chapter`, `Campus`, `Test`, `Question` | Pure reference data + Admin-authored content. `Campus` is **independent** of `Test`/`Chapter` — confirmed no `campusId` anywhere in the catalog schema (a deliberate correction from the original spec read: an Admin uploads generic tests app-wide, not per-campus) |
| `tests` | `TestAttempt`, `SubmissionAnswer`, `LiveTestRegistration` | Grading logic (MCQ auto-grade, keyword-overlap text grade) and the weak/strong-chapter computation run here, mirroring `lib/domain/test_taking/usecases/` |
| `commerce` | `Cart`, `CartItem`, `Payment`, `EarningsRecord` | Owns the purchase-gate and commission-attribution business rules (§4.6) — **not** to be trusted from client input |
| `notifications` | `Notification` | Single generic model, fanned out to all 4 roles via `recipientRole` |

---

## 2. Models

### 2.1 User / Teacher / Student inheritance strategy

The Flutter side flattens `User`'s base fields (`id, name, phoneNumber, role, isDeleted, createdAt, updatedAt`) directly into `Teacher` and `Student` with **no class inheritance** — this is purely a side effect of the `freezed` Clean-Architecture convention this codebase uses (flat, single-constructor entities; no OOP inheritance in the domain layer). It is **not** a data-modeling requirement, and the Django schema should not copy it.

**Recommendation: Django multi-table inheritance**, with `User` as a concrete base model (not `abstract = True`) and `Teacher(User)` / `Student(User)` / `Salesman` as related tables:

```
User (concrete base table)
├── id, name, phone_number, role, is_deleted, created_at, updated_at
├── Teacher (OneToOne PK → User, multi-table inheritance)
│   └── campus, subjects (M2M), classes (M2M, nullable), declared_student_count,
│       salesman (FK, nullable), onboarding_source, approval_status,
│       actual_earnings, projected_earnings
└── Student (OneToOne PK → User, multi-table inheritance)
    └── campus, board_class (FK, nullable), cart (OneToOne, nullable)
        # subject_enrollments is the reverse FK from SubjectEnrollment, not a column
```

`Salesman` does **not** extend `User` per §9.2 (it has its own `id`/`name`/`createdAt` plus a `uniqueCode` login credential, no `phoneNumber`/`role`/`isDeleted` — it's structurally distinct). Model it as a standalone table. `Admin` is also standalone (`id`, `name`, `role: admin`, `createdAt`, no self-service signup — seeded via Django admin/migration, never a public endpoint).

**Why multi-table inheritance over a single-table `role` discriminator:** `Teacher` and `Student` have disjoint field sets (a `Student` has no `actualEarnings`, a `Teacher` has no `boardClassId`) with several required-vs-nullable differences per role. A single wide table would force every `Teacher`-only column to be nullable even though it's `required: true` on the `Teacher` schema, silently weakening the constraint DRF/Postgres could otherwise enforce. Multi-table inheritance keeps each role's `required`/`nullable` split exactly as strict as §9.2 specifies, at the cost of one extra join per Teacher/Student read — acceptable here since neither table is queried at a scale where that join matters.

**Why the JSON output must still be flat regardless:** whichever Django strategy is chosen, the DRF serializer for `Teacher`/`Student` must flatten the inherited `User` fields into the same top-level JSON object the Flutter `TeacherDto`/`StudentDto` already expect (`{"id": ..., "name": ..., "phoneNumber": ..., "role": ..., "campusId": ..., ...}` — one flat object, no nested `"user": {...}` sub-object). This is a serializer-level concern (`TeacherSerializer(ModelSerializer)` reading through the `user_ptr` relation via explicit field declarations or `source=` mappings), independent of how the tables themselves are related.

### 2.2 Full model list (18 entities, field-exact against §9.2 and the final schema-auditor sweep)

| Model | Key fields (type, null?, FK) |
|---|---|
| `User` | `id: UUID/PK`, `name: CharField(120)`, `phone_number: CharField, unique`, `role: CharField(choices=[teacher,student,salesman])`, `is_deleted: BooleanField(default=False)`, `created_at/updated_at: DateTimeField` |
| `Admin` | `id, name, role: CharField(choices=[admin]), created_at` — no self-signup, seeded only |
| `Teacher` | `campus: FK(Campus)`, `subjects: M2M(Subject)`, `classes: M2M(BoardClass, null=True)`, `declared_student_count: IntegerField(null=True)`, `salesman: FK(Salesman, null=True)`, `onboarding_source: CharField(choices=[azeemDeveloper,salesmanSeeded,selfSignup])`, `approval_status: CharField(choices=[approved,pendingAdminApproval])`, `actual_earnings: DecimalField(default=0)`, `projected_earnings: DecimalField(null=True)` |
| `Student` | `campus: FK(Campus)`, `board_class: FK(BoardClass, null=True)` (choices: `9th`, `Matric`, `1st year`, `2nd year`), `stream: CharField(choices=[preEngineering,preMedical,iCom,fa,ics], null=True)` (mandatory if `1st year`/`2nd year`), `cart: OneToOne(Cart, null=True)` (`subject_enrollments` = reverse FK) |
| `Salesman` | `id, name, unique_code: CharField(unique=True)`, `teachers: reverse FK from Teacher.salesman`, `created_at` |
| `BoardClass` | `id, name (9th, Matric, 1st year, 2nd year), is_enabled: BooleanField(default=False)` |
| `Subject` | `id, name, board_class: FK(BoardClass)` |
| `Chapter` | `id, subject: FK(Subject), title, order: IntegerField` (1-based; `order==1` is the free-sample chapter) |
| `Campus` | `id, name, city` |
| `Test` | `id, title, kind: CharField(choices=[subjectWiseGuessPaper,subjectWiseSimplePaper,chapterWise])`, `board_class: FK`, `subject: FK`, `chapter: FK(null=True)`, `is_live: BooleanField(default=False)`, `live_date: DateTimeField(null=True)`, `is_free_sample: BooleanField(default=False)`, `created_by_admin: FK(Admin)`, `created_at` — **no `campus` FK, no `price` field** (confirmed absent on the Flutter entity both times) |
| `Question` | `id, test: FK(Test), chapter: FK(Chapter), type: CharField(choices=[mcq,shortAnswer,longAnswer])`, `question_text`, `options: JSONField(null=True)`, `correct_option_index: IntegerField(null=True)`, `expected_answer: TextField(null=True)` |
| `TestAttempt` | `id, student: FK, test: FK, score_percent: FloatField, weak_chapter_ids: JSONField(null=True)` (list of Chapter FKs), `strong_chapter_ids: JSONField(null=True)`, `duration_seconds: IntegerField(null=True)`, `is_live_test_attempt: BooleanField(default=False)`, `attempted_at: DateTimeField` (`answers` = reverse FK from `SubmissionAnswer`) |
| `SubmissionAnswer` | `id, attempt: FK(TestAttempt), question: FK(Question), answer_text: TextField(null=True)`, `selected_option_index: IntegerField(null=True)`, `is_correct: BooleanField(null=True)`, `solution_explanation: TextField(null=True)`, `graded_by_ai: BooleanField(default=False)` |
| `SubjectEnrollment` | `student: FK, subject: FK, teacher: FK(null=True), discount_applied: BooleanField(default=False)` — **app-layer invariant, not just a DB default**: `discount_applied` must only ever be `True` when `teacher_id is not None` (enforce with a `CheckConstraint`, not just serializer validation) |
| `EarningsRecord` | `id, teacher: FK(null=True), salesman: FK(null=True), student: FK, amount: DecimalField, trigger_event: CharField(choices=[paidPackPurchase]), created_at` |
| `Notification` | `id, recipient_id: CharField` (polymorphic — not a real FK since it can point at Teacher/Student/Salesman/Admin), `recipient_role: CharField(choices=[admin,teacher,student,salesman])`, `type: CharField(choices=[studentRegistered,profileUpdatePending,teacherAwaitingApproval,newTestUploaded,discountAnnouncement,liveTestReminder])`, `message: TextField, is_read: BooleanField(default=False), created_at` |
| `Cart` | `id, student: OneToOne, total_amount: DecimalField(default=0)` (`items` = reverse FK from `CartItem`) |
| `CartItem` | `cart: FK, test: FK, price: DecimalField, discounted_price: DecimalField(null=True)` |
| `Payment` | `id, student: FK, amount: DecimalField, status: CharField(choices=[pending,success,failed])`, `gateway_reference: CharField(null=True), created_at` |
| `LiveTestRegistration` | `id, student: FK, test: FK, registered_at: DateTimeField, final_score: FloatField(null=True)`, `timing_seconds: IntegerField(null=True), prize_rank: IntegerField(null=True)` — `final_score`/`timing_seconds`/`prize_rank` are schema-present but **write paths for them don't exist yet anywhere in Flutter** (Phase-1 explicitly excludes leaderboard UI); backend should accept them as nullable and simply not populate them until a Phase-2 grading pipeline exists |

**`Admin`/`Salesman` FK note**: neither has a Flutter entity (confirmed — no `lib/domain/admin/` or `lib/domain/salesman/` directory exists anywhere in the app, correctly out of scope per the locked Phase-1 plan). Their Django tables must still exist, because `Teacher.salesman_id`, `Test.created_by_admin_id`, and `EarningsRecord.salesman_id` are real foreign keys that need a real table to reference — they're just never exposed through any endpoint this Flutter app calls.

---

## 3. Serializers / Viewsets Plan (DRF)

**Critical dependency: `djangorestframework-camel-case`.** Every `*_dto.dart` file in this codebase uses `json_serializable` with **no `fieldRename` override** (confirmed by grepping every DTO — none declare `@JsonSerializable(fieldRename: FieldRename.snake)`), meaning Dart's camelCase field names (`phoneNumber`, `boardClassId`, `isFreeSample`, `scorePercent`, ...) are serialized to JSON **verbatim as camelCase**. DRF's `ModelSerializer` defaults to snake_case (`phone_number`) matching Django's own field-naming convention. Without a camelCase-conversion layer, every response body would need per-field `source=`/rename boilerplate on every serializer — instead, install `djangorestframework-camel-case` and wrap `DEFAULT_RENDERER_CLASSES`/`DEFAULT_PARSER_CLASSES` with `CamelCaseJSONRenderer`/`CamelCaseJSONParser` globally in `settings.py`. This is a real dependency decision, not optional polish — without it, `AppConfig.isMockMode = false` does NOT work as a zero-code flip.

Per-model pattern (illustrative, not exhaustive — every model above gets the same shape):

- `ModelSerializer` per model, with nested read serializers for one-to-many children (e.g. `TestAttemptSerializer` nests `SubmissionAnswerSerializer(many=True)` under `answers`, matching `TestAttemptDto.answers: List<SubmissionAnswerDto>`).
- `ModelViewSet` or targeted `APIView`s per the endpoint list in §4 — most endpoints here are **not** plain CRUD (they're role-scoped sub-resource reads like `/teachers/{id}/students`), so hand-written `APIView`/`GenericAPIView` subclasses per endpoint will map more directly to `ApiEndpoints` than a router-generated `ModelViewSet` would.
- Permission classes: `IsAuthenticated` + a custom `IsOwnerOrReadOnly`-style check keyed off the JWT's embedded `role`/`user_id` for every `{studentId}`/`{teacherId}`-scoped path — a student must never be able to read another student's cart/progress/attempts by guessing an id in the URL.

---

## 4. API Contract

Base path assumed: `/api/v1` (not yet declared anywhere in the Flutter `AppConfig.apiBaseUrl` — it's an empty/placeholder value today, so this prefix is a recommendation, confirm with whoever owns deployment before finalizing).

### 4.1 Auth

| Endpoint (`ApiEndpoints`) | Method | Request | Response | Errors |
|---|---|---|---|---|
| `/auth/otp/request` | POST | `{"phoneNumber": string, "role": "teacher"\|"student"}` | `AuthSession` stub: `{"userId": string?, "role": ..., "phoneNumber": ..., "token": null}` | `ValidationFailure` (400, malformed phone), `NotFoundFailure` (404, unknown role/phone combo — **only if OTP-request-for-unregistered-user is meant to fail**; see open item on signup-vs-login OTP semantics) |
| `/auth/otp/verify` | POST | `{"phoneNumber": string, "otp": string, "role": string}` | Full `AuthSession` with non-null `token` (JWT) | `ValidationFailure` (400, wrong OTP), `UnauthorizedFailure` (401, expired/locked-out) |

### 4.2 Catalog (read-only from this app's perspective — Admin writes are out of scope)

| Endpoint | Method | Response |
|---|---|---|
| `/catalog/board-classes` | GET | `BoardClass[]` |
| `/catalog/subjects?boardClassId=` | GET | `Subject[]` |
| `/catalog/chapters?subjectId=` | GET | `Chapter[]` |
| `/catalog/campuses` | GET | `Campus[]` |
| `/catalog/tests?subjectId=&chapterId=` | GET | `Test[]` (both query params optional — omitting both returns the full catalog, matching `CatalogDummyDataSource`'s "no args = all tests" fallthrough that `cartTestsByIdProvider` relies on) |
| `/catalog/questions?testId=` | GET | `Question[]` |

### 4.3 Teacher

| Endpoint | Method | Notes |
|---|---|---|
| `/teachers/{id}` | GET / PUT / DELETE | GET = profile read; PUT = `teacher-profile`'s edit (name/phone only — reject attempts to change `campusId`/`subjects`/`approvalStatus`/earnings fields server-side even if present in the body); DELETE = soft-delete (`is_deleted=True`), **not** a real row deletion |
| `/teachers/{id}/overview` | GET | Stat-card summary (`teacher-overview`) |
| `/teachers/{id}/students` | GET | Every `Student` with a `SubjectEnrollment.teacherId == id` (`teacher-students`) |
| `/teachers/{id}/earnings` | GET | `EarningsRecord[]` for this teacher — **see §4.6, this must be GET-only in production; the client-facing POST variant the current Flutter code calls must not be trusted** |

**Gap found**: `ApiEndpoints` has no constant for "look up teacher by phone" (used during teacher OTP login to distinguish salesman-seeded vs. self-signup) or "teacher signup." The actual `TeacherRemoteDataSourceImpl` hardcodes `GET /teachers?phoneNumber=` and `POST /teachers/signup` inline, with an explicit code comment flagging these should be promoted to real `ApiEndpoints` constants once that file is available to edit. Backend should implement both paths:
- `GET /teachers?phoneNumber={phone}` → `Teacher | null` (used to skip signup for salesman-seeded teachers)
- `POST /teachers/signup` → creates a `Teacher` with `approvalStatus: pendingAdminApproval`, `onboardingSource: selfSignup`

### 4.4 Student

| Endpoint | Method | Notes |
|---|---|---|
| `/students/{id}` | GET / PUT / DELETE | PUT is **upsert**-shaped in the current Flutter contract — `student-onboarding`'s "complete onboarding" step PUTs the full `Student` object to `studentById(id)` with no separate `POST /students` create endpoint. Backend must treat this PUT as create-or-update (the `id` is already known client-side, issued at OTP-verify time). `student-profile`'s edit reuses the same PUT for name/phone only — same "don't trust client-sent read-only fields" rule as Teacher |
| `/students/{id}/cart` | GET / POST / DELETE | GET = read cart; POST = add item (body: `CartItemDto`, response: updated `Cart`); DELETE with `?testId=` query param = remove item, response: updated `Cart`. **No per-item sub-resource** — confirmed the Flutter `CartRemoteDataSource` deliberately models add/remove against the cart resource itself, not `/students/{id}/cart/items/{itemId}` |
| `/students/{id}/progress` | GET | Reserved in `ApiEndpoints` but **not actually called by any current datasource** — `student-progress` instead reuses `/students/{id}/test-attempts` directly and computes the pie-chart summary client-side from `TestAttempt.weakChapterIds`/`strongChapterIds`. Backend can either leave this unimplemented for now or pre-aggregate the same summary server-side as a future optimization — not required for Phase-1 parity |
| `/students/{id}/subject-enrollments` | PUT | Persists the onboarding subject/teacher selections (`SubjectEnrollment[]`) |
| `/students/{id}/test-attempts` | GET | Every `TestAttempt` for this student, newest first (`student-progress`, `teacher-students`' per-student detail) |

### 4.5 Tests / Attempts / Live

| Endpoint | Method | Request / Response |
|---|---|---|
| `/tests/{id}/submit` | POST | Request: full `TestAttempt` (client has already graded MCQs locally and run the keyword-overlap text grader — see §4.6 for why this must be **re-validated**, not trusted verbatim). Response: the persisted `TestAttempt` |
| `/live-tests/register` | POST | `{"studentId": string, "testId": string}` → `LiveTestRegistration`. Idempotent — registering twice for the same test returns the existing record, never a duplicate. Backend must reject if `Test.isLive != true` (a student can never register for a non-live test) |
| `/live-tests/registrations/{studentId}` | GET | `LiveTestRegistration[]` for this student |

### 4.6 Commerce — the two endpoints needing real backend enforcement, not just CRUD

**Purchase gating.** The Flutter `test-taking` feature's entry gate checks `Test.isFreeSample OR testId ∈ GetPurchasedTestIdsUseCase(studentId)` — currently computed **client-side** by reading `/payments/status?studentId=` and trusting the `purchasedTestIds` array it returns. The backend must be the actual source of truth here: `GET /payments/status?studentId=` should be derived server-side from `Payment` rows with `status: success` joined through `Cart`/`CartItem`, never from anything the client asserts. `POST /tests/{id}/submit` should **independently re-check** this same gate server-side before accepting a submission — a client that's been tampered with (or simply has a stale local purchase cache) must not be able to submit an attempt for a test it hasn't purchased and isn't a free sample.

**Earnings attribution.** The current Flutter `CheckoutUseCase` (client-side) computes a 10% commission per cart item with a teacher-attributed subject and calls `POST /teachers/{id}/earnings` directly after checkout succeeds — i.e., **the client currently constructs and submits the `EarningsRecord` itself**. This is fine for a dummy-data Phase-1 build but is a real trust boundary problem for a production backend: a modified client could POST arbitrary `EarningsRecord`s inflating a teacher's commission. **Recommendation**: keep `GET /teachers/{id}/earnings` as a real client-facing read endpoint, but make `POST /teachers/{id}/earnings` either (a) internal-only / not exposed to the Flutter client at all, with the real trigger living inside the `POST /cart/checkout` handler itself (compute commission server-side, atomically, in the same transaction that marks the `Payment` successful), or (b) if the POST path must stay for Phase-1 parity, require it to be idempotent and validated against an actual successful `Payment`+`SubjectEnrollment.teacherId` pair server-side rather than trusting the posted `amount`/`teacherId` fields verbatim. Either way, **the commission amount must be computed by the backend, never accepted as client input.**

| Endpoint | Method | Notes |
|---|---|---|
| `/cart/checkout` | POST | `{"studentId": string}` → `Payment`. This is where the earnings-attribution trigger belongs server-side (see above) |
| `/payments/status?studentId=` | GET | `{"purchasedTestIds": string[]}` — backing the purchase gate; must be derived from real `Payment` rows, see above |

### 4.7 Notifications

| Endpoint | Method |
|---|---|
| `/notifications/{recipientId}` | GET → `Notification[]` |
| `/notifications/{notificationId}/read` | POST → marks `isRead: true`, no body |

### 4.8 Error shape → `Failure` taxonomy mapping

The Flutter `Failure` sealed class (`lib/domain/common/failure.dart`) has exactly 8 subtypes. DRF exceptions must map onto these consistently so `ErrorInterceptor` (`lib/core/network/interceptors/error_interceptor.dart`) can reconstruct the right one from the HTTP status + a JSON error body:

| Failure | HTTP status | When |
|---|---|---|
| `ValidationFailure` | 400 | Serializer validation errors (bad OTP format, missing required field, the `discountApplied`-without-`teacherId` constraint, etc.) |
| `UnauthorizedFailure` | 401 / 403 | Missing/expired/wrong-role JWT, or a student/teacher trying to read another user's scoped resource |
| `NotFoundFailure` | 404 | Unknown id in a path param |
| `ServerFailure` | 500 | Unhandled server exception |
| `NetworkFailure` | — | Never produced server-side; this is the Dio-layer "no connection at all" case, purely client-side |
| `AssetLoadFailure` / `ParsingFailure` / `UnknownFailure` | — | Also client-only (dummy-datasource / malformed-JSON-parsing cases) — the backend never needs to emit these deliberately, but a malformed response body will fall through to `UnknownFailure` on the client regardless |

Recommend a consistent DRF error body shape across all 400/401/403/404/500 responses, e.g. `{"error": {"code": "validation_error", "message": "..."}}`, and a matching `ErrorInterceptor` update (already client-side, not part of this doc) to read `error.code` rather than inferring purely from status code, since 400 alone doesn't distinguish "bad OTP" from "duplicate registration" if both ever need different client-side handling.

---

## 5. OTP Auth Design

- **Flow**: `POST /auth/otp/request` (phone + role) → SMS sent → `POST /auth/otp/verify` (phone + OTP + role) → JWT issued. Passwordless — no password/email fallback exists anywhere in this app, by design (§9.1).
- **Token issuance**: short-lived access JWT + refresh token, embedding `user_id` and `role` as claims so DRF permission classes can scope every `{studentId}`/`{teacherId}` path without an extra DB lookup per request.
- **Rate-limit/lockout**: the Flutter side already has client-facing constants for this shape (`AppConfig.otpMaxAttempts`, `otpLockoutRestartSeconds`) that currently only gate the dummy datasource's local retry counter — the backend needs its own real enforcement (e.g. `django-ratelimit` or a Redis-backed attempt counter keyed by phone number) since a client-side-only lockout is trivially bypassed.
- **Open items — flagged verbatim from spec §12, not resolved here**:
  - Confirm OTP delivery channel (SMS vendor) and rate-limit/lockout rules for Teacher and Student OTP login.
  - Confirm single-IP sign-in enforcement mechanism for students vs. the multi-device grace period.

---

## 6. Admin / Salesman Contract Notes

Neither app is designed here — this doc only needs to guarantee the API surface they'll consume is real and stable:

- **Admin (web app, out of scope)**: needs write access to `catalog` (create `Test`/`Question`, toggle `BoardClass.isEnabled`), `Teacher` approval (`approvalStatus` transitions), and is the only actor allowed to set `Test.isLive`/`Test.liveDate`. None of these write paths exist in `ApiEndpoints` today since this Flutter app never calls them — they'll need their own endpoint set (e.g. `/admin/tests`, `/admin/teachers/{id}/approve`) designed when the Admin app is actually built, using the same DRF models this doc defines.
- **Salesman (APK, out of scope)**: logs in via `uniqueCode` (not phone+OTP — a structurally different auth path per §9.2), and needs write access to seed `Teacher` records (`onboardingSource: salesmanSeeded`) pre-linked to their own `salesmanId`. Same story — no endpoints exist yet for this app to call.
- Both apps read/write the **same underlying models** this doc defines (`Test`, `Teacher`, etc.) — there's no data-layer fork, only an endpoint/permission-surface fork specific to each app's role.

---

## 7. Open Items Carried Over From Spec §12 (verbatim, not resolved by this doc)

- Confirm OTP delivery channel (SMS vendor) and rate-limit/lockout rules for Teacher and Student OTP login.
- Confirm student "amount owed"/revenue visibility scope referenced as TBD in the functional spec.
- Confirm single-IP sign-in enforcement mechanism for students vs. the multi-device grace period.
- Confirm live-test grading formula (timing vs. accuracy weighting) before implementing `LiveTestRegistration.prizeRank`.
- **Account recovery for lost phone numbers**: since auth is passwordless (phone + OTP only, no password/email fallback), a student/teacher who loses access to their registered SIM has no self-service recovery path. Needs an Admin-assisted flow — e.g. Admin verifies identity manually and re-links the account to a new phone number. Recommend modeling this as a `Notification`/support-request type (e.g. `phoneRecoveryRequested`) rather than an automated flow, at least for Phase 1.

**Additional open item found while writing this doc (not in the original spec §12 list)**: the earnings-attribution trust boundary described in §4.6 — the current Flutter `CheckoutUseCase` client-side-computes and POSTs the `EarningsRecord` rather than the backend deriving it from a verified successful `Payment`. This needs a product/eng decision before the real backend goes live, since it's currently a client-trust gap by construction (acceptable only because there is no real backend yet).
