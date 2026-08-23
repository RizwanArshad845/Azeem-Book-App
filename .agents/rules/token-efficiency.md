# Token Efficiency Rules

1. **Precision File Reading**:
   - Never use `view_file` on whole files > 100 lines without setting `StartLine` and `EndLine`.
   - First locate target symbols using `grep_search`, then view a 30-line slice.

2. **Precision Code Editing**:
   - Never overwrite entire existing files using `write_to_file`. Always use `replace_file_content` targeting single concise contiguous blocks.

3. **Avoid Reading Generated / Large Artifacts**:
   - Exclude `*.g.dart`, `*.freezed.dart`, `*.mocks.dart`, `build/`, and `.dart_tool/` from file reading and searches.
   - For specs (`project_spec.md`, `backend.md`), read only the specific section needed.

4. **Concise High-Density Responses**:
   - Use file links `[file.dart](file:///...)` rather than dumping unaltered code blocks in conversation.
   - Keep summaries direct, clear, and actionable.

5. **Subagent Offloading**:
   - For wide exploration, multiple grep iterations, or scanning multiple directories, invoke a lightweight `flash` subagent (`token-scout`) to keep the parent context lean.
