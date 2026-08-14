# Azeem Publications — Flutter Dev Release Build Plan

## Context

The user pasted a complete, pre-written build spec (`claude_code_prompt.md`) for a Flutter
dev-release demo app for Azeem Publications: a student onboarding flow followed by a Computer
Science diagnostic test with radar-chart results, built mobile-only with no backend (all state
local via Riverpod), to be shown to a client. The spec also mandates a specific production-grade
architecture (Clean Architecture + MVVM, GetIt DI, freezed/json_serializable models, themed
design tokens, ARB localization scaffolding, SOLID) so that a real backend can be slotted in
later with changes confined to the `data/` layer.

The project directory (`C:\Users\arsha\OneDrive\Desktop\azeem_book_app`) started as the default
`flutter create` counter app. This is a from-scratch build.

Two facts verified against the real repo that update the original spec:
- The question bank JSON exists at `assets/computer_science_question_bank.json` (**not**
  `assets/data/question_bank.json` as the spec assumed) and matches the described schema:
  `{subject, chapters, mcqs, shortQuestions}` — 8 chapters, 48 MCQs, 76 short questions.
  **Chapter ids in the data are `1,2,3,4,5,6,7,9`** — not contiguous 1–8 (chapter 8 is simply
  absent from the source material). Code must treat `chapter` as an opaque id, never assume
  contiguity or use it as a 0-based index.
- The logo now exists at `assets/images/azeem_academy_logo.png`, matching the intended final
  path exactly. `pubspec.yaml`'s wildcard `assets:` entry (`assets/`) already covers it.

Goal of this plan: implement the full spec end-to-end (onboarding → home → diagnostic test →
results) as a polished, working dev build, with a **freshly randomized 40-question test for
every student/session** — no caching or seeding that would make two attempts identical.

## Dependencies

```
flutter pub add flutter_riverpod go_router fl_chart freezed_annotation json_annotation get_it flutter_svg intl dropdown_search
flutter pub add flutter_localizations --sdk=flutter
flutter pub add dev:build_runner dev:freezed dev:json_serializable
```
- `dropdown_search` for the searchable College dropdown and dynamic Subject dropdowns.
- `generate: true` under `flutter:` in `pubspec.yaml`, plus a root `l10n.yaml`
  (`arb-dir: lib/l10n`, `template-arb-file: app_en.arb`,
  `output-localization-file: app_localizations.dart`, `synthetic-package: false`).

## Directory structure (Clean Architecture + MVVM, per spec §0)

```
lib/
  main.dart, app.dart
  l10n/app_en.arb
  core/
    constants/app_assets.dart, app_routes.dart
    config/app_config.dart
    theme/app_colors.dart, app_dimensions.dart, app_theme.dart
    extensions/context_extensions.dart
    utils/validators.dart
    di/injection.dart, riverpod_providers.dart
    services/logger.dart
    router/app_router.dart
    widgets/ (AppButton, AppTextField, AppDropdown, SectionProgressIndicator,
               RadioOptionTile, ChapterScoreTile, LoadingIndicator, AppSnackbar, AppLogo)
  domain/                      # pure Dart, zero Flutter/core imports
    common/result.dart, failure.dart
    onboarding/entities/{student_profile,class_level}.dart
    onboarding/repositories/{college_repository,subject_repository}.dart
    question_bank/entities/{chapter,mcq_question,short_question,test_question,question_bank}.dart
    question_bank/repositories/question_bank_repository.dart
    diagnostic/entities/{self_assessment_ratings,test_answer,test_session,
                          chapter_score_result,results_summary}.dart
    diagnostic/usecases/{build_test_session_usecase,grade_short_answer_usecase,
                          calculate_results_usecase}.dart
  data/
    question_bank/models/{chapter_dto,mcq_dto,short_question_dto,question_bank_dto}.dart
    question_bank/repositories/question_bank_repository_impl.dart
    onboarding/repositories/{college_repository_impl,subject_repository_impl}.dart
  presentation/
    splash/view/splash_view.dart, viewmodel/splash_viewmodel.dart
    onboarding/state/onboarding_state.dart
    onboarding/viewmodel/onboarding_viewmodel.dart
    onboarding/view/{phone_number_view,otp_sheet_view,personal_info_a_view,
                      personal_info_b_view,personal_info_c_view,subject_count_view,
                      subject_selection_view}.dart
    onboarding/widgets/{otp_digit_box,class_level_segmented_control}.dart
    home/view/home_view.dart, viewmodel/home_viewmodel.dart
    home/widgets/{home_feature_card,subject_picker_sheet}.dart
    diagnostic/viewmodel/{self_assessment_viewmodel,consent_viewmodel,test_viewmodel,
                           test_timer_viewmodel,results_viewmodel}.dart
    diagnostic/view/{self_assessment_view,consent_view,test_view,results_view}.dart
    diagnostic/widgets/{chapter_confidence_slider,mcq_question_card,short_question_card,
                         question_grid_sheet,rec_indicator,countdown_timer_bar,
                         readiness_gauge}.dart
```

Each entity/DTO/state class one file; keep view files "dumb" (state read via `ref.watch`,
actions via viewmodel calls only — no business logic in widgets, no `setState` for app state,
only for pure ephemeral UI per spec §0).

## Build order

1. **Core infra** — constants, `AppColors`/`AppDimensions`/`AppTheme`, `context_extensions.dart`,
   `core/widgets/`, `logger.dart`, `validators.dart`. No codegen dependency yet.
2. **Domain layer** — `result.dart`/`failure.dart`, then onboarding/question_bank/diagnostic
   entities and repository interfaces/use cases.
3. **Data layer** — DTOs (`@freezed` + `@JsonSerializable` mirroring the JSON exactly, including
   the `type` discriminator) and repository impl signatures.
   - **Run `dart run build_runner build --delete-conflicting-outputs` once here.**
4. **DI wiring** — `core/di/injection.dart` (GetIt registrations) + `riverpod_providers.dart`
   (bridge `sl<T>()` into `Provider<T>`s).
5. **Feature-by-feature presentation**, in user-flow order: Splash → Onboarding → Home →
   Diagnostic (self-assessment → consent → test → results).
6. **Router wiring last** (`core/router/app_router.dart`), once every view target exists.
7. **Verification** — see below.

## Key data model shapes

- `StudentProfile {name, city, college, classLevel, classCode?, subjects, phoneNumber}`
- `Chapter {chapter, title, mcqCount, shortCount}` — `chapter` is the raw JSON id, unmapped.
- `McqQuestion {id, chapter, question, options, correctIndex}`
- `ShortQuestion {id, chapter, question, modelAnswer}`
- `TestQuestion` — freezed sealed union `.mcq(McqQuestion) | .short(ShortQuestion)`.
- `TestSession {sessionId, questions, answers, currentIndex, status, consentAcknowledged, startedAt}`
- `TestAnswer {questionId, chapter, isMcq, selectedIndex?, textAnswer?, scoreFraction}`
- `SelfAssessmentRatings` — `Map<int chapter, int rating>` (1–5, default 3).
- `ChapterScoreResult {chapter, title, scorePercent, band(red|yellow|green)}`
- `ResultsSummary {chapterScores, overallReadinessPercent, selfAssessmentPercent, testScorePercent}`

## Routing (go_router)

Provider-backed `GoRouter` driven by a `ChangeNotifier` listening to onboarding/test viewmodels
for `redirect`. Routes: `/splash`, `/onboarding/phone` (OTP is a bottom sheet over this route),
`/onboarding/personal-info/a|b|c`, `/onboarding/subject-count`, `/onboarding/subjects`, `/home`,
`/diagnostic/self-assessment`, `/diagnostic/consent`, `/diagnostic/test`, `/diagnostic/results`.

Redirect rules enforce the linear flow on any navigation attempt. The no-resume/exit-confirm
requirement is handled in `test_view.dart` via `PopScope(canPop: false, ...)`.

## Scoring (domain use cases, not viewmodels)

- `BuildTestSessionUseCase` — allocates 40 questions across the 8 chapters proportional to each
  chapter's share of the 124-question pool (largest-remainder rounding), splits MCQ/short
  proportionally per chapter the same way, samples without replacement, then shuffles final
  order. **Uses an unseeded `Random()` created fresh per invocation** (never a shared/static
  instance, never memoized) so every student gets a different random test each time they start
  one — this is a hard requirement, not just a nice-to-have.
- `GradeShortAnswerUseCase` — tokenize + stopword-strip + keyword-overlap ratio, clamped [0,1].
- `CalculateResultsUseCase` — per-chapter average → band red(<50)/yellow(50–75)/green(>75);
  `overallReadinessPercent = 0.2*selfAssessmentPercent + 0.8*testScorePercent`.

## Verification

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. `flutter gen-l10n`
4. `flutter analyze`
5. `flutter run` and walk the full happy path end-to-end, and confirm two separate test runs
   produce different question sets/order.
