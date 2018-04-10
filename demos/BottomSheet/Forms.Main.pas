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
    procedure FormShow(Sender: TObject);
  private
    FBottomSheetFI: TFrameInfo<TImageFrame>;
    FBottomSheet: TLayout;
    FPeek: TControl;
    FDraggingPeek: Boolean;
  protected
    function GetBottomSheetFI: TFrameInfo<TImageFrame>;
    function BottomSheet: TLayout;
    function Peek: TControl;
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
var
  LLocalPoint: TPointF;
begin
  if (EventInfo.GestureID = igiPan) then
  begin
    if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
      FDraggingPeek := Peek.LocalRect.Contains(Peek.AbsoluteToLocal(EventInfo.Location));

    if FDraggingPeek then
      BottomSheet.Height := Peek.Height + (ContentLayout.Height - EventInfo.Location.Y);

    if TInteractiveGestureFlag.gfEnd in EventInfo.Flags then
    begin
      FDraggingPeek := False;

      // final "release" animation
      if BottomSheet.Height >= (ContentLayout.Height / 2) then
        TAnimator.AnimateFloat(BottomSheet, 'Height', ContentLayout.Height, 0.3)
      else
        TAnimator.AnimateFloat(BottomSheet, 'Height', Peek.Height, 0.3)
    end;

    Handled := True;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  BottomSheetFI.Show;
end;

function TMainForm.GetBottomSheetFI: TFrameInfo<TImageFrame>;
begin
  if not Assigned(FBottomSheetFI) then
    FBottomSheetFI := FrameStand1.New<TImageFrame>(ContentLayout, 'bottomsheetstand');
  Result := FBottomSheetFI;
end;

function TMainForm.Peek: TControl;
begin
  if (not Assigned(FPeek)) and Assigned(FBottomSheetFI) then
    FPeek := FBottomSheetFI.Stand.FindStyleResource('peek') as TControl;
  Result := FPeek;
end;

end.
