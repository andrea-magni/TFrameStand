unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FrameStand, FMX.ListBox, FMX.Objects,
  System.ImageList, FMX.ImgList;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    ShowSomethingButton: TButton;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    ComboBox1: TComboBox;
    ImageList1: TImageList;
    procedure ShowSomethingButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
 FMX.MultiResBitmap
 , Frames.Picture;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FrameStand1.CommonActions.Add('Close*',
    procedure (AInfo: TFrameInfo<TFrame>)
    begin
      AInfo.Hide();
    end
  );
end;

procedure TMainForm.ShowSomethingButtonClick(Sender: TObject);
var
  LFrameInfo: TFrameInfo<TPictureFrame>;
  LItem: TCustomBitmapItem;
  LSize: TSize;
begin
  if ImageList1.BitmapItemByName('sample1', LItem, LSize) then
  begin
    LFrameInfo := FrameStand1.New<TPictureFrame>(Layout1);

    LFrameInfo.Frame.PictureImage.Bitmap := LItem.Bitmap;
    LFrameInfo.Frame.DescriptionLabel.Text := 'A nice description of the picture here';

    LFrameInfo.Show;
  end;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
