unit Data.Main;

interface

uses
  System.SysUtils, System.Classes, System.Messaging;

type

  TFinishMessage = class(TMessage);

  TMainData = class(TDataModule)
  public
    { Public declarations }
    procedure Finish;
  end;

var
  MainData: TMainData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TMainData }

procedure TMainData.Finish;
begin
  TMessageManager.DefaultManager.SendMessage(Self, TFinishMessage.Create);
end;

end.
