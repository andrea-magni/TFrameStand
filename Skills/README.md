# TFrameStand skill for Claude (Claude Code / Cowork)

This folder contains an [Agent Skill](https://code.claude.com/docs/en/skills) for working with TFrameStand and TFormStand:

- **`tframestand-development/`** — develop FireMonkey UIs with TFrameStand/TFormStand: stands and the stand gallery, dialogs with a result (`ShowModal`, `ModalResult`), Back/Esc, navigation stacks (`Push`/`Pop`), animations, Common Actions, context injection, responsive frames (`ResponsiveMode = rmLive`) and the lifecycle of the subjects.

## Install as a plugin (recommended)

This repository is also a Claude plugin marketplace. From Claude Code:

```
/plugin marketplace add andrea-magni/TFrameStand
/plugin install tframestand@tframestand
```

The skill becomes available automatically (also invocable as `/tframestand:tframestand-development`) and gets updated when new versions are published.

## Install with npx (any AI tool)

If you use other agentic tools besides Claude Code (Cursor, Codex, ...) or prefer not to use plugins, the [skills CLI](https://github.com/vercel-labs/skills) installs the same skill into any compatible tool (requires Node.js):

```
npx skills add andrea-magni/TFrameStand
```

## Manual install

Alternatively, copy the skill folder into one of:

- `.claude/skills/` inside your own project (project-level, shared with your team via git);
- `~/.claude/skills/` (personal, available in every project).

Example (from your project root):

```
git clone https://github.com/andrea-magni/TFrameStand
xcopy /E /I TFrameStand\Skills\tframestand-development .claude\skills\tframestand-development
```

Verify with `/skills` or just ask Claude to show a frame as a dialog with TFrameStand.
