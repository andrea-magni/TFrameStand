# Lifecycle & Ownership

A subject goes through a simple life: it is created (or adopted), shown, hidden, possibly shown again, and finally closed. The `Status` property of the info tells you where it is.

```
New / Use ──► Ready ──Show──► Showing ──► Visible ──Hide──► Hiding ──► Hidden ──Close──► (freed)
                                  ▲                                     │
                                  └───────────────Show──────────────────┘
```

## Creating: `New` and `Use`

```pascal
function New<T: TFrame>(const AParent: TFmxObject = nil; const AStandStyleName: string = ''): TFrameInfo<T>;
function Use<T: TFrame>(const AFrame: T; const AParent: TFmxObject = nil; const AStandStyleName: string = ''): TFrameInfo<T>;
```

Both:

1. resolve the parent and the stand name (see [Core Concepts](/guide/core-concepts));
2. let [Responsive](/features/responsive) definitions and the `OnGetSubjectClass` event change frame class, stand and parent (`New` only);
3. clone the stand, add it to the parent, invisible, and put the subject in its container;
4. collect the methods marked with `[BeforeShow]`, `[Show]`, `[AfterShow]`, `[Hide]`;
5. bind the [Common Actions](/features/common-actions) to the controls of the stand and of the subject;
6. inject the fields marked with context attributes such as `[FrameInfo]` or `[Parent]` (see [Context Injection](/features/injection)).

`New<T>` creates the frame itself (with `Owner = nil` and an empty `Name`, so you can create many instances of the same frame) and owns it. `Use<T>` adopts a frame you already have, for instance one placed on the form at design time, and does not own it.

Non-generic overloads exist for frames: `Use(AFrame: TFrame; ...)` and `New(AFrameClassName: string; ...)`. The latter looks the class up through RTTI by its qualified name (`'Frames.Details.TDetailsFrame'`), so the frame class must be linked in the executable.

## Showing: `Show`

`Show` runs these steps, synchronously:

1. `Status := Showing`;
2. the frame's `[BeforeShow]` methods, then the component's `OnBeforeShow` event;
3. the frame's `[Show]` methods if any, otherwise the default: `Stand.Visible := True` and `Stand.BringToFront`;
4. the animations of the stand that match `AnimationShow` (`OnShow*`) are started;
5. `Status := Visible`;
6. the frame's `[AfterShow]` methods, then the `OnAfterShow` event.

`[AfterShow]` and `OnAfterShow` run as soon as the animations are **started**, not when they end.

`NewAndShow<T>` combines `New`, an optional configuration of the frame and of the info, and `Show`:

```pascal
FrameStand1.NewAndShow<TDetailsFrame>(Layout1, 'lightbox',
  procedure (AFrame: TDetailsFrame) begin AFrame.Customer := LCustomer; end,
  procedure (AInfo: TFrameInfo<TDetailsFrame>) begin AInfo.Stand.Opacity := 0.9; end);
```

## Hiding: `Hide`

```pascal
function Hide(const ADelay: Integer = 0; const AThen: TProc = nil): Boolean;
```

1. if the subject is already hiding, no new hide starts and `Hide` returns `False`; its `AThen` is called when the hide in progress completes;
2. the `OnBeforeHide` event; `Status := Hiding`;
3. the animations matching `AnimationHide` (`OnHide*`) are started, and the longest `Delay + Duration` among them becomes the hide delay;
4. after the delay (or after `ADelay` milliseconds, when you pass a value other than 0): the frame's `[Hide]` methods if any, otherwise the default (stop the animations, `Stand.Visible := False`); `Status := Hidden`; `AThen` is called; the `OnAfterHide` event.

A hidden subject keeps its frame and stand, and can be shown again with `Show`. This is the cheapest way to reuse a frame that appears often (a side menu, a wait screen).

## Closing: `Close` and `HideAndClose`

`Close` removes the subject from the component immediately, without animations: the stand is removed from its parent and freed, and the frame is

- **freed**, if it is owned (created by `New`, or `FrameIsOwned := True`);
- **removed** from the container and left to you, otherwise (adopted with `Use`).

The info object itself is freed by `Close`: **do not use it afterwards**, and clear any field that references it.

```pascal
procedure TMainForm.CloseDetails;
begin
  if Assigned(FDetailsInfo) then
  begin
    FDetailsInfo.Close;
    FDetailsInfo := nil;   // the info has been freed
  end;
end;
```

`HideAndClose(ADeferExecutionMS = 0; AThen = nil)` is the usual way to dismiss a subject: it hides it (with its animations), waits `DefaultHideAndCloseDeferTimeMS` milliseconds (100 by default, or `ADeferExecutionMS`), then closes it and calls `AThen`.

It is safe to call it at any moment: if a `Hide` is already in progress, the subject is closed when that hide completes; if a `HideAndClose` is already in progress (a double tap on a close button, `HideAndCloseAll` while a subject is closing), the subject is closed once and every `AThen` is called after the close.

## Closing many subjects

The component offers bulk operations, all accepting a class or an array of classes (descendants included):

```pascal
FrameStand1.CloseAll;                                  // everything, immediately
FrameStand1.CloseAll([TDetailsFrame]);                 // only the details frames
FrameStand1.CloseAllExcept(TMenuFrame);                // all but the menu
FrameStand1.HideAndCloseAll([TDetailsFrame, TEditFrame]);
FrameStand1.HideAndCloseAllExcept([TMenuFrame]);
```

When the component is destroyed, all the remaining subjects are closed: stands removed from their parents and freed, owned subjects freed, adopted ones detached and left to you. This holds also when the component lives elsewhere than the parents of its stands (on a data module, or on another form).

## When the parent or the subject is destroyed

The stand is a child of its parent, so FMX destroys it, with the subject inside, when the parent (or the whole form) is destroyed. The component is notified (through `FreeNotification`) and simply forgets the subject: the info is freed, the subject leaves `FrameInfos` and `VisibleFrames`, and nothing already destroyed is touched again. The same happens when your code frees an adopted frame or form that is on a stand.

- Freeing a form with subjects still on screen is safe, in any order with respect to the component.
- A frame adopted with `Use` is a child of the stand while it is shown: if its parent is destroyed, FMX destroys the frame too. Close it first (`Close`, `CloseAll`) if you want to keep it.
- The controls of a form adopted by `TFormStand` live in the stand while it is shown: they share the same fate. A form created with `New` is freed with its owner component.

## Timing and threads

Hide delays use the FMX platform timer (`TDelayedAction`, no background threads): every callback (`[Hide]` methods, `AThen`, `OnAfterHide`, the close of `HideAndClose`) runs in the **main thread**, after the delay.

The pending callbacks belong to the info: when the subject is closed, or the component is destroyed with its form, before the delay has elapsed, they are cancelled. In particular:

- `Close` during a `Hide` (or a `HideAndClose`) cancels it: its `AThen` and `OnAfterHide` are not called;
- if `AThen` (or a `[Hide]` method) closes the subject, `OnAfterHide` is not fired, since the info no longer exists.

Callbacks still pending when the application terminates are dropped.

All the methods of the components must be called from the main thread. See [Background Work](/features/background-work) for the pattern to use with tasks.
