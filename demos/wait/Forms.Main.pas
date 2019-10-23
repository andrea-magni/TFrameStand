unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FrameStand, SubjectStand;

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

uses Frames.Wait, System.Threading;

procedure TMainForm.DoSomethingButtonClick(Sender: TObject);
var
  LFrameInfo: TFrameInfo<TWaitFrame>;
begin
  LFrameInfo := FrameStand1.New<TWaitFrame>(Layout1);

  LFrameInfo.Show;

  TTask.Run(
    procedure
    begin
      // background task to execute
      Sleep(1000); // using Sleep to simulate some computation

      LFrameInfo.Frame.UpdateMessageText('Phase 1...');
      Sleep(2000);

      LFrameInfo.Frame.UpdateMessageText('Phase 2...');
      Sleep(3000);


      // On background task completion, hide the wait frame
      TThread.Synchronize(nil,
        procedure
        begin
          LFrameInfo.Hide;
          LFrameInfo.Close;
        end
      );
    end
  );
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
