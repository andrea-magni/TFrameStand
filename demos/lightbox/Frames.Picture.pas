unit Frames.Picture;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TPictureFrame = class(TFrame)
    PictureImage: TImage;
    BottomLayout: TLayout;
    DescriptionLabel: TLabel;
    Rectangle1: TRectangle;
  private
    function GetBitmap: TBitmap;
    function GetDescription: string;
    procedure SetBitmap(const Value: TBitmap);
    procedure SetDescription(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property Bitmap: TBitmap read GetBitmap write SetBitmap;
    property Description: string read GetDescription write SetDescription;
  end;

implementation

{$R *.fmx}

{ TPictureFrame }

function TPictureFrame.GetBitmap: TBitmap;
begin
  Result := PictureImage.Bitmap;
end;

function TPictureFrame.GetDescription: string;
begin
  Result := DescriptionLabel.Text;
end;

procedure TPictureFrame.SetBitmap(const Value: TBitmap);
begin
  PictureImage.Bitmap := Value;
end;

procedure TPictureFrame.SetDescription(const Value: string);
begin
  DescriptionLabel.Text := Value;
end;

end.
