unit Tests.CommonActions;

interface

uses
  System.SysUtils, DUnitX.TestFramework
, FMX.Types, FMX.Forms, FMX.Controls
, SubjectStand, FrameStand
, Tests.Subjects
;

type
  [TestFixture]
  TCommonActionsFixture = class
  private
    FMain: TForm;
    FFrameStand: TFrameStand;
    FLog: string;
    procedure ClickClose(const AInfo: TFrameInfo<TButtonFrame>);
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure KeysInRegistrationOrder;
    [Test] procedure ActionsRunInRegistrationOrder;
    [Test] procedure AddingAPatternAgainReplacesIt;
    [Test] procedure ClosingActionStopsTheFollowingOnes;
  end;

implementation

{ TCommonActionsFixture }

procedure TCommonActionsFixture.Setup;
begin
  FLog := '';
  FMain := TForm.CreateNew(nil);
  FFrameStand := TFrameStand.Create(FMain);
end;

procedure TCommonActionsFixture.TearDown;
begin
  FreeAndNil(FMain);
end;

procedure TCommonActionsFixture.ClickClose(const AInfo: TFrameInfo<TButtonFrame>);
var
  LButton: TControl;
begin
  // what FMX does on a click (TControl.Click is protected)
  LButton := AInfo.Frame.CloseButton;
  if Assigned(LButton.OnClick) then
    LButton.OnClick(LButton);
end;

procedure TCommonActionsFixture.KeysInRegistrationOrder;
var
  LIndex: Integer;
  LKeys: TArray<string>;
begin
  // 20 patterns: a dictionary would return them in another order
  for LIndex := 0 to 19 do
    FFrameStand.CommonActions.Add('*Button' + StringOfChar('*', LIndex), procedure (AInfo: TSubjectInfo) begin end);
  LKeys := FFrameStand.CommonActions.Keys;
  Assert.AreEqual(20, Length(LKeys));
  for LIndex := 0 to 19 do
    Assert.AreEqual('*Button' + StringOfChar('*', LIndex), LKeys[LIndex]);
end;

procedure TCommonActionsFixture.ActionsRunInRegistrationOrder;
begin
  FFrameStand.CommonActions.Add('Close*', procedure (AInfo: TSubjectInfo) begin FLog := FLog + 'A'; end);
  FFrameStand.CommonActions.Add('*Button', procedure (AInfo: TSubjectInfo) begin FLog := FLog + 'B'; end);
  FFrameStand.CommonActions.Add('C*', procedure (AInfo: TSubjectInfo) begin FLog := FLog + 'C'; end);
  ClickClose(FFrameStand.New<TButtonFrame>(FMain));
  Assert.AreEqual('ABC', FLog);
end;

procedure TCommonActionsFixture.AddingAPatternAgainReplacesIt;
begin
  FFrameStand.CommonActions.Add('Close*', procedure (AInfo: TSubjectInfo) begin FLog := FLog + 'A'; end);
  FFrameStand.CommonActions.Add('*Button', procedure (AInfo: TSubjectInfo) begin FLog := FLog + 'B'; end);
  FFrameStand.CommonActions.Add('C*', procedure (AInfo: TSubjectInfo) begin FLog := FLog + 'C'; end);
  FFrameStand.CommonActions.Add('*Button', procedure (AInfo: TSubjectInfo) begin FLog := FLog + 'b'; end);
  Assert.AreEqual(3, FFrameStand.CommonActions.Count);
  ClickClose(FFrameStand.New<TButtonFrame>(FMain));
  Assert.AreEqual('AbC', FLog, 'replaced, same position');
end;

procedure TCommonActionsFixture.ClosingActionStopsTheFollowingOnes;
begin
  FFrameStand.CommonActions.Add('Close*', procedure (AInfo: TSubjectInfo) begin FLog := FLog + 'A'; AInfo.Close; end);
  FFrameStand.CommonActions.Add('*Button', procedure (AInfo: TSubjectInfo) begin FLog := FLog + 'B'; end);
  ClickClose(FFrameStand.New<TButtonFrame>(FMain));
  Assert.AreEqual('A', FLog);
  Assert.AreEqual(0, FFrameStand.Count);
end;

initialization
  TDUnitX.RegisterTestFixture(TCommonActionsFixture);

end.
