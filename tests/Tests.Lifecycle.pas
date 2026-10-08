unit Tests.Lifecycle;

interface

uses
  System.SysUtils, System.Classes, System.Threading, System.Diagnostics
, DUnitX.TestFramework
, FMX.Types, FMX.Forms, FMX.Controls, FMX.Layouts
, SubjectStand, FrameStand, FormStand
, Tests.Subjects
;

type
  [TestFixture]
  TLifecycleFixture = class
  private
    FMain: TForm;
    FFrameStand: TFrameStand;
    FFormStand: TFormStand;
    function VisibleFormsData: string;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    // VisibleFrames / VisibleForms: history of Show/Hide
    [Test] procedure VisibleFormsKeepTheShowHideHistory;
    [Test] procedure VisibleFramesKeepTheShowHideHistory;

    // streaming
    [Test] procedure DeprecatedAliasesAreNotWritten;
    [Test] procedure DeprecatedAliasesAreStillRead;

    // delayed hide and close
    [Test] procedure HideWaitsForTheDelay;
    [Test] procedure HideAndCloseDuringHideCloses;
    [Test] procedure HideAndCloseTwiceClosesOnce;
    [Test] procedure CloseCancelsAPendingHide;
    [Test] procedure FreeingTheComponentCancelsPendingCallbacks;
    [Test] procedure CloseFromHideCallback;
    [Test] procedure HideAndCloseOnHiddenSubject;
    [Test] procedure HideWaitsForOnHideAnimations;

    // TDelayedAction
    [Test] procedure DelayedActionRuns;
    [Test] procedure DelayedActionFromBackgroundThreadRunsInMainThread;
    [Test] procedure DelayedActionCanBeCancelled;

    // memory
    [Test] procedure HideCloseCyclesDoNotGrowMemory;
  end;

implementation

const
  STAND_WITH_HIDE_ANIMATION =
    'object TStyleContainer'#13#10 +
    '  object TLayout'#13#10 +
    '    StyleName = ''animated'''#13#10 +
    '    object TLayout'#13#10 +
    '      StyleName = ''container'''#13#10 +
    '    end'#13#10 +
    '    object TFloatAnimation'#13#10 +
    '      StyleName = ''OnHideFade'''#13#10 +
    '      Duration = 0.300000000000000000'#13#10 +
    '      PropertyName = ''Opacity'''#13#10 +
    '      StartValue = 1.000000000000000000'#13#10 +
    '      StopValue = 0.000000000000000000'#13#10 +
    '    end'#13#10 +
    '  end'#13#10 +
    'end';

{ TLifecycleFixture }

procedure TLifecycleFixture.Setup;
begin
  FMain := TForm.CreateNew(nil);
  FFrameStand := TFrameStand.Create(FMain);
  FFormStand := TFormStand.Create(FMain);
end;

procedure TLifecycleFixture.TearDown;
begin
  FreeAndNil(FMain);
  Pump(50); // let deferred frees run
end;

function TLifecycleFixture.VisibleFormsData: string;
var
  LForm: TForm;
begin
  Result := '';
  for LForm in FFormStand.VisibleForms do
    Result := Result + TDataForm(LForm).Data;
end;

procedure TLifecycleFixture.VisibleFormsKeepTheShowHideHistory;
var
  A, B: TFormInfo<TDataForm>;
  LFormA, LFormB: TDataForm;
begin
  LFormA := TDataForm.Create(nil);
  LFormB := TDataForm.Create(nil);
  try
    LFormA.Data := 'A';
    LFormB.Data := 'B';
    A := FFormStand.Use<TDataForm>(LFormA, FMain);
    B := FFormStand.Use<TDataForm>(LFormB, FMain);
    A.Show; B.Show; A.Show;
    Assert.AreEqual('ABA', VisibleFormsData, 'every Show is listed');
    Assert.AreEqual('A', TDataForm(FFormStand.LastShownForm).Data);
    A.Hide;
    Assert.AreEqual('AB', VisibleFormsData, 'Hide takes back the most recent Show');
    Assert.AreEqual('B', TDataForm(FFormStand.LastShownForm).Data);
    A.Show; A.Show;
    A.Close;
    Assert.AreEqual('B', VisibleFormsData, 'Close removes every entry');
    B.Hide;
    Assert.AreEqual('', VisibleFormsData);
    Assert.IsNull(FFormStand.LastShownForm);
    B.Close;
  finally
    LFormA.Free;
    LFormB.Free;
  end;
end;

procedure TLifecycleFixture.VisibleFramesKeepTheShowHideHistory;
var
  A, B: TFrameInfo<TFrame>;
begin
  A := FFrameStand.New<TFrame>(FMain);
  B := FFrameStand.New<TFrame>(FMain);
  A.Show; B.Show; A.Show;
  Assert.AreEqual(3, FFrameStand.VisibleFrames.Count, 'every Show is listed');
  Assert.AreSame(A.Frame, FFrameStand.LastShownFrame);
  A.Hide;
  Assert.AreEqual(2, FFrameStand.VisibleFrames.Count);
  Assert.AreSame(A.Frame, FFrameStand.VisibleFrames[0], 'Hide takes back the most recent Show');
  Assert.AreSame(B.Frame, FFrameStand.LastShownFrame);
  A.Show; A.Show;
  A.Close;
  Assert.AreEqual(1, FFrameStand.VisibleFrames.Count, 'Close removes every entry');
  Assert.AreSame(B.Frame, FFrameStand.LastShownFrame);
  B.Close;
  Assert.AreEqual(0, FFrameStand.VisibleFrames.Count);
end;

procedure TLifecycleFixture.DeprecatedAliasesAreNotWritten;
var
  LBinary: TMemoryStream;
  LText: TStringStream;
begin
  FFrameStand.Name := 'FrameStand1';
  FFrameStand.DefaultStandName := 'lightbox';
  LBinary := TMemoryStream.Create;
  LText := TStringStream.Create;
  try
    LBinary.WriteComponent(FFrameStand);
    LBinary.Position := 0;
    ObjectBinaryToText(LBinary, LText);
    Assert.Contains(LText.DataString, 'DefaultStandName');
    Assert.DoesNotContain(LText.DataString, 'DefaultStyleName');
  finally
    LText.Free;
    LBinary.Free;
  end;
end;

procedure TLifecycleFixture.DeprecatedAliasesAreStillRead;

  function Load(const AText: string): string;
  var
    LText: TStringStream;
    LBinary: TMemoryStream;
    LStand: TFrameStand;
  begin
    LText := TStringStream.Create(AText);
    LBinary := TMemoryStream.Create;
    try
      ObjectTextToBinary(LText, LBinary);
      LBinary.Position := 0;
      LStand := LBinary.ReadComponent(nil) as TFrameStand;
      try
        Result := LStand.DefaultStandName;
      finally
        LStand.Free;
      end;
    finally
      LBinary.Free;
      LText.Free;
    end;
  end;

begin
  RegisterClass(TFrameStand);
  Assert.AreEqual('new', Load('object FS: TFrameStand'#13#10'  DefaultStyleName = ''old'''#13#10'  DefaultStandName = ''new'''#13#10'end'));
  Assert.AreEqual('old', Load('object FS: TFrameStand'#13#10'  DefaultStyleName = ''old'''#13#10'end'));
end;

procedure TLifecycleFixture.HideWaitsForTheDelay;
var
  LInfo: TFrameInfo<TFrame>;
  LThen: Integer;
begin
  LThen := 0;
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.Show;
  LInfo.Hide(100, procedure begin Inc(LThen) end);
  Assert.IsTrue(LInfo.Hiding, 'hiding during the delay');
  Pump(400);
  Assert.AreEqual(1, LThen);
  Assert.IsTrue(LInfo.Status = TSubjectStatus.Hidden);
end;

procedure TLifecycleFixture.HideAndCloseDuringHideCloses;
var
  LInfo: TFrameInfo<TFrame>;
  LThen: Integer;
begin
  LThen := 0;
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.Show;
  LInfo.Hide(150);
  LInfo.HideAndClose(50, procedure begin Inc(LThen) end);
  Pump(600);
  Assert.AreEqual(0, FFrameStand.Count, 'closed when the hide in progress completes');
  Assert.AreEqual(1, LThen);
end;

procedure TLifecycleFixture.HideAndCloseTwiceClosesOnce;
var
  LInfo: TFrameInfo<TFrame>;
  LThen: Integer;
begin
  LThen := 0;
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.Show;
  LInfo.HideAndClose(50, procedure begin Inc(LThen) end);
  LInfo.HideAndClose(50, procedure begin Inc(LThen) end);
  Pump(600);
  Assert.AreEqual(0, FFrameStand.Count);
  Assert.AreEqual(2, LThen, 'every AThen called after the close');
end;

procedure TLifecycleFixture.CloseCancelsAPendingHide;
var
  LInfo: TFrameInfo<TFrame>;
  LThen: Integer;
begin
  LThen := 0;
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.Show;
  LInfo.Hide(150, procedure begin Inc(LThen) end);
  LInfo.Close;
  Pump(400);
  Assert.AreEqual(0, LThen, 'no callback after Close');
end;

procedure TLifecycleFixture.FreeingTheComponentCancelsPendingCallbacks;
var
  LInfo: TFrameInfo<TFrame>;
  LThen: Integer;
begin
  LThen := 0;
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.Show;
  LInfo.HideAndClose(100, procedure begin Inc(LThen) end);
  FreeAndNil(FFrameStand);
  Pump(500);
  Assert.AreEqual(0, LThen);
end;

procedure TLifecycleFixture.CloseFromHideCallback;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.Show;
  LInfo.Hide(0, procedure begin LInfo.Close end);
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TLifecycleFixture.HideAndCloseOnHiddenSubject;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.Show;
  LInfo.Hide;
  LInfo.HideAndClose;
  Pump(400);
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TLifecycleFixture.HideWaitsForOnHideAnimations;
var
  LStyleBook: TStyleBook;
  LStream: TStringStream;
  LInfo: TFrameInfo<TFrame>;
  LStopwatch: TStopwatch;
  LHiddenAt: Int64;
  LClosed: Boolean;
begin
  LStyleBook := TStyleBook.Create(FMain);
  LStream := TStringStream.Create(STAND_WITH_HIDE_ANIMATION);
  try
    LStyleBook.LoadFromStream(LStream);
  finally
    LStream.Free;
  end;
  FFrameStand.StandBook := LStyleBook;

  LInfo := FFrameStand.New<TFrame>(FMain, 'animated');
  Assert.AreEqual('animated', LInfo.StandStyleName);
  LInfo.Show;
  LHiddenAt := -1;
  LClosed := False;
  LStopwatch := TStopwatch.StartNew;
  LInfo.Hide(0, procedure begin LHiddenAt := LStopwatch.ElapsedMilliseconds end);
  Pump(100);
  Assert.IsTrue(LInfo.Hiding, 'still hiding at 100 ms (animation: 300 ms)');
  LInfo.HideAndClose(20, procedure begin LClosed := True end);
  Pump(600);
  Assert.IsTrue((LHiddenAt >= 280) and (LHiddenAt < 600), Format('hidden after %d ms', [LHiddenAt]));
  Assert.IsTrue(LClosed and (FFrameStand.Count = 0), 'closed after the animated hide');
end;

procedure TLifecycleFixture.DelayedActionRuns;
var
  LRan: Integer;
begin
  LRan := 0;
  TDelayedAction.Execute(50, procedure begin Inc(LRan) end);
  Assert.AreEqual(0, LRan, 'not immediately');
  Pump(300);
  Assert.AreEqual(1, LRan);
end;

procedure TLifecycleFixture.DelayedActionFromBackgroundThreadRunsInMainThread;
var
  LRan: Integer;
  LInMainThread: Boolean;
begin
  LRan := 0;
  LInMainThread := False;
  TTask.Run(
    procedure
    begin
      TDelayedAction.Execute(50,
        procedure
        begin
          LInMainThread := TThread.CurrentThread.ThreadID = MainThreadID;
          Inc(LRan);
        end);
    end);
  Pump(500);
  Assert.AreEqual(1, LRan);
  Assert.IsTrue(LInMainThread);
end;

procedure TLifecycleFixture.DelayedActionCanBeCancelled;
var
  LRan: Integer;
  LAction: IDelayedAction;
begin
  LRan := 0;
  LAction := TDelayedAction.Schedule(50, procedure begin Inc(LRan) end);
  Assert.IsTrue(LAction.Pending);
  LAction.Cancel;
  Assert.IsFalse(LAction.Pending);
  Pump(200);
  Assert.AreEqual(0, LRan);
end;

procedure TLifecycleFixture.HideCloseCyclesDoNotGrowMemory;
var
  LCycle: Integer;
  LInfo: TFrameInfo<TFrame>;
  LBefore, LAfter: Int64;
begin
  LBefore := 0;
  for LCycle := 1 to 300 do
  begin
    if LCycle = 21 then
      LBefore := AllocatedBytes;
    LInfo := FFrameStand.New<TFrame>(FMain);
    LInfo.Show;
    case LCycle mod 4 of
      0: LInfo.HideAndClose(10);
      1: begin LInfo.Hide(30); LInfo.HideAndClose(10); end;
      2: begin LInfo.Hide(50, procedure begin end); LInfo.Close; end;
      3: begin LInfo.HideAndClose(10); LInfo.HideAndClose(10); end;
    end;
    if LCycle mod 20 = 0 then
      Pump(120);
  end;
  Pump(300);
  LAfter := AllocatedBytes;
  Assert.AreEqual(0, FFrameStand.Count);
  Assert.IsTrue(LAfter - LBefore < 4096, Format('memory grew by %d bytes', [LAfter - LBefore]));
end;

initialization
  TDUnitX.RegisterTestFixture(TLifecycleFixture);

end.
