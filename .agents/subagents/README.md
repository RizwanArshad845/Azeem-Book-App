# Token-Efficient Subagent Specifications

This directory contains persistent definitions and instructions for subagents specialized in low-token execution.

## Subagent Roster

### 1. `token-scout`
- **Model**: `flash` or `flash_lite`
- **Role**: Codebase Scout & Symbol Locator
- **Purpose**: Rapidly traverses the codebase using `grep_search` and `find_by_name`, inspecting narrow line ranges (30-50 lines max). Returns a dense bullet summary of file paths and line numbers without dumping file contents into the parent context.
- **Tools**: Read-only tools (`grep_search`, `find_by_name`, `view_file`, `list_dir`).

### 2. `token-saver-auditor`
- **Model**: `flash`
- **Role**: Code Reviewer & Architecture Compliance Auditor
- **Purpose**: Checks code changes against Clean Architecture, Riverpod 3.x patterns, and Flutter standards without loading entire files.
- **Tools**: Read-only tools.

### 3. `surgical-code-editor`
- **Model**: `inherit` or `pro`
- **Role**: High-Precision Code Modifier
- **Purpose**: Executes pinpoint edits using `replace_file_content` on single contiguous blocks without rewriting full files.
- **Tools**: Read & Write tools (`replace_file_content`, `view_file`, `grep_search`).

## How to Invoke in Antigravity

```dart
// Example invocation of token-scout
invoke_subagent({
  "Subagents": [
    {
      "TypeName": "token-scout",
      "Role": "Codebase Scout",
      "Model": "flash",
      "Prompt": "Find the provider definition for user authentication in lib/presentation or lib/core/di. Return only filename, line number, and signature."
    }
  ]
})
```
