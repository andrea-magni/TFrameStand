unit Tests.Injection;

interface

uses
  System.SysUtils, DUnitX.TestFramework
, FMX.Types, FMX.Forms, FMX.Controls, FMX.Layouts, FMX.Edit
, SubjectStand, FrameStand, FormStand
, Tests.Subjects
;

type
  [TestFixture]
  TInjectionFixture = class
  private
    FMain: TForm;
    FLayout: TLayout;
    FFrameStand: TFrameStand;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure MethodParameters;
    [Test] procedure MethodParameterWithoutAttributeFailsAtCreation;
    [Test] procedure Fields;
    [Test] procedure TypedParentMismatchIsReported;
    [Test] procedure TypedParent;
    [Test] procedure FormMethodParameters;
    [Test] procedure SubstitutionWithInfoTypedOnTheDerivedFrame;
    [Test] procedure SubstitutionWithInfoTypedOnTheBaseFrame;
  end;

implementation

{ TInjectionFixture }

procedure TInjectionFixture.Setup;
begin
  FMain := TForm.CreateNew(nil);
  FLayout := TLayout.Create(FMain);
  FLayout.Parent := FMain;
  FFrameStand := TFrameStand.Create(FMain);
end;

procedure TInjectionFixture.TearDown;
begin
  FreeAndNil(FMain);
end;

procedure TInjectionFixture.MethodParameters;
var
  LInfo: TFrameInfo<TParamsFrame>;
begin
  LInfo := FFrameStand.New<TParamsFrame>(FLayout);
  LInfo.Show;
  Assert.AreEqual(LInfo.ClassName, LInfo.Frame.GotInfo, '[FrameInfo]');
  Assert.AreEqual('TFrameStand', LInfo.Frame.GotStand, '[FrameStand]');
  Assert.AreEqual(LInfo.ClassName, LInfo.Frame.GotSubjectInfo, '[SubjectInfo]');
  Assert.AreEqual('TLayout', LInfo.Frame.GotParent, '[Parent]');
  Assert.AreEqual('TLayout', LInfo.Frame.GotContainer, '[Container]');
  Assert.AreEqual('TLayout', LInfo.Frame.GotStandControl, '[Stand]');
end;

procedure TInjectionFixture.MethodParameterWithoutAttributeFailsAtCreation;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin FFrameStand.New<TNoAttributeFrame>(FLayout) end, ESubjectStandError,
    'cannot inject parameter AParent');
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TInjectionFixture.Fields;
var
  LInfo: TFrameInfo<TFieldsFrame>;
begin
  LInfo := FFrameStand.New<TFieldsFrame>(FLayout);
  Assert.AreEqual(LInfo.ClassName, ClassNameOf(LInfo.Frame.FI), '[FrameInfo]');
  Assert.AreEqual('TFrameStand', ClassNameOf(LInfo.Frame.FS), '[FrameStand]');
  Assert.AreEqual(LInfo.ClassName, ClassNameOf(LInfo.Frame.SI), '[SubjectInfo]');
  Assert.AreEqual('TLayout', ClassNameOf(LInfo.Frame.P), '[Parent]');
  Assert.AreEqual('TLayout', ClassNameOf(LInfo.Frame.C), '[Container]');
  Assert.AreEqual('TLayout', ClassNameOf(LInfo.Frame.C2), '[Context]');
  Assert.AreEqual('TLayout', ClassNameOf(LInfo.Frame.ST), '[Stand]');
end;

procedure TInjectionFixture.TypedParentMismatchIsReported;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin FFrameStand.New<TEditFrame>(FLayout) end, ESubjectStandError,
    'cannot inject \[Parent\] into field Edit: the value is a TLayout, the declared type is TEdit');
end;

procedure TInjectionFixture.TypedParent;
var
  LEdit: TEdit;
begin
  LEdit := TEdit.Create(FMain);
  LEdit.Parent := FMain;
  Assert.AreEqual('TEdit', ClassNameOf(FFrameStand.New<TEditFrame>(LEdit).Frame.Edit));
end;

procedure TInjectionFixture.FormMethodParameters;
var
  LFormStand: TFormStand;
  LInfo: TFormInfo<TParamsForm>;
begin
  LFormStand := TFormStand.Create(FMain);
  LInfo := LFormStand.New<TParamsForm>(FLayout);
  LInfo.Show;
  Assert.AreEqual(LInfo.ClassName, LInfo.Form.GotInfo, '[FormInfo]');
  Assert.AreEqual('TFormStand', LInfo.Form.GotStand, '[FormStand]');
end;

procedure TInjectionFixture.SubstitutionWithInfoTypedOnTheDerivedFrame;
begin
  FFrameStand.Responsive.Define(TBaseFrame, TDerivedFrame, 'xs');
  Assert.WillRaiseWithMessageRegex(
    procedure begin FFrameStand.New<TBaseFrame>(FLayout) end, ESubjectStandError,
    'declare it as TFrameInfo<.*TBaseFrame> or TSubjectInfo');
end;

procedure TInjectionFixture.SubstitutionWithInfoTypedOnTheBaseFrame;
var
  LInfo: TFrameInfo<TBaseFrame>;
begin
  FFrameStand.Responsive.Define(TBaseFrame, TDerived2Frame, 'xs');
  LInfo := FFrameStand.New<TBaseFrame>(FLayout);
  Assert.AreEqual('TDerived2Frame', LInfo.Frame.ClassName);
  Assert.AreEqual(LInfo.ClassName, ClassNameOf(TDerived2Frame(LInfo.Frame).FI));
  Assert.AreEqual(LInfo.ClassName, ClassNameOf(TDerived2Frame(LInfo.Frame).SI));
end;

initialization
  TDUnitX.RegisterTestFixture(TInjectionFixture);

end.
