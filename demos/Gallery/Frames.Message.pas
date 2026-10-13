unit Frames.Message;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.StdCtrls, FMX.Layouts,
  FMX.Controls.Presentation, SubjectStand, FrameStand;

type
  // a question with OK / Cancel, for the 'dialog' stand
  TMessageFrame = class(TFrame)
    TitleLabel: TLabel;
    TextLabel: TLabel;
    ButtonsLayout: TLayout;
    OkButton: TButton;
    Button_cancel: TButton; // '*_cancel': the Common Action of the main form
    procedure OkButtonClick(Sender: TObject);
  private
    function GetText: string;
    function GetTitle: string;
    procedure SetText(const AValue: string);
    procedure SetTitle(const AValue: string);
  protected
    [FrameInfo] FInfo: TFrameInfo<TMessageFrame>;
  public
    property Title: string read GetTitle write SetTitle;
    property Text: string read GetText write SetText;
  end;

implementation

{$R *.fmx}

procedure TMessageFrame.OkButtonClick(Sender: TObject);
begin
  FInfo.ModalResult := mrOk;
end;

function TMessageFrame.GetText: string;
begin
  Result := TextLabel.Text;
end;

function TMessageFrame.GetTitle: string;
begin
  Result := TitleLabel.Text;
end;

procedure TMessageFrame.SetText(const AValue: string);
begin
  TextLabel.Text := AValue;
end;

procedure TMessageFrame.SetTitle(const AValue: string);
begin
  TitleLabel.Text := AValue;
end;

end.
