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
    BackButton: TButton;
    Layout1: TLayout;
    Stands: TStyleBook;
    procedure StepButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FrameStand1BeforeStartAnimation(const ASender: TSubjectStand;
      const ASubjectInfo: TSubjectInfo; const AAnimation: TAnimation);
  private
    { Private declarations }
    procedure FrameStand1AfterShow(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo);
    procedure UpdateButtons;
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
  FrameStand1.OnAfterShow := FrameStand1AfterShow; // also after Back (key or button)

  TMessageManager.DefaultManager.SubscribeToMessage(TFinishMessage
  , procedure (const S: TObject; const M: TMessage)
    begin
      // all the pages go, and the navigation stack with them
      FrameStand1.HideAndCloseAll;
      UpdateButtons;
    end
  );
  UpdateButtons;
end;

procedure TMainForm.StepButtonClick(Sender: TObject);
begin
  // the page below is hidden and kept (PushMode = pmHide): Back shows it
  // again, with what was typed in it
  case FrameStand1.StackCount of
    0: FrameStand1.Push<TFrame1>(nil, 'wizard_start');
    1: FrameStand1.Push<TFrame2>(nil, 'wizard');
    2: FrameStand1.Push<TFrame3>(nil, 'wizard_end');
  end;
end;

procedure TMainForm.BackButtonClick(Sender: TObject);
begin
  FrameStand1.Pop; // the Back key of Android and Esc do the same (CatchBackKey)
end;

procedure TMainForm.FrameStand1AfterShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
  UpdateButtons;
end;

procedure TMainForm.UpdateButtons;
begin
  BackButton.Enabled := FrameStand1.StackCount > 1;
  StepButton.Enabled := FrameStand1.StackCount < 3;
  if FrameStand1.StackCount = 0 then
    StepButton.Text := 'Start'
  else
    StepButton.Text := 'Next';
end;

procedure TMainForm.FrameStand1BeforeStartAnimation(
  const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo;
  const AAnimation: TAnimation);
var
  LAnimation: TFloatAnimation;
  LBack: Boolean;
begin
  if not (AAnimation is TFloatAnimation) then
    Exit;
  LAnimation := TFloatAnimation(AAnimation);
  // the property animated by the stand, going forward
  if LAnimation.TagString = '' then
    LAnimation.TagString := LAnimation.PropertyName;
  LBack := ASender.StackOperation = soPop;

  if AAnimation.StyleName = 'OnShow_SlideIn' then
  begin
    // forward: in from the right; back (Pop): in from the left
    if LBack then
      LAnimation.PropertyName := 'Margins.Right'
    else
      LAnimation.PropertyName := LAnimation.TagString;
    LAnimation.StartValue := ASubjectInfo.Stand.Width;
  end
  else if AAnimation.StyleName = 'OnHide_SlideOut' then
  begin
    // forward: out to the left; back (Pop): out to the right
    if LBack then
      LAnimation.PropertyName := 'Margins.Left'
    else
      LAnimation.PropertyName := LAnimation.TagString;
    LAnimation.StopValue := ASubjectInfo.Stand.Width;
  end;
end;

end.
