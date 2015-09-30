unit FrameStand.Editors.Forms.Test;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FrameStand, FMX.ListBox, Frames.Test;

type
  TTestForm = class(TForm)
    Layout1: TLayout;
    TestBedLayout: TLayout;
    ShowButton: TButton;
    StandComboBox: TComboBox;
    Label1: TLabel;
    HideButton: TButton;
    procedure ShowButtonClick(Sender: TObject);
    procedure HideButtonClick(Sender: TObject);
  private
    FFrameStand: TFrameStand;
    FFrameInfo: TFrameInfo<TTestFrame>;
    procedure SetFrameStand(const Value: TFrameStand);
    function GetStyleBook: TStyleBook;
  protected
    procedure DoFrameStandChanged; virtual;
  public

    property FrameStand: TFrameStand read FFrameStand write SetFrameStand;
    property StyleBook: TStyleBook read GetStyleBook;
  end;

var
  TestForm: TTestForm;

implementation

{$R *.fmx}

uses FMX.Ani;

procedure TTestForm.DoFrameStandChanged;
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

function TTestForm.GetStyleBook: TStyleBook;
begin
  Result := nil;
  if Assigned(FFrameStand) then
    Result := FFrameStand.StyleBook;
end;

procedure TTestForm.HideButtonClick(Sender: TObject);
begin
  if Assigned(FFrameInfo) then
  begin
    FFrameInfo.Hide;
    FFrameInfo.Close;
    FFrameInfo := nil;
  end;
end;

procedure TTestForm.SetFrameStand(const Value: TFrameStand);
begin
  if FFrameStand <> Value then
  begin
    FFrameStand := Value;
    DoFrameStandChanged;
  end;
end;


procedure TTestForm.ShowButtonClick(Sender: TObject);
var
  LStyleName: string;
begin
  LStyleName := '';
  if Assigned(StandComboBox.Selected) then
    LStyleName := StandComboBox.Selected.Text;
  FFrameInfo := FrameStand.New<TTestFrame>(TestBedLayout, LStyleName);
  FFrameInfo.Show();
end;

end.
