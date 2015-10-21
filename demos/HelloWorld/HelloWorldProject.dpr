program HelloWorldProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Frames.HelloWorld in 'Frames.HelloWorld.pas' {HelloWorldFrame: TFrame},
  Frames.CodeRageX in 'Frames.CodeRageX.pas' {CodeRageXFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
