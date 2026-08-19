---
name: add-schema-entity
description: Generate Freezed domain Entity and data DTO with fromJson/toJson strictly from project_spec.md §9.2 YAML schema.
---

# Skill: add-schema-entity

When given an entity name defined in `project_spec.md` §9.2 (such as `Teacher`, `Student`, `Test`, `Question`, `TestAttempt`, `SubjectEnrollment`, `EarningsRecord`, `Cart`, `Payment`, etc.):

1. Read the exact field definitions, types, default values, and nullability requirements from `project_spec.md` §9.2 YAML block.
2. Generate the **Domain Entity** in `lib/domain/<feature>/entities/<entity_name>.dart`:
   - `@freezed` class definition.
   - Strictly match Dart data types (`String`, `int`, `double`, `bool`, `DateTime`, etc.).
   - Explicit nullability (optional fields with `?`, non-optional fields without `?`).
   - Zero Flutter/Data package imports.
3. Generate the **Data DTO** in `lib/data/<feature>/models/<entity_name>_dto.dart`:
   - `@freezed` and `@JsonSerializable()` annotations.
   - `factory <EntityName>Dto.fromJson(Map<String, dynamic> json)` constructor.
   - Mapper functions: `.toDomain()` and `fromDomain(<EntityName> entity)`.
4. Ensure no extra fields are invented and no schema constraints are dropped.
