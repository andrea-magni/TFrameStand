# TFrameStand / TFormStand

```pascal
TSubjectStand = class(TComponent)          // unit SubjectStand
TFrameStand   = class(TSubjectStand)       // unit FrameStand
TFormStand    = class(TSubjectStand)       // unit FormStand
```

Members are listed for `TFrameStand`; `TFormStand` has the same ones with `Form` in place of `Frame` (see [TFormStand](/features/formstand#api)).

## Published properties

| Property | Type | Default | Description |
|---|---|---|---|
| `StandBook` | `TStyleBook` | | Style book holding the stands. |
| `DefaultStandName` | `string` | `framestand` / `formstand` | Stand used when no name is passed. |
| `DefaultParent` | `TFmxObject` | | Parent used when none is passed; if empty, the `Owner`. |
| `AnimationShow` | `string` | `OnShow*` | Mask of the animations started by `Show`. |
| `AnimationHide` | `string` | `OnHide*` | Mask of the animations started by `Hide`. |
| `CommonActionList` | `TActionList` | | Action list for prefix-based binding. |
| `CommonActionPrefix` | `string` | `ca_` | Prefix of the controls bound to `CommonActionList`. |
| `DefaultHideAndCloseDeferTimeMS` | `Integer` | `100` | Pause between hide and close in `HideAndClose`. |
| `ResponsiveMode` | `TResponsiveMode` | `rmOnCreate` | `rmLive`: subjects created with `New`/`Push` are replaced when their parent changes breakpoint. See [Responsive Frames](/features/responsive#live-following-the-window). |
| `PushMode` | `TPushMode` | `pmHide` | What `Push` does to the page below: `pmHide`, `pmKeepVisible`, `pmClose`. See [Navigation Stack](/features/navigation). |
| `CatchBackKey` | `Boolean` | `False` | Back (Android) and Esc, caught in `OnKeyDown` of the owner form, close the topmost dialog or subject: see `HandleBackKey` and [Back and Esc](/features/dialogs#back-and-esc). |
| `StyleBook` | `TStyleBook` | | **Deprecated**: old name of `StandBook`. |
| `DefaultStyleName` | `string` | | **Deprecated**: old name of `DefaultStandName`. |

`StyleBook` and `DefaultStyleName` are still published, so forms saved with them load as before, but they are not shown in the Object Inspector and are saved with the new names. Delphi has no `deprecated` directive for properties: the compiler does not warn about code that uses them, so replace them with `StandBook` and `DefaultStandName`. They will be removed in a future major version.

`StandBook`, `CommonActionList` and `DefaultParent` may refer to components on other forms or data modules: when one of them is freed, the property is cleared.

Events: `OnBeforeShow`, `OnAfterShow`, `OnBeforeHide`, `OnAfterHide`, `OnBeforeStartAnimation`, `OnBindCommonActionList`, `OnGetSubjectClass`, `OnResponsiveChange`. See [Events](/reference/events).

## Public properties

| Property | Type | Description |
|---|---|---|
| `Count` | `Integer` | Number of subjects handled. |
| `FrameInfos` | `TObjectDictionary<TFrame, TFrameInfo<TFrame>>` | All the infos, keyed by frame. Read it, don't change it: the component frees the infos (`Close`, its destructor); `Clear` or `Remove` on the dictionary drop them without freeing them. |
| `VisibleFrames` | `TList<TFrame>` | History of the `Show`/`Hide` calls: each `Show` appends the frame (a frame shown twice is listed twice), each `Hide` removes its most recent entry, `Close` removes all its entries. |
| `CommonActions` | `TCommonActionDictionary<TSubjectInfo>` | Registered [Common Actions](/features/common-actions). |
| `Responsive` | `TResponsiveContainer` | Breakpoints and definitions for [responsive](/features/responsive) substitution. |
| `ResponsiveBreakpoints` | `TArray<TBreakpoint>` | Read/replace all the breakpoints at once. |
| `ResponsiveBreakpoint[AName]` | `TBreakpoint` | A breakpoint by name. |
| `StackCount` | `Integer` | Pages in the [navigation stack](/features/navigation). |
| `StackTop` | `TSubjectInfo` | The top page of the stack, nil when it is empty. |
| `StackOperation` | `TStackOperation` | `soPush` / `soPop` while `Push` and `Pop` show and hide pages, `soNone` otherwise. |

## Creating subjects

```pascal
function New<T: TFrame>(const AParent: TFmxObject = nil;
  const AStandStyleName: string = ''): TFrameInfo<T>;
function New(const AFrameClassName: string; const AParent: TFmxObject = nil;
  const AStandStyleName: string = ''): TFrameInfo<TFrame>;
```

Creates a frame of class `T` (or of the class with that qualified name, looked up with RTTI), after responsive substitution and `OnGetSubjectClass`, and puts it on a new clone of the stand. The frame is owned by the component. Not shown yet.

```pascal
function Use<T: TFrame>(const AFrame: T; const AParent: TFmxObject = nil;
  const AStandStyleName: string = ''): TFrameInfo<T>;
function Use(const AFrame: TFrame; const AParent: TFmxObject = nil;
  const AStandStyleName: string = ''): TFrameInfo<TFrame>;
```

Puts an existing frame on a new clone of the stand. The frame is not owned: `Close` detaches it but does not free it.

```pascal
function NewAndShow<T: TFrame>(const AParent: TFmxObject = nil;
  const AStandStyleName: string = ''; const AConfigProc: TProc<T> = nil;
  const AConfigFIProc: TProc<TFrameInfo<T>> = nil): TFrameInfo<T>;
```

`New<T>`, then `AConfigProc(Frame)`, then `AConfigFIProc(Info)`, then `Show`.

## Navigation stack

```pascal
function Push<T: TFrame>(const AParent: TFmxObject = nil;
  const AStandStyleName: string = ''; const AConfigProc: TProc<T> = nil): TFrameInfo<T>;
function Pop: Boolean;
function PopToRoot: Boolean;
```

`Push` creates a page like `New`, puts it on top of the stack and shows it; the page below is hidden, left visible or closed, as `PushMode` says. `Pop` closes the top page and shows the one below again; `PopToRoot` goes back to the first page. Both return `False` when there is nothing to pop. See [Navigation Stack](/features/navigation).

## Finding subjects

| Method | Returns |
|---|---|
| `FrameInfo(AFrame: TFrame)` | the info of that frame, or `nil` |
| `FrameInfo(AFrameClass: TFrameClass)` | the first info whose frame is of that class (or a descendant), or `nil` |
| `FrameInfo<T>` | the same, typed |
| `GetFrameInfo<T>(ANewIfNotFound = True; AParent = nil; AStandStyleName = '')` | `FrameInfo<T>`, or `New<T>(AParent, AStandStyleName)` when missing and `ANewIfNotFound` |
| `LastShownFrame` | the last entry of `VisibleFrames` (the most recent `Show` not yet hidden), or `nil` |

## Closing subjects

| Method | Effect |
|---|---|
| `CloseAll` | closes every subject, immediately |
| `CloseAll(AClass)` / `CloseAll([AClass, ...])` | closes the subjects of those classes (descendants included) |
| `CloseAllExcept(AClass)` / `CloseAllExcept([...])` | closes all but those classes |
| `HideAndCloseAll` and the same overloads | hides with animations, then closes |
| `HideAndCloseAllExcept(...)` | the same, excluding classes |
| `Remove(ASubject)` | removes and frees the info of a subject (what `Close` calls) |

## Other

| Method | Description |
|---|---|
| `HandleBackKey(var AKey: Word; var AKeyChar: Char): Boolean` | on `vkHardwareBack` or `vkEscape`, cancels the topmost dialog (`ShowModal`) or runs the `BackKeyAction` of the topmost subject; returns `True` and clears the key when it does. Call it from `OnKeyDown` of the form, or set `CatchBackKey`. |
| `DeviceAndPlatformInfo(AForm: TForm = nil)` | platform, device class, device name and display metrics of the device (uses `Application.MainForm` when `AForm` is nil). |
