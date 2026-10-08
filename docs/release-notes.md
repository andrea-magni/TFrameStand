# Release Notes

Releases are published on [GitHub](https://github.com/andrea-magni/TFrameStand/releases) and on GetIt.

## Unreleased (master)

- Design-time packages for Delphi 12 and 13 fixed to require the runtime package of their own version ([#91](https://github.com/andrea-magni/TFrameStand/issues/91), [#94](https://github.com/andrea-magni/TFrameStand/issues/94)).

## v.2.0 — March 2026

- Delphi 13 Florence support (`packages\FrameStand_13.groupproj`).

## v.1.9 — November 2023

- Delphi 12 Athens support.
- Non-generic overloads `TFrameStand.New(AFrameClassName)` and `TFrameStand.Use(AFrame)` ([#71](https://github.com/andrea-magni/TFrameStand/issues/71)), useful when the frame class is known only at runtime.

## v.1.8 — March 2022

- Delphi 11.1 Alexandria support.
- Reworked `Responsive` demo.

## v.1.7 — November 2021

- Delphi 11 Alexandria support; all the demos upgraded.
- Gaussian blur in the `lightbox` demo.

## v.1.6 — May 2020

- Delphi 10.4 Sydney support.

## v.1.5 — October 2019

- **TFormStand**: the twin of TFrameStand that uses `TForm` descendants as subjects, sharing the engine through the new `SubjectStand` unit.
- New methods: `CloseAll`, `CloseAllExcept`, `HideAndClose`, `HideAndCloseAll`, `HideAndCloseAllExcept`, `FrameInfo` overloads.
- `Show(ABackgroundTask, ...)` deprecated: background work is now left to the application (see [Background Work](/features/background-work)).
- Separate runtime and design-time packages for 10.3 Rio.

::: tip Migrating to 1.5
Some attributes moved to the `SubjectStand` unit: add it to the `uses` clause wherever you use `FrameStand`.
:::

## v.1.4 — November 2018

- `OnAfterShow` event.
- `VisibleFrames` property.
- Responsive capabilities (breakpoints and frame substitution).
- Packages for 10.3 Rio.

## v.1.3 — April 2017

- `OnAfterHide` event.
- Common Actions bound to every `TControl` descendant.
- Packages for 10.2 Tokyo.

## v.1.2 — October 2016

- `Status` property.
- Workaround for an FMX alignment issue in 10.1 Berlin ([#12](https://github.com/andrea-magni/TFrameStand/issues/12)).
- Packages for Seattle, Berlin and XE8.

## v.1.1 — November 2015

- Improved component editor.
- `Hiding` property; multiple `Hide` calls ignored while hiding.
- Hide delay computed automatically from the `OnHide*` animations.
- `TActionList` support for Common Actions.
- `DefaultParent` property.
- Fix: the search of the controls to bind to Common Actions was not recursive.

## v.1.0 — November 2015

First release, presented at [CodeRage X](https://www.youtube.com/watch?v=Z6_ZvnCmFCw).
