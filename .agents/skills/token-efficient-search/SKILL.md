---
name: token-efficient-search
description: High-precision, zero-waste codebase navigation workflows using bounded pattern searches, path filtering, and symbol indexing. Use when locating classes, methods, providers, routes, or configurations across large codebases without reading full files.
metadata:
  model: models/gemini-3.1-pro-preview
---
# Token-Efficient Codebase Search

Fast, low-context methods to locate code symbols, DI registrations, route definitions, and API integrations in Flutter & Dart codebases.

## Contents
- [Search Strategy Decision Tree](#search-strategy-decision-tree)
- [Bounded Search Patterns](#bounded-search-patterns)
- [Filtering Out Generated & Vendor Files](#filtering-out-generated--vendor-files)
- [Step-by-Step Search Workflow](#step-by-step-search-workflow)

---

## Search Strategy Decision Tree

```text
Do you know the exact file name or partial name?
  ├── YES ──► Use `find_by_name` (Set Pattern='*foo*.dart', MaxDepth=4)
  └── NO  ──► Do you know a class, method, or string literal?
                ├── YES ──► Use `grep_search` (Set Query='class Foo', MatchPerLine=true)
                └── NO  ──► Delegate broad exploration to a `token-scout` (flash subagent)
```

---

## Bounded Search Patterns

### 1. Locating Riverpod Providers / ViewModels
```json
{
  "SearchPath": "C:/Users/arsha/OneDrive/Desktop/azeem_book_app/lib",
  "Query": "Provider<",
  "MatchPerLine": true,
  "Includes": ["lib/presentation/**/*.dart", "lib/core/di/**/*.dart"]
}
```

### 2. Finding Specific Feature Entities / Models
```json
{
  "SearchPath": "C:/Users/arsha/OneDrive/Desktop/azeem_book_app/lib/domain",
  "Query": "class ",
  "MatchPerLine": true
}
```

### 3. Finding GoRouter Route Definitions
```json
{
  "SearchPath": "C:/Users/arsha/OneDrive/Desktop/azeem_book_app/lib/core/router",
  "Query": "GoRoute",
  "MatchPerLine": true
}
```

---

## Filtering Out Generated & Vendor Files

Always exclude generated files from searches:
- `*.g.dart`
- `*.freezed.dart`
- `*.mocks.dart`
- `build/`
- `.dart_tool/`

When using `grep_search`, filter with `Includes: ["!**/*.g.dart", "!**/*.freezed.dart", "!**/build/**"]`.

---

## Step-by-Step Search Workflow

1. **Step 1**: Narrow the search path to the specific Clean Architecture layer (`lib/core`, `lib/domain`, `lib/data`, or `lib/presentation`).
2. **Step 2**: Execute `grep_search` with exact case-sensitive regex or literal string matching.
3. **Step 3**: Identify the exact filename and line number from the match list.
4. **Step 4**: Open **only** the 30-50 lines surrounding the target line via `view_file` (`StartLine` and `EndLine`).
5. **Step 5**: Execute the required change using `replace_file_content`.
