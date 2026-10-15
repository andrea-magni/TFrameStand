# Lifecycle, injection, Common Actions

## Creating

```pascal
function New<T: TFrame>(const AParent: TFmxObject = nil; const AStandStyleName: string = ''): TFrameInfo<T>;
function Use<T: TFrame>(const AFrame: T; const AParent: TFmxObject = nil; const AStandStyleName: string = ''): TFrameInfo<T>;
function NewAndShow<T: TFrame>(const AParent: TFmxObject = nil; const AStandStyleName: string = '';
  const AConfigProc: TProc<T> = nil; const AConfigFIProc: TProc<TFrameInfo<T>> = nil): TFrameInfo<T>;
function GetFrameInfo<T: TFrame>(const ANewIfNotFound: Boolean = True; ...): TFrameInfo<T>; // find or create
```

- Parent: `AParent`, else `DefaultParent`, else the owner form; none raises `ESubjectStandError`.
- Stand: `AStandStyleName`, else `DefaultStandName`. Not found in `StandBook`: a plain `TLayout` stand.
- `New` creates the frame (`Owner = nil`, empty `Name`: many instances are fine) and owns it; responsive definitions and `OnGetSubjectClass` may change class, stand and parent. `Use` adopts an existing frame (not owned).
- Non-generic: `Use(AFrame: TFrame)`, `New('Unit.TClassName')` (RTTI: the class must be linked).

## Show, Hide, Close

- `Show`: `[BeforeShow]` methods, `OnBeforeShow`, `[Show]` methods or the default (stand visible, `BringToFront`), `OnShow*` animations started, `[AfterShow]`, `OnAfterShow` (right after the animations start).
- `Hide(ADelay = 0; AThen = nil): Boolean`: `OnBeforeHide`, `OnHide*` animations; after the longest one (or `ADelay` ms): `[Hide]` methods or default hide, `AThen`, `OnAfterHide`. Returns False if a hide is in progress (`AThen` then runs when it completes). A hidden subject can be shown again.
- `HideAndClose(ADeferMS = 0; AThen = nil)`: hide, wait `DefaultHideAndCloseDeferTimeMS` (100), close, `AThen`. Safe to call repeatedly or during a hide.
- `HideAndCloseAfter(ADelayMS)`: `HideAndClose` later; cancelled if the subject is closed before.
- `Close`: immediate, no animation; frees the stand, frees (owned) or detaches (adopted) the frame, **frees the info**.
- Bulk: `CloseAll`, `CloseAll([TClassA])`, `CloseAllExcept(TMenuFrame)`, `HideAndCloseAll`, `HideAndCloseAllExcept(...)`.
- Info state: `Status` (Initializing, Ready, Showing, Visible, Hiding, Hidden, Closing), `IsVisible`, `Hiding`.
- Component lists: `FrameInfos` (dictionary frame → info), `VisibleFrames` (Show/Hide history: a frame shown twice is listed twice), `LastShownFrame`, `FrameInfo<T>`, `Count`.

Timing: delays use the FMX timer (main thread). Pending callbacks are cancelled when the subject is closed or the component destroyed: `Close` during a `Hide` cancels its `AThen` and `OnAfterHide`.

Destruction: freeing the parent or the form with subjects on screen is safe (FreeNotification); the component forgets them. Freeing the component closes the remaining subjects.

## Events of the component

`OnBeforeShow`, `OnAfterShow`, `OnBeforeHide`, `OnAfterHide` (`procedure(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo)`), `OnBeforeStartAnimation` (adds `const AAnimation: TAnimation`, unit `FMX.Ani`), `OnBindCommonActionList`, `OnGetSubjectClass`, `OnResponsiveChange`. Check `ASubjectInfo.StandStyleName` or `ASubjectInfo.Subject is TMyFrame` to act on specific subjects; `ASubjectInfo.Stand.FindStyleResource('card')` reaches stand elements.

## Context injection

Fields of the frame (injected by `New`/`Use`) and parameters of lifecycle methods:

```pascal
type
  TDetailsFrame = class(TFrame)
  private
    [FrameInfo] FInfo: TFrameInfo<TDetailsFrame>;   // the info (or a base class's info)
    [FrameStand] FStand: TFrameStand;               // the component
  public
    [BeforeShow] procedure BeforeShow([Parent] AParent: TFmxObject);
    [AfterShow] procedure AfterShow;
    [Hide] procedure DoHide;      // replaces the default hide: call FInfo.DefaultHide
  end;
```

Attributes (units `SubjectStand`, `FrameStand`, `FormStand`): `[SubjectStand]`, `[SubjectInfo]`, `[Stand]`, `[Container]`, `[Parent]`, `[FrameStand]`, `[FrameInfo]`, `[FormStand]`, `[FormInfo]`; lifecycle `[BeforeShow]`, `[Show]`, `[AfterShow]`, `[Hide]` on public methods. Wrong types raise `ESubjectStandError` at `New`/`Use`, naming the field or parameter.

## Common Actions

```pascal
// before creating the subjects
FrameStand1.CommonActions.Add('Close*', procedure (AInfo: TSubjectInfo) begin AInfo.HideAndClose; end);
FrameStand1.CommonActions.Add('*_cancel', procedure (AInfo: TSubjectInfo) begin AInfo.ModalResult := mrCancel; end);
```

- Bound to every control of the stand clone and of the subject whose `StyleName` (or `Name` when `StyleName` is empty) matches the mask (case-insensitive): stand elements too (`background_cancel`).
- The matched control's `OnClick` is replaced; several matching actions run in registration order; `Add` of an existing pattern replaces it; actions stop once one closes the subject.
- `CommonActionList` + `CommonActionPrefix` (`ca_`): controls named `ca_Save` get the `Save` action of a `TActionList`.
