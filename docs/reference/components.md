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
| `StyleBook` | `TStyleBook` | | Old name of `StandBook`. |
| `DefaultStyleName` | `string` | | Old name of `DefaultStandName`. |

`StandBook`, `CommonActionList` and `DefaultParent` may refer to components on other forms or data modules: when one of them is freed, the property is cleared.

Events: `OnBeforeShow`, `OnAfterShow`, `OnBeforeHide`, `OnAfterHide`, `OnBeforeStartAnimation`, `OnBindCommonActionList`, `OnGetSubjectClass`. See [Events](/reference/events).

## Public properties

| Property | Type | Description |
|---|---|---|
| `Count` | `Integer` | Number of subjects handled. |
| `FrameInfos` | `TObjectDictionary<TFrame, TFrameInfo<TFrame>>` | All the infos, keyed by frame. |
| `VisibleFrames` | `TList<TFrame>` | History of the `Show`/`Hide` calls: each `Show` appends the frame (a frame shown twice is listed twice), each `Hide` removes its most recent entry, `Close` removes all its entries. |
| `CommonActions` | `TCommonActionDictionary<TSubjectInfo>` | Registered [Common Actions](/features/common-actions). |
| `Responsive` | `TResponsiveContainer` | Breakpoints and definitions for [responsive](/features/responsive) substitution. |
| `ResponsiveBreakpoints` | `TArray<TBreakpoint>` | Read/replace all the breakpoints at once. |
| `ResponsiveBreakpoint[AName]` | `TBreakpoint` | A breakpoint by name. |

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
| `DeviceAndPlatformInfo(AForm: TForm = nil)` | platform, device class, device name and display metrics of the device (uses `Application.MainForm` when `AForm` is nil). |
