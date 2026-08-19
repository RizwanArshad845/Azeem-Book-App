# Azeem Publications — Main App (Flutter) Project Guidelines

> Full architecture, data schema, and screen breakdown live in `project_spec.md` — read the relevant section (`§9` for schema, `§10.2` for nav, etc.) only when the current task needs it, don't load the whole file by default.

## Core Rules & Architecture

1. **Clean Architecture + MVVM Pattern**:
   - `lib/core`: Cross-cutting DI, router, theme, config, constants, extensions, shared widgets, network.
   - `lib/domain/<feature>`: Entities (`freezed`), abstract repository interfaces, single-purpose use cases. Zero Flutter/Riverpod/package dependencies.
   - `lib/data/<feature>`: DTOs/models (`freezed` + `json_serializable`), datasources (remote Dio + local dummy), repository implementations.
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

4. **Dummy-Data-First Rule**:
   - Every repository MUST choose between remote and dummy datasources via `AppConfig.isMockMode`.
   - Never call a real API endpoint directly from a viewmodel or view.

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
