unit Frames.CodeRageX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects
  , FrameStand, SubjectStand;

type
  TCodeRageXFrame = class(TFrame)
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
    [FrameInfo] FInfo: TFrameInfo<TCodeRageXFrame>;
  public
    { Public declarations }
    [BeforeShow] procedure MyBeforeShow;
  end;

implementation

{$R *.fmx}

procedure TCodeRageXFrame.Image1Click(Sender: TObject);
begin
  // not Close: it would free the frame, Image1 included, while FMX is still
  // processing the click on Image1
  FInfo.HideAndClose;
end;

procedure TCodeRageXFrame.MyBeforeShow;
begin
  Image1.RotationAngle := 30;
end;

end.
