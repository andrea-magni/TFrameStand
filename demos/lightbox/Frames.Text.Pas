unit Frames.Text;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TTextFrame = class(TFrame)
    Memo1: TMemo;
  private
    function GetText: string;
    procedure SetText(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property Text: string read GetText write SetText;
  end;

implementation

{$R *.fmx}

{ TTextFrame }

function TTextFrame.GetText: string;
begin
  Result := Memo1.Text;
end;

procedure TTextFrame.SetText(const Value: string);
begin
  Memo1.Text := Value;
end;

end.
