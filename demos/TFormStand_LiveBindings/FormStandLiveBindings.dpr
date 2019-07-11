program FormStandLiveBindings;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Forms.Orders in 'Forms.Orders.pas' {OrdersForm},
  Data.Local in 'Data.Local.pas' {LocalData: TDataModule};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TLocalData, LocalData);
  Application.Run;
end.
