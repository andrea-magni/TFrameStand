unit Tests.BackKey;

// Back (Android) and Esc: HandleBackKey, CatchBackKey, BackKeyAction.

interface

uses
  System.SysUtils, System.Classes, System.UITypes, DUnitX.TestFramework
, FMX.Types, FMX.Forms, FMX.Controls
, SubjectStand, FrameStand, FormStand
, Tests.Subjects
;

type
  [TestFixture]
  TBackKeyFixture = class
  private
    FMain: TForm;
    FFrameStand: TFrameStand;
    FFormStand: TFormStand;
    FResults: string;
    FFormKeys: Integer;
    function Recorder(const AName: string): TProc<TModalResult>;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
    function PressKey(const AKey: Word): Word;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure BackCancelsTheDialog;
    [Test] procedure EscCancelsTheDialog;
    [Test] procedure OtherKeysAreIgnored;
    [Test] procedure NothingToCloseLeavesTheKey;
    [Test] procedure BackKeyActionHideAndClose;
    [Test] procedure BackKeyActionHide;
    [Test] procedure TopmostDialogFirst;
    [Test] procedure HidingSubjectIsSkipped;
    [Test] procedure CatchBackKeyHooksTheForm;
    [Test] procedure CatchBackKeyKeepsTheFormHandler;
    [Test] procedure CatchBackKeyOff;
    [Test] procedure TwoComponentsLastShownFirst;
    [Test] procedure ComponentFreedWhileHooked;
  end;

implementation

{ TBackKeyFixture }

procedure TBackKeyFixture.Setup;
begin
  FResults := '';
  FFormKeys := 0;
  FMain := TForm.CreateNew(nil);
  FFrameStand := TFrameStand.Create(FMain);
  FFormStand := TFormStand.Create(FMain);
end;

procedure TBackKeyFixture.TearDown;
begin
  FreeAndNil(FMain);
end;

function TBackKeyFixture.Recorder(const AName: string): TProc<TModalResult>;
begin
  Result :=
    procedure (AResult: TModalResult)
    begin
      if AResult = mrCancel then
        FResults := FResults + AName + ':cancel '
      else
        FResults := FResults + AName + ':other ';
    end;
end;

procedure TBackKeyFixture.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  Inc(FFormKeys);
end;

function TBackKeyFixture.PressKey(const AKey: Word): Word;
var
  LKeyChar: WideChar;
begin
  // what FMX does: the OnKeyDown of the form
  Result := AKey;
  LKeyChar := #0;
  if Assigned(FMain.OnKeyDown) then
    FMain.OnKeyDown(FMain, Result, LKeyChar, []);
end;

procedure TBackKeyFixture.BackCancelsTheDialog;
var
  LKey: Word;
  LKeyChar: Char;
begin
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('A'));
  LKey := vkHardwareBack;
  LKeyChar := #0;
  Assert.IsTrue(FFrameStand.HandleBackKey(LKey, LKeyChar));
  Assert.AreEqual<Word>(0, LKey, 'key cleared: Android must not close the form');
  Assert.AreEqual('A:cancel ', FResults);
  Pump(300);
  Assert.AreEqual(0, FFrameStand.Count, 'closed');
end;

procedure TBackKeyFixture.EscCancelsTheDialog;
var
  LKey: Word;
  LKeyChar: Char;
begin
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('A'));
  LKey := vkEscape;
  LKeyChar := #0;
  Assert.IsTrue(FFrameStand.HandleBackKey(LKey, LKeyChar));
  Assert.AreEqual('A:cancel ', FResults);
end;

procedure TBackKeyFixture.OtherKeysAreIgnored;
var
  LKey: Word;
  LKeyChar: Char;
begin
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('A'));
  LKey := vkReturn;
  LKeyChar := #0;
  Assert.IsFalse(FFrameStand.HandleBackKey(LKey, LKeyChar));
  Assert.AreEqual<Word>(vkReturn, LKey);
  Assert.AreEqual('', FResults);
end;

procedure TBackKeyFixture.NothingToCloseLeavesTheKey;
var
  LKey: Word;
  LKeyChar: Char;
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.Show; // not a dialog, no BackKeyAction: e.g. a toolbar
  LKey := vkHardwareBack;
  LKeyChar := #0;
  Assert.IsFalse(FFrameStand.HandleBackKey(LKey, LKeyChar));
  Assert.AreEqual<Word>(vkHardwareBack, LKey, 'left to the form');
  Pump(300);
  Assert.IsTrue(LInfo.IsVisible);
end;

procedure TBackKeyFixture.BackKeyActionHideAndClose;
var
  LKey: Word;
  LKeyChar: Char;
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.BackKeyAction := baHideAndClose; // e.g. a detail page
  LInfo.Show;
  LKey := vkHardwareBack;
  LKeyChar := #0;
  Assert.IsTrue(FFrameStand.HandleBackKey(LKey, LKeyChar));
  Pump(300);
  Assert.AreEqual(0, FFrameStand.Count, 'hidden and closed');
end;

procedure TBackKeyFixture.BackKeyActionHide;
var
  LKey: Word;
  LKeyChar: Char;
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.BackKeyAction := baHide; // a subject kept to be shown again
  LInfo.Show;
  LKey := vkHardwareBack;
  LKeyChar := #0;
  Assert.IsTrue(FFrameStand.HandleBackKey(LKey, LKeyChar));
  Pump(300);
  Assert.IsFalse(LInfo.IsVisible, 'hidden');
  Assert.AreEqual(1, FFrameStand.Count, 'not closed');
  LKey := vkHardwareBack;
  Assert.IsFalse(FFrameStand.HandleBackKey(LKey, LKeyChar), 'hidden: nothing left');
  LInfo.Show;
  LKey := vkHardwareBack;
  Assert.IsTrue(FFrameStand.HandleBackKey(LKey, LKeyChar), 'shown again');
  Pump(300);
end;

procedure TBackKeyFixture.TopmostDialogFirst;
var
  LToolbar: TFrameInfo<TFrame>;
begin
  FFrameStand.CatchBackKey := True;
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('A'));
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('B'));
  LToolbar := FFrameStand.New<TFrame>(FMain);
  LToolbar.Show; // shown last, but not closed by Back
  Assert.AreEqual<Word>(0, PressKey(vkHardwareBack));
  Assert.AreEqual('B:cancel ', FResults);
  Assert.AreEqual<Word>(0, PressKey(vkHardwareBack));
  Assert.AreEqual('B:cancel A:cancel ', FResults);
  Assert.AreEqual<Word>(vkHardwareBack, PressKey(vkHardwareBack), 'nothing left to cancel');
  Pump(300);
  Assert.AreEqual(1, FFrameStand.Count, 'the toolbar stays');
end;

procedure TBackKeyFixture.HidingSubjectIsSkipped;
var
  LInfo: TFrameInfo<TFrame>;
  LKey: Word;
  LKeyChar: Char;
begin
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('A'));
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.BackKeyAction := baHide;
  LInfo.Show;
  LInfo.Hide(300); // still hiding
  LKey := vkHardwareBack;
  LKeyChar := #0;
  Assert.IsTrue(FFrameStand.HandleBackKey(LKey, LKeyChar));
  Assert.AreEqual('A:cancel ', FResults, 'the dialog below');
  Pump(600);
end;

procedure TBackKeyFixture.CatchBackKeyHooksTheForm;
begin
  FFrameStand.CatchBackKey := True;
  Assert.IsTrue(Assigned(FMain.OnKeyDown), 'hooked');
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('A'));
  Assert.AreEqual<Word>(0, PressKey(vkEscape));
  Assert.AreEqual('A:cancel ', FResults);
end;

procedure TBackKeyFixture.CatchBackKeyKeepsTheFormHandler;
begin
  FMain.OnKeyDown := FormKeyDown;
  FFrameStand.CatchBackKey := True;
  PressKey(vkReturn);
  Assert.AreEqual(1, FFormKeys, 'other keys reach the form');
  PressKey(vkHardwareBack);
  Assert.AreEqual(2, FFormKeys, 'Back reaches the form when there is nothing to close');
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('A'));
  PressKey(vkHardwareBack);
  Assert.AreEqual(2, FFormKeys, 'handled by the component');
  Assert.AreEqual('A:cancel ', FResults);
end;

procedure TBackKeyFixture.CatchBackKeyOff;
begin
  FMain.OnKeyDown := FormKeyDown;
  FFrameStand.CatchBackKey := True;
  FFrameStand.CatchBackKey := False;
  Assert.IsTrue(TMethod(FMain.OnKeyDown).Data = Pointer(Self), 'the handler of the form is back');
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('A'));
  Assert.AreEqual<Word>(vkHardwareBack, PressKey(vkHardwareBack));
  Assert.AreEqual('', FResults);
  Assert.AreEqual(1, FFormKeys);
end;

procedure TBackKeyFixture.TwoComponentsLastShownFirst;
begin
  FFrameStand.CatchBackKey := True;
  FFormStand.CatchBackKey := True;
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('frame'));
  FFormStand.New<TDataForm>(FMain).ShowModal(Recorder('form'));
  PressKey(vkHardwareBack);
  Assert.AreEqual('form:cancel ', FResults, 'the form dialog was shown last');
  PressKey(vkHardwareBack);
  Assert.AreEqual('form:cancel frame:cancel ', FResults);
  Pump(300);
end;

procedure TBackKeyFixture.ComponentFreedWhileHooked;
begin
  FMain.OnKeyDown := FormKeyDown;
  FFrameStand.CatchBackKey := True;
  FFormStand.CatchBackKey := True;
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder('frame'));
  FreeAndNil(FFrameStand);
  FFormStand.New<TDataForm>(FMain).ShowModal(Recorder('form'));
  PressKey(vkHardwareBack);
  Assert.AreEqual('form:cancel ', FResults, 'the other component still works');
  PressKey(vkHardwareBack);
  Assert.AreEqual(1, FFormKeys, 'and then the form');
  Pump(300);
end;

initialization
  TDUnitX.RegisterTestFixture(TBackKeyFixture);

end.
