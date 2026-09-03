---
name: scaffold-feature
description: Generate standard Clean Architecture + MVVM folder skeleton and stub files for a given feature name in Azeem Book App.
---

# Skill: scaffold-feature

When invoked with a feature name (e.g., `teacher-overview`, `student-cart`, `test-taking`), generate the exact folder structure and stub files adhering to `project_spec.md` §2.1.

## Target Structure

For `<feature>` (formatted in snake_case, e.g., `teacher_overview`):

1. **`lib/data/<feature>/`**
   - `datasources/remote/<feature>_remote_datasource.dart`
   - `models/<feature>_dto.dart`
   - `repositories/<feature>_repository_impl.dart`

2. **`lib/domain/<feature>/`**
   - `entities/<feature>_entity.dart`
   - `repositories/<feature>_repository.dart`
   - `usecases/get_<feature>_usecase.dart`

3. **`lib/presentation/<feature>/`**
   - `view/<feature>_view.dart`
   - `viewmodel/<feature>_viewmodel.dart`
   - `widgets/<feature>_card.dart`

## Rules & Conventions

- Domain layer files must NOT import Flutter, Riverpod, or Data layer code.
- Data layer repositories MUST call their `remote` datasource directly — no dummy/mock datasource layer.
- Presentation viewmodels MUST use Riverpod code generation (`@riverpod`).
- Views MUST render responsive layouts using `context.colors` and `context.dimens`.
