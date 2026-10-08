# Background Work

A wait screen while something runs in the background is one of the most common uses of TFrameStand (see `demos\wait`). The components are UI objects and must be used from the main thread; the work runs in a task, and the UI is touched only through `TThread.Synchronize` or `TThread.Queue`.

```pascal
uses System.Threading, FrameStand, SubjectStand, Frames.Wait;

procedure TMainForm.DoSomethingButtonClick(Sender: TObject);
var
  LInfo: TFrameInfo<TWaitFrame>;
begin
  // show the wait frame over Layout1 (main thread)
  LInfo := FrameStand1.NewAndShow<TWaitFrame>(Layout1);

  TTask.Run(
    procedure
    begin
      Sleep(1000);                                  // the actual work
      LInfo.Frame.UpdateMessageText('Phase 1...');  // synchronizes internally
      Sleep(2000);

      // back to the main thread to dismiss the wait frame
      TThread.Synchronize(nil,
        procedure
        begin
          LInfo.HideAndClose;
        end);
    end);
end;
```

The `TWaitFrame` of the demo exposes a thread-safe method to update its message:

```pascal
procedure TWaitFrame.UpdateMessageText(const AText: string; const ASync: Boolean);
begin
  if not ASync then
    MessageText := AText
  else
    TThread.Synchronize(nil, procedure begin MessageText := AText; end);
end;
```

Because the stand covers its parent, the wait frame also blocks the clicks on the controls below it: pass a single control as parent to block only that part of the UI.

::: warning
Do not close the form, or free the parent, while the task can still call back into the info: the info is freed by `HideAndClose`. If the form can be closed during the work, cancel the task (or check a flag) before touching the UI.
:::

## The deprecated `Show(ABackgroundTask, ...)` overload

Up to version 1.4, `Show` accepted an anonymous method to run in a `TTask` and a completion callback. The overload is still there, marked `deprecated`, but non-UI concerns have been left out of the components since version 1.5: write the task yourself as above, it gives you full control over errors and cancellation.
