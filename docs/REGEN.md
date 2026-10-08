# Regenerating the documentation

The content of this VitePress site is **authored by reading the source code**, the
demos and the GitHub releases: there is no generator that rebuilds the prose from
the `.pas` files. "Regenerating" means having an AI agent (Claude Code) re-synthesize
**only the parts that changed** since the last sync.

## TL;DR

1. Open **Claude Code** in the repository root (`C:\Sviluppo\Librerie\TFrameStand`).
2. Paste the prompt below.
3. Review the changes, run `docs\build.cmd` (it also checks the internal links), commit.

## How it works

- [`.docs-baseline`](./.docs-baseline) holds the `commit=` the docs are aligned to.
- What changed since then:

  ```bash
  git diff --stat <baseline-commit>..HEAD -- source demos packages
  git diff <baseline-commit>..HEAD -- source
  ```

- Mapping (source → page):
  - `SubjectStand.pas` → `guide/core-concepts.md`, `guide/lifecycle.md`, `features/animations.md`,
    `features/common-actions.md`, `features/injection.md`, `reference/subject-info.md`,
    `reference/attributes.md`, `reference/events.md`
  - `FrameStand.pas` → `reference/components.md`, `guide/lifecycle.md`
  - `FormStand.pas` → `features/formstand.md`, `reference/attributes.md`
  - `ResponsiveContainer.pas` → `features/responsive.md`
  - `DeviceAndPlatformInfo.pas` → `features/responsive.md` (last section)
  - `*.Editors*.pas` → `features/component-editor.md`
  - `packages/` → `guide/installation.md`, `reference/units.md`
  - `demos/` → `demos/index.md` and the examples in the feature pages
  - GitHub releases → `release-notes.md`
- `ANALYSIS.md` (not published) is the technical review of the code: when an issue it
  lists is fixed, remove the corresponding "Known issue" boxes from the pages.

## Prompt to paste

```text
Refresh the VitePress documentation in docs/ for TFrameStand.
1. Read docs/.docs-baseline and run `git diff --stat <commit>..HEAD -- source demos packages`.
2. For each changed unit, read the diff and update only the affected pages, following the
   mapping in docs/REGEN.md. Keep the existing style: English, short paragraphs, Delphi
   code samples that compile, tables for members.
3. If a new release exists (`gh release list`), add it to docs/release-notes.md.
4. Run docs\build.cmd and fix any dead link.
5. Update docs/.docs-baseline to the current HEAD and today's date.
Do not touch pages unrelated to the changes.
```
