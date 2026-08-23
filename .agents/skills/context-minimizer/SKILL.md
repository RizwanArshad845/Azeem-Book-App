---
name: context-minimizer
description: Practices for compacting conversational context, avoiding redundant tool output, generating tight concise summaries, and structuring subagent handoffs. Use during complex multi-step tasks, refactoring, and code audits.
metadata:
  model: models/gemini-3.1-pro-preview
---
# Context Minimizer & Density Optimization

Guidelines and protocols for keeping the LLM active context window small, fast, and high-density across extended pair programming sessions.

## 1. High-Density Communication Standard
- **No Verbose Echoing**: Never repeat code blocks back to the user that were not changed.
- **Reference Links**: Use GitHub-style markdown links `[filename](file:///path/to/file#L10-L30)` instead of quoting entire files.
- **Direct Action Summaries**: Provide concise bullet lists highlighting what was modified, added, or deleted.

## 2. Progressive Disclosure of Project Specs
- Do not load full specification files like `project_spec.md` (35KB+) or `backend.md` (27KB+) into the context in their entirety.
- Use `view_file` on specific sections:
  - Navigation: `project_spec.md` §10.2
  - Data Schema: `project_spec.md` §9
  - UI Rules: `project_spec.md` §10.1
  - Backend Contracts: specific endpoint sections in `backend.md`

## 3. Subagent Handoff Protocols
When spawning subagents to conserve tokens:
1. **Specify a constrained output schema** in the subagent prompt (e.g. "Return strictly a JSON or 5-bullet list containing file paths, line numbers, and concise summaries").
2. **Select model `flash` or `flash_lite`** for exploratory and read-heavy tasks.
3. **Terminate subagent after completion** so background resources and contexts are clean.
