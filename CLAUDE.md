# Azeem Publications — Main App (Flutter) Project Guidelines

> Full architecture, data schema, and screen breakdown live in `project_spec.md` — read the relevant section (`§9` for schema, `§10.2` for nav, etc.) only when the current task needs it, don't load the whole file by default.
>
> Backend/API contract (Django + DRF design doc, cross-referenced against actual Flutter entities/DTOs/endpoints) lives in `backend.md` — read it when working on remote datasources, DTO shapes, or anything that needs to match a real backend contract. Django project architecture and coding conventions (MVT layering, service layer, ORM patterns, testing/settings conventions) live in `backend_architecture.md` — read it when scaffolding or reviewing the actual Django backend implementation.

## Core Rules & Architecture

1. **Clean Architecture + MVVM Pattern**:
   - `lib/core`: Cross-cutting DI, router, theme, config, constants, extensions, shared widgets, network.
   - `lib/domain/<feature>`: Entities (`freezed`), abstract repository interfaces, single-purpose use cases. Zero Flutter/Riverpod/package dependencies.
   - `lib/data/<feature>`: DTOs/models (`freezed` + `json_serializable`), remote Dio datasources, repository implementations.
   - `lib/presentation/<feature>`: Views, ViewModels (hand-written `Notifier`/`AsyncNotifier`, see §2 below), feature widgets. No raw repository or entity calls directly from views.

2. **State Management**:
   - Riverpod is mandatory for all business state, via `Notifier`/`AsyncNotifier` subclasses + a manually declared `NotifierProvider`/`AsyncNotifierProvider` (e.g. `final fooViewModelProvider = AsyncNotifierProvider<FooViewModel, T>(FooViewModel.new);`), named exactly as `@riverpod` codegen would generate. **Not `@riverpod` codegen** — `riverpod_generator`/`riverpod_annotation` are not installed: no current version resolves against this project's pinned `freezed`/`json_serializable`/`build_runner`/`flutter_riverpod ^3.4.2` versions (confirmed via `flutter pub add`, version-solving fails on `analyzer` constraints). Re-evaluate if the ecosystem catches up, but don't re-attempt without checking `flutter pub add riverpod_annotation dev:riverpod_generator` resolves cleanly first.
   - `setState` is strictly forbidden for business or shared state (ephemeral local focus/animations only).
   - This project pins `flutter_riverpod ^3.4.2` (Riverpod 3.x): `AsyncValue.valueOrNull` no longer exists — `.value` itself is now the nullable-safe accessor. Don't write `.valueOrNull`.
   - Use `ref.watch(provider.select(...))` in UI build methods; `ref.read` in handlers.
   - Use `AsyncValue<T>` for async data states across views.

3. **Dependency Injection**:
   - Service locator powered by `get_it` in `core/di/injection.dart`.
   - Riverpod providers expose `get_it` instances to the UI layer.

4. **Real-Backend-Only Rule**:
   - There is no dummy/mock datasource layer or `AppConfig.isMockMode` switch — every repository calls its remote Dio datasource directly.
   - Never call a real API endpoint directly from a viewmodel or view; always go through a repository/use case.

5. **UI & Design Rules (§10.1)**:
   - One primary action per screen (prominent `AppButton`).
   - Reuse shared widget kit (`AppButton`, `AppTextField`, `AppDropdown`, `AppCard`, `SectionProgressIndicator`, `LoadingIndicator`, `AppSnackbar`, `EmptyStateView`).
   - No hardcoded colors or spacing: use `context.colors` and `context.dimens`.
   - Cards for scannable data, not tables.

6. **Navigation & Routing (§10.2)**:
   - Navigation via `go_router` with `StatefulShellRoute.indexedStack` for bottom navigation shell routes.
   - Onboarding and active test-taking flows pushed on top or outside shell routes.

7. **Code Generation & Models**:
   - `freezed` for models/entities, `json_serializable` for JSON mapping.
   - Run `flutter pub run build_runner build --delete-conflicting-outputs` after any model change (ViewModels are hand-written, not codegen'd — see §2).

## UI & Flow Guidelines (Handwritten Corrections & Specs)

1. **Floating Card Onboarding UI ("Kiraya" Card Layout)**:
   - Onboarding screens (Student & Teacher) must use a centered floating `Card` container sitting over a branded background pattern populated with generated icons/emojis and optional dialogue bubbles.
   - Azeem Publications Logo must be displayed prominently at the top of every onboarding screen layout.
   - Phone number input stays inside the card (no full-screen phone page). On phone submit, an inline/modal **OTP Sheet** opens directly over the card for immediate verification.

2. **Student Class & Subject Rules**:
   - Class options are strictly: `9th`, `Matric`, `1st year`, `2nd year`.
   - If `1st year` or `2nd year` is selected, dynamically present stream selection: `Pre-Engineering`, `Pre-Medical`, `I.Com`, `F.A`, `I.C.S`.
   - Subject representation uses **illustrations with a native-icon fallback**: per-subject illustration assets (dropped into `assets/illustrations/`, resolved by `subjectIllustration(name)`) render on subject/course cards, falling back to the native Flutter icon (`subjectIcon(name)`) when an asset is missing. (Round-2 change: illustrations supersede icon-only cards; icons remain the guaranteed fallback.)
   - Post-onboarding subject additions: Subject cards permit direct subject addition/purchase with animated badge updates on the navigation bar Cart icon.

3. **Teacher Onboarding & Validation Rules**:
   - Initial check: "Onboarded via Azeem Developer/Book" vs "Outside Teacher". Pre-seeded Azeem Developer teachers log in directly via SMS OTP (fetching pre-entered details to dashboard); outside teachers proceed through full onboarding.
   - Phone field validation: Strict 11-digit format starting with `03...` (e.g. `03001234567`) with inline error/toast feedback.
   - Class selection: Multi-select — a teacher may teach more than one class. Subjects are unioned (deduplicated by name) across all selected classes.
   - Required fields marked with a prominent **red asterisk (`*`)**.
   - Student count widget: Integer counter input with explicit `+` / `-` increment & decrement buttons.
   - Submit buttons: Greyed out / disabled until all mandatory fields pass validation.

4. **App Header, Navigation & Profile**:
   - AppBar titles must be centered with highlighted background separation.
   - App bar actions: Dedicated IconButtons for Notifications and Profile (replacing the old kebab action menu).
   - Bottom navigation: 3 tabs each (Student: Home, Cart, Progress; Teacher: Overview, Students, Earnings).
   - Logout & Delete Account: Accessible from within the Student and Teacher Profile screens (with confirm dialog and GitHub-style typed confirmation for destructive deletion).

5. **Test-Taking, Scoring & Analytics**:
   - Question lock: Next question button disabled/greyed out if answer is not selected/entered.
   - Score screen: Display detailed solutions for wrong answers and weak topics.
   - Re-attempt option: Enabled based on test score/results, dynamically updating student attempt records & progress.
   - View expected test preview option prior to attempt.
   - Progress Screen: Visually attractive & detailed analytics with filter toggles for **Overall Cumulative Progress** vs **Per-Subject Progress**. Center empty states when no progress exists.
   - Teacher Earnings: Creative card layout, projected revenue metrics, and personalized greeting (e.g., "Welcome back, [Teacher Name]!").

## Subagents & Specialized Skills (`.claude/`)

### 1. Dedicated Project Subagents (`.claude/agents/`)
- **`feature-builder`**: Autonomous Clean Architecture feature builder for scaffolding entities, DTOs, datasources, repositories, ViewModels, and views.
- **`schema-auditor`**: Entity & backend contract auditor that verifies synchronization between Flutter DTOs (`freezed`), API endpoints, and Django models.
- **Domain Subagents**: `flutter-ui-development`, `state-management`, `backend-integration`, `database-storage`, `performance-optimization`, `testing-qa`, `devops-deployment`, `flutter-platform-native`.

### 2. Custom Project Skills (`.claude/skills/`)
- **`scaffold-feature`**: Standardized scaffold generator for feature modules across `domain/`, `data/`, and `presentation/`.
- **`add-schema-entity`**: Generator for new `freezed` data models, DTOs, and repository interfaces.
- **Domain Skills**: `flutter-ui`, `state-management`, `backend-integration`, `database-storage`, `performance`, `testing`, `devops`, `accessibility`, `animations`, `localization`, `navigation`, `plugins`.

## Universal Agent Skills (`.agents/skills/`)

The workspace includes installed skill plugins for Flutter and Dart AI agents:
- **`flutter/agent-plugins`**: Architecture best practices, responsive layouts, layout issue diagnostics, JSON serialization patterns, declarative routing (`go_router`), localization, HTTP package integration.
- **`dart-lang/skills`**: Package conflict resolution, static analysis, pattern matching, primary constructors, FFI assets, ffigen, documentation standards.



