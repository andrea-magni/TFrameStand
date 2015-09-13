program ViewAndDialogsFrameStand;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  DataModules.Main in 'DataModules.Main.pas' {MainDataModule: TDataModule},
  Frames.EmployeeDetails in 'Frames.EmployeeDetails.pas' {EmployeeDetailsFrame: TFrame},
  Frames.RatingDialog in 'Frames.RatingDialog.pas' {RatingDialogFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.Run;
end.
