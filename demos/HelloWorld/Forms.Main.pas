unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FrameStand, Frames.HelloWorld,
  Frames.CodeRageX;

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
    FFrameInfo: TFrameInfo<THelloWorldFrame>;
    FCodeRageFrameInfo: TFrameInfo<TCodeRageXFrame>;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  FFrameInfo.Hide();
  FFrameInfo.Close;
end;

procedure TMainForm.CloseCodeRageXButtonClick(Sender: TObject);
begin
  FCodeRageFrameInfo.Hide;
  FCodeRageFrameInfo.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FrameStand1.CommonActions.Add(
    'SayHello*'
    , procedure (AInfo: TFrameInfo<TFrame>)
      begin
        ShowMessage('Hello, the frame is ' + AInfo.Frame.ClassName);
      end
  );
end;

procedure TMainForm.ShowButtonClick(Sender: TObject);
begin
  FFrameInfo := FrameStand1.New<THelloWorldFrame>(Layout1, 'bluestand');

  FFrameInfo.Show();
end;

procedure TMainForm.ShowCodeRageXButtonClick(Sender: TObject);
begin
  FCodeRageFrameInfo := FrameStand1.New<TCodeRageXFrame>(Layout1, 'bluestand');

  FCodeRageFrameInfo.Show();
end;

end.
