unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FrameStand;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    DoSomethingButton: TButton;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Label1: TLabel;
    procedure DoSomethingButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses Frames.Wait;

procedure TMainForm.DoSomethingButtonClick(Sender: TObject);
var
  LFrameInfo: TFrameInfo<TWaitFrame>;
begin
  LFrameInfo := FrameStand1.New<TWaitFrame>(Layout1);

  LFrameInfo.Show;

  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(5000); // simulate doing something (5s)

      TThread.Synchronize(nil,
        procedure
        begin
          LFrameInfo.Hide;
          LFrameInfo.Close;
        end
      );
    end
  ).Start;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
