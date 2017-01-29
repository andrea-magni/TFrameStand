unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FrameStand, FMX.Controls.Presentation
, Frames.ColorDialog, FMX.Ani, FMX.Effects
;

type
  TMainForm = class(TForm)
    ToolBar1: TToolBar;
    FrameStand1: TFrameStand;
    StyleBook1: TStyleBook;
    Rectangle1: TRectangle;
    ChangeColorButton: TButton;
    ShadowEffect1: TShadowEffect;
    ColorAnimation1: TColorAnimation;
    procedure ChangeColorButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FColorDialog: TFrameInfo<TColorDialogFrame>;
  protected
    procedure DoCancelColorDialog(Sender: TObject);
    function ColorDialog: TFrameInfo<TColorDialogFrame>;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.ChangeColorButtonClick(Sender: TObject);
begin
  ColorDialog.Show();
end;

function TMainForm.ColorDialog: TFrameInfo<TColorDialogFrame>;
begin
  // creation on demand
  if not Assigned(FColorDialog) then
  begin
    FColorDialog := FrameStand1.New<TColorDialogFrame>();

    FColorDialog.Frame.AvailableColors := [TAlphaColorRec.Green, TAlphaColorRec.Yellow
      , TAlphaColorRec.Red, TAlphaColorRec.Magenta, TAlphaColorRec.Blue, TAlphaColorRec.Teal
    ];

    FColorDialog.Frame.OnColorChosen :=
      procedure (AColor: TAlphaColor)
      begin
        // use the value here (do whatever you need)
        // Rember you can even assign a new anonymous methods to ColorDialog.Frame.OnColorChosen
//        Rectangle1.Fill.Color := AColor;
        ColorAnimation1.StopValue := AColor;
        ColorAnimation1.Start;

        FColorDialog.Hide;
      end;

    (FColorDialog.Stand.FindStyleResource('background_cancel') as TRectangle).OnClick := DoCancelColorDialog;

    FColorDialog.Frame.OnCancel :=
      procedure
      begin
        // do something when user cancel dialog?
        FColorDialog.Hide;
      end;
  end;
  Result := FColorDialog;
end;

procedure TMainForm.DoCancelColorDialog(Sender: TObject);
begin
  if Assigned(FColorDialog) and (FColorDialog.IsVisible) then
    FColorDialog.Frame.Cancel;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // this action will be tied to the rectangle implementing
  // the "faded" background of the stand (see 'background_cancel')
  // element in StyleBook1 and also tied to Button_cancel TButton
  // on the frame
  FrameStand1.CommonActions.Add('*_cancel'
  , procedure (AInfo: TFrameInfo<TFrame>)
    begin
      if (AInfo.Frame is TColorDialogFrame) then
        TColorDialogFrame(AInfo.Frame).Cancel;
    end
  );
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FColorDialog) then
  begin
    FColorDialog.Close;
    FColorDialog := nil;
  end;
end;

end.
