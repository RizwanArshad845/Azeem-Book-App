# Code Review & Architecture Audit Findings

> [!NOTE]
> This document summarizes the post-build architectural, state management, localization, and performance audit for Phase 1 of **Azeem Book App**.

---

## 1. Localization Audit & Implementation

### Status & Verification
- **Infrastructure**: Configured via `l10n.yaml`, `flutter_localizations`, and custom extension helper `context.l10n` in `lib/core/extensions/context_extensions.dart`.
- **Supported Languages**: English (`en`) and Urdu (`ur`).
- **ARB Files**:
  - `lib/l10n/app_en.arb` (English translation keys for Auth, Onboarding, Test-Taking, Cart, Dashboards, Profile, and Dialogs)
  - `lib/l10n/app_ur.arb` (Complete Urdu translations for all corresponding keys)
- **Language Switcher**: Integrated in `StudentProfileView` and `TeacherProfileView` using `LocaleController` (`localeProvider`), allowing dynamic runtime locale switching between English and Urdu.

---

## 2. setState vs. Riverpod Compliance Audit

### Ephemeral UI State (`setState`) Call Site Breakdown
All 13 `setState` calls in `lib/` were audited and confirmed to manage **only local, non-persisted widget UI state**:

| File Path | Line(s) | Ephemeral State Usage | Compliant? |
| :--- | :--- | :--- | :--- |
| `teacher_signup_view.dart` | 88, 100, 181, 225 | Campus selection dropdown & subject checkbox list toggles before form submit | Yes |
| `board_class_select_view.dart` | 78 | Temporary selection index before tapping Continue | Yes |
| `campus_select_view.dart` | 72 | Radio highlight state before tapping Next | Yes |
| `subject_teacher_select_view.dart` | 38, 49 | Local subject-to-teacher map binding | Yes |
| `checkout_view.dart` | 35, 40 | Local `_isProcessing` spinner toggle during async payment call | Yes |
| `otp_digit_box.dart` | 10 (doc) | FocusNode highlight ring state | Yes |
| `phone_entry_view.dart` | 36, 39 | Local inline phone format error text toggle | Yes |
| `press_scale.dart` | 22 | Touch down/up scale micro-animation (`_pressed`) | Yes |

### Git History Analysis
- `git log -S "setState"` shows no historical instances where business state was put into `setState` and later reverted.
- All domain & feature business states (Auth user session, Student onboarding, Teacher onboarding, Cart items, Test attempts, Earnings) were built directly using Riverpod `NotifierProvider` / `AsyncNotifierProvider` per `CLAUDE.md §2`.

---

## 3. Code Optimization & N+1 Loop Analysis

### Identified N+1 Provider Execution Patterns
1. `student_home_viewmodel.dart` — `liveTestsProvider` iterates through enrolled subjects calling `getTestsUseCase(subjectId)` individually.
2. `student_progress_viewmodel.dart` — `studentProgressViewModelProvider` iterates over test IDs calling `getQuestionsUseCase(testId)`.
3. `teacher_students_viewmodel.dart` — `teacherStudentsViewModelProvider` loops through board/class pairs calling `getSubjectsUseCase(boardId, classId)`.

### Audit Verdict
- **Impact**: Zero impact during Phase 1 mock/dummy data testing (single-digit records).
- **Backend Action Item**: During backend integration (Phase 2), implement batch fetch APIs (e.g. `GET /api/v1/tests?subjectIds=1,2,3`) to eliminate multiple HTTP calls in a loop.

---

## 4. Dependency Injection (DI) Memory & Factory Scope Audit

### Analysis
- **Factory Registration (`sl.registerFactory`)**: 25 Use Cases.
- **Lazy Singleton Registration (`sl.registerLazySingleton`)**: 21 Repositories and Data Sources.

### Memory & Performance Impact
- Use cases in this application are stateless `const` classes containing only a reference to their repository interface.
- Instantiation costs negligible memory (~bytes). Allocations occur strictly upon ViewModel initialization per screen visit.
- **Verdict**: Harmless. Converting Use Cases to singletons is optional but unnecessary for runtime performance.

---

## 5. Shared Widget Consolidation

To prevent private widget duplication across subagents, 4 consolidated shared components were established in `lib/core/widgets/`:

1. `StatSummaryCard` (`lib/core/widgets/stat_summary_card.dart`)
   - Standardized dashboard stat tile.
   - Replaces bespoke cards in `teacher_overview_view.dart`, `teacher_earnings_view.dart`, and `average_score_card.dart`.
2. `StatusBadge` (`lib/core/widgets/status_badge.dart`)
   - Consolidated badge widget for status chips ("Registered", "Pending", "Passed", "Failed").
   - Applied across `board_class_select_view.dart`, `live_tests_view.dart`, `attempt_card.dart`, and home views.
3. `AppListRow` (`lib/core/widgets/app_list_row.dart`)
   - Unified list item layout wrapping `AppCard`.
   - Refactored `StudentCard`, `EarningsRecordCard`, `_NotificationCard`, `_LiveTestCard`, and `attempt_card.dart`.
4. `confirmDialog` (`lib/core/widgets/confirm_dialog.dart`)
   - Global alert dialog helper for confirmation dialogs.
   - Used in `StudentProfileView`, `TeacherProfileView`, and `TestTakingView`.
