# Phase 1 Build Summary — What Was Actually Built

> Companion to [`PHASE1_BUILD_PLAN.md`](./PHASE1_BUILD_PLAN.md) (the approved plan, written before implementation started). This document records what was actually built, the decisions made along the way, deviations from the original plan, and known limitations. Read the plan for *intent*; read this for *what happened*.

Status: **All 15 feature units + 2 manual core additions complete.** Static verification (`flutter pub get`, `flutter gen-l10n`, `flutter analyze`) is clean with zero issues. Manual interactive walkthrough (`flutter run`, both role flows) is **deferred to the user** — not yet performed.

---

## 1. Cleanup (A0)

Deleted the old, unrelated single-role no-auth "diagnostic test" demo entirely, per explicit user confirmation: `lib/presentation/{diagnostic,onboarding,home}/`, `lib/domain/{diagnostic,onboarding,question_bank}/`, `lib/data/{onboarding,question_bank}/`, `assets/computer_science_question_bank.json`, and the two widgets (`chapter_score_tile.dart`, `radio_option_tile.dart`) that were only consumed by it. `docs/BUILD_PLAN.md` (the old plan) was left in place as historical record.

## 2. Foundation (A1)

- `core/config/app_config.dart` rebuilt: `isMockMode`, `apiBaseUrl`, `enableLiveTests`, `enableGeminiOcr`, kept OTP constants.
- `core/network/`: `api_endpoints.dart`, `dio_client.dart`, `interceptors/{auth,logging,error}_interceptor.dart` — new.
- `domain/common/failure.dart` extended with `NetworkFailure`/`ServerFailure`/`UnauthorizedFailure`/`NotFoundFailure`.
- Shared widget kit completed: `app_card`, `section_progress_indicator`, `empty_state_view`, `app_error_view`, `async_value_widget`, `app_scaffold_with_bottom_nav`.
- `core/di/injection.dart` + `core/di/riverpod_providers.dart` reset to baseline; `core/constants/app_routes.dart` + `core/router/app_router.dart` rebuilt around `StatefulShellRoute.indexedStack` with two role-gated shells, tabs initially `_ComingSoonPage` placeholders swapped in one at a time as each feature landed (the last placeholder was removed in Batch 8 once `teacher-profile` landed — `_ComingSoonPage` no longer exists in the router).

## 3. Feature Batches — Build Order & Key Decisions

| Batch | Units | Mode |
|---|---|---|
| 1 | `catalog`, `campus-directory`, `auth` | parallel (succeeded) |
| 2 | `teacher-onboarding`, `student-onboarding` | parallel (**hit API spend-limit mid-run**, recovered manually) |
| — | manual app-shell-wiring (router redirect logic) | manual |
| 3 | `student-home`, `teacher-overview`, `notifications` | parallel |
| 4 | `student-cart` | solo |
| 5 | `test-taking` | solo |
| 6 | `student-progress`, `teacher-students` | **sequential** (user directive after Batch 2's spend-limit failure) |
| 7 | `live-test-registration`, `teacher-earnings` | sequential |
| — | manual locale-toggle core addition | manual |
| 8 | `student-profile`, `teacher-profile` | sequential |

**Two locked-in business rules that reshaped the plan mid-flight (both from direct user correction, not spec prose):**

1. **`campus-directory` split from `catalog`.** The user pointed out an admin uploads generic tests at the app level — campus shouldn't gate the catalog. Confirmed `Test` has no `campusId` in §9.2, so `Campus` became its own independent reference-data unit instead of a `catalog` dependency.
2. **Purchase gating + live-test scheduling semantics.** The user clarified: (a) a `Test` is attemptable only if `isFreeSample` or purchased via a successful `Payment` — this is why `student-cart` (Batch 4) was built *before* `test-taking` (Batch 5), reversing their natural read order so the gate check has real purchase data; (b) live tests are Admin-scheduled and occasional, never student-initiated — `live-test-registration` only ever registers interest in an already-scheduled `Test.isLive` row, never creates/schedules one.

### Batch-by-batch notes

- **Batch 1**: `catalog` seeded 116 tests / 754 questions with business-rule-consistent dummy data (2 free tests per subject's first chapter, sparse `isLive` subset). `campus_directory` seeded 8 campuses / 3 cities. `auth` built the full OTP flow (`UserRole {teacher, student}`, `AuthSession`, `AuthViewModel`, `currentUserProvider`).
- **Batch 2**: Both subagents crashed on "You've hit your monthly spend limit" — but had already finished writing files. Recovered by directly inspecting/completing the work instead of re-dispatching, rather than losing it. `Teacher`/`Student` both flatten `User`'s base fields (`id, name, phoneNumber, role, isDeleted, createdAt, updatedAt`) per this codebase's no-inheritance freezed convention, since §9.2 models `Teacher extends User`/`Student extends User` but Clean-Architecture entities here don't support inheritance. `SubjectEnrollment.create()` factory enforces "discount only if teacherId set." A throwaway `TeacherOption`/`TeacherDirectoryRepository` stand-in was introduced here for the subject→teacher picker during onboarding — **explicitly documented as a known shortcut**, not yet reconciled with the real `Teacher` list `teacher-onboarding` produces (flagged again by the final schema-auditor sweep — see §5 below).
- **Batch 3**: `student-home` (enrolled-subjects/chapters/tests drill-down, live-test banner), `teacher-overview` (stat cards; `declaredStudentCount` used as a self-reported students-onboarded proxy, later superseded by `teacher-students`' live count in Batch 6), `notifications` (deliberately standalone 4-value `NotificationRecipientRole` enum, kept separate from the 2-value `UserRole`).
- **Batch 4**: `student_cart` — `Test` has no price field in §9.2, so pricing is a documented deterministic pure function (`price_for_test.dart`: guess paper 250, simple paper 150, chapter-wise 100) rather than an invented schema field. 20% teacher-discount rule. `GetPurchasedTestIdsUseCase` built here specifically to unblock `test-taking`'s purchase gate.
- **Batch 5**: `test_taking` — grading use cases include a keyword-overlap text-answer grader (≥0.5 threshold, dummy AI stub — real Gemini OCR grading is Phase 2) and `compute_weak_strong_chapters.dart` (<50% weak / >75% strong, documented Phase-1 thresholds reused by later features instead of being re-derived). Route became parameterized (`/test-taking/:testId`), which required reworking the router's outside-shell-route matching from exact-set to prefix-based (`_isOutsideShellRoute`).
- **Batch 6**: `student-progress` added `TestAttemptRepository.getAttemptsForStudent` (a genuinely missing read method) and a pie-chart summary that reuses `compute_weak_strong_chapters.dart`'s output rather than re-deriving thresholds. `teacher-students` added the equivalent `StudentRepository.getStudentsForTeacher`, plus a second parameterized route (`AppRoutes.teacherStudentProgressDetailPath`) mirroring the `test-taking` precedent, and a hand-written `Notifier<String>` for the search filter since Riverpod 3.4.2 dropped `StateProvider`.
- **Batch 7**: `live-test-registration` added the `LiveTestRegistration` entity exactly per §9.2, deliberately built **no leaderboard UI** (Phase-1 scope explicitly excludes it — `finalScore`/`timingSeconds`/`prizeRank` exist on the entity for a future phase but are never read in the presentation layer). The originally-reserved `AppRoutes.liveTestRun` route was **deleted** — live-test entry reuses the existing `test-taking` renderer directly via `testTakingPath(testId)` instead of a separate screen. `teacher-earnings` added the `EarningsRecord` entity and, notably, **wired a real cross-feature trigger**: `student_cart`'s `CheckoutUseCase` now calls a new `RecordEarningsUseCase` after a successful payment, attributing a flat 10% commission (documented, arbitrary demo rate — §9.2 doesn't specify one) per cart item whose subject has a teacher attached, best-effort so a commission-recording failure never fails an already-successful payment.
- **Batch 8**: `student-profile`/`teacher-profile` both needed new repository write methods (`updateStudent`/`deleteAccount`, `updateTeacher`/`deleteAccount` — soft-delete only, `isDeleted = true`, never hard-delete) that didn't exist before. Both onboarding viewmodels gained a `setStudent`/`setTeacher` method so the profile feature can push an edit back into the single shared source-of-truth provider. Delete-account logs the user out via the existing `AuthViewModel.logout()` path and lets the router's redirect naturally return them to auth. The language toggle (§10.2) is real: a shared `core/providers/locale_provider.dart` (`LocaleController`, persisted via `flutter_secure_storage`, added as a manual core step between Batches 7 and 8) is wired into `MaterialApp.router(locale: ...)` in `app.dart`; only English is functionally selectable today since `AppLocalizations.supportedLocales` has just `Locale('en')`, with Urdu shown as a disabled "coming soon" option — per §11's explicit note that Urdu is "addable later without code changes."

## 4. One Real Runtime Bug Found & Fixed

`AppDropdown<T>` (`core/widgets/app_dropdown.dart`) crashed at runtime in an early Chrome smoke test when rendering the campus-select dropdown — the underlying `dropdown_search` package asserts `T == String || T == int || T == double || compareFn != null`, and the widget never passed a `compareFn` through. Fixed by adding an optional `compareFn` parameter defaulting to `(a, b) => a == b`, correct for any `freezed` entity's value equality.

## 5. Known Limitations / Acknowledged Shortcuts (carried forward, not silently fixed)

- **`TeacherOption`/`TeacherDirectoryRepository`** (`student_onboarding`, Batch 2) is a documented throwaway stand-in for the subject→teacher picker shown during student onboarding. It does not read the real `Teacher` list `teacher-onboarding` produces. Flagged again by the final schema-auditor sweep as a self-acknowledged shortcut worth reconciling — not a schema violation, just duplicated/parallel data.
- **No session/locale restore on cold app restart.** `AuthViewModel`/`SplashViewModel` never re-hydrate a persisted session from `flutter_secure_storage` on launch (session is only ever set in-memory during a live app session); `student_onboarding`/`teacher_onboarding`'s viewmodels likewise always resolve to `null` on a fresh `build()` rather than looking up a previously-onboarded user by id. Consistent, intentional Phase-1 simplification — not fixed mid-stream since it wasn't part of any unit's assigned scope.
- **Live tests are not exempt from the purchase gate.** `TestTakingViewModel`'s existing gate (`isFreeSample` or purchased) still applies to live tests. Flagged as an open product question during the `live-test-registration` build — a live/event test arguably shouldn't require a cart purchase — but the gate was left as-is rather than weakened without being asked.
- **Windows desktop (`flutter run -d windows`) is blocked** by a missing Developer Mode / symlink-support setting on this machine; verification used Chrome instead. Not something this session enabled unilaterally, since it requires a system-level `ms-settings:developers` change.
- **Commission rate (10%) and per-test pricing (250/150/100)** are both documented, deterministic, arbitrary placeholder values — §9.2 doesn't specify either. Easy to change in one place each (`price_for_test.dart`, `CheckoutUseCase._teacherCommissionRate`) once real figures are provided.

## 6. Verification Performed

- After every batch: `dart run build_runner build --delete-conflicting-outputs` + `flutter analyze` — clean at every checkpoint, currently clean project-wide.
- `schema-auditor` checkpoints ran after every batch, plus one final full sweep across all 18 in-scope §9.2 entities (`Teacher, Student, Campus, BoardClass, Subject, Chapter, Test, Question, TestAttempt, SubmissionAnswer, SubjectEnrollment, EarningsRecord, Notification, Cart, CartItem, Payment, LiveTestRegistration`, plus `User`'s fields flattened into `Teacher`/`Student`) — **zero field-name, type, nullability, or FK drift found**, including a regression spot-check on `Test`/`Student`/`Teacher`/`TestAttempt` (the entities most likely to be touched incidentally by later cross-feature work).
- `flutter pub get`, `flutter gen-l10n`, `flutter analyze` all clean, run fresh at the end of the build.
- **Not yet done**: interactive `flutter run` walkthrough of both role flows (auth → onboarding → home tab set → test-taking → cart/checkout → progress/earnings → notifications → profile incl. language toggle). Deferred to the user per their explicit request.

## 7. Files Touched (by layer, high level)

- `lib/domain/{catalog,campus_directory,auth,teacher_onboarding,student_onboarding,notifications,student_cart,test_taking,live_test_registration,earnings}/**`
- `lib/data/{catalog,campus_directory,auth,teacher_onboarding,student_onboarding,notifications,student_cart,test_taking,live_test_registration,earnings}/**`
- `lib/presentation/{auth,teacher_onboarding,student_onboarding,student_home,teacher_overview,notifications,student_cart,test_taking,student_progress,teacher_students,live_test_registration,teacher_earnings,student_profile,teacher_profile}/**`
- `lib/core/{di/injection.dart, di/riverpod_providers.dart, constants/app_routes.dart, router/app_router.dart, providers/locale_provider.dart, network/**, widgets/**, config/app_config.dart}`
- `lib/app.dart` (locale wiring)
- `CLAUDE.md` (hand-written-Riverpod convention documented as permanent house rule; `AsyncValue.valueOrNull` → `.value` note)

No backend exists yet — every repository still runs against dummy datasources (`AppConfig.isMockMode == true` by default), with the remote-Dio side of every datasource already written and ready to flip on once a real API exists at the contract described in `backend.md`.
