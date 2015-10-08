program ButtonSetTFrameStand;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Frames.ButtonSet in 'Frames.ButtonSet.pas' {ButtonSetFrame: TFrame},
  Frames.Button in 'Frames.Button.pas' {ButtonFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
