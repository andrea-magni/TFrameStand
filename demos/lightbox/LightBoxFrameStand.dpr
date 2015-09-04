program LightBoxFrameStand;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Frames.Dataset in 'Frames.Dataset.pas' {DatasetFrame: TFrame},
  Frames.Picture in 'Frames.Picture.pas' {PictureFrame: TFrame},
  Frames.Text in 'Frames.Text.Pas' {TextFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
