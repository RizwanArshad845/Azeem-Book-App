# Token Saving Playbook & Best Practices

## 1. Context Window Conservation

Every prompt sent to an LLM incurs processing cost across the entire chat transcript. Minimizing cumulative context size directly accelerates response speed and reduces token costs.

### Key Rules
1. **Never read generated code**: Files like `*.g.dart`, `*.freezed.dart`, `*.mocks.dart`, `l10n/*.dart` contain thousands of boilerplate lines. Never load them into the context window. Read the source entity or abstract contract instead.
2. **Use bounded `grep_search` and `find_by_name`**:
   - Limit file searches to `SearchDirectory: "lib/domain"` or `"lib/presentation"`.
   - Never search indiscriminately at the root directory when looking for UI widgets or repositories.
3. **Use targeted line slices**:
   - Inspecting a 1,000-line file consumes ~4,000 tokens per call.
   - Slicing 40 lines (`StartLine: 120`, `EndLine: 160`) consumes ~200 tokens. (95% token savings).

---

## 2. Surgical File Edits

1. **Avoid `write_to_file` on existing files**:
   - `write_to_file` requires the model to output the entire contents of the file again in the tool call argument, consuming massive output tokens.
   - `replace_file_content` outputs only the replacement lines.
2. **Match exact surrounding context**:
   - Include 2-3 lines of surrounding code to make `TargetContent` unique within the file range `[StartLine, EndLine]`.

---

## 3. Subagent Delegation Architecture

```text
Parent Agent (Main Conversation Context)
   │
   ├─► Flash Subagent: Codebase Scout (reads 10 files, grep 20 terms in isolated context)
   │     └─► Returns: "Target method is at lib/presentation/home/view_model.dart:45"
   │
   └─► Parent Agent performs single 5-line precision edit!
```

By offloading heavy exploratory file reading to subagents running on `flash` or `flash_lite`, the parent agent's conversation history stays lean, snappy, and token-efficient.
