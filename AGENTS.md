# Antigravity Agent Guidelines — Azeem Publications

This workspace is configured with specialized token-saving skills, rules, and subagent architectures.

## Architecture & Codebase Standards
- **Clean Architecture + MVVM**: `lib/core` (DI, router, theme), `lib/domain` (Entities, Use cases), `lib/data` (DTOs, datasources, repo impls), `lib/presentation` (Views, ViewModels).
- **Riverpod State Management**: Hand-written `Notifier` / `AsyncNotifier` (Riverpod 3.x: use `.value`, not `.valueOrNull`).
- **Dependency Injection**: `get_it` service locator registered in `lib/core/di/injection.dart`.
- **Model Generation**: `freezed` + `json_serializable`. Run `flutter pub run build_runner build --delete-conflicting-outputs`.

## Token Optimization & Efficiency Rules
1. **Targeted Reading**: Always use `StartLine` and `EndLine` in `view_file`. Use `grep_search` to find line numbers first.
2. **Surgical Edits**: Use `replace_file_content` for editing existing files. Do not rewrite whole files with `write_to_file`.
3. **No Generated Files**: Do not read `*.g.dart`, `*.freezed.dart`, or build artifacts.
4. **Subagent Delegation**: Offload multi-file exploration and scanning to lightweight `flash` subagents (`token-scout`).
5. **High-Density Outputs**: Use concise markdown bullet points and clickable `file:///` links.
