---
description: "An Agent Skill that teaches Claude Code and other AI coding agents to develop FireMonkey user interfaces with TFrameStand and TFormStand: installation as a plugin, with npx or by hand, and usage examples."
---

# AI Agent Skill

TFrameStand ships with an [Agent Skill](https://code.claude.com/docs/en/skills) that teaches AI coding agents (Claude Code, Cowork, and any tool supporting the open `SKILL.md` format) how to work with TFrameStand and TFormStand. It lives in the [`Skills/`](https://github.com/andrea-magni/TFrameStand/tree/master/Skills) folder of the repository:

| Skill | What it does |
| --- | --- |
| **`tframestand-development`** | FireMonkey UIs with TFrameStand and TFormStand: stands and the [stand gallery](/features/gallery), [dialogs with a result](/features/dialogs), Back/Esc, the [navigation stack](/features/navigation), animations, [Common Actions](/features/common-actions), [context injection](/features/injection), [responsive frames](/features/responsive) and the [lifecycle](/guide/lifecycle) of the subjects, with the rules that avoid the common mistakes (closing a frame inside its own click, keeping freed infos, `TButton.ModalResult`...). |

A skill is a folder with a `SKILL.md` file (instructions, plus a `description` that tells the agent *when* to use it) and `references/` files read on demand. Once installed, the agent uses it by itself when your code uses TFrameStand or you ask for dialogs, side menus, bottom sheets, pages or Back button handling in a FireMonkey app.

::: info Since v.2.3
The skill describes v.2.3 and later: `ShowModal`, Back/Esc, `Push`/`Pop`, the gallery and `ResponsiveMode` are not in older versions.
:::

## Installation in Claude Code (recommended: plugin)

The TFrameStand repository is also a **Claude plugin marketplace**. From Claude Code:

```
/plugin marketplace add andrea-magni/TFrameStand
/plugin install tframestand@tframestand
```

The skill is available at once and is updated when a new version is published. It can also be invoked explicitly:

```
/tframestand:tframestand-development
```

## Installation with npx (any AI tool)

For other agentic tools (Cursor, Codex, ...), or without plugins, the [skills CLI](https://github.com/vercel-labs/skills) installs the same skill into any compatible tool (requires Node.js):

```
npx skills add andrea-magni/TFrameStand
```

## Manual installation (Claude Code / Cowork)

Copy the skill folder into one of the standard skill locations:

- `.claude/skills/` inside your project: project-level, shared with your team via git;
- `~/.claude/skills/`: personal, available in every project.

Example, from your project root (Windows):

```
git clone https://github.com/andrea-magni/TFrameStand
xcopy /E /I TFrameStand\Skills\tframestand-development .claude\skills\tframestand-development
```

Verify with `/skills`, or ask the agent to show a frame as a dialog.

## Other AI agents

The skill is plain Markdown in the open Agent Skills format. Agents without skill support can read it from their instructions file (`AGENTS.md`, `.cursorrules`, custom instructions...):

```markdown
When working on Delphi FireMonkey code that uses TFrameStand or TFormStand, read and follow
Skills/tframestand-development/SKILL.md (and its references/ folder).
```

## Usage examples

With the skill installed, prompts like these produce idiomatic TFrameStand code:

- *"Show TColorPickerFrame as a dialog and use the chosen color when the user confirms."* (`ShowModal` with the frame, `FInfo.ModalResult` in the frame, a `*_cancel` Common Action)
- *"Add a side menu that slides in from the left and closes with the Android Back button."* (the `drawer` stand of the gallery, `CatchBackKey`)
- *"Turn these three frames into a wizard with Next and Back buttons."* (`Push`/`Pop`, slide animations that reverse on `Pop`)
- *"Show the orders as a list on phones and as a grid on wide windows, also when the window is resized."* (`Responsive.Define`, `ResponsiveMode = rmLive`, `OnResponsiveChange`)
