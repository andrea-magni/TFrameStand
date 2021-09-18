unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FrameStand,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, SubjectStand, FMX.Ani;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    ToolBar1: TToolBar;
    StepButton: TButton;
    Layout1: TLayout;
    Stands: TStyleBook;
    procedure StepButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FrameStand1BeforeStartAnimation(const ASender: TSubjectStand;
      const ASubjectInfo: TSubjectInfo; const AAnimation: TAnimation);
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
        FFrameInfo.HideAndClose(0
        , procedure
          begin
            FFrameInfo := nil;
          end
        );
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

  FFrameInfo := TFrameInfo<TFrame>( FrameStand1.New<T>(nil, LStandName) ); // this cast should not be necessary a T has a TFrame type constraint
  FFrameInfo.Show();
end;

procedure TMainForm.ShowStep<T>;
begin
  if Assigned(FFrameInfo) then
    FFrameInfo.HideAndClose(0,
      procedure
      begin
        ShowNext<T>;
      end
    )
  else
    ShowNext<T>;
end;

procedure TMainForm.FrameStand1BeforeStartAnimation(
  const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo;
  const AAnimation: TAnimation);
begin
  if AAnimation.StyleName = 'OnShow_SlideIn' then
    (AAnimation as TFloatAnimation).StartValue := ASubjectInfo.Stand.Width
  else if AAnimation.StyleName = 'OnShow_SlideOut' then
    (AAnimation as TFloatAnimation).StopValue := ASubjectInfo.Stand.Width;

end;

procedure TMainForm.StepButtonClick(Sender: TObject);
begin
  MainData.Next;
end;

end.
