unit Tests.ModalResult;

// ShowModal and ModalResult: dialogs that report a result to the caller.

interface

uses
  System.SysUtils, System.Classes, System.UITypes, DUnitX.TestFramework
, FMX.Types, FMX.Forms, FMX.Controls
, SubjectStand, FrameStand, FormStand
, Tests.Subjects
;

type
  [TestFixture]
  TModalResultFixture = class
  private
    FMain: TForm;
    FFrameStand: TFrameStand;
    FFormStand: TFormStand;
    FCalls: Integer;
    FResult: TModalResult;
    function Recorder: TProc<TModalResult>;
    procedure UseAnimatedStand;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure ResultProcGetsTheModalResult;
    [Test] procedure ClosedAfterTheResult;
    [Test] procedure FrameStillAliveInTheResultProc;
    [Test] procedure KeptWhenAskedAndShownAgain;
    [Test] procedure HideWithoutResultGivesCancel;
    [Test] procedure HideAndCloseWithoutResultGivesCancel;
    [Test] procedure CloseWithoutResultGivesCancel;
    [Test] procedure CloseAllGivesCancel;
    [Test] procedure FirstResultWins;
    [Test] procedure ResultAfterTheHideAnimation;
    [Test] procedure NotModalJustStoresTheResult;
    [Test] procedure ResultProcCanCloseTheDialog;
    [Test] procedure InjectedInfoSetsTheResult;
    [Test] procedure CommonActionSetsTheResult;
    [Test] procedure NoResultProcWhenTheOwnerIsDestroyed;
    [Test] procedure FormStandShowModal;
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

{ TModalResultFixture }

procedure TModalResultFixture.Setup;
begin
  FCalls := 0;
  FResult := mrNone;
  FMain := TForm.CreateNew(nil);
  FFrameStand := TFrameStand.Create(FMain);
  FFormStand := TFormStand.Create(FMain);
end;

procedure TModalResultFixture.TearDown;
begin
  FreeAndNil(FMain);
end;

function TModalResultFixture.Recorder: TProc<TModalResult>;
begin
  Result :=
    procedure (AResult: TModalResult)
    begin
      Inc(FCalls);
      FResult := AResult;
    end;
end;

procedure TModalResultFixture.UseAnimatedStand;
var
  LStyleBook: TStyleBook;
  LStream: TStringStream;
begin
  LStyleBook := TStyleBook.Create(FMain);
  LStream := TStringStream.Create(STAND_WITH_HIDE_ANIMATION);
  try
    LStyleBook.LoadFromStream(LStream);
  finally
    LStream.Free;
  end;
  FFrameStand.StandBook := LStyleBook;
end;

procedure TModalResultFixture.ResultProcGetsTheModalResult;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.ShowModal(Recorder());
  Assert.IsTrue(LInfo.IsVisible);
  Assert.AreEqual(0, FCalls, 'no result yet');
  LInfo.ModalResult := mrOk;
  Assert.AreEqual(1, FCalls);
  Assert.AreEqual(mrOk, FResult);
  Pump(300);
  Assert.AreEqual(1, FCalls, 'called once');
end;

procedure TModalResultFixture.ClosedAfterTheResult;
var
  LInfo: TFrameInfo<TCountFrame>;
  LDestroyed: Integer;
begin
  LDestroyed := FramesDestroyed;
  LInfo := FFrameStand.New<TCountFrame>(FMain);
  LInfo.ShowModal(Recorder());
  LInfo.ModalResult := mrYes;
  // closed later (DefaultHideAndCloseDeferTimeMS): it can be set from a click on the frame
  Assert.AreEqual(1, FFrameStand.Count, 'not closed inside the click');
  Pump(300);
  Assert.AreEqual(0, FFrameStand.Count, 'closed');
  Assert.AreEqual(LDestroyed + 1, FramesDestroyed, 'frame freed');
end;

procedure TModalResultFixture.FrameStillAliveInTheResultProc;
var
  LInfo: TFrameInfo<TCountFrame>;
  LFrame, LGotFrame: TCountFrame;
  LDestroyed, LDestroyedInProc: Integer;
  LGotResult: TModalResult;
begin
  LDestroyed := FramesDestroyed;
  LDestroyedInProc := -1;
  LGotFrame := nil;
  LGotResult := mrNone;
  LInfo := FFrameStand.New<TCountFrame>(FMain);
  LFrame := LInfo.Frame;
  LInfo.ShowModal(
    procedure (AFrame: TCountFrame; AResult: TModalResult)
    begin
      LGotFrame := AFrame;
      LGotResult := AResult;
      LDestroyedInProc := FramesDestroyed;
    end);
  LInfo.ModalResult := mrOk;
  Pump(300);
  Assert.IsTrue(LGotFrame = LFrame, 'the frame of the dialog');
  Assert.AreEqual(mrOk, LGotResult);
  Assert.AreEqual(LDestroyed, LDestroyedInProc, 'not freed yet in the result procedure');
  Assert.AreEqual(LDestroyed + 1, FramesDestroyed, 'freed afterwards');
end;

procedure TModalResultFixture.KeptWhenAskedAndShownAgain;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.ShowModal(Recorder(), False);
  LInfo.ModalResult := mrYes;
  Pump(300);
  Assert.AreEqual(1, FCalls);
  Assert.AreEqual(mrYes, FResult);
  Assert.AreEqual(1, FFrameStand.Count, 'kept');
  Assert.IsFalse(LInfo.IsVisible, 'hidden');
  Assert.AreEqual(mrYes, LInfo.ModalResult);

  LInfo.ShowModal(Recorder(), False);
  Assert.AreEqual(mrNone, LInfo.ModalResult, 'reset by ShowModal');
  Assert.IsTrue(LInfo.IsVisible);
  LInfo.ModalResult := mrNo;
  Pump(300);
  Assert.AreEqual(2, FCalls);
  Assert.AreEqual(mrNo, FResult);
  Assert.AreEqual(1, FFrameStand.Count, 'still kept');
end;

procedure TModalResultFixture.HideWithoutResultGivesCancel;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.ShowModal(Recorder());
  LInfo.Hide;
  Assert.AreEqual(1, FCalls);
  Assert.AreEqual(mrCancel, FResult);
  Pump(300);
  Assert.AreEqual(0, FFrameStand.Count, 'closed, as ShowModal asked');
  Assert.AreEqual(1, FCalls, 'called once');
end;

procedure TModalResultFixture.HideAndCloseWithoutResultGivesCancel;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.ShowModal(Recorder());
  LInfo.HideAndClose;
  Pump(300);
  Assert.AreEqual(1, FCalls);
  Assert.AreEqual(mrCancel, FResult);
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TModalResultFixture.CloseWithoutResultGivesCancel;
var
  LInfo: TFrameInfo<TCountFrame>;
  LDestroyed, LDestroyedInProc: Integer;
begin
  LDestroyed := FramesDestroyed;
  LDestroyedInProc := -1;
  LInfo := FFrameStand.New<TCountFrame>(FMain);
  LInfo.ShowModal(
    procedure (AResult: TModalResult)
    begin
      Inc(FCalls);
      FResult := AResult;
      LDestroyedInProc := FramesDestroyed;
    end);
  LInfo.Close;
  Assert.AreEqual(1, FCalls);
  Assert.AreEqual(mrCancel, FResult);
  Assert.AreEqual(LDestroyed, LDestroyedInProc, 'called before the frame is freed');
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TModalResultFixture.CloseAllGivesCancel;
begin
  FFrameStand.New<TFrame>(FMain).ShowModal(Recorder());
  FFrameStand.New<TCountFrame>(FMain).ShowModal(Recorder());
  FFrameStand.CloseAll;
  Assert.AreEqual(2, FCalls);
  Assert.AreEqual(mrCancel, FResult);
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TModalResultFixture.FirstResultWins;
var
  LInfo: TFrameInfo<TFrame>;
begin
  UseAnimatedStand;
  LInfo := FFrameStand.New<TFrame>(FMain, 'animated');
  LInfo.ShowModal(Recorder());
  LInfo.ModalResult := mrOk;
  LInfo.ModalResult := mrCancel; // e.g. a second tap while the hide animation runs
  Assert.AreEqual(mrOk, LInfo.ModalResult);
  Pump(700);
  Assert.AreEqual(1, FCalls);
  Assert.AreEqual(mrOk, FResult);
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TModalResultFixture.ResultAfterTheHideAnimation;
var
  LInfo: TFrameInfo<TFrame>;
begin
  UseAnimatedStand;
  LInfo := FFrameStand.New<TFrame>(FMain, 'animated');
  LInfo.ShowModal(Recorder());
  LInfo.ModalResult := mrOk;
  Pump(100);
  Assert.AreEqual(0, FCalls, 'still hiding at 100 ms (animation: 300 ms)');
  Pump(500);
  Assert.AreEqual(1, FCalls, 'after the animation');
  Assert.AreEqual(mrOk, FResult);
end;

procedure TModalResultFixture.NotModalJustStoresTheResult;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.Show;
  LInfo.ModalResult := mrOk;
  Pump(300);
  Assert.IsTrue(LInfo.IsVisible, 'still shown');
  Assert.AreEqual(1, FFrameStand.Count);
  Assert.AreEqual(mrOk, LInfo.ModalResult);
end;

procedure TModalResultFixture.ResultProcCanCloseTheDialog;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FMain);
  LInfo.ShowModal(
    procedure (AResult: TModalResult)
    begin
      Inc(FCalls);
      LInfo.Close;
    end);
  LInfo.ModalResult := mrOk;
  Pump(300);
  Assert.AreEqual(1, FCalls);
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TModalResultFixture.InjectedInfoSetsTheResult;
var
  LInfo: TFrameInfo<TFieldsFrame>;
begin
  LInfo := FFrameStand.New<TFieldsFrame>(FMain);
  LInfo.ShowModal(Recorder());
  LInfo.Frame.FI.ModalResult := mrRetry; // what the frame does on a click
  Pump(300);
  Assert.AreEqual(1, FCalls);
  Assert.AreEqual(mrRetry, FResult);
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TModalResultFixture.CommonActionSetsTheResult;
var
  LInfo: TFrameInfo<TButtonFrame>;
  LButton: TControl;
begin
  FFrameStand.CommonActions.Add('Close*',
    procedure (AInfo: TSubjectInfo)
    begin
      AInfo.ModalResult := mrAbort;
    end);
  LInfo := FFrameStand.New<TButtonFrame>(FMain);
  LInfo.ShowModal(Recorder());
  // what FMX does on a click (TControl.Click is protected)
  LButton := LInfo.Frame.CloseButton;
  LButton.OnClick(LButton);
  Pump(300);
  Assert.AreEqual(1, FCalls);
  Assert.AreEqual(mrAbort, FResult);
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TModalResultFixture.NoResultProcWhenTheOwnerIsDestroyed;
begin
  FFrameStand.New<TCountFrame>(FMain).ShowModal(Recorder());
  FreeAndNil(FMain);
  Pump(300);
  Assert.AreEqual(0, FCalls, 'not called during the destruction');
end;

procedure TModalResultFixture.FormStandShowModal;
var
  LInfo: TFormInfo<TDataForm>;
  LDestroyed: Integer;
  LData: string;
  LGotResult: TModalResult;
begin
  LDestroyed := FormsDestroyed;
  LData := '';
  LGotResult := mrNone;
  LInfo := FFormStand.New<TDataForm>(FMain);
  LInfo.Form.Data := 'chosen';
  LInfo.ShowModal(
    procedure (AForm: TDataForm; AResult: TModalResult)
    begin
      LData := AForm.Data;
      LGotResult := AResult;
    end);
  LInfo.ModalResult := mrOk;
  Pump(300);
  Assert.AreEqual('chosen', LData);
  Assert.AreEqual(mrOk, LGotResult);
  Assert.AreEqual(0, FFormStand.Count);
  Assert.AreEqual(LDestroyed + 1, FormsDestroyed);
end;

initialization
  TDUnitX.RegisterTestFixture(TModalResultFixture);

end.
