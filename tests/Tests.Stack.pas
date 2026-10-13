unit Tests.Stack;

// Navigation stack: Push, Pop, PopToRoot, PushMode, StackOperation.

interface

uses
  System.SysUtils, System.Classes, System.UITypes, DUnitX.TestFramework
, FMX.Types, FMX.Forms, FMX.Controls
, SubjectStand, FrameStand, FormStand
, Tests.Subjects
;

type
  [TestFixture]
  TStackFixture = class
  private
    FMain: TForm;
    FFrameStand: TFrameStand;
    FFormStand: TFormStand;
    FLog: string;
    procedure LogShow(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo);
    procedure LogHide(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo);
    procedure UseAnimatedStand;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure PushHidesThePageBelow;
    [Test] procedure PopShowsThePageBelowAsItWas;
    [Test] procedure RootIsNotPopped;
    [Test] procedure PopToRootClosesThePagesInBetween;
    [Test] procedure KeepVisibleMode;
    [Test] procedure CloseModeCreatesThePageAgain;
    [Test] procedure StackOperationDuringShowAndHide;
    [Test] procedure BackKeyPops;
    [Test] procedure BackKeyCancelsADialogOverThePage;
    [Test] procedure TopClosedBySomeoneElse;
    [Test] procedure CloseAllEmptiesTheStack;
    [Test] procedure HideAndCloseAllEmptiesTheStackAtOnce;
    [Test] procedure OwnerDestroyedWithPages;
    [Test] procedure PopWhileThePageBelowIsHiding;
    [Test] procedure FormStandPushAndPop;
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

function OpName(const AOperation: TStackOperation): string;
begin
  case AOperation of
    soPush: Result := 'push';
    soPop: Result := 'pop';
  else
    Result := 'none';
  end;
end;

{ TStackFixture }

procedure TStackFixture.Setup;
begin
  FLog := '';
  FMain := TForm.CreateNew(nil);
  FFrameStand := TFrameStand.Create(FMain);
  FFormStand := TFormStand.Create(FMain);
end;

procedure TStackFixture.TearDown;
begin
  FreeAndNil(FMain);
end;

procedure TStackFixture.LogShow(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo);
begin
  FLog := FLog + 'show' + ASubjectInfo.Subject.Tag.ToString + ':' + OpName(ASender.StackOperation) + ' ';
end;

procedure TStackFixture.LogHide(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo);
begin
  FLog := FLog + 'hide' + ASubjectInfo.Subject.Tag.ToString + ':' + OpName(ASender.StackOperation) + ' ';
end;

procedure TStackFixture.UseAnimatedStand;
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

procedure TStackFixture.PushHidesThePageBelow;
var
  LA, LB: TFrameInfo<TFrame>;
begin
  LA := FFrameStand.Push<TFrame>(FMain);
  Assert.AreEqual(1, FFrameStand.StackCount);
  Assert.IsTrue(LA.IsVisible);
  LB := FFrameStand.Push<TFrame>(FMain);
  Assert.AreEqual(2, FFrameStand.StackCount);
  Assert.IsTrue(FFrameStand.StackTop = LB);
  Assert.IsTrue(LB.IsVisible);
  Assert.IsFalse(LA.IsVisible, 'hidden');
  Assert.AreEqual(2, FFrameStand.Count, 'kept');
end;

procedure TStackFixture.PopShowsThePageBelowAsItWas;
var
  LA: TFrameInfo<TFrame>;
  LFrameA: TFrame;
begin
  LA := FFrameStand.Push<TFrame>(FMain);
  LFrameA := LA.Frame;
  LFrameA.Hint := 'state of the page';
  FFrameStand.Push<TFrame>(FMain);
  Assert.IsTrue(FFrameStand.Pop);
  Assert.AreEqual(1, FFrameStand.StackCount);
  Assert.IsTrue(FFrameStand.StackTop = LA);
  Assert.IsTrue(LA.IsVisible, 'shown again');
  Assert.IsTrue(LA.Frame = LFrameA, 'the same frame');
  Assert.AreEqual('state of the page', LA.Frame.Hint);
  Pump(300);
  Assert.AreEqual(1, FFrameStand.Count, 'the popped page is closed');
end;

procedure TStackFixture.RootIsNotPopped;
begin
  Assert.IsFalse(FFrameStand.Pop, 'empty');
  FFrameStand.Push<TFrame>(FMain);
  Assert.IsFalse(FFrameStand.Pop, 'only the root');
  Assert.IsFalse(FFrameStand.PopToRoot);
  Assert.AreEqual(1, FFrameStand.StackCount);
end;

procedure TStackFixture.PopToRootClosesThePagesInBetween;
var
  LRoot: TFrameInfo<TFrame>;
  LDestroyed: Integer;
begin
  LDestroyed := FramesDestroyed;
  LRoot := FFrameStand.Push<TFrame>(FMain);
  FFrameStand.Push<TCountFrame>(FMain);
  FFrameStand.Push<TCountFrame>(FMain);
  FFrameStand.Push<TCountFrame>(FMain);
  Assert.IsTrue(FFrameStand.PopToRoot);
  Assert.AreEqual(1, FFrameStand.StackCount);
  Assert.IsTrue(LRoot.IsVisible);
  Assert.AreEqual(LDestroyed + 2, FramesDestroyed, 'the pages in between, at once');
  Pump(300);
  Assert.AreEqual(LDestroyed + 3, FramesDestroyed, 'the top one after its hide');
  Assert.AreEqual(1, FFrameStand.Count);
end;

procedure TStackFixture.KeepVisibleMode;
var
  LA: TFrameInfo<TFrame>;
begin
  FFrameStand.PushMode := pmKeepVisible;
  LA := FFrameStand.Push<TFrame>(FMain);
  FFrameStand.Push<TFrame>(FMain);
  Assert.IsTrue(LA.IsVisible, 'still visible under the new page');
  FFrameStand.Pop;
  Pump(300);
  Assert.IsTrue(LA.IsVisible);
  Assert.AreEqual(1, FFrameStand.Count);
end;

procedure TStackFixture.CloseModeCreatesThePageAgain;
var
  LA: TFrameInfo<TCountFrame>;
  LFrameA: TCountFrame;
  LDestroyed, LConfigured: Integer;
begin
  FFrameStand.PushMode := pmClose;
  LDestroyed := FramesDestroyed;
  LConfigured := 0;
  LA := FFrameStand.Push<TCountFrame>(FMain, '',
    procedure (AFrame: TCountFrame)
    begin
      Inc(LConfigured);
      AFrame.Tag := 42;
    end);
  LFrameA := LA.Frame;
  Assert.AreEqual(1, LConfigured);
  FFrameStand.Push<TFrame>(FMain);
  Pump(300);
  Assert.AreEqual(LDestroyed + 1, FramesDestroyed, 'the page below is closed');
  Assert.AreEqual(2, FFrameStand.StackCount, 'but still in the stack');
  Assert.IsFalse(FFrameStand.StackTop.Subject is TCountFrame, 'top: the second page');

  Assert.IsTrue(FFrameStand.Pop);
  Assert.AreEqual(2, LConfigured, 'configured again');
  Assert.IsTrue(FFrameStand.StackTop.Subject is TCountFrame);
  Assert.IsTrue(FFrameStand.StackTop.Subject <> LFrameA, 'a new frame');
  Assert.AreEqual<NativeInt>(42, FFrameStand.StackTop.Subject.Tag);
  Assert.IsTrue(FFrameStand.StackTop.IsVisible);
  Pump(300);
  Assert.AreEqual(1, FFrameStand.Count);
end;

procedure TStackFixture.StackOperationDuringShowAndHide;
var
  LA, LB: TFrameInfo<TFrame>;
begin
  FFrameStand.OnBeforeShow := LogShow;
  FFrameStand.OnBeforeHide := LogHide;
  LA := FFrameStand.Push<TFrame>(FMain);
  LA.Frame.Tag := 1; // after its first show
  FLog := '';
  LB := FFrameStand.Push<TFrame>(FMain);
  LB.Frame.Tag := 2;
  Assert.AreEqual('show0:push hide1:push ', FLog);
  FLog := '';
  FFrameStand.Pop;
  Assert.AreEqual('show1:pop hide2:pop ', FLog);
  Assert.AreEqual(soNone, FFrameStand.StackOperation, 'outside Push and Pop');
  Pump(300);
end;

procedure TStackFixture.BackKeyPops;
var
  LKey: Word;
  LKeyChar: Char;
  LA: TFrameInfo<TFrame>;
begin
  LA := FFrameStand.Push<TFrame>(FMain);
  FFrameStand.Push<TFrame>(FMain);
  LKey := vkHardwareBack;
  LKeyChar := #0;
  Assert.IsTrue(FFrameStand.HandleBackKey(LKey, LKeyChar));
  Assert.AreEqual(1, FFrameStand.StackCount);
  Assert.IsTrue(LA.IsVisible);
  LKey := vkHardwareBack;
  Assert.IsFalse(FFrameStand.HandleBackKey(LKey, LKeyChar), 'the root is left to the form');
  Assert.AreEqual<Word>(vkHardwareBack, LKey);
  Pump(300);
end;

procedure TStackFixture.BackKeyCancelsADialogOverThePage;
var
  LKey: Word;
  LKeyChar: Char;
  LResult: TModalResult;
begin
  LResult := mrNone;
  FFrameStand.Push<TFrame>(FMain);
  FFrameStand.Push<TFrame>(FMain);
  FFrameStand.New<TFrame>(FMain).ShowModal(
    procedure (AResult: TModalResult)
    begin
      LResult := AResult;
    end);
  LKey := vkHardwareBack;
  LKeyChar := #0;
  FFrameStand.HandleBackKey(LKey, LKeyChar);
  Assert.AreEqual(mrCancel, LResult, 'the dialog first');
  Assert.AreEqual(2, FFrameStand.StackCount, 'the pages stay');
  Pump(300);
end;

procedure TStackFixture.TopClosedBySomeoneElse;
var
  LA, LB: TFrameInfo<TFrame>;
begin
  LA := FFrameStand.Push<TFrame>(FMain);
  LB := FFrameStand.Push<TFrame>(FMain);
  LB.HideAndClose; // e.g. a Close* Common Action on the page
  Pump(300);
  Assert.AreEqual(1, FFrameStand.StackCount);
  Assert.IsTrue(LA.IsVisible, 'back to the page below');
  Assert.AreEqual(1, FFrameStand.Count);
end;

procedure TStackFixture.CloseAllEmptiesTheStack;
begin
  FFrameStand.Push<TFrame>(FMain);
  FFrameStand.Push<TFrame>(FMain);
  FFrameStand.CloseAll;
  Pump(300);
  Assert.AreEqual(0, FFrameStand.StackCount);
  Assert.AreEqual(0, FFrameStand.Count, 'no page shown again');
end;

procedure TStackFixture.HideAndCloseAllEmptiesTheStackAtOnce;
begin
  FFrameStand.Push<TFrame>(FMain);
  FFrameStand.Push<TFrame>(FMain);
  FFrameStand.Push<TFrame>(FMain);
  FFrameStand.HideAndCloseAll;
  Assert.AreEqual(0, FFrameStand.StackCount, 'at once, while the pages hide');
  Pump(300);
  Assert.AreEqual(0, FFrameStand.Count, 'no page shown again');
end;

procedure TStackFixture.OwnerDestroyedWithPages;
begin
  FFrameStand.PushMode := pmClose;
  FFrameStand.Push<TCountFrame>(FMain);
  FFrameStand.Push<TCountFrame>(FMain);
  FFrameStand.Push<TCountFrame>(FMain).HideAndClose;
  FreeAndNil(FMain);
  Pump(300);
  Assert.Pass('no access violation');
end;

procedure TStackFixture.PopWhileThePageBelowIsHiding;
var
  LA: TFrameInfo<TFrame>;
begin
  UseAnimatedStand;
  LA := FFrameStand.Push<TFrame>(FMain, 'animated');
  FFrameStand.Push<TFrame>(FMain, 'animated');
  Assert.IsTrue(LA.Hiding, 'hide animation of the page below');
  FFrameStand.Pop; // before that animation ends
  Pump(800);
  Assert.IsTrue(LA.IsVisible, 'shown again after its hide');
  Assert.AreEqual(1, FFrameStand.Count);
end;

procedure TStackFixture.FormStandPushAndPop;
var
  LA: TFormInfo<TDataForm>;
  LDestroyed: Integer;
begin
  LDestroyed := FormsDestroyed;
  LA := FFormStand.Push<TDataForm>(FMain, '',
    procedure (AForm: TDataForm)
    begin
      AForm.Data := 'root';
    end);
  FFormStand.Push<TDataForm>(FMain);
  Assert.IsFalse(LA.IsVisible);
  Assert.IsTrue(FFormStand.Pop);
  Assert.IsTrue(LA.IsVisible);
  Assert.AreEqual('root', LA.Form.Data);
  Pump(300);
  Assert.AreEqual(LDestroyed + 1, FormsDestroyed);
  Assert.AreEqual(1, FFormStand.Count);
end;

initialization
  TDUnitX.RegisterTestFixture(TStackFixture);

end.
