unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FrameStand,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Gestures, Frames.Image,
  System.Actions, FMX.ActnList, FMX.Layouts;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    ToolBar1: TToolBar;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    Label2: TLabel;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    InitiateBottomSheet: TAction;
    HideBottomSheet: TAction;
    ContentLayout: TLayout;
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
  private
    FBottomSheetFI: TFrameInfo<TImageFrame>;
    FBottomSheet: TLayout;
  protected
    function GetBottomSheetFI: TFrameInfo<TImageFrame>;
    function BottomSheet: TLayout;
    property BottomSheetFI: TFrameInfo<TImageFrame> read GetBottomSheetFI;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  FMX.Ani;

{$R *.fmx}

function TMainForm.BottomSheet: TLayout;
begin
  if (not Assigned(FBottomSheet)) and Assigned(FBottomSheetFI) then
    FBottomSheet := FBottomSheetFI.Stand.FindStyleResource('bottomsheet') as TLayout;
  Result := FBottomSheet;
end;

procedure TMainForm.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if (EventInfo.GestureID = igiPan) then
  begin
    // initial show of the bottom sheet
    if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
      if (not Assigned(FBottomSheetFI)) or (not BottomSheetFI.IsVisible) then
        BottomSheetFI.Show;

    //AM find a way to parametrize the 50 value (read from stand)
    BottomSheet.Height := 50 + (ContentLayout.Height - EventInfo.Location.Y);

    // final "release" animation
    if TInteractiveGestureFlag.gfEnd in EventInfo.Flags then
    begin
      if BottomSheet.Height > (ContentLayout.Height / 2) then
        TAnimator.AnimateFloat(BottomSheet, 'Height', ContentLayout.Height, 0.5)
      else
        BottomSheetFI.Hide;
    end;

    Handled := True;
  end;
end;

function TMainForm.GetBottomSheetFI: TFrameInfo<TImageFrame>;
begin
  if not Assigned(FBottomSheetFI) then
    FBottomSheetFI := FrameStand1.New<TImageFrame>(ContentLayout, 'bottomsheetstand');
  Result := FBottomSheetFI;
end;

end.
