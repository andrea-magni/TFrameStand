unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FrameStand,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    ToolBar1: TToolBar;
    StepButton: TButton;
    Layout1: TLayout;
    Stands: TStyleBook;
    procedure StepButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FFrameInfo: TFrameInfo<TFrame>;
    procedure ShowNext<T: TFrame>;
    procedure ShowStep<T: TFrame>;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  System.Messaging
, Data.Main
, Frames.First, Frames.Second, Frames.Third
;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TStepMessage
  , procedure (const S: TObject; const M: TMessage)
    var
      LStepM: TStepMessage;
    begin
      LStepM := M as TStepMessage;
      case LStepM.Value of
        1: ShowStep<TFrame1>;
        2: ShowStep<TFrame2>;
        3: ShowStep<TFrame3>;
      end;
    end
  );

  TMessageManager.DefaultManager.SubscribeToMessage(TFinishMessage
  , procedure (const S: TObject; const M: TMessage)
    begin
      if Assigned(FFrameInfo) then
      begin
        FFrameInfo.Hide(0
        , procedure
          begin
            FFrameInfo.Close;
            FFrameInfo := nil;
          end
        );
      end;
    end
  );

end;

procedure TMainForm.ShowNext<T>;
var
  LStandName: string;
begin
  LStandName := 'wizard';
  case MainData.Step of
    1: LStandName := 'wizard_start';
    MainData.STEP_COUNT: LStandName := 'wizard_end';
  end;

  FFrameInfo := TFrameInfo<TFrame>( FrameStand1.New<T>(nil, LStandName) );
  FFrameInfo.Show();
end;

procedure TMainForm.ShowStep<T>;
begin
  if Assigned(FFrameInfo) then
  begin
    FFrameInfo.Hide(0
    , procedure
      begin
        FFrameInfo.Close;
        FFrameInfo := nil;

        ShowNext<T>;
      end
    );
  end
  else
    ShowNext<T>;
end;

procedure TMainForm.StepButtonClick(Sender: TObject);
begin
  MainData.Next;
end;

end.
