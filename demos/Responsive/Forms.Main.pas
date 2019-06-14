unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects
  , FrameStand, ResponsiveContainer
  , Frames.Dashboard
  , Frames.Orders_xs, Frames.Orders_sm, Frames.Orders_lg, SubjectStand
  {$IFDEF ANDROID}
  , Frames.Orders_sm_Android, Frames.Orders_lg_Android
  {$ENDIF}
  ;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    TopToolBar: TToolBar;
    MainContent: TLayout;
    Text1: TText;
    Layout1: TLayout;
    LineXS: TLine;
    LineSM: TLine;
    LineMD: TLine;
    LineLG: TLine;
    TextXS: TText;
    TextSM: TText;
    TextMD: TText;
    TextLG: TText;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure TextXSClick(Sender: TObject);
    procedure TextSMClick(Sender: TObject);
    procedure TextMDClick(Sender: TObject);
    procedure TextLGClick(Sender: TObject);
    procedure FrameStand1BeforeShow(const ASender: TSubjectStand;
      const ASubjectInfo: TSubjectInfo);
  private
    { Private declarations }
    FBreakpoint: TBreakpoint;
    FDashboardFI: TFrameInfo<TDashboardFrame>;
    FOrdersFI: TFrameInfo<TOrdersFrame_xs>;
    function GetDashboardFI: TFrameInfo<TDashboardFrame>;
    function GetOrdersFI: TFrameInfo<TOrdersFrame_xs>;
    property DashboardFI: TFrameInfo<TDashboardFrame> read GetDashboardFI;
    property OrdersFI: TFrameInfo<TOrdersFrame_xs> read GetOrdersFI;

    procedure RemoveHighlight(const ABreakpointName: string);
    procedure Highlight(const ABreakpointName: string);
  public
    { Public declarations }
    procedure AfterConstruction; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  Utils.Application, Data.Orders
;

{ TMainForm }

procedure TMainForm.AfterConstruction;
begin
  inherited;
  FrameStand1.Responsive.Breakpoints.Clear;
  FrameStand1.Responsive.AddBreakpoint(240, 'xs');
  FrameStand1.Responsive.AddBreakpoint(480, 'sm');
  FrameStand1.Responsive.AddBreakpoint(720, 'md');
  FrameStand1.Responsive.AddBreakpoint(1080, 'lg');

  LineXS.Width := FrameStand1.Responsive.Breakpoints.ByName('xs').MaxWidth;
  LineSM.Width := FrameStand1.Responsive.Breakpoints.ByName('sm').MaxWidth;
  LineMD.Width := FrameStand1.Responsive.Breakpoints.ByName('md').MaxWidth;
  LineLG.Width := FrameStand1.Responsive.Breakpoints.ByName('lg').MaxWidth;

  // xs, sm, md, lg
  {$IFDEF MSWINDOWS}
  FrameStand1.Responsive.Define(TOrdersFrame_xs, TOrdersFrame_sm, 'sm');
  FrameStand1.Responsive.Define(TOrdersFrame_xs, TOrdersFrame_lg, 'lg');
  {$ENDIF}

  {$IFDEF ANDROID}
  FrameStand1.Responsive.Define(TOrdersFrame_xs, TOrdersFrame_sm_Android, 'sm');
  FrameStand1.Responsive.Define(TOrdersFrame_xs, TOrdersFrame_lg_Android, 'md');
  {$ENDIF}

//  FBreakpoint := FrameStand1.Responsive.CurrentBreakpoint(MainContent.Width);

  TSwitchToMessage.Subscribe(
    procedure (const AActivity: TMainActivity; const ASender: TObject)
    begin
      case AActivity of
        maDashboard: DashboardFI.Show();
           maOrders: OrdersFI.Show();
      end;
    end
  );

  TSwitchToMessage.Send(maDashboard, Self);
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack) or (Key = vkF1) then
  begin
    TKeyMessage.Send(TKeyInfo.Create(Key, KeyChar, Shift));
    Key := 0;
    KeyChar := #0;
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
var
  LBreakpoint: TBreakpoint;
begin
  if not Assigned(Framestand1.Responsive) then
    Exit;

  LBreakpoint := Framestand1.Responsive.CurrentBreakpoint(MainContent.Width);
  if FBreakpoint.Name <> LBreakpoint.Name then
  begin
    RemoveHighlight(FBreakpoint.Name);
    FBreakpoint := LBreakpoint;
    Highlight(FBreakpoint.Name);

    // close and reopen orders
    if Assigned(FOrdersFI) then
    begin
      FOrdersFI.Close;
      FOrdersFI := nil;

      // new orders view
      TSwitchToMessage.Send(maOrders, Self);
    end;
  end;
end;

procedure TMainForm.FrameStand1BeforeShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
  Text1.Text := 'Class: ' + ASubjectInfo.Subject.ClassName;
end;

function TMainForm.GetDashboardFI: TFrameInfo<TDashboardFrame>;
begin
  if not Assigned(FDashboardFI) then
    FDashboardFI := FrameStand1.New<TDashboardFrame>(MainContent);
  Result := FDashboardFI;
end;

function TMainForm.GetOrdersFI: TFrameInfo<TOrdersFrame_xs>;
begin
  if not Assigned(FOrdersFI) then
  begin
    FOrdersFI := FrameStand1.New<TOrdersFrame_xs>(MainContent);
    FOrdersFI.Frame.DM := OrdersData;
  end;
  Result := FOrdersFI;
end;

procedure TMainForm.Highlight(const ABreakpointName: string);
var
  LLine: TLine;
  LText: TText;
begin
  LLine := FindComponent('Line'+ABreakpointName) as TLine;
  if Assigned(LLine) then
    LLine.Stroke.Thickness := 15;
  LText := FindComponent('Text'+ABreakpointName) as TText;
  if Assigned(LText) then
  begin
    LText.Font.Style := LText.Font.Style + [TFontStyle.fsBold];
    LText.TextSettings.FontColor := TAlphaColorRec.White;
  end;
end;

procedure TMainForm.RemoveHighlight(const ABreakpointName: string);
var
  LLine: TLine;
  LText: TText;
begin
  LLine := FindComponent('Line'+ABreakpointName) as TLine;
  if Assigned(LLine) then
    LLine.Stroke.Thickness := 3;
  LText := FindComponent('Text'+ABreakpointName) as TText;
  if Assigned(LText) then
  begin
    LText.Font.Style := LText.Font.Style - [TFontStyle.fsBold];
    LText.TextSettings.FontColor := TAlphaColorRec.Darkgrey;
  end;
end;

procedure TMainForm.TextLGClick(Sender: TObject);
begin
  Width := Trunc(FrameStand1.Responsive.Breakpoints.ByName('lg').MaxWidth-1);
end;

procedure TMainForm.TextMDClick(Sender: TObject);
begin
  Width := Trunc(FrameStand1.Responsive.Breakpoints.ByName('md').MaxWidth-1);
end;

procedure TMainForm.TextSMClick(Sender: TObject);
begin
  Width := Trunc(FrameStand1.Responsive.Breakpoints.ByName('sm').MaxWidth-1);
end;

procedure TMainForm.TextXSClick(Sender: TObject);
begin
  Width := Trunc(FrameStand1.Responsive.Breakpoints.ByName('xs').MaxWidth-1);
end;

end.
