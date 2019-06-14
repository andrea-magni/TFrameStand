unit Frames.Helper;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts
  , FMX.Edit
  , SubjectStand, FrameStand;

type
  THelperFrame = class(TFrame)
    FlowLayout1: TFlowLayout;
    TenLessButton: TButton;
    FiveLessButton: TButton;
    FiveMoreButton: TButton;
    TenMoreButton: TButton;
    procedure TenLessButtonClick(Sender: TObject);
    procedure FiveLessButtonClick(Sender: TObject);
    procedure FiveMoreButtonClick(Sender: TObject);
    procedure TenMoreButtonClick(Sender: TObject);
  private
    { Private declarations }
    [Parent] FParent: TEdit;
    function GetCurrentValue: Integer;
    procedure SetCurrentValue(const Value: Integer);
  public
    { Public declarations }
    property CurrentValue: Integer read GetCurrentValue write SetCurrentValue;
  end;

implementation

{$R *.fmx}

procedure THelperFrame.FiveLessButtonClick(Sender: TObject);
begin
  CurrentValue := CurrentValue - 5;
end;

procedure THelperFrame.FiveMoreButtonClick(Sender: TObject);
begin
  CurrentValue := CurrentValue + 5;
end;

function THelperFrame.GetCurrentValue: Integer;
begin
  Result := StrToIntDef(FParent.Text, 0);
end;

procedure THelperFrame.SetCurrentValue(const Value: Integer);
begin
  FParent.Text := Value.ToString;
end;

procedure THelperFrame.TenLessButtonClick(Sender: TObject);
begin
  CurrentValue := CurrentValue - 10;
end;

procedure THelperFrame.TenMoreButtonClick(Sender: TObject);
begin
  CurrentValue := CurrentValue + 10;
end;

end.
