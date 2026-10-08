unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FrameStand, Frames.HelloWorld,
  Frames.CodeRageX, SubjectStand;

type
  TMainForm = class(TForm)
    ToolBar1: TToolBar;
    Layout1: TLayout;
    ShowButton: TButton;
    FrameStand1: TFrameStand;
    CloseButton: TButton;
    StandsStyleBook: TStyleBook;
    ShowCodeRageXButton: TButton;
    CloseCodeRageXButton: TButton;
    procedure ShowButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ShowCodeRageXButtonClick(Sender: TObject);
    procedure CloseCodeRageXButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  // no reference to keep: the frames can be shown many times, and the
  // CodeRage X frame closes itself
  FrameStand1.HideAndCloseAll([THelloWorldFrame]);
end;

procedure TMainForm.CloseCodeRageXButtonClick(Sender: TObject);
begin
  FrameStand1.HideAndCloseAll([TCodeRageXFrame]);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FrameStand1.CommonActions.Add(
    'SayHello*'
    , procedure (AInfo: TSubjectInfo)
      begin
        ShowMessage('Hello, the frame is ' + AInfo.Subject.ClassName);
      end
  );
end;

procedure TMainForm.ShowButtonClick(Sender: TObject);
begin
  FrameStand1.NewAndShow<THelloWorldFrame>(Layout1, 'bluestand');
end;

procedure TMainForm.ShowCodeRageXButtonClick(Sender: TObject);
begin
  FrameStand1.NewAndShow<TCodeRageXFrame>(Layout1, 'bluestand');
end;

end.
