unit Frames.MaterialButton;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Effects;

type
  TMaterialButtonFrame = class(TFrame)
    Circle1: TCircle;
    ShadowEffect1: TShadowEffect;
    Image1: TImage;
    procedure Circle1Click(Sender: TObject);
  private
    FOnClick: TProc;
  public

    property OnClick: TProc read FOnClick write FOnClick;
  end;

implementation

{$R *.fmx}

procedure TMaterialButtonFrame.Circle1Click(Sender: TObject);
begin
  if Assigned(FOnClick) then
    FOnClick();
end;

end.
