unit Frames.ButtonSet;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Frames.Button
  , FrameStand;

type
  TButtonSetFrame = class(TFrame)
    ButtonFrame1: TButtonFrame;
    ButtonFrame2: TButtonFrame;
    ButtonFrame3: TButtonFrame;
  private
    FRightToLeft: Boolean;
    procedure SetRightToLeft(const Value: Boolean);
  public
    [BeforeShow]
    procedure BeforeShow([Parent] AParentObj: TFmxObject);

    property RightToLeft: Boolean read FRightToLeft write SetRightToLeft;
  end;

implementation

{$R *.fmx}

uses Math;

{ TButtonSetFrame }

procedure TButtonSetFrame.BeforeShow(AParentObj: TFmxObject);
var
  LMarginValue, LButtonHeight: Single;

  procedure SetupButtonFrame(AFrame: TButtonFrame);
  begin
    if RightToLeft then
    begin
      AFrame.Margins.Left := 0;
      AFrame.Margins.Right := LMarginValue;
      AFrame.OnShowSlideIn.PropertyName := 'Margins.Right';
    end
    else
    begin
      AFrame.Margins.Left := LMarginValue;
      AFrame.Margins.Right := 0;
      AFrame.OnShowSlideIn.PropertyName := 'Margins.Left';
    end;
    AFrame.Height := LButtonHeight;
  end;

begin
  LMarginValue := -400;
  LButtonHeight := Height / 3;

  if AParentObj is TControl then
  begin
    LMarginValue := -TControl(AParentObj).Width;
    LButtonHeight := TControl(AParentObj).Height / 3;
  end
  else if AParentObj is TCustomForm then
  begin
    LMarginValue := -TCustomForm(AParentObj).Width;
    LButtonHeight := TCustomForm(AParentObj).Height / 3;
  end;

  LButtonHeight := Min(LButtonHeight, 64);

  SetupButtonFrame(ButtonFrame1);
  SetupButtonFrame(ButtonFrame2);
  SetupButtonFrame(ButtonFrame3);
end;

procedure TButtonSetFrame.SetRightToLeft(const Value: Boolean);
begin
  FRightToLeft := Value;

  ButtonFrame1.RightToLeft := FRightToLeft;
  ButtonFrame2.RightToLeft := FRightToLeft;
  ButtonFrame3.RightToLeft := FRightToLeft;
end;

end.
