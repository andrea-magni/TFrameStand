unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Generics.Collections, FrameStand, FMX.Controls.Presentation, FMX.Edit,
  FMX.StdCtrls;

type
  TForm1 = class(TForm)
    FrameStand1: TFrameStand;
    StyleBook1: TStyleBook;
    Edit1: TEdit;
    ShowButton: TButton;
    procedure ShowButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses Frames.Helper;

procedure TForm1.ShowButtonClick(Sender: TObject);
begin
  FrameStand1.New<THelperFrame>(Edit1).Show();
end;

end.
