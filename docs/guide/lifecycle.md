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

1. if the subject is already hiding, nothing happens and `Hide` returns `False`;
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

## Closing many subjects

The component offers bulk operations, all accepting a class or an array of classes (descendants included):

```pascal
FrameStand1.CloseAll;                                  // everything, immediately
FrameStand1.CloseAll([TDetailsFrame]);                 // only the details frames
FrameStand1.CloseAllExcept(TMenuFrame);                // all but the menu
FrameStand1.HideAndCloseAll([TDetailsFrame, TEditFrame]);
FrameStand1.HideAndCloseAllExcept([TMenuFrame]);
```

When the component is destroyed (with its form), all the remaining subjects are closed.

## Timing and threads

Hide delays are implemented with a short-lived background thread that sleeps and then goes back to the main thread with `TThread.Synchronize`; every callback (`[Hide]` methods, `AThen`, `OnAfterHide`, the close of `HideAndClose`) runs in the **main thread**.

Because these callbacks run later, avoid destroying the parent, or the form, while a subject is still hiding: close the subjects first (`CloseAll`) when you tear down a form programmatically.

All the methods of the components must be called from the main thread. See [Background Work](/features/background-work) for the pattern to use with tasks.
