unit Tests.Teardown;

interface

uses
  System.SysUtils, System.Classes, DUnitX.TestFramework
, FMX.Types, FMX.Types3D, FMX.Forms, FMX.Forms3D, FMX.Controls, FMX.Layouts
, FMX.Layers3D, FMX.ActnList
, SubjectStand, FrameStand, FormStand
, Tests.Subjects
;

type
  // objects destroyed by someone else (B14, B15)
  [TestFixture]
  TTeardownFixture = class
  private
    FMain: TForm;
    FLayout: TLayout;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure AdoptedFormWithoutControlsCloses;
    [Test] procedure AdoptedFormGetsAllItsControlsBack;
    [Test] procedure OwnerFreedWithAdoptedForm;
    [Test] procedure OwnerFreedWithAdoptedFrame;
    [Test] procedure OwnerFreedFreesFormsCreatedByNew;
    [Test] procedure ParentFreedWhileShown;
    [Test] procedure AdoptedFrameFreedByTheApplication;
    [Test] procedure ComponentOwnedElsewhereRemovesItsStands;
    [Test] procedure CyclesDoNotGrowMemory;
  end;

  // StandBook, CommonActionList, DefaultParent freed elsewhere (B7)
  [TestFixture]
  TReferencesFixture = class
  private
    FMain: TForm;
    FFrameStand: TFrameStand;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure StandBookFreedElsewhere;
    [Test] procedure CommonActionListFreedElsewhere;
    [Test] procedure DefaultParentFreedElsewhere;
    [Test] procedure ReassignedReferenceIsNotCleared;
  end;

  // parents and owners (B6)
  [TestFixture]
  TParentsFixture = class
  public
    [Test] procedure Layer3DParent;
    [Test] procedure Layer3DWidthIsInPixels;
    [Test] procedure Form3DOwner;
    [Test] procedure NonFmxOwnerNeedsAParent;
    [Test] procedure NoOwnerNoParent;
  end;

implementation

type
  TFrameStandAccess = class(TFrameStand);

function StandParentName(const AInfo: TSubjectInfo): string;
begin
  Result := ClassNameOf(AInfo.Stand.Parent);
end;

{ TTeardownFixture }

procedure TTeardownFixture.Setup;
begin
  FramesDestroyed := 0;
  FormsDestroyed := 0;
  FMain := TForm.CreateNew(nil);
  FLayout := TLayout.Create(FMain);
  FLayout.Parent := FMain;
end;

procedure TTeardownFixture.TearDown;
begin
  FreeAndNil(FMain);
  Pump(50);
end;

procedure TTeardownFixture.AdoptedFormWithoutControlsCloses;
var
  LFormStand: TFormStand;
  LForm: TEmptyForm;
begin
  LFormStand := TFormStand.Create(FMain);
  LForm := TEmptyForm.Create(nil);
  try
    LFormStand.Use<TEmptyForm>(LForm, FLayout).Show;
    LFormStand.CloseAll;
    Assert.AreEqual(0, LFormStand.Count);
  finally
    LForm.Free;
  end;
end;

procedure TTeardownFixture.AdoptedFormGetsAllItsControlsBack;
var
  LFormStand: TFormStand;
  LForm: TDataForm;
begin
  LFormStand := TFormStand.Create(FMain);
  LForm := TDataForm.Create(nil);
  try
    LFormStand.Use<TDataForm>(LForm, FLayout).Show;
    Assert.AreEqual(0, LForm.ChildrenCount, 'controls moved to the stand');
    LFormStand.CloseAll;
    Assert.AreEqual(3, LForm.ChildrenCount, 'all the controls given back');
  finally
    LForm.Free;
  end;
end;

procedure TTeardownFixture.OwnerFreedWithAdoptedForm;
var
  LFormStand: TFormStand;
  LForm: TDataForm;
begin
  LFormStand := TFormStand.Create(FMain);
  LForm := TDataForm.Create(nil);
  try
    LFormStand.Use<TDataForm>(LForm, FLayout).Show;
    FreeAndNil(FMain);
    Assert.AreEqual(0, FormsDestroyed, 'the adopted form survives its stand');
  finally
    LForm.Free;
  end;
end;

procedure TTeardownFixture.OwnerFreedWithAdoptedFrame;
var
  LFrameStand: TFrameStand;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LFrameStand.Use<TCountFrame>(TCountFrame.Create(nil), FLayout).Show;
  FreeAndNil(FMain);
  // the frame was a child of the stand: FMX freed it with the form
  Assert.AreEqual(1, FramesDestroyed);
end;

procedure TTeardownFixture.OwnerFreedFreesFormsCreatedByNew;
var
  LFormStand: TFormStand;
begin
  LFormStand := TFormStand.Create(FMain);
  LFormStand.New<TDataForm>(FLayout).Show;
  FreeAndNil(FMain);
  Assert.AreEqual(1, FormsDestroyed);
end;

procedure TTeardownFixture.ParentFreedWhileShown;
var
  LFrameStand: TFrameStand;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LFrameStand.New<TCountFrame>(FLayout).Show;
  FreeAndNil(FLayout);
  Assert.AreEqual(0, LFrameStand.Count, 'subject removed');
  Assert.AreEqual(1, FramesDestroyed);
  LFrameStand.CloseAll;
  FreeAndNil(FMain);
  Assert.AreEqual(1, FramesDestroyed, 'no double free');
end;

procedure TTeardownFixture.AdoptedFrameFreedByTheApplication;
var
  LFrameStand: TFrameStand;
  LFrame: TCountFrame;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LFrame := TCountFrame.Create(nil);
  LFrameStand.Use<TCountFrame>(LFrame, FLayout).Show;
  LFrame.Free;
  Assert.AreEqual(0, LFrameStand.Count, 'subject removed');
  Assert.AreEqual(0, LFrameStand.VisibleFrames.Count);
  Assert.AreEqual(0, FLayout.ChildrenCount, 'stand detached');
  Pump(50); // the detached stand is freed here
end;

procedure TTeardownFixture.ComponentOwnedElsewhereRemovesItsStands;
var
  LOther: TForm;
  LHolder: TComponent;
  LFrameStand: TFrameStand;
  LFrame: TCountFrame;
begin
  LOther := TForm.CreateNew(nil);
  LHolder := TComponent.Create(nil);
  LFrame := TCountFrame.Create(nil);
  try
    LFrameStand := TFrameStand.Create(LHolder);
    LFrameStand.Use<TCountFrame>(LFrame, LOther).Show;
    LFrameStand.New<TCountFrame>(LOther).Show;
    Assert.AreEqual(2, LOther.ChildrenCount);
    FreeAndNil(LHolder);
    Assert.AreEqual(0, LOther.ChildrenCount, 'stands removed');
    Assert.AreEqual(1, FramesDestroyed, 'owned frame freed, adopted frame kept');
    Assert.IsNull(LFrame.Parent, 'adopted frame detached');
  finally
    LFrame.Free;
    LHolder.Free;
    LOther.Free;
  end;
end;

procedure TTeardownFixture.CyclesDoNotGrowMemory;
var
  LFrameStand: TFrameStand;
  LFormStand: TFormStand;
  LCycle: Integer;
  LFrame: TCountFrame;
  LOther: TForm;
  LForm: TDataForm;
  LBefore, LAfter: Int64;
begin
  LFrameStand := TFrameStand.Create(FMain);
  LFormStand := TFormStand.Create(FMain);
  LBefore := 0;
  for LCycle := 1 to 300 do
  begin
    if LCycle = 21 then
      LBefore := AllocatedBytes;
    LFrame := TCountFrame.Create(nil);
    LFrameStand.Use<TCountFrame>(LFrame, FLayout).Show;
    LFrame.Free;
    LOther := TForm.CreateNew(nil);
    LFrameStand.New<TCountFrame>(LOther).Show;
    LOther.Free;
    LForm := TDataForm.Create(nil);
    LFormStand.Use<TDataForm>(LForm, FLayout).Show;
    LFormStand.CloseAll;
    LForm.Free;
    Pump(1);
  end;
  LAfter := AllocatedBytes;
  Assert.AreEqual(0, LFrameStand.Count + LFormStand.Count);
  Assert.IsTrue(LAfter - LBefore < 4096, Format('memory grew by %d bytes', [LAfter - LBefore]));
end;

{ TReferencesFixture }

procedure TReferencesFixture.Setup;
begin
  FMain := TForm.CreateNew(nil);
  FFrameStand := TFrameStand.Create(FMain);
end;

procedure TReferencesFixture.TearDown;
begin
  FreeAndNil(FMain);
end;

procedure TReferencesFixture.StandBookFreedElsewhere;
var
  LModule: TComponent;
begin
  LModule := TComponent.Create(nil);
  FFrameStand.StandBook := TStyleBook.Create(LModule);
  LModule.Free;
  Assert.IsNull(FFrameStand.StandBook);
  FFrameStand.New<TFrame>(FMain).Show;
  Assert.AreEqual(1, FFrameStand.Count);
end;

procedure TReferencesFixture.CommonActionListFreedElsewhere;
var
  LModule: TComponent;
begin
  LModule := TComponent.Create(nil);
  FFrameStand.CommonActionList := TActionList.Create(LModule);
  LModule.Free;
  Assert.IsNull(FFrameStand.CommonActionList);
  FFrameStand.New<TFrame>(FMain).Show;
  Assert.AreEqual(1, FFrameStand.Count);
end;

procedure TReferencesFixture.DefaultParentFreedElsewhere;
var
  LOther: TForm;
  LLayout: TLayout;
begin
  LOther := TForm.CreateNew(nil);
  LLayout := TLayout.Create(LOther);
  LLayout.Parent := LOther;
  FFrameStand.DefaultParent := LLayout;
  LOther.Free;
  Assert.IsNull(FFrameStand.DefaultParent);
  Assert.AreEqual('TForm', StandParentName(FFrameStand.New<TFrame>), 'falls back to the owner');
end;

procedure TReferencesFixture.ReassignedReferenceIsNotCleared;
var
  LModule: TComponent;
begin
  LModule := TComponent.Create(nil);
  FFrameStand.StandBook := TStyleBook.Create(LModule);
  FFrameStand.StandBook := TStyleBook.Create(FMain);
  LModule.Free;
  Assert.IsNotNull(FFrameStand.StandBook, 'the new style book is kept');
end;

{ TParentsFixture }

procedure TParentsFixture.Layer3DParent;
var
  LForm3D: TForm3D;
  LLayer: TLayer3D;
  LFrameStand: TFrameStand;
begin
  LForm3D := TForm3D.CreateNew(nil);
  try
    LLayer := TLayer3D.Create(LForm3D);
    LLayer.Parent := LForm3D;
    LLayer.Width := 10;
    LFrameStand := TFrameStand.Create(LForm3D);
    Assert.AreEqual('TLayer3D', StandParentName(LFrameStand.New<TFrame>(LLayer)));
    // responsive lookup on a 3D parent
    LFrameStand.Responsive.Define(TBaseFrame, TDerived2Frame, 'xs');
    Assert.AreEqual('TDerived2Frame', LFrameStand.New<TBaseFrame>(LLayer).Frame.ClassName);
  finally
    LForm3D.Free;
  end;
end;

procedure TParentsFixture.Layer3DWidthIsInPixels;
var
  LForm3D: TForm3D;
  LLayer: TLayer3D;
  LFrameStand: TFrameStand;
  LWidth: Single;
begin
  LForm3D := TForm3D.CreateNew(nil);
  try
    LLayer := TLayer3D.Create(LForm3D);
    LLayer.Parent := LForm3D;
    LLayer.Width := 10;
    LFrameStand := TFrameStand.Create(LForm3D);
    Assert.IsTrue(TFrameStandAccess(LFrameStand).GetParentWidth(LLayer, LWidth));
    Assert.AreEqual(Double(500), Double(LWidth), 0.01, 'Width 10 x Resolution 50');
    LLayer.Projection := TProjection.Screen;
    LLayer.Width := 300;
    Assert.IsTrue(TFrameStandAccess(LFrameStand).GetParentWidth(LLayer, LWidth));
    Assert.AreEqual(Double(300), Double(LWidth), 0.01, 'Screen projection');
  finally
    LForm3D.Free;
  end;
end;

procedure TParentsFixture.Form3DOwner;
var
  LForm3D: TForm3D;
  LFrameStand: TFrameStand;
begin
  LForm3D := TForm3D.CreateNew(nil);
  try
    LFrameStand := TFrameStand.Create(LForm3D);
    Assert.AreEqual('TForm3D', StandParentName(LFrameStand.New<TFrame>));
  finally
    LForm3D.Free;
  end;
end;

procedure TParentsFixture.NonFmxOwnerNeedsAParent;
var
  LModule: TComponent;
  LMain: TForm;
  LFrameStand: TFrameStand;
begin
  LModule := TComponent.Create(nil);
  LMain := TForm.CreateNew(nil);
  try
    LFrameStand := TFrameStand.Create(LModule);
    Assert.WillRaiseWithMessageRegex(
      procedure begin LFrameStand.New<TFrame> end, ESubjectStandError,
      'no parent for the stand.*owner: TComponent');
    Assert.AreEqual('TForm', StandParentName(LFrameStand.New<TFrame>(LMain)), 'explicit parent');
    LFrameStand.DefaultParent := LMain;
    Assert.AreEqual('TForm', StandParentName(LFrameStand.New<TFrame>), 'DefaultParent');
  finally
    LModule.Free;
    LMain.Free;
  end;
end;

procedure TParentsFixture.NoOwnerNoParent;
var
  LFrameStand: TFrameStand;
begin
  LFrameStand := TFrameStand.Create(nil);
  try
    Assert.WillRaiseWithMessageRegex(
      procedure begin LFrameStand.New<TFrame> end, ESubjectStandError,
      'no parent for the stand.*owner: none');
  finally
    LFrameStand.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTeardownFixture);
  TDUnitX.RegisterTestFixture(TReferencesFixture);
  TDUnitX.RegisterTestFixture(TParentsFixture);

end.
