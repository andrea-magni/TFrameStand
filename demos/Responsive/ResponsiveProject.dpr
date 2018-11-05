program ResponsiveProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Frames.Dashboard in 'Frames.Dashboard.pas' {DashboardFrame: TFrame},
  Frames.Orders_xs in 'Frames.Orders_xs.pas' {OrdersFrame_xs: TFrame},
  Data.Orders in 'Data.Orders.pas' {OrdersData: TDataModule},
  Utils.Application in 'Utils.Application.pas',
  Frames.Orders_sm in 'Frames.Orders_sm.pas' {OrdersFrame_sm: TFrame},
  Frames.Orders_lg in 'Frames.Orders_lg.pas' {OrdersFrame_lg: TFrame},
  Frames.Orders_sm_Android in 'Frames.Orders_sm_Android.pas' {OrdersFrame_sm_Android: TFrame},
  Frames.Orders_lg_Android in 'Frames.Orders_lg_Android.pas' {OrdersFrame_lg_Android: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOrdersData, OrdersData);
  Application.Run;
end.
