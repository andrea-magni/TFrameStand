unit Frames.Wait;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Ani, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TWaitFrame = class(TFrame)
    MessageLabel: TLabel;
    Image1: TImage;
    OnShowRun: TFloatAnimation;
    BackgroundRectangle: TRectangle;
    ContentsLayout: TLayout;
  private
    { Private declarations }
    function GetMessageText: string;
    procedure SetMessageText(const Value: string);
  public
    { Public declarations }
    procedure UpdateMessageText(const AText: string; const ASync: Boolean = True);

    property MessageText: string read GetMessageText write SetMessageText;
  end;

implementation

{$R *.fmx}

{ TWaitFrame }

function TWaitFrame.GetMessageText: string;
begin
  Result := MessageLabel.Text;
end;

procedure TWaitFrame.SetMessageText(const Value: string);
begin
  MessageLabel.Text := Value;
end;

procedure TWaitFrame.UpdateMessageText(const AText: string;
  const ASync: Boolean);
begin
  if not ASync then
    MessageLabel.Text := AText
  else
    TThread.Synchronize(nil,
      procedure
      begin
        MessageLabel.Text := AText;
      end
    );
end;

end.
