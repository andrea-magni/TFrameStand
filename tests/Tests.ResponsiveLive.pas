unit Tests.ResponsiveLive;

// ResponsiveMode = rmLive: subjects replaced when the parent changes breakpoint.

interface

uses
  System.SysUtils, System.Classes, System.UITypes, DUnitX.TestFramework
, FMX.Types, FMX.Forms, FMX.Controls, FMX.Layouts
, SubjectStand, FrameStand, FormStand, ResponsiveContainer
, Tests.Subjects
;

type
  [TestFixture]
  TResponsiveLiveFixture = class
  private
    FMain: TForm;
    FContent: TLayout;
    FFrameStand: TFrameStand;
    FChanges: Integer;
    FOldClass: string;
    procedure ResponsiveChange(const ASender: TSubjectStand; const AInfo: TSubjectInfo;
      const AOldSubject: TSubject);
    procedure SetWidth(const AWidth: Single);
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure OnCreateModeKeepsTheSubject;
    [Test] procedure VisibleSubjectReplaced;
    [Test] procedure BackToTheSmallerBreakpoint;
    [Test] procedure HiddenSubjectReplacedWhenShown;
    [Test] procedure OnResponsiveChangeGetsBothSubjects;
    [Test] procedure OneReplacementPerBreakpointChange;
    [Test] procedure StandChangesToo;
    [Test] procedure ModalResultAfterTheReplacement;
    [Test] procedure StackKeepsItsPage;
    [Test] procedure UsedSubjectsAreNotReplaced;
    [Test] procedure OwnerDestroyedWhileACheckIsPending;
  end;

implementation

{ TResponsiveLiveFixture }

procedure TResponsiveLiveFixture.Setup;
begin
  FChanges := 0;
  FOldClass := '';
  FMain := TForm.CreateNew(nil);
  FContent := TLayout.Create(FMain);
  FContent.Parent := FMain;
  FContent.SetBounds(0, 0, 300, 500); // xs (breakpoints: xs 400, sm 768...)
  FFrameStand := TFrameStand.Create(FMain);
  FFrameStand.DefaultParent := FContent;
  FFrameStand.Responsive.Define(TBaseFrame, TDerived2Frame, 'sm');
  FFrameStand.OnResponsiveChange := ResponsiveChange;
end;

procedure TResponsiveLiveFixture.TearDown;
begin
  FreeAndNil(FMain);
end;

procedure TResponsiveLiveFixture.ResponsiveChange(const ASender: TSubjectStand;
  const AInfo: TSubjectInfo; const AOldSubject: TSubject);
begin
  Inc(FChanges);
  FOldClass := AOldSubject.ClassName; // still alive here
  AInfo.Subject.Tag := AOldSubject.Tag; // "copy the state"
end;

procedure TResponsiveLiveFixture.SetWidth(const AWidth: Single);
begin
  // the stand fills its parent: resized with it
  FContent.Width := AWidth;
  Pump(100);
end;

procedure TResponsiveLiveFixture.OnCreateModeKeepsTheSubject;
var
  LInfo: TFrameInfo<TBaseFrame>;
begin
  LInfo := FFrameStand.New<TBaseFrame>;
  LInfo.Show;
  SetWidth(800);
  Assert.AreEqual('TBaseFrame', LInfo.Frame.ClassName, 'rmOnCreate: as created');
  Assert.AreEqual(0, FChanges);
end;

procedure TResponsiveLiveFixture.VisibleSubjectReplaced;
var
  LInfo: TFrameInfo<TBaseFrame>;
begin
  FFrameStand.ResponsiveMode := rmLive;
  LInfo := FFrameStand.New<TBaseFrame>;
  LInfo.Show;
  Assert.AreEqual('TBaseFrame', LInfo.Frame.ClassName);
  SetWidth(800);
  Assert.AreEqual('TDerived2Frame', LInfo.Frame.ClassName, 'sm: replaced');
  Assert.IsTrue(LInfo.Subject = LInfo.Frame);
  Assert.AreEqual(1, FFrameStand.Count, 'the same info');
  Assert.IsTrue(FFrameStand.FrameInfo(LInfo.Frame) = TFrameInfo<TFrame>(LInfo), 'registered with the new frame');
  Assert.IsTrue(LInfo.IsVisible, 'shown again');
  Assert.AreEqual(1, FFrameStand.VisibleFrames.Count, 'one entry in the Show/Hide history');
  Assert.IsTrue(FFrameStand.VisibleFrames[0] = LInfo.Frame);
  Assert.IsTrue(LInfo.Frame.Parent = LInfo.Container, 'in the container of the new stand');
end;

procedure TResponsiveLiveFixture.BackToTheSmallerBreakpoint;
var
  LInfo: TFrameInfo<TBaseFrame>;
begin
  FFrameStand.ResponsiveMode := rmLive;
  LInfo := FFrameStand.New<TBaseFrame>;
  LInfo.Show;
  SetWidth(800);
  SetWidth(300);
  Assert.AreEqual('TBaseFrame', LInfo.Frame.ClassName, 'xs again');
  Assert.AreEqual(2, FChanges);
end;

procedure TResponsiveLiveFixture.HiddenSubjectReplacedWhenShown;
var
  LInfo: TFrameInfo<TBaseFrame>;
begin
  FFrameStand.ResponsiveMode := rmLive;
  LInfo := FFrameStand.New<TBaseFrame>;
  LInfo.Show;
  LInfo.Hide;
  SetWidth(800);
  Assert.AreEqual('TBaseFrame', LInfo.Frame.ClassName, 'hidden: not yet');
  LInfo.Show;
  Assert.AreEqual('TDerived2Frame', LInfo.Frame.ClassName, 'when shown');
  Assert.IsTrue(LInfo.IsVisible);
  Assert.AreEqual(1, FFrameStand.VisibleFrames.Count);
end;

procedure TResponsiveLiveFixture.OnResponsiveChangeGetsBothSubjects;
var
  LInfo: TFrameInfo<TBaseFrame>;
begin
  FFrameStand.ResponsiveMode := rmLive;
  LInfo := FFrameStand.New<TBaseFrame>;
  LInfo.Frame.Tag := 42;
  LInfo.Show;
  SetWidth(800);
  Assert.AreEqual(1, FChanges);
  Assert.AreEqual('TBaseFrame', FOldClass, 'the old subject, still alive in the event');
  Assert.AreEqual<NativeInt>(42, LInfo.Frame.Tag, 'state copied by the event');
end;

procedure TResponsiveLiveFixture.OneReplacementPerBreakpointChange;
var
  LInfo: TFrameInfo<TBaseFrame>;
begin
  FFrameStand.ResponsiveMode := rmLive;
  LInfo := FFrameStand.New<TBaseFrame>;
  LInfo.Show;
  // a window being resized: many sizes, one breakpoint change
  FContent.Width := 500;
  FContent.Width := 600;
  FContent.Width := 700;
  Pump(100);
  SetWidth(750);
  SetWidth(760);
  Assert.AreEqual(1, FChanges);
  Assert.AreEqual('TDerived2Frame', LInfo.Frame.ClassName);
end;

procedure TResponsiveLiveFixture.StandChangesToo;
var
  LInfo: TFrameInfo<TFrame>;
begin
  FFrameStand.ResponsiveMode := rmLive;
  FFrameStand.Responsive.Define(
    TResponsiveDefinition.Create(TFrame, 'small'),
    TResponsiveDefinition.Create(nil, 'large'), 'sm');
  LInfo := FFrameStand.New<TFrame>(nil, 'small');
  LInfo.Show;
  Assert.AreEqual('small', LInfo.StandStyleName);
  SetWidth(800);
  Assert.AreEqual('large', LInfo.StandStyleName, 'another stand, same class');
  Assert.AreEqual('TFrame', LInfo.Frame.ClassName);
end;

procedure TResponsiveLiveFixture.ModalResultAfterTheReplacement;
var
  LInfo: TFrameInfo<TBaseFrame>;
  LGotClass: string;
  LResult: TModalResult;
begin
  FFrameStand.ResponsiveMode := rmLive;
  LGotClass := '';
  LResult := mrNone;
  LInfo := FFrameStand.New<TBaseFrame>;
  LInfo.ShowModal(
    procedure (AFrame: TBaseFrame; AResult: TModalResult)
    begin
      LGotClass := AFrame.ClassName;
      LResult := AResult;
    end);
  SetWidth(800);
  LInfo.ModalResult := mrOk;
  Pump(300);
  Assert.AreEqual(mrOk, LResult, 'still a dialog after the replacement');
  Assert.AreEqual('TDerived2Frame', LGotClass, 'the frame at the time of the result');
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TResponsiveLiveFixture.StackKeepsItsPage;
var
  LRoot, LTop: TFrameInfo<TBaseFrame>;
begin
  FFrameStand.ResponsiveMode := rmLive;
  LRoot := FFrameStand.Push<TBaseFrame>;
  LTop := FFrameStand.Push<TBaseFrame>;
  SetWidth(800);
  Assert.AreEqual('TDerived2Frame', LTop.Frame.ClassName, 'visible: replaced');
  Assert.IsTrue(FFrameStand.StackTop = LTop, 'same info on top');
  Assert.AreEqual('TBaseFrame', LRoot.Frame.ClassName, 'hidden: not yet');
  FFrameStand.Pop;
  Assert.AreEqual('TDerived2Frame', LRoot.Frame.ClassName, 'replaced when shown again by Pop');
  Pump(300);
end;

procedure TResponsiveLiveFixture.UsedSubjectsAreNotReplaced;
var
  LFrame: TBaseFrame;
  LInfo: TFrameInfo<TBaseFrame>;
begin
  FFrameStand.ResponsiveMode := rmLive;
  LFrame := TBaseFrame.Create(nil);
  LInfo := FFrameStand.Use<TBaseFrame>(LFrame);
  LInfo.FrameIsOwned := True;
  LInfo.Show;
  SetWidth(800);
  Assert.IsTrue(LInfo.Frame = LFrame, 'Use: no class was requested');
  Assert.AreEqual(0, FChanges);
end;

procedure TResponsiveLiveFixture.OwnerDestroyedWhileACheckIsPending;
var
  LInfo: TFrameInfo<TBaseFrame>;
begin
  FFrameStand.ResponsiveMode := rmLive;
  LInfo := FFrameStand.New<TBaseFrame>;
  LInfo.Show;
  FContent.Width := 800; // check scheduled
  FreeAndNil(FMain);
  Pump(100);
  Assert.Pass('no access violation');
end;

initialization
  TDUnitX.RegisterTestFixture(TResponsiveLiveFixture);

end.
