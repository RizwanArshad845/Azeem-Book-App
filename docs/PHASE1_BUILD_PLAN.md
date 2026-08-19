# Azeem Publications Main App — Full Phase-1 Build + Django Backend Design Doc

## Context

`project_spec.md` (repo root) is the single source of truth for a full rebuild of this Flutter app: a two-role (Teacher/Student) platform with OTP auth, subject/chapter/test catalog browsing, test-taking + grading, cart/checkout, earnings/commissions, notifications, and profile management — all built against dummy datasources per the project's "dummy-data-first" rule, since no backend exists yet.

The repo previously contained an unrelated leftover: a single-role, no-auth "diagnostic test" demo (onboarding → home → 40-question CS test → radar-chart results) built against a hardcoded JSON asset, from an earlier, different spec (`docs/BUILD_PLAN.md`, kept as historical record). That flow was confirmed out of Phase-1 scope and deleted before this build started.

A separate **Django backend design doc** (`backend.md`, markdown only, no runnable code) is written so a real backend can eventually be built against the exact same contracts the Flutter dummy layer already assumes.

**Decisions locked with the user:**
1. Build the full Phase-1 scope per §11 (Auth, complete Student flow, complete Teacher flow, live tests in beta — register/run only, no leaderboard). Admin/Salesman apps are out of scope; only their FK fields need to exist.
2. Delete the old demo code entirely before starting.
3. Backend deliverable is a single `backend.md` design doc — Django app/model/API contract design, no Python code.

---

## Part A — Flutter: Full Phase-1 Build

### A0. Cleanup (do first)

Delete:
- `lib/presentation/{diagnostic,onboarding,home}/`
- `lib/domain/{diagnostic,onboarding,question_bank}/`
- `lib/data/{onboarding,question_bank}/`
- `assets/computer_science_question_bank.json`
- `lib/core/widgets/chapter_score_tile.dart`, `lib/core/widgets/radio_option_tile.dart` (only consumed by deleted files — confirm via grep before deleting)

Edit `pubspec.yaml`: remove `- assets/computer_science_question_bank.json` from `flutter: assets:`.

Keep as-is: `lib/presentation/splash/**`, `lib/core/theme/**`, `lib/core/extensions/context_extensions.dart`, `lib/core/widgets/{app_button,app_dropdown,app_text_field,app_snackbar,loading_indicator,press_scale,fade_slide_in,app_logo,blurred_logo_backdrop}.dart`, `lib/core/services/logger.dart`, `lib/core/utils/validators.dart`, `lib/domain/common/result.dart`, `lib/app.dart`, `lib/main.dart`.

### A1. Shared Foundation (before any feature work)

- **`core/config/app_config.dart`**: keep OTP constants (`otpLength`, `otpCode`, `otpMaxAttempts`, `otpLockoutRestartSeconds`, `splashDelaySeconds`); add `isMockMode` (`--dart-define=MOCK_MODE`), `apiBaseUrl`, `enableLiveTests`, `enableGeminiOcr`; drop old test-timing/subject-pool constants.
- **`core/di/injection.dart`** + **`core/di/riverpod_providers.dart`**: reset to baseline (Logger only) — every feature appends its own bindings later.
- **`core/constants/app_routes.dart`**: full rewrite — auth routes, 5 student shell routes, 5 teacher shell routes, outside-shell routes (`testTaking`, `liveTestRun`, `cartCheckout`, teacher's per-student progress detail).
- **`core/router/app_router.dart`**: full rewrite to `StatefulShellRoute.indexedStack` with two role-gated branch sets, each tab initially rendering `EmptyStateView("Coming soon")` so later features slot into existing routes.
- **New**: `core/network/api_endpoints.dart`, `core/network/dio_client.dart`, `core/network/interceptors/{auth,logging,error}_interceptor.dart`; extend `domain/common/failure.dart` with `NetworkFailure/ServerFailure/UnauthorizedFailure/NotFoundFailure`.
- **New widget kit members** (`core/widgets/`): `app_card.dart`, `section_progress_indicator.dart`, `empty_state_view.dart`, `app_error_view.dart`, `async_value_widget.dart`.
- **New**: `core/widgets/app_scaffold_with_bottom_nav.dart` (the shell scaffold consumed by the router).
- **New domain primitives** (built as part of the `auth` unit): `domain/auth/entities/{user_role,auth_session}.dart`.
- **New pubspec deps**: `dio`, `flutter_secure_storage` (session/locale persistence).

⚠️ **Schema footgun**: `Teacher`/`Student` `extends User` in §9.2, but `add-schema-entity` generates flat classes with no inheritance. Every prompt for a Teacher/Student-owning unit must explicitly say "flatten User's fields (`id, name, phoneNumber, role, isDeleted, createdAt, updatedAt`) into this entity," or `schema-auditor` will flag missing fields.

### A2. Feature Decomposition (dependency-ordered `feature-builder` units)

| # | feature name | §9.2 entities | Screens/VMs | Depends on |
|---|---|---|---|---|
| 1 | `catalog` | BoardClass, Subject, Chapter, Test, Question | none (reference-data repo/dummy source only) | Foundation |
| 1b | `campus-directory` | Campus | none (reference-data repo/dummy source only) | Foundation |
| 2 | `auth` | User(base), AuthSession, UserRole | role-select, phone entry, OTP verify, AuthViewModel/currentUserProvider | Foundation |
| 3 | `teacher-onboarding` | Teacher (User flattened in) | self-signup form, salesman-seeded pass-through, pending-approval banner | auth, catalog, campus-directory |
| 4 | `student-onboarding` | Student (flattened), SubjectEnrollment | campus/boardclass select, subject multi-select + per-subject teacher picker | auth, catalog, campus-directory |
| — | *(manual)* app-shell-wiring | — | router redirect: role→shell, pending-approval→banner, incomplete onboarding→step | 3, 4 |
| 5 | `student-home` | Test/Subject/Chapter(read), SubjectEnrollment(read) | subject grid, chapter drill-down, chapter test list, live-test banner | catalog, student-onboarding |
| 6 | `teacher-overview` | Teacher(read), EarningsRecord(summary read) | students-onboarded count, earnings summary | teacher-onboarding |
| 7 | `notifications` | Notification | shared repo/usecase/vm + thin student/teacher tab views | auth |
| 8 | `student-cart` | Cart, CartItem, Payment | cart tab, teacher-discount calc, checkout→payment redirect stub | student-home, student-onboarding |
| 9 | `test-taking` | Test/Question(read), TestAttempt, SubmissionAnswer | outside-shell question renderer/timer/submit/grading, **purchase-gate check** (see rule below) | catalog, student-home, **student-cart** |
| 10 | `student-progress` | TestAttempt(read), Test/Chapter(read) | attempted-tests list, pie-chart report (`fl_chart`) | test-taking |
| 11 | `teacher-students` | Student(read, filtered), SubjectEnrollment(read), TestAttempt(read) | filterable/paginated students list + per-student progress detail | teacher-onboarding, student-onboarding, test-taking |
| 12 | `live-test-registration` | LiveTestRegistration, Test(read) | register action (only for `isLive` tests the admin has scheduled), live-run (reuses test-taking renderer), no leaderboard UI | student-home, test-taking |
| 13 | `teacher-earnings` | EarningsRecord, Teacher(read) | earnings dashboard | teacher-onboarding, student-cart |
| — | *(manual)* locale-toggle core addition | — | shared `localeProvider` wired into `app.dart` | after 13 |
| 14 | `student-profile` | Student(edit), User | edit profile, language toggle, delete account | auth, student-onboarding |
| 15 | `teacher-profile` | Teacher(edit), User | edit profile, language toggle, delete account | auth, teacher-onboarding |

`Admin`/`Salesman`: no entity files — only FK string fields (`salesmanId`, `createdByAdminId`) on Teacher/Test/EarningsRecord.

**Business rules that shape ordering (user-clarified, not in the spec's prose but implied by the schema):**
- **Purchase gating**: a `Test` is attemptable only if `isFreeSample` is true (the first-chapter 2-free-tests rule) OR the test is part of a `Cart`/`Payment` with `status: success` for that student. This is why `test-taking` (unit 9) depends on `student-cart` (unit 8) — moved earlier in the sequence specifically so the entry-point gate check has real purchase data to check against, instead of being bolted on after the fact.
- **Live tests are Admin-scheduled and occasional, not student-initiated**: Admin authors and bulk-uploads all tests (including live ones) via the separate Admin web app — out of scope here, but it means the `catalog` unit's dummy data for `Test` must model live tests as a **sparse subset** with real-looking future `liveDate` values (not "always on"), and `live-test-registration` only ever *registers interest in* an admin-scheduled live test — it never lets a student create or trigger one.

### A3. Parallelization Policy

`core/di/injection.dart`, `core/di/riverpod_providers.dart`, `core/constants/app_routes.dart`, `core/router/app_router.dart` are shared-edit hotspots — **never** touched concurrently. Each `feature-builder` dispatch in a parallel batch is scoped to only write `lib/{data,domain,presentation}/<feature>/**` and must return the exact DI-registration and route lines to add in its summary; the coordinating thread applies those to the 4 shared files sequentially after the batch completes, then runs codegen/analyze once per batch.

**Batches**: `[catalog, campus-directory, auth]` → `[teacher-onboarding, student-onboarding]` → *(manual shell-wiring)* → `[student-home, teacher-overview, notifications]` → `[student-cart]` (solo) → `[test-taking]` (solo — needs `student-cart`'s purchase data for gating) → `[student-progress, teacher-students]` → `[live-test-registration, teacher-earnings]` → *(manual locale addition)* → `[student-profile, teacher-profile]`.

### A4. Verification Checkpoints

After every batch: `flutter pub run build_runner build --delete-conflicting-outputs`, then `flutter analyze`.

Run `schema-auditor` after: Batch 1 (catalog+campus-directory+auth entities), Batch 2 (Teacher/Student/SubjectEnrollment + User-flattening check), the `student-cart` batch (Cart/CartItem/Payment), the `test-taking` batch (TestAttempt/SubmissionAnswer + purchase-gate logic), and a final full sweep after the last batch (Notification/EarningsRecord/LiveTestRegistration, marking Admin/Salesman as "N/A — separate app").

### A5. End-to-end verification

After the full build: `flutter pub get` → `flutter gen-l10n` → `flutter analyze` → `flutter run`, walk both role flows (auth → onboarding → home tab set → test-taking → cart/checkout → progress/earnings → notifications → profile incl. language toggle) in the running app per `verify`/UI-testing house rules, not just static analysis.

---

## Part B — `backend.md` (Django, design doc only)

Written after the Flutter build (or in parallel once §9 stabilizes, since it only depends on the spec, not the Flutter code). Sections:

1. **App breakdown** — Django apps mapped to feature domains: `accounts` (User/Teacher/Student/Salesman/Admin + OTP auth), `catalog` (BoardClass/Subject/Chapter/Campus), `tests` (Test/Question/TestAttempt/SubmissionAnswer/LiveTestRegistration), `commerce` (Cart/CartItem/Payment/EarningsRecord), `notifications`.
2. **Models** — one Django model per §9.2 entity, exact field/type/nullability/FK mapping (e.g. `DateTime`→`DateTimeField`, freezed enums→`choices=`), including the `User`-inheritance handled via Django's multi-table or proxy inheritance (or a `role` discriminator + FK pattern — pick one and justify it).
3. **Serializers/viewsets plan** (DRF) — per model, matching the exact JSON shape the Flutter DTOs already expect (so dummy→real is a config flip, per §6.2).
4. **API contract** — endpoint list matching `core/network/api_endpoints.dart` paths from the Flutter build (`/auth/otp/request`, `/auth/otp/verify`, `/teacher/{id}/overview`, `/student/{id}/cart`, `/tests/{id}/submit`, etc.), request/response bodies, status codes, error shape matching `Failure` types.
5. **OTP auth design** — passwordless phone+OTP flow, token issuance/refresh, rate-limit/lockout (flagging the still-open items from spec §12: SMS vendor, lockout rules, single-IP enforcement).
6. **Admin/Salesman contract notes** — how the separate Admin (web) and Salesman (APK) apps consume the same API without needing this document to design their UIs.
7. **Open items carried over from spec §12** — listed verbatim so backend implementation doesn't silently resolve them without stakeholder input.

---

## Execution Mechanics

Work proceeds in the batch order in A3, using `Agent` calls with `subagent_type: feature-builder` for each unit (parallel within a batch via multiple tool calls in one message, per the tool's parallelization rules), interleaved with manual shared-file edits and verification commands run directly. `backend.md` is written directly (no subagent needed) after Part A or in a parallel work stream once §9 is confirmed stable.
