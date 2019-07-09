unit Forms.Second;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls
, FormStand;

type
//  [Align(TAlignLayout.Left), ClipChildren(True)]
  TSecondForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    [FormInfoAttribute] FI: TFormInfo<TSecondForm>;
  public
    { Public declarations }
  end;

var
  SecondForm: TSecondForm;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TSecondForm.Button1Click(Sender: TObject);
begin
  FI.HideAndClose;
end;

end.
