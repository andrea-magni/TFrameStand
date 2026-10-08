# Common Actions

Many frames share the same gestures: close, cancel, confirm, go back. **Common Actions** let you write that behaviour once, on the component, and bind it by name to the controls of every frame and every stand it shows.

## Registering a Common Action

```pascal
uses FrameStand, SubjectStand;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FrameStand1.CommonActions.Add('Close*',
    procedure (AInfo: TSubjectInfo)
    begin
      AInfo.HideAndClose;
    end);
end;
```

`CommonActions.Add(APattern, AAction)` takes a mask and a `TProc<TSubjectInfo>`. When a subject is created with `New` or `Use`, the component walks the whole tree of the stand clone, frame included, and for every `TControl` whose `StyleName` (or `Name`, when `StyleName` is empty) matches the mask, it assigns a handler to `OnClick`. On click, every Common Action whose mask matches the control is executed, with the info of that subject.

The mask uses the syntax of `MatchesMask` (`*`, `?`, sets like `[abc]`) and is case-insensitive, so `Close*` matches `CloseButton`, `close_background`, `CloseIcon`...

The action receives a `TSubjectInfo`: cast it, or use `Subject`, to reach the frame.

```pascal
FrameStand1.CommonActions.Add('*_cancel',
  procedure (AInfo: TSubjectInfo)
  begin
    if AInfo.Subject is TColorDialogFrame then
      TColorDialogFrame(AInfo.Subject).Cancel;
  end);
```

::: warning Things to know
- Register Common Actions **before** creating the subjects: they are bound when the subject is created, and controls added to the frame later are not bound.
- The matched control's `OnClick` is **replaced**. If a control needs its own handler, give it a name that does not match.
- Patterns are kept in a dictionary: adding the same pattern twice raises an exception, and the order in which several matching actions run is not defined.
:::

## Stand elements as triggers

Because the whole stand is scanned, elements of the stand can trigger Common Actions too: a dimmed `TRectangle` named `close_background` behind a dialog closes it when the user taps outside, for all the dialogs of the application, without a line of code in the frames.

## Binding a TActionList

The second flavour binds controls to the actions of a `TActionList`, through their `Action` property:

1. drop a `TActionList` on the form and assign it to `CommonActionList`;
2. create the actions, for example `Save` and `Cancel`;
3. in the frames, name the controls with the `CommonActionPrefix` (`ca_` by default) followed by the action name: `ca_Save`, `ca_Cancel`.

When the frame is created, each control with an `Action` property whose `StyleName` (or `Name`) starts with the prefix gets the action with the matching name (case-insensitive). Captions, images, `Enabled` and `Visible` then follow the action, and `OnUpdate` keeps them in sync, as in any FMX action binding.

The `OnBindCommonActionList` event lets you change the name of the action to bind for a given control, or bind controls whose names do not follow the prefix convention:

```pascal
procedure TMainForm.FrameStand1BindCommonActionList(ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo; const AObject: TFmxObject; var ACommonActionName: string);
begin
  if AObject.Name = 'OkButton' then
    ACommonActionName := 'Save';
end;
```

Inside an action's `OnExecute`, use `FrameStand1.LastShownFrame` (or keep the info) to know which subject the action refers to.
