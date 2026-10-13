unit Frames.Choice;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.StdCtrls, FMX.Layouts,
  FMX.Controls.Presentation, SubjectStand, FrameStand;

type
  // a list of choices, for the 'bottomsheet' and 'drawer' stands
  TChoiceFrame = class(TFrame)
    TitleLabel: TLabel;
    ChoicesLayout: TLayout;
  private
    FChosen: string;
    function GetTitle: string;
    procedure SetTitle(const AValue: string);
    procedure SetChoices(const AValue: TArray<string>);
    procedure ChoiceClick(Sender: TObject);
  protected
    [FrameInfo] FInfo: TFrameInfo<TChoiceFrame>;
  public
    property Title: string read GetTitle write SetTitle;
    property Choices: TArray<string> write SetChoices;
    property Chosen: string read FChosen;
  end;

implementation

{$R *.fmx}

procedure TChoiceFrame.ChoiceClick(Sender: TObject);
begin
  FChosen := (Sender as TButton).Text;
  FInfo.ModalResult := mrOk;
end;

function TChoiceFrame.GetTitle: string;
begin
  Result := TitleLabel.Text;
end;

procedure TChoiceFrame.SetChoices(const AValue: TArray<string>);
var
  LIndex: Integer;
  LButton: TButton;
begin
  ChoicesLayout.DeleteChildren;
  for LIndex := 0 to High(AValue) do
  begin
    LButton := TButton.Create(Self);
    LButton.Parent := ChoicesLayout;
    // Align = Top orders the controls by Position.Y: in the order of AValue
    LButton.Position.Y := LIndex * 100;
    LButton.Align := TAlignLayout.Top;
    LButton.Height := 44;
    LButton.Margins.Bottom := 8;
    LButton.Text := AValue[LIndex];
    LButton.OnClick := ChoiceClick;
  end;
end;

procedure TChoiceFrame.SetTitle(const AValue: string);
begin
  TitleLabel.Text := AValue;
end;

end.
