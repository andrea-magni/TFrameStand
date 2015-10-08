unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Generics.Collections, FrameStand, FMX.Controls.Presentation,
  FMX.StdCtrls
  , Frames.ButtonSet, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, Data.Bind.GenData, Fmx.Bind.GenData,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.ObjectScope, FMX.Objects,
  FMX.ScrollBox, FMX.Memo, FMX.Layouts, System.ImageList, FMX.ImgList;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    StandsStyleBook: TStyleBook;
    EmployeeListView: TListView;
    ToolBar1: TToolBar;
    PrototypeBindSource1: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    Layout1: TLayout;
    Memo1: TMemo;
    Image1: TImage;
    LinkPropertyToFieldBitmap: TLinkPropertyToField;
    LinkControlToField1: TLinkControlToField;
    Button1: TButton;
    ImageList1: TImageList;
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
    FEmployeeFrameInfo: TFrameInfo<TButtonSetFrame>;
    FImageFrameInfo: TFrameInfo<TButtonSetFrame>;
    function GetEmployeeFrameInfo: TFrameInfo<TButtonSetFrame>;
    function GetImageFrameInfo: TFrameInfo<TButtonSetFrame>;
  protected
    property EmployeeFrameInfo: TFrameInfo<TButtonSetFrame> read GetEmployeeFrameInfo;
    property ImageFrameInfo: TFrameInfo<TButtonSetFrame> read GetImageFrameInfo;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses FMX.MultiResBitmap;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  EmployeeFrameInfo.Show();
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FEmployeeFrameInfo) then
  begin
    FEmployeeFrameInfo.Close;
    FEmployeeFrameInfo := nil;
  end;

  if Assigned(FImageFrameInfo) then
  begin
    FImageFrameInfo.Close;
    FImageFrameInfo := nil;
  end;
end;

function TMainForm.GetEmployeeFrameInfo: TFrameInfo<TButtonSetFrame>;
var
  LItem: TCustomBitmapItem;
  LSize: TSize;
begin
  if not Assigned(FEmployeeFrameInfo) then
  begin
    FEmployeeFrameInfo := FrameStand1.New<TButtonSetFrame>(EmployeeListView);

    FEmployeeFrameInfo.Frame.RightToLeft := False;

    FEmployeeFrameInfo.Frame.ButtonFrame1.ButtonText := 'Edit';
    if ImageList1.BitmapItemByName('edit', LItem, LSize) then
      FEmployeeFrameInfo.Frame.ButtonFrame1.ButtonImage := LItem.Bitmap;

    FEmployeeFrameInfo.Frame.ButtonFrame1.OnButtonClick :=
      procedure (Sender: TObject)
      begin
        ShowMessage('Employee Edit clicked!');
      end;

    FEmployeeFrameInfo.Frame.ButtonFrame2.ButtonText := 'Delete';
    if ImageList1.BitmapItemByName('delete', LItem, LSize) then
      FEmployeeFrameInfo.Frame.ButtonFrame2.ButtonImage := LItem.Bitmap;
    FEmployeeFrameInfo.Frame.ButtonFrame2.OnButtonClick :=
      procedure (Sender: TObject)
      begin
        ShowMessage('Employee Delete clicked!');
      end;

    FEmployeeFrameInfo.Frame.ButtonFrame3.ButtonText := 'Close';
    if ImageList1.BitmapItemByName('close', LItem, LSize) then
      FEmployeeFrameInfo.Frame.ButtonFrame3.ButtonImage := LItem.Bitmap;
    FEmployeeFrameInfo.Frame.ButtonFrame3.OnButtonClick :=
      procedure (Sender: TObject)
      begin
        FEmployeeFrameInfo.Hide();
      end;
  end;
  Result := FEmployeeFrameInfo;
end;

function TMainForm.GetImageFrameInfo: TFrameInfo<TButtonSetFrame>;
var
  LItem: TCustomBitmapItem;
  LSize: TSize;
begin
  if not Assigned(FImageFrameInfo) then
  begin
    FImageFrameInfo := FrameStand1.New<TButtonSetFrame>(Image1);

    FImageFrameInfo.Frame.RightToLeft := True;

    FImageFrameInfo.Frame.ButtonFrame1.ButtonText := 'Edit';
    if ImageList1.BitmapItemByName('edit', LItem, LSize) then
      FImageFrameInfo.Frame.ButtonFrame1.ButtonImage := LItem.Bitmap;

    FImageFrameInfo.Frame.ButtonFrame1.OnButtonClick :=
      procedure (Sender: TObject)
      begin
        ShowMessage('Image Edit clicked!');
      end;

    FImageFrameInfo.Frame.ButtonFrame2.ButtonText := 'Delete';
    if ImageList1.BitmapItemByName('delete', LItem, LSize) then
      FImageFrameInfo.Frame.ButtonFrame2.ButtonImage := LItem.Bitmap;
    FImageFrameInfo.Frame.ButtonFrame2.OnButtonClick :=
      procedure (Sender: TObject)
      begin
        ShowMessage('Image Delete clicked!');
      end;

    FImageFrameInfo.Frame.ButtonFrame3.ButtonText := 'Close';
    if ImageList1.BitmapItemByName('close', LItem, LSize) then
      FImageFrameInfo.Frame.ButtonFrame3.ButtonImage := LItem.Bitmap;
    FImageFrameInfo.Frame.ButtonFrame3.OnButtonClick :=
      procedure (Sender: TObject)
      begin
        FImageFrameInfo.Hide();
      end;
  end;
  Result := FImageFrameInfo;
end;

procedure TMainForm.Image1Click(Sender: TObject);
begin
  ImageFrameInfo.Show();
end;

end.
