unit Frames.ColorDialog;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects;

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
    procedure SetChosenColor(const Value: TAlphaColor);
  protected
    procedure DoRenderAvailableColors;
    procedure RectOnClickHandler(Sender: TObject);
  public
    { Public declarations }
    OnColorChosen: TProc<TAlphaColor>;
    OnCancel: TProc;

    procedure Cancel;
    property AvailableColors: TArray<TAlphaColor> read FAvailableColors write SetAvailableColors;
    property ChosenColor: TAlphaColor read FChosenColor write SetChosenColor;
  end;

implementation

{$R *.fmx}

{ TColorDialogFrame }

procedure TColorDialogFrame.Cancel;
begin
  if Assigned(OnCancel) then
    OnCancel();
end;

procedure TColorDialogFrame.DoRenderAvailableColors;
var
  LRect: TRectangle;
  LColor: TAlphaColor;
begin
  while Length(FAvailableColorsRect) > 0 do
    FAvailableColorsRect[0].Free;

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
  ChosenColor := (Sender as TRectangle).Fill.Color;
end;

procedure TColorDialogFrame.SetAvailableColors(
  const Value: TArray<TAlphaColor>);
begin
  FAvailableColors := Value;
  DoRenderAvailableColors;
end;

procedure TColorDialogFrame.SetChosenColor(const Value: TAlphaColor);
begin
  FChosenColor := Value;
  if Assigned(OnColorChosen) then
    OnColorChosen(FChosenColor);
end;

end.
