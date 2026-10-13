unit Frames.ColorDialog;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects,
  SubjectStand, FrameStand;

type
  TColorDialogFrame = class(TFrame)
    Layout1: TLayout;
    FlowLayout1: TFlowLayout;
    Label1: TLabel;
    Button_cancel: TButton;
  private
    { Private declarations }
    FAvailableColors: TArray<TAlphaColor>;
    FAvailableColorsRect: TArray<TRectangle>;
    FChosenColor: TAlphaColor;
    procedure SetAvailableColors(const Value: TArray<TAlphaColor>);
  protected
    // injected by TFrameStand: the info of this frame, to report the result
    [FrameInfo] FInfo: TFrameInfo<TColorDialogFrame>;
    procedure DoRenderAvailableColors;
    procedure RectOnClickHandler(Sender: TObject);
  public
    { Public declarations }
    property AvailableColors: TArray<TAlphaColor> read FAvailableColors write SetAvailableColors;
    property ChosenColor: TAlphaColor read FChosenColor;
  end;

implementation

{$R *.fmx}

{ TColorDialogFrame }

procedure TColorDialogFrame.DoRenderAvailableColors;
var
  LRect: TRectangle;
  LColor: TAlphaColor;
begin
  for LRect in FAvailableColorsRect do
    LRect.Free;
  FAvailableColorsRect := nil;

  for LColor in AvailableColors do
  begin
    LRect := TRectangle.Create(FlowLayout1);
    try
      LRect.Fill.Color := LColor;
      LRect.OnClick := RectOnClickHandler;
      FlowLayout1.AddObject(LRect);
      FAvailableColorsRect := FAvailableColorsRect + [LRect];
    except
      LRect.Free;
      raise;
    end;
  end;
end;

procedure TColorDialogFrame.RectOnClickHandler(Sender: TObject);
begin
  FChosenColor := (Sender as TRectangle).Fill.Color;
  // hides the dialog, calls the result procedure of ShowModal, closes the dialog
  FInfo.ModalResult := mrOk;
end;

procedure TColorDialogFrame.SetAvailableColors(
  const Value: TArray<TAlphaColor>);
begin
  FAvailableColors := Value;
  DoRenderAvailableColors;
end;

end.
