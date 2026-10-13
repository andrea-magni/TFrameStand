unit Frames.Toast;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  // a short message, for the 'snackbar' stand
  TToastFrame = class(TFrame)
    TextLabel: TLabel;
  private
    function GetText: string;
    procedure SetText(const AValue: string);
  public
    property Text: string read GetText write SetText;
  end;

implementation

{$R *.fmx}

function TToastFrame.GetText: string;
begin
  Result := TextLabel.Text;
end;

procedure TToastFrame.SetText(const AValue: string);
begin
  TextLabel.Text := AValue;
end;

end.
