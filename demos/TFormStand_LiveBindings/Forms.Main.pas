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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses Forms.Orders;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormStand1.CloseAll<TOrdersForm>;
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
var
  LFormInfo: TFormInfo<TOrdersForm>;
begin
  LFormInfo := FormStand1.GetFormInfo<TOrdersForm>(True, Rectangle1);
  if not LFormInfo.IsVisible then
    LFormInfo.Show;
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  FormStand1.HideAndCloseAll<TOrdersForm>;
end;

end.
