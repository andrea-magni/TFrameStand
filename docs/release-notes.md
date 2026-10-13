# Release Notes

Releases are published on [GitHub](https://github.com/andrea-magni/TFrameStand/releases) and on GetIt.

## Unreleased (v.2.3)

**Dialogs**
- [Dialog results](/features/dialogs): `ShowModal(AResultProc, AClose = True)` on frame and form infos, with a result procedure that receives the result (and the frame or the form), and a `ModalResult` property that dismisses the dialog. Dialogs hidden or closed without a result report `mrCancel`. The Dialog demo uses them.
- [Back and Esc](/features/dialogs#back-and-esc): with `CatchBackKey` the Back button of Android and the Esc key cancel the topmost dialog; other subjects opt in with `BackKeyAction` (`baHide`, `baHideAndClose`). `HandleBackKey` does the same from your own `OnKeyDown`. The Dialog and ViewAndDialogs demos use it.

**Navigation**
- [Navigation stack](/features/navigation): `Push<T>`, `Pop`, `PopToRoot`, `StackCount`, `StackTop` on `TFrameStand` and `TFormStand`. `PushMode` says what happens to the page below (`pmHide`: hidden and kept, the default; `pmKeepVisible`; `pmClose`: created again by `Pop`). `StackOperation` tells `OnBeforeStartAnimation` whether pages move forward or back. Back and Esc pop the stack. The Wizard demo uses it.

**Responsive**
- [Live responsive](/features/responsive#live-following-the-window): with `ResponsiveMode = rmLive`, subjects created with `New`/`Push` are replaced when their parent moves to another breakpoint (resize, rotation), in the same info: references, the navigation stack and dialogs in progress keep working. `OnResponsiveChange` lets you copy the state to the new subject. The Responsive demo uses it.
- `ShowModal` with a procedure that receives the frame or the form passes the one at the time of the result.

**Stands**
- [Stand Gallery](/features/gallery): `stands\Stands.Light.style` and `stands\Stands.Dark.style` with six ready-made stands (`dialog`, `lightbox`, `bottomsheet`, `drawer`, `snackbar`, `page`), and the Gallery demo.
- [Animation values from the size of the stand](/features/animations#values-from-the-size-of-the-stand): a `TStyleTag` in a `TFloatAnimation` sets its start and stop values from the size of the stand or of the animated element, and from the direction of the navigation stack (`PopStartValue`, `PopStopValue`).
- `HideAndCloseAfter(ADelayMS)` on the infos, for snackbars and toasts.

**Setup**
- The uninstaller also removes `stands`, `tmsbuild.yaml` and `version.txt`.

**Deprecations** (nothing removed: existing code and forms work as before)
- `Show(ABackgroundTask, ...)`: the compiler warning now says what to use instead.
- `StyleBook` and `DefaultStyleName` (old names of `StandBook` and `DefaultStandName`) are no longer shown in the Object Inspector. They still load from old forms, which the IDE saves with the new names. The demos use the new names.

**Demos**
- HelloWorld and Dialog find the units in `..\..\source`, like the other demos, instead of relying on the library path of the IDE.

## v.2.2 — October 2026

Packaging release: setup, TMS Smart Setup, one package folder per Delphi version, TFrameStand in the About box and splash screen of the IDE. No changes to the runtime units.

**Installation**
- [Setup](/guide/installation#setup) (`TFrameStand_2.2_Setup.exe`, Inno Setup): builds and installs the packages in the RAD Studio versions you choose (10.4 to 13), defines `TFRAMESTANDDIR` and adds the source folder to the library path of every platform of the IDE. The setup attached to v.2.1 did not install anything (see below).
- [TMS Smart Setup](/guide/installation#tms-smart-setup) support (`tmsbuild.yaml`, `version.txt`).
- TMS Smart Setup builds the runtime package for Linux64 too, when [FMXLinux](/guide/installation#tms-smart-setup) is installed (suggested by the Smart Setup maintainers).

**IDE**
- TFrameStand is listed in the About box of RAD Studio and on its splash screen, with its version and license (as MARS-Curiosity).
- The components are in the **TFrameStand - Andrea Magni** page of the Tool Palette (it was **Andrea Magni**).
- The design-time package is built for Win64 too and installed in the 64-bit IDE of RAD Studio 12.3 and later, by the setup and by TMS Smart Setup. The design-time units use fully qualified unit names (`System.Classes`, `Winapi.Windows`).

**Packages**
- One folder per Delphi version (`packages\104Sydney`, `11Alexandria`, `12Athens`, `13Florence`) with the same package names in all of them: `FrameStandPackage` and `dclFrameStandPackage` (before: `FrameStandPackage_13`, `dclFrameStandPackage_13`, ...). Remove the old design-time package before installing the new one; projects built with runtime packages must list `FrameStandPackage`.
- The packages for Delphi 11.0 are removed: `11Alexandria` needs 11.1 or later.
- Compiled units go to `lib\<folder>\dcu\<platform>\<config>`, BPL and DCP files to the default folders of the IDE: the packages of different Delphi versions and platforms, built by hand or by the setup, no longer overwrite each other (before, every version shared `lib\dcu`, and Win32 and Win64 shared `lib\bpl` and `lib\dcp`). The C++ headers once committed in `lib\cpp` are removed (they are generated by the build).
- The package groups have a build group (Release; runtime package for Win32 and Win64, design-time package for Win32): the setup builds what it lists. The v.2.1 setup stopped at the start with "no RAD Studio version available" because the groups had none.

## v.2.1 — October 2026

**Delphi 10.4 Sydney is now the minimum version.** The packages for XE8 to 10.3 are removed, together with the code for the ARC compilers (Android and iOS up to 10.3), which could no longer be tested. Delphi 10.3 users can stay on v.2.0.1.

**Quality**
- `TFrameStand` and `TFormStand` share their implementation through a generic base class, `TSubjectStandBase<S, I>` (about 140 duplicated lines removed). Public API unchanged; for descendants, the protected fields `FFrameInfos` / `FFormInfos` are now `FInfos`, and `CloseAll`, `CloseAllExcept`, `HideAndCloseAll`, `HideAndCloseAllExcept` are implemented once in `TSubjectStand`.
- A DUnitX test suite (`tests\`, 54 tests) and a build script (`build.cmd`) that builds packages, demos and tests for a Delphi version and runs the tests. See [Building & Testing](/guide/building).

**Runtime**
- Hide and close delays use the FMX platform timer instead of a background thread per call; pending hides and closes are cancelled when the subject is closed or the component is destroyed, so their callbacks never run on freed objects. `TDelayedAction.Schedule` returns a cancellable `IDelayedAction`.
- `HideAndClose` called while a `Hide` (or another `HideAndClose`) is in progress now closes the subject when it completes; before, the close was silently dropped.
- Lifecycle methods (`[BeforeShow]`, `[Show]`, `[AfterShow]`, `[Hide]`) accept `[FrameInfo]`, `[FrameStand]`, `[FormInfo]` and `[FormStand]` parameters, like fields. Injection problems raise an `ESubjectStandError` naming the field or parameter, when the subject is created (before: "Parameter count mismatch" or "Invalid class typecast", at `Show`).
- Freeing a form, or a parent, with subjects still on screen no longer crashes: the components watch their stands and subjects (`FreeNotification`) and forget those destroyed by FMX or by the application. The same for adopted frames or forms freed while shown. Forms created with `New` are now freed with their owner (they leaked), and a component destroyed while its stands live on another form removes them.
- Common Actions: the actions matching a control run in registration order (it was the random order of a dictionary); `CommonActions.Add` with a pattern already registered replaces its action instead of raising "Duplicates not allowed"; when an action closes the subject, the following ones are not run on the freed info.
- `StandBook`, `CommonActionList` and `DefaultParent` can live on another form or a data module: they are cleared when that component is freed (before, the next `New` used a freed object).
- 3D parents (`TLayer3D`, `TForm3D`) and owners that are not FMX objects: `New` no longer fails with "cannot determine parent Width" when there are no responsive definitions; responsive lookups on 3D layers use the pixel width of their 2D content; a missing parent raises a clear `ESubjectStandError` (before: `EInvalidCast`, or a stand silently left without parent by `Use`).
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
