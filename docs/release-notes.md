# Release Notes

Releases are published on [GitHub](https://github.com/andrea-magni/TFrameStand/releases) and on GetIt.

## Unreleased (v.2.1)

**Runtime**
- Hide and close delays use the FMX platform timer instead of a background thread per call; pending hides and closes are cancelled when the subject is closed or the component is destroyed, so their callbacks never run on freed objects. `TDelayedAction.Schedule` returns a cancellable `IDelayedAction`.
- `HideAndClose` called while a `Hide` (or another `HideAndClose`) is in progress now closes the subject when it completes; before, the close was silently dropped.
- Lifecycle methods (`[BeforeShow]`, `[Show]`, `[AfterShow]`, `[Hide]`) accept `[FrameInfo]`, `[FrameStand]`, `[FormInfo]` and `[FormStand]` parameters, like fields. Injection problems raise an `ESubjectStandError` naming the field or parameter, when the subject is created (before: "Parameter count mismatch" or "Invalid class typecast", at `Show`).
- Freeing a form, or a parent, with subjects still on screen no longer crashes: the components watch their stands and subjects (`FreeNotification`) and forget those destroyed by FMX or by the application. The same for adopted frames or forms freed while shown. Forms created with `New` are now freed with their owner (they leaked), and a component destroyed while its stands live on another form removes them.
- `TFormStand`: closing an adopted form without controls no longer raises an assertion, and an adopted form gets back all its controls (about half of them were freed with the stand).

## v.2.0.1 — October 2026

Maintenance release: packages, demos and a few runtime fixes. No API changes.

**Packages**
- Runtime packages build again for every platform: the `-LUDesignIDE` switch is gone from them, it made Android, iOS and macOS builds fail with "Required package 'DesignIDE' not found" ([#90](https://github.com/andrea-magni/TFrameStand/issues/90)).
- Design-time packages: `{$DESIGNONLY ON}` (the #92 fix had been lost for Delphi 13), `designide` in the `requires` clause, each project references only the runtime package of its own version ([#91](https://github.com/andrea-magni/TFrameStand/issues/91), [#92](https://github.com/andrea-magni/TFrameStand/issues/92), [#94](https://github.com/andrea-magni/TFrameStand/issues/94)).
- Consistent CRLF line endings in the source archives ([#88](https://github.com/andrea-magni/TFrameStand/issues/88)).

**Runtime**
- Responsive: the stand name and the parent of a matching definition are applied even when it is not the last definition.
- Responsive: breakpoints no longer depend on the order of the list (`SetBreakpoint` used to break `CurrentBreakpoint`).
- `TBreakpoint` text format is locale-independent (`'xs (768.00)'`).
- `VisibleFrames` / `VisibleForms` keep the Show/Hide history correctly: `Hide` takes back the most recent `Show` of the subject (it used to remove the oldest entry, so `LastShownFrame` / `LastShownForm` could return a hidden subject) and `Close` removes every entry of the subject.
- The deprecated `StyleBook` and `DefaultStyleName` properties are no longer written to the `.fmx` files (still read).
- `DeviceAndPlatformInfo` returns zeroed fields when the device information is not available.

**Demos**
- `Dialog` compiles again ([#84](https://github.com/andrea-magni/TFrameStand/issues/84)); `HelloWorld` calls its `[BeforeShow]` method; both are now in `AllDemosProjectGroup`.

**Documentation**
- New documentation site: <https://andrea-magni.github.io/TFrameStand/>.

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
