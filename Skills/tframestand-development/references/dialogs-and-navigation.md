# Dialogs, Back/Esc, navigation stack

## Dialogs with a result

```pascal
// caller (does not block, like TForm.ShowModal(AResultProc) in FMX)
FrameStand1.New<TColorDialogFrame>(nil, 'dialog').ShowModal(
  procedure (AFrame: TColorDialogFrame; AResult: TModalResult)
  begin
    if AResult = mrOk then
      Rectangle1.Fill.Color := AFrame.ChosenColor;
  end);

// dialog frame
type
  TColorDialogFrame = class(TFrame)
  protected
    [FrameInfo] FInfo: TFrameInfo<TColorDialogFrame>;
  public
    property ChosenColor: TAlphaColor read FChosenColor;
  end;

procedure TColorDialogFrame.ColorClick(Sender: TObject);
begin
  FChosenColor := (Sender as TRectangle).Fill.Color;
  FInfo.ModalResult := mrOk; // hides, calls the result procedure, closes
end;
```

- Overloads: `ShowModal(TProc<TModalResult>; AClose = True)` and, on `TFrameInfo<T>`/`TFormInfo<T>`, `ShowModal(TProc<T, TModalResult>; AClose = True)`.
- The result procedure runs once, after the hide animation and **before** the close: the frame is still alive. `AClose = False`: only hidden, reusable (`ShowModal` again resets `ModalResult`).
- Hidden or closed without a result (`Hide`, `HideAndClose`, `Close`, `CloseAll`, Back/Esc): `mrCancel`. Not called when the component or its owner are destroyed.
- First result wins. `ModalResult` on a subject not shown with `ShowModal` is only stored. `IsModal`: waiting for the result.
- `System.UITypes` for `TModalResult`/`mrOk`.

## Back (Android) and Esc

- `CatchBackKey := True` (published): hooks the owner form's `OnKeyDown` (one hook per form, shared by all components; the form's handler is called for unhandled keys). If the code assigns `OnKeyDown` after the form is created, call `FrameStand1.HandleBackKey(Key, KeyChar)` from the handler instead (returns True and clears the key when it acts).
- Acts on the subject shown last, visible and not hiding, that is a dialog (`ModalResult := mrCancel`) or has a `BackKeyAction`: `baNone` (default: key goes to the form), `baHide` (subjects kept in a field and shown again), `baHideAndClose`, `baPop` (set by `Push` on pages above the root).
- On the root page / with nothing to close the key reaches the form: Android closes the app as usual.

## Navigation stack

```pascal
FrameStand1.Push<TStep1Frame>(nil, 'page');                  // root
FrameStand1.Push<TStep2Frame>(nil, 'page',
  procedure (AFrame: TStep2Frame) begin AFrame.OrderID := FOrder; end);
FrameStand1.Pop;          // False on the root: it is never popped
FrameStand1.PopToRoot;    // pages in between closed without animations
FrameStand1.StackCount; FrameStand1.StackTop;   // TSubjectInfo
```

- `PushMode` (published): `pmHide` (default: page below hidden and kept, shown again as it was), `pmKeepVisible` (left under the new page), `pmClose` (closed; `Pop` creates it again and runs `AConfigProc` again).
- `StackOperation` (`soPush`/`soPop`/`soNone`): read it in `OnBeforeStartAnimation` to reverse slide directions; gallery stands use `PopStartValue`/`PopStopValue` instead.
- Top page closed by other means (its `HideAndClose`, a `Close*` Common Action): it leaves the stack and the page below is shown again. `CloseAll`/`HideAndCloseAll` empty the stack.
- One stack per component: use two components for two independent flows. `TFormStand` has the same members.
