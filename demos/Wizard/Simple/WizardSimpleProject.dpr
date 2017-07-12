program WizardSimpleProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Frames.First in 'Frames.First.pas' {Frame1: TFrame},
  Frames.Second in 'Frames.Second.pas' {Frame2: TFrame},
  Frames.Third in 'Frames.Third.pas' {Frame3: TFrame},
  Data.Main in 'Data.Main.pas' {MainData: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainData, MainData);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
