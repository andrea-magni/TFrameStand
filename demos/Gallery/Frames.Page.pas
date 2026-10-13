unit Frames.Page;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.StdCtrls, FMX.Layouts,
  FMX.Controls.Presentation, SubjectStand, FrameStand;

type
  // a page of the navigation stack, for the 'page' stand
  TPageFrame = class(TFrame)
    TitleLabel: TLabel;
    TextLabel: TLabel;
    ButtonsLayout: TLayout;
    BackButton: TButton;
    NextButton: TButton;
    procedure BackButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
  private
    FNumber: Integer;
    procedure SetNumber(const AValue: Integer);
  protected
    [FrameStand] FStand: TFrameStand;
    [FrameInfo] FInfo: TFrameInfo<TPageFrame>;
  public
    property Number: Integer read FNumber write SetNumber;
  end;

implementation

{$R *.fmx}

procedure TPageFrame.BackButtonClick(Sender: TObject);
begin
  // the first page is the root of the stack: it is closed instead
  if not FStand.Pop then
    FInfo.HideAndClose;
end;

procedure TPageFrame.NextButtonClick(Sender: TObject);
var
  LNext: Integer;
begin
  LNext := FNumber + 1;
  FStand.Push<TPageFrame>(nil, 'page',
    procedure (AFrame: TPageFrame)
    begin
      AFrame.Number := LNext;
    end);
end;

procedure TPageFrame.SetNumber(const AValue: Integer);
begin
  FNumber := AValue;
  TitleLabel.Text := 'Page ' + AValue.ToString;
  TextLabel.Text := 'Pages slide in from the right with Push and back from the left with Pop (Back, Esc, or the Back button).';
end;

end.
