unit Frames.Picture;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TPictureFrame = class(TFrame)
    Image1: TImage;
    DisplayNameLabel: TLabel;
  private
    FPositionIndex: Integer;
    FDisplayName: string;
    function GetBitmap: TBitmap;
    procedure SetBitmap(const Value: TBitmap);
    procedure SetDisplayName(const Value: string);
  public
    property Bitmap: TBitmap read GetBitmap write SetBitmap;
    property PositionIndex: Integer read FPositionIndex write FPositionIndex;
    property DisplayName: string read FDisplayName write SetDisplayName;
  end;

implementation

{$R *.fmx}

{ TPictureFrame }

function TPictureFrame.GetBitmap: TBitmap;
begin
  Result := Image1.Bitmap;
end;

procedure TPictureFrame.SetBitmap(const Value: TBitmap);
begin
  Image1.Bitmap.Assign(Value);
end;

procedure TPictureFrame.SetDisplayName(const Value: string);
begin
  FDisplayName := Value;
  DisplayNameLabel.Text := FDisplayName;
end;

end.
