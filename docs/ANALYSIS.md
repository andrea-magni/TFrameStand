# TFrameStand — technical review (October 2026)

Internal document, not published on the site (excluded in `.vitepress/config.mts`).
Baseline: `master` at `8693c7e` (v.2.0 + PR #95). Compiler used for the checks: Delphi 13 (dcc32 37.0).

## Snapshot

| | |
|---|---|
| Code | ~3,100 lines in `source\` (runtime ~2,600: `SubjectStand` 1,082, `FormStand` 560, `FrameStand` 461, `ResponsiveContainer` 337, `DeviceAndPlatformInfo` 130) |
| Packages | runtime + design-time for 10.3 → 13 (plus stale XE8–10.2 runtime packages) |
| Demos | 17 projects, 14 in `AllDemosProjectGroup` |
| Tests / CI | none |
| GitHub | 277 stars, 86 forks, 2 open issues (#81 can't reproduce, #17 Delphinus) |
| Last release | v.2.0, 2026-03-06 (Delphi 13) |

The runtime units compile with no hints or warnings on Delphi 13. The design is sound and still
original in the FMX ecosystem: the subject/stand/container split, name-based animations, Common
Actions and attribute injection age well. The issues below are mostly in the edges (timing,
packaging, the responsive module) rather than in the core idea.

Legend: ✅ verified (compiled or executed), 📖 found by reading the code.

## Status after v.2.0.1 (branch `release/2.0.1`)

| Item | Status |
|---|---|
| P1, P2, P6 design-time packages | fixed (`cdd4a61`), verified D13 Win32 + Win64x |
| #90 `-LUDesignIDE` in the runtime packages (found while fixing P6) | fixed (`f043c4e`), verified D13 Win32, Win64, Android64, OSXARM64, iOSDevice64 |
| P3 release | v.2.0.1 to be tagged |
| P4 line endings | fixed: the whole index is LF, archives get CRLF |
| P5 version claims | README and docs say 10.3 → 13; old packages left in place, unsupported |
| E1 Dialog demo | fixed (`bed4b19`) |
| E2 demo group | fixed (`e69dd53`). Correction: HelloWorld *does* have a .dproj; building it revealed `W1074` on `[BeforeShow]` (missing `SubjectStand` in uses), fixed in `e70c977` |
| B3 Lookup | fixed (`26f8350`), console test |
| B4 breakpoints order | fixed (`a04254e`), console test (18 cases) |
| B8 deprecated aliases streamed | fixed (`afe2905`), streaming test (old forms still load) |
| B9 VisibleFrames history | fixed (`b5b736d`): Hide removes the *last* entry, Close removes all; duplicates are intended (Show/Hide history). FMX console test, 12 checks (6 fail on the previous code) |
| B11 locale / uninitialized record | fixed (`690e5d6`), console test |
| E3 | not a defect: FMX style lookups ignore case (`TStyleIndexer` lowercases names and lookups), so `'viewport3d'` finds `viewport3D`. Verified with Delphi 13: the `stand3D` stand shows and gets its camera |
| P7 | done (not released yet): one folder per Delphi version with the same package names, DCU output in `lib\<folder>\dcu`, BPL/DCP in the IDE default folders (it also fixes the setup overwriting the units of one Delphi version with another, and Win64 overwriting the Win32 BPL/DCP); build groups in the `.groupproj` (the setup builds only what they list: without them the v.2.1 setup found no RAD Studio version), `tmsbuild.yaml` for TMS Smart Setup. The 11.0 packages are dropped |

## Status v.2.1 (released)

| Item | Status |
|---|---|
| B1 delayed actions on freed objects | fixed (`5fbd43a`): FMX timer service, cancellation on destroy, life guard. Tests: callbacks after Close / component freed, background-thread Execute, Schedule+Cancel, 1000 hide/close cycles with no memory growth, real `OnHide*` animation (hide after 314 ms for a 300 ms animation) |
| B2 HideAndClose dropped while hiding | fixed (`fff9260`): continuations queued; double HideAndClose closes once and calls every AThen |
| B5 method-parameter injection | fixed (`bbc8982`): one ResolveContext for fields and parameters, `[FrameInfo]`/`[FrameStand]`/`[FormInfo]`/`[FormStand]` on parameters, `ESubjectStandError` at New/Use naming field/parameter. Test: 21 checks, only 10 pass on v.2.0.1. Generic infos after responsive substitution: clear error with the right type (was EInvalidCast) |
| B14 adopted form without controls | fixed (`a09616a`, #108), plus `UnparentAll` enumerating a list it modifies (one control in two lost) |
| B15 owner/parent/subject destroyed | fixed (`a3c7968`, #109): stands and subjects watched with FreeNotification, teardown independent of csDestroying, deferred free of the stand when the subject dies. Related defects fixed by the same change: forms created with New leaked with their owner; parent freed alone -> Invalid pointer operation; adopted frame freed by the app stayed registered; component owned elsewhere left its stands on the form. Tests: 8 scenarios in separate processes (7 failed before), 950 cycles with 0 bytes of growth |
| B15 under ARC | `bab8120`: stands and owned subjects disposed with DisposeOf under AUTOREFCOUNT (FFreeNotifies holds strong references there); compile-checked only |
| B7 references to other forms/data modules | fixed (`1cb8140`): setters with FreeNotification for StandBook, CommonActionList, DefaultParent. Test: 4 scenarios (3 failed before, 2 with access violations) |
| B6 3D parents, non-FMX owners | fixed (`903fc27`): lookup only with definitions, virtual GetParentWidth (3D layers: Width * Resolution, since LayerWidth is protected), ResolveParent with ESubjectStandError. Test: 4 scenarios (all failed before) |
| B10 Common Actions | fixed (`c08459c`): registration order, Add replaces an existing pattern, life guard after an action closing the subject. Replacing OnClick kept by decision (documented, including the effect on controls with an Action). Test: 7 checks (4 failed before) |
| E5 HelloWorld demo closes a frame inside its own click, keeps freed infos | fixed (`658ec5a`) |
| E4 tests and build script | done: `tests\` (DUnitX, 54 tests, all the scenarios verified for v.2.0.1 and v.2.1; mutation-checked) and `build.cmd` (packages, demos, tests; output in `build\`, `.res` untouched via `SkipResGeneration`) |
| B13 duplication TFrameStand/TFormStand | fixed (`cf152e0`): generic `TSubjectStandBase<S, I>` (registry, history, lookups), bulk close in `TSubjectStand`. Found while unifying: `CloseAll`/`HideAndCloseAll` reached infos freed meanwhile by FreeNotification (subjects shown inside the controls of another subject; regression of the unreleased B15 fix): `IsRegistered` check, test with nested stands |

All 16 demos build for Win32 with Delphi 13 with no warnings.

## 1. Packaging and release

| # | Finding | Evidence | Fix |
|---|---|---|---|
| P1 | `dclFrameStandPackage_13.dpk` has `{$DESIGNONLY}` again: the #92 fix (`d5a99b6`) was reverted one commit later by `085882e` (the IDE rewrote the .dpk when saving). All the other `dcl*.dpk` files use the bare form too. | ✅ `git show 085882e` | `{$DESIGNONLY ON}` in every dcl package; re-check after every IDE save. |
| P2 | `dclFrameStandPackage_13.dproj` still lists `FrameStandPackage_10_3;…_11_1` in `DCC_UsePackage` for every platform (fixed for 12 in `ff4096f`, not for 13). | ✅ grep | Same cleanup as `ff4096f`. |
| P3 | Tag `v.2.0` was created *before* the fixes for #91, #92, #94 (06:04 vs 06:47–06:58 and October): the release ZIP (and probably GetIt) ships broken dcl packages for 12 and 13. | ✅ `gh release list`, commit times | Release **v.2.0.1** after P1/P2. |
| P4 | Mixed line endings in the index: 137 files LF, 83 CRLF, 1 mixed; `.gitattributes` has no `text` rule. This is the CR/CRLF warning in #88. | ✅ `git ls-files --eol` | `* text=auto eol=crlf` for `.pas/.dpk/.dpr/.fmx/.dproj`, then `git add --renormalize .`. |
| P5 | The source uses inline variables (`FrameStand.GetFrameClass`, #71) so it needs 10.3+, but XE8/10/10.1/10.2 packages are still there and the README says "tested on XE8". | ✅ code + README | Remove the old packages (or rewrite 6 lines) and fix the README. |
| P6 | Design-time packages use `DesignEditors`/`DesignIntf` but do not list `designide` in `requires`. | 📖 | Add `designide` (removes the need for `-LUDesignIDE`, see #90). |
| P7 | One `.dpk` per Delphi version, identical but for the name: every new version is a copy-paste and the source of #91/#94. | ✅ `diff` 12 vs 13 | Keep per-version `.dproj`, but generate them with a script, or adopt SmartSetup (`tmsbuild.yaml`) as done for MARS. |

## 2. Demos

| # | Finding | Evidence | Fix |
|---|---|---|---|
| E1 | `demos\Dialog` does not compile: `E2010 Incompatible types: 'TProc<TSubjectInfo>' and 'Procedure'` (`Forms.Main.pas(99)`). It is the regression reported in #84. | ✅ dcc32 | `procedure (AInfo: TSubjectInfo)` and `AInfo.Subject`. |
| E2 | `Dialog` and `HelloWorld` are not in `AllDemosProjectGroup`. | ✅ | Add them. |
| E3 | ~~`Stand3D`: the `stand3D` branch of `OnBeforeShow` looks up `'viewport3d'`, a style name that does not exist in the stand.~~ Wrong: the stand's `TViewport3D` is named `viewport3D` and FMX style lookups ignore case. | ✅ decoded the style resource; ✅ shown with Delphi 13 | None. |
| E4 | No build check for the demos: E1 went unnoticed for 3 years. | | A `build.cmd` running msbuild on the package group and on `AllDemosProjectGroup` (see §5). |

## 3. Runtime defects

| # | Sev. | Finding | Evidence | Fix |
|---|---|---|---|---|
| B1 | High | **Hide timing uses one anonymous thread per call** (`TDelayedAction`: `Sleep` + `Synchronize`). If the info, the parent or the form is freed while the thread sleeps, the callback runs on freed objects (AV). On shutdown, `Synchronize` from a thread can hang or run after `Application` is gone. | 📖 | `TThread.ForceQueue(nil, Proc, ADelay)` (10.4+) or a `TTimer`, plus a cancellation flag/generation counter checked by the callback and set by `Close`/destructor. |
| B2 | High | **`HideAndClose` can silently never close**: it calls `Hide(0, …)` and ignores the result; if a hide is already in progress, `Hide` returns `False`, the `AThen` with the `Close` is dropped, the subject stays in `FrameInfos` until the component dies. Happens with a double tap on a close button, or `HideAndCloseAll` while something is hiding. | 📖 | Queue `AThen` when already hiding (keep a list of pending continuations). |
| B3 | Med | **`TResponsiveContainer.Lookup` reads the `for..in` variable after the loop** (`LOption.Target.StandName`, `LOption.Target.Parent`) instead of `LMatch`: stand name/parent of the matching target are lost unless the matching definition is the last one. | ✅ test: expected `TB/wide`, got `TB/framestand` | Use `LMatch` (and initialize it: no warning is emitted today). |
| B4 | Med | **`SetBreakpoint` breaks the order**: it deletes and appends, while `CurrentBreakpoint` and `Matches` assume ascending order. Also the comparer passed to `TBreakpoints` sorts *descending*, so calling `Sort` breaks everything. | ✅ test: `SetBreakpoint(300,'xs')` → `CurrentBreakpoint(250) = sm` | Fix the comparer (ascending) and `Sort` after every add/set. |
| B5 | Med | **Lifecycle-method parameters**: parameters without a supported attribute are skipped, so `Invoke` fails with a parameter-count error; `[FrameInfo]`, `[FrameStand]`, `[FormInfo]`, `[FormStand]` are not supported on parameters (they are on fields); the generic `ContextAttribute` branch maps any unknown context attribute to `Container`. | 📖 | One virtual `ResolveContext(AAttribute, AType): TValue` used by both fields and parameters, overridden by `TFrameInfo`/`TFormInfo`; a clear exception naming the method/parameter otherwise. |
| B6 | Med | **`New` fails when the parent is not a `TControl` or a `TForm`** (e.g. the component on a `TForm3D`, or `DefaultParent` on a 3D object): `DoResponsiveLookup` raises "cannot determine parent Width" even when no responsive definition exists. `GetDefaultParent` does `Owner as TFmxObject` → `EInvalidCast` with a data-module owner. | 📖 | Skip the lookup when there are no definitions; use `TCommonCustomForm.ClientWidth`/`IControl`; give a clear error for non-FMX owners. |
| B7 | Med | **No `FreeNotification`** on `StandBook`, `CommonActionList`, `DefaultParent`: if they live on another form or data module, freeing them leaves dangling pointers (`Notification` only works for components with the same owner). | 📖 | Property setters with `FreeNotification`/`RemoveFreeNotification`. |
| B8 | Low | **Deprecated aliases are streamed twice**: `StyleBook`/`StandBook` and `DefaultStyleName`/`DefaultStandName` are both published and both written in every `.fmx`. | ✅ `lightbox\Forms.Main.fmx` | `stored False` on the deprecated ones (still read from old forms). |
| B9 | Low | `VisibleFrames`/`VisibleForms` are the Show/Hide history (duplicates intended), but `DoAfterHide` removed the *first* entry of the subject and `DoClose` only one: `LastShownFrame` could return a hidden frame, and a subject shown twice stayed listed after `Close`. | ✅ | Hide removes the last entry, Close all of them. |
| B10 | Low | Common Actions overwrite the control's `OnClick` without notice; the pattern dictionary has no defined order; `Add` of an existing pattern raises. | 📖 | Chain the previous `OnClick`; ordered list; `AddOrSetValue`. |
| B11 | Low | `TDeviceAndPlatformInfo.Retrieve` returns uninitialized fields when the behaviour service is not available. `TBreakpoint.ToString`/`Implicit` are locale dependent (`'xs (768,00)'` on an Italian system). | ✅ (locale) | `Result := Default(...)`; `FormatSettings.Invariant`. |
| B12 | Info | `{$IFDEF AUTOREFCOUNT}` / `DisposeOf` branches are dead once the minimum version is 10.4. | 📖 | Remove with the next minimum-version bump. |
| B14 | Med | `TFormInfo.TeardownSubjectContainer`: closing a form adopted with `Use` that has **no child controls** fails (`Assert(Assigned(FFormContainer))` in `UnparentAll`, AV without assertions), because `ParentAll` creates the form container only when there are children. | ✅ test | Skip unparenting when `FFormContainer` is nil. |
| B15 | Med | Freeing the owner form while a form adopted with `Use` is still on its stand raises an access violation during teardown (the stand clones, children of the form, are already gone when `TFormStand` closes its subjects). Present before v.2.0.1 too. | ✅ test | Close the subjects (or detach the stands) from `Notification`/`BeforeDestruction`, or check `csDestroying` of the parent too. |
| B13 | Info | `TFrameStand`/`TFormStand` duplicate ~150 lines (`CloseAll*`, `HideAndCloseAll*`, `New`, `Use`, `Remove`, `FrameInfo` overloads); `TFormStand` lacks the non-generic `New(AClassName)`/`Use` added for frames in #71. | 📖 | A generic intermediate class `TSubjectStand<S, I>` or shared protected helpers. |

## 4. Documentation (done)

- New VitePress site in `docs\` (English, same setup as MARS): guide, features, reference, demos,
  release notes; `llms.txt`/`llms-full.txt`; GitHub Pages workflow in `.github/workflows/docs.yml`;
  `build.cmd`/`preview.cmd`; `REGEN.md` + `.docs-baseline` for incremental refreshes.
- Pages describe the current behaviour; the two places where a defect changes what users
  observe carry a "Known issue" box (responsive lookup, method parameters): remove them when
  B3/B5 are fixed.
- To publish: **Settings ▸ Pages ▸ Source: GitHub Actions** on the repository, then push.
  Address: <https://andrea-magni.github.io/TFrameStand/>.
- README: add the link to the site, update the badge (`commits-since/v.1.9` → latest), fix the
  version claims (P5) and the typo in the title (`#TFrameStand` without space).

## 5. Proposed roadmap

### v.2.0.1 — maintenance (hours)

1. P1, P2, P6 (packages), P4 (line endings), E1, E2 (demos).
2. B3, B4, B8, B9, B11: small, local, low-risk fixes.
3. README refresh + link to the documentation site; enable GitHub Pages.
4. Tag `v.2.0.1`, GitHub release, GetIt update.

### v.2.1 — robustness (days)

1. B1 + B2: replace `TDelayedAction` internals, cancellation on close, queued continuations.
2. B5, B6, B7, B10.
3. **Tests**: DUnitX project with `ResponsiveContainer` (pure logic) and lifecycle/injection tests on
   a hidden FMX form (FMX runs headless enough on Windows for this).
4. **Build script** (`build.cmd`): msbuild of the package group and of all the demos for Win32,
   run before every release. GitHub-hosted runners have no Delphi, so it stays local (or a
   self-hosted runner).
5. Package managers: SmartSetup `tmsbuild.yaml` (as for MARS), and a Boss/Delphinus manifest,
   which closes #17 after ten years.

### v.3.0 — features (weeks)

Ideas ordered by value for the users, as far as the issues and the demos suggest:

1. **Dialog results**: `ShowModal`-like API for frames, e.g.
   `FrameStand1.NewAndShow<TConfirmFrame>(...).OnClose(procedure(AResult: TModalResult) ...)`,
   with `[FrameInfo] FInfo` + `FInfo.Close(mrOk)` in the frame. Most uses of TFrameStand are dialogs,
   and today every app reinvents the result plumbing.
2. **Back/Escape handling**: an option to close the topmost subject (`VisibleFrames.Last`) on
   `vkHardwareBack`/`Esc`, the most common chore in mobile apps (see the `Responsive` demo).
3. **Navigation stack**: `Push<T>`/`Pop` with stand-based transitions, for wizards and master/detail
   flows (the `Wizard` demo does it by hand).
4. **Stand gallery**: a ready-made `.style` with lightbox, dialog, bottom sheet, side drawer,
   snackbar/toast, full-screen page, with light/dark variants, plus a page in the docs. It would
   lower the entry barrier more than any API change.
5. **Live responsive**: an opt-in `ResponsiveMode = rmLive` that re-creates (or re-parents) visible
   subjects when the breakpoint changes, instead of the manual close/new of the demo.
6. Clean-ups that break compatibility: remove `Show(ABackgroundTask…)`, `StyleBook`,
   `DefaultStyleName`, the `AUTOREFCOUNT` branches; minimum Delphi 10.4; merge the frame/form
   duplication (B13).
7. **AI agent skill** for TFrameStand, like the MARS skills (`mars-development`): the docs and
   `llms.txt` are a ready base.

## Platform review (v.2.1)

Done on request, before B6/B7, re-checking B1 and B15. Sources: `source\fmx` and `source\rtl` of Delphi 13.

| Topic | Finding | How |
|---|---|---|
| One-shot timers destroyed in their own callback (B1) | Safe on Windows (callback loop breaks after the call), macOS and iOS (the NSTimer target is released, but `onTimer` touches no field after the call), Android (`DestroyTimer` only sets a flag, the runnable releases itself on the next run). It is the same path as `TTimer.Enabled := False` inside `OnTimer`. | source reading (FMX.Platform.Timer.*); Windows by tests |
| Main-thread queue (`TThread.Queue`, `ForceQueue`) | All four platforms hook `WakeMainThread` and run `CheckSynchronize` from their event loop. | source reading (FMX.Platform.*) |
| Destruction order: children before owned components (B15) | `TFmxObject.Destroy` (`DeleteChildren`, then inherited) is common FMX code: same on every platform. | source reading; Windows by tests |
| ARC (Delphi 10.3, Android/iOS) | `TComponent.FFreeNotifies` holds strong references under AUTOREFCOUNT: Free would not destroy stands linked by FreeNotification, hence DisposeOf (`bab8120`). | source reading; ARC branches compile-checked with `-DAUTOREFCOUNT`, not run (no ARC compiler in Delphi 13) |
| Linux (FMXLinux) | Not in the Delphi sources; TDelayedAction falls back to a thread + `TThread.Queue` when no `IFMXTimerService` is registered. | not verified |
| Build | Runtime package builds for Win32, Win64, Android64, OSXARM64, iOSDevice64; design-time for Win32 and Win64x. | built with Delphi 13 |

Decision (2026-10-08): minimum raised to Delphi 10.4 Sydney. AUTOREFCOUNT branches removed (B12), packages for XE8 to 10.3 removed, `{$MESSAGE FATAL}` on older compilers in `SubjectStand`. The ARC row above is history: no supported compiler uses ARC.
