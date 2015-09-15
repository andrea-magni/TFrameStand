unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FrameStand, FMX.ListBox, FMX.Objects,
  System.ImageList, FMX.ImgList, Data.DB, Datasnap.DBClient;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    PictureButton: TButton;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    ImageList1: TImageList;
    TextButton: TButton;
    DatasetButton: TButton;
    ClientDataSet1: TClientDataSet;
    procedure PictureButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TextButtonClick(Sender: TObject);
    procedure DatasetButtonClick(Sender: TObject);
    procedure FrameStand1BeforeShow(const ASender: TFrameStand;
      const AFrameInfo: TFrameInfo<FMX.Forms.TFrame>);
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
 , Frames.Picture
 , Frames.Text
 , Frames.Dataset
 ;

procedure TMainForm.DatasetButtonClick(Sender: TObject);
var
  LFrameInfo: TFrameInfo<TDatasetFrame>;
begin
  LFrameInfo := FrameStand1.New<TDatasetFrame>();

  LFrameInfo.Frame.DataSet := ClientDataSet1;
  LFrameInfo.Frame.ItemTextField := 'LastName';
  LFrameInfo.Frame.DetailField := 'FirstName';

  LFrameInfo.Show;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FrameStand1.CommonActions.Add('Close*',
    procedure (AInfo: TFrameInfo<TFrame>)
    begin
      AInfo.Hide();
    end
  );
end;

procedure TMainForm.FrameStand1BeforeShow(const ASender: TFrameStand;
  const AFrameInfo: TFrameInfo<FMX.Forms.TFrame>);
var
  LContentBackground: TRectangle;
  LTenPercent: Single;
begin
  LTenPercent := 0;
  if AFrameInfo.Parent is TCustomForm then
    LTenPercent := TCustomForm(AFrameInfo.Parent).Width / 10
  else if AFrameInfo.Parent is TControl then
    LTenPercent := TControl(AFrameInfo.Parent).Width / 10;

  LContentBackground := AFrameInfo.Stand.FindStyleResource('content_background') as TRectangle;

  LContentBackground.Margins.Rect := TRectF.Create(LTenPercent, LTenPercent
  , LTenPercent, LTenPercent);
end;

procedure TMainForm.PictureButtonClick(Sender: TObject);
var
  LFrameInfo: TFrameInfo<TPictureFrame>;
  LItem: TCustomBitmapItem;
  LSize: TSize;
begin
  LFrameInfo := FrameStand1.New<TPictureFrame>();

  if ImageList1.BitmapItemByName('sample1', LItem, LSize) then
    LFrameInfo.Frame.Bitmap := LItem.Bitmap;
  LFrameInfo.Frame.Description := 'A nice description of the picture here';

  LFrameInfo.Show;
end;

procedure TMainForm.TextButtonClick(Sender: TObject);
var
  LFrameInfo: TFrameInfo<TTextFrame>;
begin
  LFrameInfo := FrameStand1.New<TTextFrame>();

  LFrameInfo.Frame.Text :=
    'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod '
  + 'tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, '
  + 'quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo '
  + 'consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse '
  + 'cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non '
  + 'proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  LFrameInfo.Show;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
