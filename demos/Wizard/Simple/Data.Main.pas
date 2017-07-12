unit Data.Main;

interface

uses
  System.SysUtils, System.Classes, System.Messaging;

type

  TStepMessage = TMessage<Integer>;
  TFinishMessage = class(TMessage);

  TMainData = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FStep: Integer;
    procedure SetStep(const Value: Integer);
    function GetCanNext: Boolean;
  protected
    procedure StepChanged; virtual;
  public
    { Public declarations }
    procedure Next;
    procedure Finish;
    property Step: Integer read FStep write SetStep;
    property CanNext: Boolean read GetCanNext;

    const STEP_COUNT = 3;
  end;

var
  MainData: TMainData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TMainData }

procedure TMainData.DataModuleCreate(Sender: TObject);
begin
  FStep := 0;
end;

procedure TMainData.Finish;
begin
  FStep := 0;
  TMessageManager.DefaultManager.SendMessage(Self, TFinishMessage.Create);
end;

function TMainData.GetCanNext: Boolean;
begin
  Result := Step < STEP_COUNT;
end;

procedure TMainData.Next;
begin
  if Step < STEP_COUNT then
    Step := Step + 1;
end;

procedure TMainData.SetStep(const Value: Integer);
begin
  if FStep <> Value then
  begin
    FStep := Value;
    StepChanged;
  end;
end;

procedure TMainData.StepChanged;
begin
  TMessageManager.DefaultManager.SendMessage(Self, TStepMessage.Create(FStep));
end;

end.
