# Dialog Results

Most frames shown with TFrameStand are dialogs: pick a colour, confirm a deletion, rate an item. `ShowModal` and `ModalResult` give them the result plumbing of FMX modal forms: the dialog sets a result, the caller gets it in a procedure.

::: info Since v.2.3
`ShowModal`, `ModalResult` and the Back/Esc handling are new in v.2.3 (not released yet).
:::

## Showing a dialog

```pascal
uses System.UITypes, FrameStand, SubjectStand;

procedure TMainForm.ChangeColorButtonClick(Sender: TObject);
begin
  FrameStand1.New<TColorDialogFrame>.ShowModal(
    procedure (AFrame: TColorDialogFrame; AResult: TModalResult)
    begin
      if AResult = mrOk then
        Rectangle1.Fill.Color := AFrame.ChosenColor;
    end);
end;
```

Like `TForm.ShowModal(AResultProc)` in FMX, `ShowModal` does not block: it shows the subject and returns; the result procedure is called later, once, when the dialog is dismissed. It works the same on every platform.

There are two overloads:

| Overload | Use it when |
|---|---|
| `ShowModal(procedure (AFrame: T; AResult: TModalResult); AClose = True)` | you need the data of the dialog (the chosen colour, the text typed): the frame is passed in. `TFormInfo<T>` passes the form. |
| `ShowModal(procedure (AResult: TModalResult); AClose = True)` | the result is all you need (Yes/No, OK/Cancel). |

## Setting the result

The dialog sets `ModalResult` on its info, usually from a click. With [context injection](/features/injection) the frame gets its info without any code in the caller:

```pascal
type
  TColorDialogFrame = class(TFrame)
  ...
  protected
    [FrameInfo] FInfo: TFrameInfo<TColorDialogFrame>;
  public
    property ChosenColor: TAlphaColor read FChosenColor;
  end;

procedure TColorDialogFrame.ColorClick(Sender: TObject);
begin
  FChosenColor := (Sender as TRectangle).Fill.Color;
  FInfo.ModalResult := mrOk;
end;
```

Setting a value other than `mrNone`:

1. hides the dialog, with the hide animations of the stand;
2. calls the result procedure, when the hide is complete: the frame is still alive, so its properties can be read;
3. closes the dialog (frees the frame), after `DefaultHideAndCloseDeferTimeMS`, so it is safe to set `ModalResult` from a click on the frame.

The first result wins: a second tap on another button while the hide animation runs does not change it.

## Cancelling

A dialog dismissed without a result reports `mrCancel`: `Hide`, `HideAndClose`, `Close` and `CloseAll` all call the result procedure once, with `mrCancel`, before the frame is freed. The result procedure is not called when the component or its owner are destroyed.

[Common Actions](/features/common-actions) cancel all the dialogs of the application from one place: the `Cancel` buttons of the frames and the dimmed background of the stand.

```pascal
procedure TMainForm.FormCreate(Sender: TObject);
begin
  // a Cancel button named Button_cancel, a 'background_cancel' element in the stand
  FrameStand1.CommonActions.Add('*_cancel',
    procedure (AInfo: TSubjectInfo)
    begin
      AInfo.ModalResult := mrCancel;
    end);
end;
```

## Keeping the dialog

With `AClose = False` the dialog is only hidden: create it once, show it again with `ShowModal` (which resets `ModalResult` to `mrNone`), close it when you no longer need it.

```pascal
if not Assigned(FRatingDialog) then
  FRatingDialog := FrameStand1.New<TRatingDialogFrame>;
FRatingDialog.ShowModal(
  procedure (AFrame: TRatingDialogFrame; AResult: TModalResult)
  begin
    if AResult = mrOk then
      SaveRating(AFrame.Rating);
  end,
  False);
```

## Back and Esc

The Back button of Android and the Esc key close the dialog on top: set `CatchBackKey` on the component (in the Object Inspector) and they cancel the topmost dialog, which reports `mrCancel`.

```pascal
FrameStand1.CatchBackKey := True; // usually set at design time
```

Subjects that are not dialogs are left alone, so toolbars, overlays and button sets stay on screen. A page that should go away on Back too says so with `BackKeyAction`:

| `BackKeyAction` | Back / Esc |
|---|---|
| `baNone` (default) | nothing: the key goes to the form |
| `baHide` | `Hide`: for a subject kept in a field and shown again |
| `baHideAndClose` | `HideAndClose` |

```pascal
FDetails := FrameStand1.New<TEmployeeDetailsFrame>(ListView1);
FDetails.BackKeyAction := baHide;
```

Back acts on the subject shown last, still visible and not hiding, that is a dialog or has a `BackKeyAction`; with a `TFrameStand` and a `TFormStand` on the same form, on the one shown last of the two. When it acts, the key is cleared, so Android does not close the form; otherwise the key goes on to the form as usual.

`CatchBackKey` hooks the `OnKeyDown` event of the owner form, and calls the handler of the form for the keys it does not handle. If you assign `OnKeyDown` in code after the form is created, or prefer to keep the control, call `HandleBackKey` from your handler instead:

```pascal
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if FrameStand1.HandleBackKey(Key, KeyChar) then
    Exit; // a dialog or a page was closed
  // ... your keys
end;
```

## Things to know

::: warning
- `ModalResult` set on a subject not shown with `ShowModal` is only stored: the subject stays on screen.
- The `ModalResult` property of FMX buttons does not apply: a button sets the result of the **form** that holds it, which is the form hosting the stand. Set the result from `OnClick` or from a Common Action.
- After the result procedure, `ModalResult` keeps the result (`mrCancel` when there was none), until the next `ShowModal`.
:::

The [Dialog demo](/demos/#dialog) shows the colour picker of this page.
