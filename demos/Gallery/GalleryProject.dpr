program GalleryProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Frames.Message in 'Frames.Message.pas' {MessageFrame: TFrame},
  Frames.Photo in 'Frames.Photo.pas' {PhotoFrame: TFrame},
  Frames.Choice in 'Frames.Choice.pas' {ChoiceFrame: TFrame},
  Frames.Toast in 'Frames.Toast.pas' {ToastFrame: TFrame},
  Frames.Page in 'Frames.Page.pas' {PageFrame: TFrame};

{$R *.res}
// the stand gallery (stands\Stands.Light.style, Stands.Dark.style), embedded
// as RCDATA resources STANDS_LIGHT and STANDS_DARK (RcItem in the .dproj)
{$R *.dres}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
