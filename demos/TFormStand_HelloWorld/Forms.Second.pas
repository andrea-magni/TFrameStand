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

procedure TSecondForm.Button1Click(Sender: TObject);
begin
  FI.Hide(0
  , procedure
    begin
      FI.Close;
    end
  );
end;

end.
