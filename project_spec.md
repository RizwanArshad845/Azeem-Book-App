# Azeem Publications — Main App Project Spec (Flutter)

**Status:** Living document — single source of truth for development, including AI-assisted coding (Claude Code).
**Scope of this document:** The **Main App** (Play Store — Teacher + Student onboarding and flows). The Admin App is a separate web application (out of scope for implementation here, but its API contracts are shared). The Salesman App is a separate APK/codebase that consumes the **same backend** and the **same shared DTO/API layer** defined here.

---

## 1. Overview & Purpose

Azeem Publications' Main App onboards **Teachers** and **Students**, delivers subject/chapter-wise tests, grades and reports results, and drives revenue through a teacher-attribution/commission model. Three roles interact with the same backend:

| App | Platform | Codebase | In scope here? |
|---|---|---|---|
| Main App | Flutter (Android/iOS) | This repo | ✅ Primary focus |
| Admin App | Web | Separate | ❌ Out of scope (contracts shared) |
| Salesman App | Flutter (APK, not on Play Store) | Separate repo | ⚠️ Shares backend + shared DTO/API package |

Because the backend is not ready, the app ships against **dummy data sources** that are structurally identical to what the real API will return, so the eventual swap is a one-line configuration change, not a rewrite.

---

## 2. Architecture

### 2.1 Pattern: Clean Architecture + MVVM

Same layering convention already established on the Azeem Academy dev-release codebase — this spec extends it rather than introducing a new pattern.

```
lib/
  core/                      # cross-cutting: DI, router, theme, config, constants, extensions, shared widgets, network client
    di/
    router/
    theme/                   # app_colors.dart (ThemeExtension), app_dimensions.dart
    extensions/              # context.colors, context.dimens, context.l10n
    constants/               # app_assets.dart, app_routes.dart
    config/                  # app_config.dart, env.dart
    network/                 # dio_client.dart, interceptors/
    services/                # logger.dart, etc.
    widgets/                 # AppButton, AppTextField, AppDropdown, etc.

  data/
    <feature>/
      datasources/
        remote/              # <Feature>RemoteDataSource (Dio + ApiEndpoints)
        local/                # DummyTeacherDataSource, cache, etc.
      models/                # freezed DTOs + fromJson/toJson (request & response)
      repositories/          # <Feature>RepositoryImpl — picks remote or dummy datasource via AppConfig.isMockMode

  domain/
    <feature>/
      entities/               # freezed entities (pure Dart, no Flutter/Riverpod imports)
      repositories/           # abstract <Feature>Repository interfaces
      usecases/               # single-purpose classes, one per business action

  presentation/
    <feature>/
      view/                   # screens/widgets — no business logic
      viewmodel/              # @riverpod Notifier/AsyncNotifier — state + orchestration
      widgets/                # feature-local reusable widgets

  shared/                     # (optional) extracted into a shared package later — see §5
    dto/
    api/
```

- **Domain layer** has zero Flutter/Riverpod/package imports. Repository interfaces live here; use cases are single-purpose (`GetTeacherOverviewUseCase`, `SubmitTestAttemptUseCase`, etc.), not one giant repository-passthrough.
- **Data layer** owns models, JSON mapping, and the dummy-vs-real datasource switch (§4). Swapping dummy → real API touches only this layer.
- **Presentation layer** is View ↔ ViewModel ↔ Model. Views read state via `ref.watch` (scoped with `.select` wherever practical) and call viewmodel methods; they never touch a repository or entity directly.

### 2.2 SOLID Discipline

- **S** — ViewModels orchestrate only; repositories fetch/persist only; widgets render only.
- **O** — New role dashboards or test types extend via new implementations (new use case, new `TestType` variant + builder), not new branches in existing conditionals.
- **L** — Any `TeacherRepository` (dummy or real) is a drop-in behind the same interface; same for every other repository.
- **I** — Small, feature-specific repository interfaces (`AuthRepository`, `TeacherRepository`, `TestRepository`, `EarningsRepository`, ...) rather than one `AppRepository`.
- **D** — ViewModels/use cases depend on domain interfaces only; GetIt/Riverpod wire the concrete implementation at the composition root.

---

## 3. State Management

- **Riverpod with code generation (`@riverpod`) is mandatory.** Every screen/feature state is a generated `Notifier`/`AsyncNotifier`.
- **`setState` is forbidden** for anything beyond pure, zero-effect ephemeral UI (e.g., a text field's local focus animation) — never for business/shared state.
- **Scoped watching**: `ref.watch(provider.select((s) => s.field))` in `build()`; `ref.read` inside callbacks/handlers. Isolate frequently-changing slices (timers, live counters) into their own small `ConsumerWidget` so they don't rebuild the whole screen.
- **`AsyncValue`** is the standard shape for anything async (network, dummy-with-simulated-latency) so loading/data/error render uniformly across the app (§8).

---

## 4. Dependency Injection

- **`get_it`** as the service locator for construction/wiring (repositories, use cases, network client, services), registered in `core/di/injection.dart`.
- Riverpod providers wrap GetIt instances so the rest of the app still consumes everything idiomatically via `ref.watch`/`ref.read`:

```dart
final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<Dio>(() => DioClient.build());
  sl.registerLazySingleton<TeacherRemoteDataSource>(() => TeacherRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<TeacherDummyDataSource>(() => TeacherDummyDataSourceImpl());
  sl.registerLazySingleton<TeacherRepository>(
    () => TeacherRepositoryImpl(
      remote: sl(),
      dummy: sl(),
      isMockMode: AppConfig.isMockMode,
    ),
  );
  sl.registerFactory(() => GetTeacherOverviewUseCase(sl()));
}

final teacherRepoProvider = Provider((ref) => sl<TeacherRepository>());
```

GetIt handles construction; Riverpod handles reactive state. This decouples construction from usage and keeps mocks/tests trivial to substitute.

---

## 5. Models, Codegen & Multi-App Sharing

- **`freezed`** for every entity and DTO (immutability, `copyWith`, union types for e.g. `TestType`, `Result`).
- **`json_serializable`** for all `fromJson`/`toJson` — never hand-written parsing.
- **`build_runner`** generates code for models and `@riverpod` providers.
- **DTOs are strictly derived from the schema in §9** — no ad hoc fields invented at the widget layer.

**Multi-app coordination:** Admin (web) and Salesman (separate APK) are different codebases but must speak the same backend contracts. Extract `data/**/models` (DTOs) and `core/network` (API client + `ApiEndpoints`) into a **shared local package** (e.g. `packages/azeem_shared/`) that the Main App and the Salesman App both depend on via `path:` dependency. This keeps:
- Endpoint definitions (`ApiEndpoints`) in one place.
- Request/response DTOs (`freezed`) in one place, so a schema change is a single-package version bump for both apps.
- The Admin web app (separate stack) treats this package's schema (§9, Section B) as its own contract reference, even though it can't import the Dart package directly.

---

## 6. Network & Data Strategy

### 6.1 Dummy Data First

Backend isn't ready, so every feature ships against a dummy datasource that returns the **exact same DTO shape** the real API will eventually return.

```
data/teacher/datasources/
  remote/teacher_remote_datasource.dart      # TeacherRemoteDataSourceImpl (Dio)
  local/teacher_dummy_datasource.dart        # DummyTeacherDataSource — in-memory/JSON, same method signatures
```

Repository implementation picks a datasource based on config, not scattered `if`s in viewmodels:

```dart
class TeacherRepositoryImpl implements TeacherRepository {
  TeacherRepositoryImpl({required this.remote, required this.dummy, required this.isMockMode});
  final TeacherRemoteDataSource remote;
  final TeacherDummyDataSource dummy;
  final bool isMockMode;

  @override
  Future<Result<TeacherOverview>> getOverview(String teacherId) {
    final source = isMockMode ? dummy : remote;
    return source.getOverview(teacherId);
  }
}
```

### 6.2 The Switch Mechanism

- `core/config/app_config.dart` exposes `AppConfig.isMockMode`, sourced from `--dart-define=MOCK_MODE=true|false` (falls back to environment default, §7).
- Flipping dummy → real is **one flag + rebuild** — zero code changes elsewhere, because both datasources implement the same interface and return the same DTOs.

### 6.3 API Layer

- **`ApiEndpoints`** — a single class enumerating every path (`/auth/otp/request`, `/teacher/{id}/overview`, `/student/{id}/cart`, `/tests/{id}/submit`, ...).
- **Dio client** (`core/network/dio_client.dart`) with interceptors:
  - Auth interceptor — attaches session/OTP-derived token.
  - Logging interceptor — request/response logging via `core/services/logger.dart` (never `print`).
  - Error interceptor — maps Dio exceptions to the app's `Failure` types (§8).
- **Repository interfaces** in `domain/**/repositories`; concrete implementations in `data/**/repositories`, each choosing dummy vs. remote per §6.2.

---

## 7. Environment Configuration

| Environment | Data source | API base URL | Notes |
|---|---|---|---|
| `dev` | Dummy | n/a (unused) | Default for local development and demos |
| `staging` | Real API | staging base URL | Pre-release QA |
| `prod` | Real API | production base URL | Play Store build |

All environment values (base URL, `isMockMode`, feature flags such as `enableLiveTests`, `enableGeminiOcr`) are injected via `--dart-define` (or an `env/*.json` + `--dart-define-from-file`) and read through `core/config/app_config.dart` — never hardcoded per-screen.

---

## 8. Error Handling & Loading States

- **`Failure`** — sealed class covering `NetworkFailure`, `ServerFailure`, `ValidationFailure`, `UnauthorizedFailure`, `NotFoundFailure`, `UnknownFailure`.
- **`Result<T>`** (or `Either<Failure, T>`, simple sealed class — no package dependency required) is the return type for every repository/use-case method, so viewmodels handle success/failure explicitly instead of try/catch sprawl.
- **`AsyncValue<T>`** wraps `Result` at the viewmodel boundary so views render `loading` / `data` / `error` uniformly (shared `AsyncValueWidget`/`AppErrorView` in `core/widgets/`).
- Role-based screens (Teacher earnings, Student cart, Admin-only actions) surface `UnauthorizedFailure` via a shared "not permitted" state rather than a raw exception.

---

## 9. Data Schema

> Derived directly from the Teacher, Student, Admin, and Salesman flows in the functional spec (`DOC-20260818-WA0044.docx`). No fields or flows are invented beyond what's implied there; fields marked *(scope TBD)* are explicitly left open in that document and should stay optional/nullable until finalized.

### 9.1 Section A — Narrative Schema

**User (base, shared fields)**
Common to Teacher, Student, Salesman (Admin has a distinct, developer-approved login and is excluded from the shared-profile rules). Holds identity and contact only (`id`, `name`, `phoneNumber`, `role`, audit fields). Campus is **not** a base field — only Teacher and Student have a genuine campus relationship, so `campusId` is declared directly on those two entities instead of being inherited and left unused by Salesman/Admin. Only Teacher and Student support account deletion, and only they and Salesman expose profile edit; edits trigger an "update" notification to Admin.

**Admin**
Represents a hardcoded/developer-approved backend operator. Not a self-service entity — no signup flow, no shared profile/language behavior.

**Teacher**
Extends User with `campusId`, `subjects`, and an associated `students` list. There is no separate `college` field — campus names (e.g. "Punjab College Bahawalpur Campus") already encode the institution, so a distinct college field would be redundant. Carries onboarding status (`preloadedViaSalesman` vs. `pendingAdminApproval`), an optional `salesmanId` link, and earnings figures (actual + projected). City is not collected directly — it's derived via `campusId → Campus.city`. A Teacher is either pre-seeded via the Salesman/Azeem-Books database (OTP login only, no signup) or self-signs-up and awaits Admin approval before functioning identically thereafter.

**Student**
Extends User with a required `campusId` (their College/Campus, declared directly on Student since it isn't a base `User` field), a selected `boardClassId` (must be Admin-enabled), and a list of `subjectEnrollments` — each pairing a subject with an optional teacher (per-subject teacher selection, filtered to the student's own campus for now). Also owns a cart, purchased/attempted tests, and progress data. Authentication is passwordless — phone number + OTP only, consistent with the Teacher/Salesman login model.

**Salesman**
A minimal entity: `name`, a system-generated `uniqueCode` (sole login credential, one-time/no-logout), and the list of teachers they've onboarded.

**ClassLevel** (e.g., 9th, 10th, 11th, 12th, Matric)
Admin-managed catalog entity for the coarse grade axis — the thing a student picks *first*, before any group. Exists as a separate entity from `BoardClass` because a class level may have zero, one, or several `BoardClass` leaves depending on whether it splits into groups (9th/10th don't split — one leaf each; 11th/12th split into Pre-Medical/Pre-Engineering — two leaves each). Only `enabled` class levels are selectable; others render as "coming soon."

**BoardClass** (e.g., 9th, Pre-Medical, Pre-Engineering, Matric)
Admin-managed catalog entity — a leaf group nested under a `ClassLevel` via `classLevelId`. For class levels that don't split (9th, 10th), a single `BoardClass` row stands in for the class level itself (e.g. name "9th" duplicating its parent `ClassLevel.name`); for class levels that do split (11th, 12th), each `BoardClass` row is one group. This is what `Student.boardClassId`, `Subject.boardClassId`, and `Test.boardClassId` actually point at — a more granular leaf than "the grade" alone, e.g. "11th Pre-Medical" rather than just "11th". Only `enabled` board/classes are selectable by students/teachers; others render as "coming soon."

**Subject**
Catalog entity (Physics, Chemistry, Computer Science, etc.), always scoped to a `boardClassId`. This is what drives the subject-selection screen: once a Student's `boardClassId` is set, only subjects belonging to that board/class are offered — a subject can't exist unscoped or leak across board/classes it doesn't belong to.

**Chapter**
Belongs to a `Subject`, with a `title` and a required `order` (1-based sequence, e.g. Chapter 1, 2, 3...). This is what powers the student's subject → chapters drill-down navigation, and specifically the "2 free tests for the first chapter" rule (`order == 1`). Without an explicit order field, "first chapter" would be undefined.

**Campus**
`name` + `city`, used for filtering teachers/students/salesman views and for scoping which teachers a student can select.

**Test**
Created by Admin via bulk upload. Scoped by `boardClassId` → `subjectId`, optionally `chapterId` (FK to `Chapter`). `kind` is `subjectWiseGuessPaper | subjectWiseSimplePaper | chapterWise`. May be a `liveTest` with a scheduled `liveDate` (phase-1 beta). Source `.docx` is parsed server-side into structured `Question` records.

**Question**
Belongs to a `Test` and a `Chapter` (via `chapterId`). `type` is `mcq | shortAnswer | longAnswer`. MCQs carry `options` + `correctOptionIndex`; short/long carry an `expectedAnswer` used by AI-driven grading (Gemini OCR for long-answer photo submissions is phase 2).

**TestAttempt / Submission**
Belongs to a `Student` and a `Test`. Stores per-question `answers`, computed `score`, `weakChapterIds`/`strongChapterIds` (both FKs to `Chapter`), timing data (for live-test grading), and whether it was a live-test attempt (for the prize/leaderboard system).

**SubjectEnrollment**
Join entity between Student, Subject, and (optional) Teacher — this is what drives the teacher-discount rule (discount only if a teacher is selected) and teacher attribution for commissions.

**EarningsRecord**
Triggered when a student completes a paid-pack purchase; attributes a commission to the `teacherId` (and optionally `salesmanId`) associated with that subject/enrollment. Feeds both actual earnings and the teacher/salesman "amount owed" views on Admin.

**Notification**
Generic entity: `recipientId`, `recipientRole`, `type` (e.g., `studentRegistered`, `profileUpdatePending`, `teacherAwaitingApproval`, `newTestUploaded`, `discountAnnouncement`), `message`, `isRead`, `createdAt`.

**CartItem / Cart**
Belongs to a Student; holds selected purchasable subject bundles (extensible later to video lectures, guess papers) and a computed total reflecting the teacher-selection discount. Purchasing is bundle-only, per a deliberate user decision: a `CartItem`/purchase is scoped to a whole `subjectId`, not an individual `testId` — a student who buys a subject gets every test in it, including tests Admin adds to that subject *after* the purchase. This is why the purchase gate (`getPurchasedSubjectIds`) tracks `subjectId`s rather than a per-test snapshot.

**Payment**
Belongs to a Student; records a redirect to an external payment gateway, `status` (`pending|success|failed`), and `gatewayReference`.

**LiveTestRegistration**
Join entity between Student and a live `Test`; stores registration time, final timing/accuracy-based score, and leaderboard/prize rank.

### 9.2 Section B — Structured Schema (extractable)

```yaml
# project_spec.schema.yaml
# Source of truth for freezed Entities/DTOs (Flutter) and backend API contracts.
# Types use Dart-facing type names; nullable fields are marked required: false.

components:
  schemas:

    User:
      type: object
      description: Base fields shared by Teacher, Student, Salesman (not Admin).
      properties:
        id: { type: string, required: true, unique: true }
        name: { type: string, required: true, maxLength: 120 }
        phoneNumber: { type: string, required: true, unique: true }
        role: { type: string, enum: [teacher, student, salesman], required: true }
        isDeleted: { type: boolean, required: true, default: false }
        createdAt: { type: DateTime, required: true }
        updatedAt: { type: DateTime, required: true }

    Admin:
      type: object
      description: Developer-approved backend operator; no self-service signup.
      properties:
        id: { type: string, required: true, unique: true }
        name: { type: string, required: true }
        role: { type: string, enum: [admin], required: true }
        createdAt: { type: DateTime, required: true }

    Teacher:
      type: object
      extends: User
      properties:
        campusId: { type: string, required: true, foreignKey: Campus.id }
        subjects: { type: array, items: string, foreignKey: Subject.id, required: true }
        classes: { type: array, items: string, foreignKey: BoardClass.id, required: false }
        declaredStudentCount: { type: int, required: false }
        salesmanId: { type: string, required: false, foreignKey: Salesman.id }
        onboardingSource: { type: string, enum: [salesmanSeeded, selfSignup], required: true }
        approvalStatus: { type: string, enum: [approved, pendingAdminApproval], required: true }
        actualEarnings: { type: double, required: true, default: 0 }
        projectedEarnings: { type: double, required: false }

    Student:
      type: object
      extends: User
      properties:
        campusId: { type: string, required: true, foreignKey: Campus.id }
        boardClassId: { type: string, required: false, foreignKey: BoardClass.id, note: "must reference an Admin-enabled BoardClass" }
        subjectEnrollments: { type: array, items: SubjectEnrollment, required: false }
        cartId: { type: string, required: false, foreignKey: Cart.id }

    Salesman:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        name: { type: string, required: true }
        uniqueCode: { type: string, required: true, unique: true, note: "sole login credential" }
        teacherIds: { type: array, items: string, foreignKey: Teacher.id, required: false }
        createdAt: { type: DateTime, required: true }

    ClassLevel:
      type: object
      description: Coarse grade axis (9th/10th/11th/12th); BoardClass leaves nest under it via classLevelId.
      properties:
        id: { type: string, required: true, unique: true }
        name: { type: string, required: true, example: "9th, 10th, 11th, 12th" }
        isEnabled: { type: boolean, required: true, default: false, note: "false renders as 'coming soon'" }

    BoardClass:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        name: { type: string, required: true, example: "Pre-Medical, Pre-Engineering, 9th" }
        classLevelId: { type: string, required: true, foreignKey: ClassLevel.id }
        isEnabled: { type: boolean, required: true, default: false, note: "false renders as 'coming soon'" }

    Subject:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        name: { type: string, required: true }
        boardClassId: { type: string, required: true, foreignKey: BoardClass.id }

    Chapter:
      type: object
      description: Ordered syllabus unit belonging to a Subject. Drives "first chapter free" and chapter-wise navigation/reporting.
      properties:
        id: { type: string, required: true, unique: true }
        subjectId: { type: string, required: true, foreignKey: Subject.id }
        title: { type: string, required: true }
        order: { type: int, required: true, note: "1-based sequence within the subject; order == 1 is the free-sample chapter" }

    Campus:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        name: { type: string, required: true }
        city: { type: string, required: true }

    Test:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        title: { type: string, required: true }
        kind: { type: string, enum: [subjectWiseGuessPaper, subjectWiseSimplePaper, chapterWise], required: true }
        boardClassId: { type: string, required: true, foreignKey: BoardClass.id }
        subjectId: { type: string, required: true, foreignKey: Subject.id }
        chapterId: { type: string, required: false, foreignKey: Chapter.id }
        isLive: { type: boolean, required: true, default: false }
        liveDate: { type: DateTime, required: false }
        isFreeSample: { type: boolean, required: true, default: false, note: "first-chapter 2 free tests rule" }
        createdByAdminId: { type: string, required: true, foreignKey: Admin.id }
        createdAt: { type: DateTime, required: true }

    Question:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        testId: { type: string, required: true, foreignKey: Test.id }
        chapterId: { type: string, required: true, foreignKey: Chapter.id }
        type: { type: string, enum: [mcq, shortAnswer, longAnswer], required: true }
        questionText: { type: string, required: true }
        options: { type: array, items: string, required: false, note: "mcq only" }
        correctOptionIndex: { type: int, required: false, note: "mcq only" }
        expectedAnswer: { type: string, required: false, note: "short/long answer grading reference" }

    TestAttempt:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        studentId: { type: string, required: true, foreignKey: Student.id }
        testId: { type: string, required: true, foreignKey: Test.id }
        answers: { type: array, items: SubmissionAnswer, required: true }
        scorePercent: { type: double, required: true }
        weakChapterIds: { type: array, items: string, foreignKey: Chapter.id, required: false }
        strongChapterIds: { type: array, items: string, foreignKey: Chapter.id, required: false }
        durationSeconds: { type: int, required: false }
        isLiveTestAttempt: { type: boolean, required: true, default: false }
        attemptedAt: { type: DateTime, required: true }

    SubmissionAnswer:
      type: object
      properties:
        questionId: { type: string, required: true, foreignKey: Question.id }
        answerText: { type: string, required: false }
        selectedOptionIndex: { type: int, required: false }
        isCorrect: { type: boolean, required: false }
        gradedByAi: { type: boolean, required: true, default: false }

    SubjectEnrollment:
      type: object
      description: Join entity — Student x Subject x optional Teacher.
      properties:
        studentId: { type: string, required: true, foreignKey: Student.id }
        subjectId: { type: string, required: true, foreignKey: Subject.id }
        teacherId: { type: string, required: false, foreignKey: Teacher.id }
        discountApplied: { type: boolean, required: true, default: false, note: "true only if teacherId set" }

    EarningsRecord:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        teacherId: { type: string, required: false, foreignKey: Teacher.id }
        salesmanId: { type: string, required: false, foreignKey: Salesman.id }
        studentId: { type: string, required: true, foreignKey: Student.id }
        amount: { type: double, required: true }
        triggerEvent: { type: string, enum: [paidPackPurchase], required: true }
        createdAt: { type: DateTime, required: true }

    Notification:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        recipientId: { type: string, required: true }
        recipientRole: { type: string, enum: [admin, teacher, student, salesman], required: true }
        type: { type: string, enum: [studentRegistered, profileUpdatePending, teacherAwaitingApproval, newTestUploaded, discountAnnouncement, liveTestReminder], required: true }
        message: { type: string, required: true }
        isRead: { type: boolean, required: true, default: false }
        createdAt: { type: DateTime, required: true }

    Cart:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        studentId: { type: string, required: true, foreignKey: Student.id }
        items: { type: array, items: CartItem, required: false }
        totalAmount: { type: double, required: true, default: 0 }

    CartItem:
      type: object
      description: "Bundle-only purchasing (user decision): scoped to a whole subject, not an individual test — see CartItem/Cart prose above."
      properties:
        subjectId: { type: string, required: true, foreignKey: Subject.id }
        subjectName: { type: string, required: true, note: "denormalized for cart display, same rationale as price living here not on Test" }
        testCount: { type: int, required: true, note: "tests included at add-time, for display (e.g. '4 tests')" }
        price: { type: double, required: true }
        discountedPrice: { type: double, required: false }

    Payment:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        studentId: { type: string, required: true, foreignKey: Student.id }
        amount: { type: double, required: true }
        status: { type: string, enum: [pending, success, failed], required: true }
        gatewayReference: { type: string, required: false }
        createdAt: { type: DateTime, required: true }

    LiveTestRegistration:
      type: object
      properties:
        id: { type: string, required: true, unique: true }
        studentId: { type: string, required: true, foreignKey: Student.id }
        testId: { type: string, required: true, foreignKey: Test.id }
        registeredAt: { type: DateTime, required: true }
        finalScore: { type: double, required: false }
        timingSeconds: { type: int, required: false }
        prizeRank: { type: int, required: false }
```

---

## 10. UI/UX & Routing

### 10.1 Visual Principle: Simple by Default

With this many screens across two roles, visual restraint matters more than decoration. Rules that apply to every screen, not suggestions:

- **One primary action per screen.** Every screen has exactly one obvious next step (a single prominent `AppButton`); secondary actions are visually de-emphasized (text buttons, not competing filled buttons).
- **Reuse the shared widget kit everywhere** (`AppButton`, `AppTextField`, `AppDropdown`, `AppCard`, `SectionProgressIndicator`, `LoadingIndicator`, `AppSnackbar`, `EmptyStateView`) — no per-screen custom variants of the same component. This is what keeps 20+ screens feeling like one app instead of a patchwork.
- **Generous whitespace over dense layouts.** Prefer a scroll with breathing room (`AppDimens.md`/`lg` gaps) over cramming stats/cards edge-to-edge — this matters especially on Teacher's data-heavy screens (Earnings Dashboard, View Associated Students).
- **Cards for scannable data, not tables.** Student ranking, chapter breakdowns, associated-students lists render as a list of simple `AppCard` rows, not dense grids — easier to scan on mobile, consistent with the rest of the app.
- **Color used sparingly and semantically only** — brand teal/amber for primary actions and active states, `context.colors.success/warning/error` strictly for status (score bands, active/non-active, payment status). No decorative color.

### 10.2 Navigation: Persistent Bottom Nav Bar (Shell Route)

Both the Teacher and Student experiences use a **persistent bottom navigation bar** — the current standard app pattern (tab bar + `IndexedStack` so each tab preserves its own scroll/state when switching) — implemented via `go_router`'s `StatefulShellRoute.indexedStack`, not a `Drawer` and not raw `BottomNavigationBar` wired to `Navigator.push`.

Only top-level, role-specific destinations sit in each tab; everything else (test-taking flow, individual student's progress detail, cart checkout, OTP/onboarding) is a full-screen route pushed *on top of* the shell, so the bottom bar disappears during focused tasks (e.g., mid-test) and reappears on return.

**Student tabs** (derived from docx §"Main Screens (Phase 1)"):

| Tab | Icon | Screen(s) behind it |
|---|---|---|
| Home | home | Selected subjects grid, live-test banner, subject → chapter → test drill-down |
| Cart | cart | Add-to-cart summary, checkout → payment gateway redirect |
| Progress | chart | Attempted tests list, overall progress, per-test report (pie chart) |
| Notifications | bell | Live-test reminders, new test uploads, discount announcements |
| Profile | user | Edit profile, language toggle, delete account |

**Teacher tabs** (derived from docx §"Main Screens"):

| Tab | Icon | Screen(s) behind it |
|---|---|---|
| Overview | home | Students onboarded, actual + projected earnings summary |
| Students | people | View Associated Students (filterable, paginated), per-student Progress detail |
| Earnings | wallet | Detailed Earnings Dashboard |
| Notifications | bell | "Student Y registered at time X", new signups |
| Profile | user | Edit profile, language toggle |

**Salesman app** (separate codebase, same pattern applies there): Overview, Add Teacher, Associated Teachers — 3 tabs, same shell approach.

```dart
// core/router/app_router.dart (shape, not full implementation)
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) => AppScaffoldWithBottomNav(navigationShell: navigationShell),
  branches: [
    StatefulShellBranch(routes: [GoRoute(path: AppRoutes.studentHome, ...)]),
    StatefulShellBranch(routes: [GoRoute(path: AppRoutes.studentCart, ...)]),
    StatefulShellBranch(routes: [GoRoute(path: AppRoutes.studentProgress, ...)]),
    StatefulShellBranch(routes: [GoRoute(path: AppRoutes.studentNotifications, ...)]),
    StatefulShellBranch(routes: [GoRoute(path: AppRoutes.studentProfile, ...)]),
  ],
)
```

Onboarding (splash → phone → OTP → signup steps) and the test-taking flow are **outside** the shell — plain top-level `GoRoute`s pushed before the shell is ever entered, or on top of it, matching the "no pause / no bottom-nav during an active test" rule.

### 10.3 Design System & Routing Mechanics

- **Design system**: colors, typography, and spacing generated via the Frontend Design capability, exposed through `context.colors` / `context.dimens` (ThemeExtension pattern, no hardcoded hex/magic numbers anywhere — mirrors the Azeem Academy dev-release conventions).
- **`go_router`** only, no imperative `Navigator.push`. Routes are named constants in `core/constants/app_routes.dart`.
- **Role-based guards**: route redirect logic checks the authenticated role (Teacher vs. Student — Salesman is a separate app) before allowing entry to role-specific branches; unauthenticated users are redirected to the relevant OTP/login flow.
- **Localization**: `flutter_localizations` + ARB files (`context.l10n`) for every user-facing string, English populated now, Urdu addable later without code changes — same approach as the diagnostic-test dev release.

---

## 11. Phase Boundaries (explicit, per functional spec)

| Feature | Phase 1 | Phase 2 |
|---|---|---|
| Admin login flow (full) | Hardcoded/dev-approved only | Full flow |
| Live tests | Beta (register + run) | Full build-out |
| Teacher custom test upload | — | ✅ |
| Long-answer grading | AI text grading | + Gemini OCR photo upload + style checking |
| Video lectures / guess papers in cart | Data model allows for it | Full feature |

Anything marked *(scope TBD)* in §9 (teacher/salesman revenue-view details, teacher Profile screen) should be modeled as **optional/nullable** in the schema so it doesn't block Phase 1 development, and finalized without a breaking schema change.

---

## 12. Open Items for Backend Alignment

- Confirm OTP delivery channel (SMS vendor) and rate-limit/lockout rules for Teacher and Student OTP login.
- Confirm student "amount owed"/revenue visibility scope referenced as TBD in the functional spec.
- Confirm single-IP sign-in enforcement mechanism for students vs. the multi-device grace period.
- Confirm live-test grading formula (timing vs. accuracy weighting) before implementing `LiveTestRegistration.prizeRank`.
- **Account recovery for lost phone numbers**: since auth is passwordless (phone + OTP only, no password/email fallback), a student/teacher who loses access to their registered SIM has no self-service recovery path. Needs an Admin-assisted flow — e.g. Admin verifies identity manually and re-links the account to a new phone number. Recommend modeling this as a `Notification`/support-request type (e.g. `phoneRecoveryRequested`) rather than an automated flow, at least for Phase 1.
