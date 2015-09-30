unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FrameStand,
  FMX.StdCtrls, FMX.Layouts, FMX.Controls.Presentation, Frames.Picture,
  System.ImageList, FMX.ImgList, FMX.Objects, FMX.Ani;

type
  TMainForm = class(TForm)
    ToolBar1: TToolBar;
    RunButton: TButton;
    FrameStand1: TFrameStand;
    ImageList1: TImageList;
    StyleBook1: TStyleBook;
    FlowLayout1: TFlowLayout;
    procedure RunButtonClick(Sender: TObject);
    procedure FrameStand1BeforeStartAnimation(const ASender: TFrameStand;
      const AFrameInfo: TFrameInfo<FMX.Forms.TFrame>;
      const AAnimation: TAnimation);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses FMX.MultiResBitmap, Math;

procedure TMainForm.FrameStand1BeforeStartAnimation(const ASender: TFrameStand;
  const AFrameInfo: TFrameInfo<FMX.Forms.TFrame>; const AAnimation: TAnimation);
begin
  if AFrameInfo.Frame is TPictureFrame
     and SameText(AAnimation.StyleName, 'OnShowFadeIn')
  then
    AAnimation.Delay := Math.Log10(TPictureFrame(AFrameInfo.Frame).PositionIndex + 2) / 2;
end;

procedure TMainForm.RunButtonClick(Sender: TObject);
var
  LIndex: Integer;
  LInfo: TFrameInfo<TPictureFrame>;
  LItem: TCustomBitmapItem;
  LSize: TSize;
begin
  while FrameStand1.Count > 0 do
  begin
    LInfo := TFrameInfo<TPictureFrame>(FrameStand1.FrameInfos.ToArray[0].Value);
    LInfo.Hide;
    LInfo.Close;
  end;

  for LIndex := 0 to 8 do
  begin
    LInfo := FrameStand1.New<TPictureFrame>(FlowLayout1, 'stand1');
    LItem := ImageList1.Source.Items[LIndex].MultiResBitmap.ItemByScale(1, False, False);
    LInfo.Frame.Bitmap := LItem.Bitmap;
    LInfo.Frame.PositionIndex := LIndex;
    LInfo.Frame.DisplayName := ExtractFileName(LItem.FileName);
    LInfo.Show;
  end;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
