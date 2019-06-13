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

uses Frames.Wait;

procedure TMainForm.DoSomethingButtonClick(Sender: TObject);
begin
  FrameStand1.New<TWaitFrame>(Layout1)
    .Show(
      // background task to execute
      procedure(AFrameInfo: TFrameInfo<TWaitFrame>)
      begin
        Sleep(1000); // using Sleep to simulate some computation

        AFrameInfo.Frame.UpdateMessageText('Phase 1...');
        Sleep(2000);

        AFrameInfo.Frame.UpdateMessageText('Phase 2...');
        Sleep(3000);
      end
      , // On background task completion, hide the wait frame
      procedure(AFrameInfo: TFrameInfo<TWaitFrame>)
      begin
        AFrameInfo.Hide;
        AFrameInfo.Close;
      end
    );
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
