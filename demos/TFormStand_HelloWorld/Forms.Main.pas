unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FormStand, SubjectStand,
  FMX.Objects;

type
  TMainForm = class(TForm)
    OpenButton: TButton;
    StyleBook1: TStyleBook;
    FormStand1: TFormStand;
    CloseButton: TButton;
    Rectangle1: TRectangle;
    procedure OpenButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses Forms.Second;

procedure TMainForm.OpenButtonClick(Sender: TObject);
var
  LFormInfo: TFormInfo<TSecondForm>;
begin
  LFormInfo := FormStand1.New<TSecondForm>(Rectangle1);

  LFormInfo.Show;
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
var
  LInfo: TFormInfo<TForm>;
begin
  if FormStand1.Count > 0 then
  begin
    LInfo := FormStand1.FormInfo(FormStand1.VisibleForms[0]);
    LInfo.Hide(0
    , procedure
      begin
        LInfo.Close;
      end
    );
  end;
end;

end.
