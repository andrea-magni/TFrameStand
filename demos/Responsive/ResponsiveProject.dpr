program ResponsiveProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Frames.Dashboard in 'Frames.Dashboard.pas' {DashboardFrame: TFrame},
  Frames.Orders_xs in 'Frames.Orders_xs.pas' {OrdersFrame_xs: TFrame},
  Data.Orders in 'Data.Orders.pas' {OrdersData: TDataModule},
  Utils.Application in 'Utils.Application.pas',
  Frames.Orders_lg in 'Frames.Orders_lg.pas' {OrdersFrame_lg: TFrame},
  Frames.Orders_sm in 'Frames.Orders_sm.pas' {OrdersFrame_sm: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOrdersData, OrdersData);
  Application.CreateForm(TOrdersFrame_sm, OrdersFrame_sm);
  Application.Run;
end.
