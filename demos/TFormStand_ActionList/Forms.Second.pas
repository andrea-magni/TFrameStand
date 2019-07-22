unit Forms.Second;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls
, FormStand, System.Actions, FMX.ActnList;

type
//  [Align(TAlignLayout.Left), ClipChildren(True)]
  TSecondForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    ActionList1: TActionList;
    CloseMeAction: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure CloseMeActionExecute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action2Update(Sender: TObject);
    procedure Action4Update(Sender: TObject);
    procedure Action3Update(Sender: TObject);
  private
    { Private declarations }
    [FormInfoAttribute] FI: TFormInfo<TSecondForm>;
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses DateUtils;

procedure TSecondForm.Action2Execute(Sender: TObject);
begin
  ShowMessage('Action 2');
end;

procedure TSecondForm.Action2Update(Sender: TObject);
begin
  Action2.Enabled := Odd(SecondOf(Now));
end;

procedure TSecondForm.Action3Execute(Sender: TObject);
begin
  ShowMessage('Action 3');
end;

procedure TSecondForm.Action3Update(Sender: TObject);
begin
  Action3.Enabled := Odd(MinuteOf(Now));
end;

procedure TSecondForm.Action4Execute(Sender: TObject);
begin
  ShowMessage('Action 4 ');
end;

procedure TSecondForm.Action4Update(Sender: TObject);
begin
  Action4.Enabled := not Odd(SecondOf(Now));
end;

procedure TSecondForm.CloseMeActionExecute(Sender: TObject);
begin
  FI.HideAndClose;
end;

end.
