unit FrameStand.Editors.Forms.Test;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FrameStand, FMX.ListBox, Frames.Test,
  System.Actions, FMX.ActnList, FMX.Objects, FMX.Edit;

type
  TFrameStandTestForm = class(TForm)
    TopLayout: TLayout;
    TestBedLayout: TLayout;
    StandComboBox: TComboBox;
    Label1: TLabel;
    MainActionList: TActionList;
    ShowAction: TAction;
    HideAction: TAction;
    TestBed: TRectangle;
    TopButtonLayout: TLayout;
    FlowLayout1: TFlowLayout;
    ShowButton: TButton;
    HideButton: TButton;
    DelayEdit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    FrameAlignComboBox: TComboBox;
    Label4: TLabel;
    FrameWidthEdit: TEdit;
    Label5: TLabel;
    FrameHeightEdit: TEdit;
    Label7: TLabel;
    Label6: TLabel;
    TestBedClipCheckBox: TCheckBox;
    procedure ShowActionExecute(Sender: TObject);
    procedure HideActionExecute(Sender: TObject);
    procedure HideActionUpdate(Sender: TObject);
    procedure ShowActionUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FFrameStand: TFrameStand;
    FFrameInfo: TFrameInfo<TTestFrame>;
  protected
    procedure SetFrameStand(const Value: TFrameStand);
    function GetStyleBook: TStyleBook;
    function GetSelectedStyleName: string;
    function GetSelectedFrameAlign: TAlignLayout;
    procedure Init; virtual;
    procedure DoFrameStandChanged; virtual;
    procedure SetupTestBed;
    procedure SetupTestFrameAndTestBed;
    property SelectedStyleName: string read GetSelectedStyleName;
    property SelectedFrameAlign: TAlignLayout read GetSelectedFrameAlign;
  public
    property FrameStand: TFrameStand read FFrameStand write SetFrameStand;
    property StyleBook: TStyleBook read GetStyleBook;
  end;

implementation

{$R *.fmx}

uses FMX.Ani
  , System.Rtti
  , System.TypInfo
  ;

procedure TFrameStandTestForm.DoFrameStandChanged;
var
  LChild: TObject;
begin
  StandComboBox.Items.Clear;
  if Assigned(StyleBook) and Assigned(StyleBook.Style) then
  begin
    if StyleBook.Style.ChildrenCount > 0 then
    begin
      for LChild in StyleBook.Style.Children do
      begin
        if LChild is TFmxObject then
          StandComboBox.Items.Add(TFmxObject(LChild).StyleName);
      end;
      if StandComboBox.Items.Count > 0 then
        StandComboBox.ItemIndex := 0;
    end;
  end;
end;

procedure TFrameStandTestForm.FormCreate(Sender: TObject);
begin
  Init;
end;

procedure TFrameStandTestForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FFrameInfo) then
    FFrameInfo.Close;
end;

function TFrameStandTestForm.GetSelectedFrameAlign: TAlignLayout;
begin
  Result := TAlignLayout.Client;
  if Assigned(FrameAlignComboBox.Selected) then
    Result := TRttiEnumerationType.GetValue<TAlignLayout>(FrameAlignComboBox.Selected.Text);
end;

function TFrameStandTestForm.GetSelectedStyleName: string;
begin
  Result := '';
  if Assigned(StandComboBox.Selected) then
    Result := StandComboBox.Selected.Text;
end;

function TFrameStandTestForm.GetStyleBook: TStyleBook;
begin
  Result := nil;
  if Assigned(FFrameStand) then
    Result := FFrameStand.StyleBook;
end;

procedure TFrameStandTestForm.HideActionExecute(Sender: TObject);
begin
  SetupTestBed;

  FFrameInfo.Hide(StrToInt(DelayEdit.Text),
    procedure
    begin
      FFrameInfo.Close;
      FFrameInfo := nil;
    end
  );
end;

procedure TFrameStandTestForm.HideActionUpdate(Sender: TObject);
begin
  HideAction.Enabled := Assigned(FFrameInfo) and FFrameInfo.IsVisible;
end;

procedure TFrameStandTestForm.Init;
var
  LAlignment: TAlignLayout;
begin
  FrameAlignComboBox.Items.Clear;
  for LAlignment := Low(TAlignLayout) to High(TAlignLayout) do
    FrameAlignComboBox.Items.Add( TRttiEnumerationType.GetName<TAlignLayout>(LAlignment) );

  FrameAlignComboBox.ItemIndex := FrameAlignComboBox.Items.IndexOf('Client');
end;

procedure TFrameStandTestForm.SetFrameStand(const Value: TFrameStand);
begin
  if FFrameStand <> Value then
  begin
    FFrameStand := Value;
    DoFrameStandChanged;
  end;
end;


procedure TFrameStandTestForm.SetupTestBed;
begin
  TestBed.ClipChildren := TestBedClipCheckBox.IsChecked;
end;

procedure TFrameStandTestForm.SetupTestFrameAndTestBed;
begin
  FFrameInfo.Frame.Align := SelectedFrameAlign;
  FFrameInfo.Frame.Width := StrToFloat(FrameWidthEdit.Text);
  FFrameInfo.Frame.Height := StrToFloat(FrameHeightEdit.Text);

  SetupTestBed;
end;

procedure TFrameStandTestForm.ShowActionExecute(Sender: TObject);
begin
  FFrameInfo := FrameStand.New<TTestFrame>(TestBed, SelectedStyleName);
  SetupTestFrameAndTestBed;
  FFrameInfo.Show();
end;

procedure TFrameStandTestForm.ShowActionUpdate(Sender: TObject);
begin
  ShowAction.Enabled := not (Assigned(FFrameInfo) and FFrameInfo.IsVisible);
end;

end.
