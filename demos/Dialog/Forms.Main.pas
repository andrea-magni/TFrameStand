unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FrameStand, SubjectStand, FMX.Controls.Presentation
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.ChangeColorButtonClick(Sender: TObject);
var
  LColorDialog: TFrameInfo<TColorDialogFrame>;
begin
  LColorDialog := FrameStand1.New<TColorDialogFrame>();
  LColorDialog.Frame.AvailableColors := [TAlphaColorRec.Green, TAlphaColorRec.Yellow
    , TAlphaColorRec.Red, TAlphaColorRec.Magenta, TAlphaColorRec.Blue, TAlphaColorRec.Teal
  ];

  // the result procedure runs when the dialog is dismissed (after its hide
  // animation), the dialog is closed afterwards: the frame is still there
  LColorDialog.ShowModal(
    procedure (AFrame: TColorDialogFrame; AResult: TModalResult)
    begin
      if AResult = mrOk then
      begin
        ColorAnimation1.StopValue := AFrame.ChosenColor;
        ColorAnimation1.Start;
      end;
    end
  );
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // tied to Button_cancel on the frame and to the "faded" background of the
  // stand ('background_cancel' element in StyleBook1): both cancel the dialog
  FrameStand1.CommonActions.Add('*_cancel'
  , procedure (AInfo: TSubjectInfo)
    begin
      AInfo.ModalResult := mrCancel;
    end
  );
end;

end.
