unit Tests.Gestures;

// Interactive gestures (Touch.InteractiveGestures) of the controls of a subject
// registered with the form hosting the stand (TCommonCustomForm.AddRecognizer)
// and given back exactly (RemoveRecognizer): the form counts them per gesture.

interface

uses
  System.SysUtils, System.Classes, System.Rtti, DUnitX.TestFramework
, FMX.Types, FMX.Forms, FMX.Controls, FMX.Layouts, FMX.Objects
, SubjectStand, FrameStand, FormStand
, Tests.Subjects
;

type
  [TestFixture]
  TGesturesFixture = class
  private
    FMain: TForm;
    FLayout: TLayout;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure FormOwnedControlIsRegisteredByFmx;
    [Test] procedure FrameGesturesRegisteredWithTheHostForm;
    [Test] procedure ShowDoesNotCountTwice;
    [Test] procedure CloseGivesTheGesturesBack;
    [Test] procedure HideAndCloseGivesTheGesturesBack;
    [Test] procedure TwoFramesCountTwice;
    [Test] procedure ShowAppliesTheChanges;
    [Test] procedure StandReachingAFormLaterRegistersOnShow;
    [Test] procedure AdoptedFrameOwnedByTheHostFormIsNotCountedTwice;
    [Test] procedure FormSubjectGesturesRegisteredWithTheHostForm;
    [Test] procedure HostFormFreedBeforeTheSubject;
  end;

implementation

/// <summary>Recognizers of AGesture registered with AForm (its private
/// per-gesture counter, FGestureRecognizers).</summary>
function Recognizers(const AForm: TCommonCustomForm; const AGesture: TInteractiveGesture): Integer;
var
  LField: TRttiField;
begin
  LField := TRttiContext.Create.GetType(TCommonCustomForm).GetField('FGestureRecognizers');
  if not Assigned(LField) then
    raise Exception.Create('TCommonCustomForm.FGestureRecognizers not found');
  Result := PInteger(PByte(AForm) + LField.Offset + Ord(AGesture) * SizeOf(Integer))^;
end;

{ TGesturesFixture }

procedure TGesturesFixture.Setup;
begin
  FramesDestroyed := 0;
  FormsDestroyed := 0;
  FMain := TForm.CreateNew(nil);
  FLayout := TLayout.Create(FMain);
  FLayout.Parent := FMain;
end;

procedure TGesturesFixture.TearDown;
begin
  FreeAndNil(FMain);
  Pump(50);
end;

procedure TGesturesFixture.FormOwnedControlIsRegisteredByFmx;
var
  LRect: TRectangle;
begin
  // what the library mirrors (and a check of Recognizers)
  LRect := TRectangle.Create(FMain);
  LRect.Parent := FMain;
  LRect.Touch.InteractiveGestures := [TInteractiveGesture.Zoom];
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Zoom));
  LRect.Touch.InteractiveGestures := [];
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Zoom));
end;

procedure TGesturesFixture.FrameGesturesRegisteredWithTheHostForm;
var
  LFrameStand: TFrameStand;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LFrameStand.New<TGestureFrame>(FLayout);
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Zoom), 'Zoom');
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.DoubleTap), 'DoubleTap');
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Pan), 'Pan');
end;

procedure TGesturesFixture.ShowDoesNotCountTwice;
var
  LFrameStand: TFrameStand;
  LInfo: TFrameInfo<TGestureFrame>;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LInfo := LFrameStand.New<TGestureFrame>(FLayout);
  LInfo.Show;
  LInfo.Hide;
  Pump(50);
  LInfo.Show;
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Zoom), 'Zoom');
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.DoubleTap), 'DoubleTap');
end;

procedure TGesturesFixture.CloseGivesTheGesturesBack;
var
  LFrameStand: TFrameStand;
  LInfo: TFrameInfo<TGestureFrame>;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LInfo := LFrameStand.New<TGestureFrame>(FLayout);
  LInfo.Show;
  LInfo.Close;
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Zoom), 'Zoom');
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.DoubleTap), 'DoubleTap');
end;

procedure TGesturesFixture.HideAndCloseGivesTheGesturesBack;
var
  LFrameStand: TFrameStand;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LFrameStand.New<TGestureFrame>(FLayout).Show;
  LFrameStand.HideAndCloseAll;
  Pump(500);
  Assert.AreEqual(0, LFrameStand.Count, 'closed');
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Zoom), 'Zoom');
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.DoubleTap), 'DoubleTap');
end;

procedure TGesturesFixture.TwoFramesCountTwice;
var
  LFrameStand: TFrameStand;
  LFirst, LSecond: TFrameInfo<TGestureFrame>;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LFirst := LFrameStand.New<TGestureFrame>(FLayout);
  LSecond := LFrameStand.New<TGestureFrame>(FLayout);
  LFirst.Show;
  LSecond.Show;
  Assert.AreEqual(2, Recognizers(FMain, TInteractiveGesture.Zoom), 'two frames');
  LFirst.Close;
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Zoom), 'one closed');
  LSecond.Close;
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Zoom), 'both closed');
end;

procedure TGesturesFixture.ShowAppliesTheChanges;
var
  LFrameStand: TFrameStand;
  LInfo: TFrameInfo<TGestureFrame>;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LInfo := LFrameStand.New<TGestureFrame>(FLayout);
  LInfo.Frame.Area.Touch.InteractiveGestures := [TInteractiveGesture.Pan];
  LInfo.Show;
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Zoom), 'Zoom');
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.DoubleTap), 'DoubleTap');
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Pan), 'Pan');
  LInfo.Close;
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Pan), 'Pan given back');
end;

procedure TGesturesFixture.StandReachingAFormLaterRegistersOnShow;
var
  LFrameStand: TFrameStand;
  LLayout: TLayout;
  LInfo: TFrameInfo<TGestureFrame>;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LLayout := TLayout.Create(FMain); // not in the form yet
  LInfo := LFrameStand.New<TGestureFrame>(LLayout);
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Zoom), 'no form');
  LLayout.Parent := FMain;
  LInfo.Show;
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Zoom), 'shown in the form');
  LInfo.Close;
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Zoom), 'closed');
end;

procedure TGesturesFixture.AdoptedFrameOwnedByTheHostFormIsNotCountedTwice;
var
  LFrameStand: TFrameStand;
  LFrame: TGestureFrame;
begin
  LFrameStand := TFrameStand.Create(FMain);
  // owned by the form: FMX registers its gestures while loading it
  LFrame := TGestureFrame.Create(FMain);
  LFrame.Name := '';
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Zoom), 'registered by FMX');
  LFrameStand.Use<TGestureFrame>(LFrame, FLayout).Show;
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Zoom), 'not by the stand too');
  LFrameStand.CloseAll;
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Zoom), 'the one of FMX is kept');
end;

procedure TGesturesFixture.FormSubjectGesturesRegisteredWithTheHostForm;
var
  LFormStand: TFormStand;
begin
  LFormStand := TFormStand.Create(FMain);
  LFormStand.New<TGestureForm>(FLayout).Show;
  Assert.AreEqual(1, Recognizers(FMain, TInteractiveGesture.Pan), 'Pan');
  LFormStand.CloseAll;
  Assert.AreEqual(0, Recognizers(FMain, TInteractiveGesture.Pan), 'given back');
  Assert.AreEqual(1, FormsDestroyed);
end;

procedure TGesturesFixture.HostFormFreedBeforeTheSubject;
var
  LFrameStand: TFrameStand;
begin
  // the stand component outlives the form: nothing is given back to a freed form
  LFrameStand := TFrameStand.Create(nil);
  try
    LFrameStand.New<TGestureFrame>(FLayout).Show;
    FreeAndNil(FMain);
    Pump(50);
    Assert.AreEqual(0, LFrameStand.Count, 'subject gone with the form');
    LFrameStand.CloseAll;
  finally
    LFrameStand.Free;
  end;
  Pump(50);
end;

initialization
  TDUnitX.RegisterTestFixture(TGesturesFixture);

end.
