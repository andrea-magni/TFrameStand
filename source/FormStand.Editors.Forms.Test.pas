unit FormStand.Editors.Forms.Test;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FormStand, FMX.ListBox, Forms.Test,
  System.Actions, FMX.ActnList, FMX.Objects, FMX.Edit;

type
  TFormStandTestForm = class(TForm)
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
    FormAlignComboBox: TComboBox;
    Label4: TLabel;
    FormWidthEdit: TEdit;
    Label5: TLabel;
    FormHeightEdit: TEdit;
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
    FFormStand: TFormStand;
    FFormInfo: TFormInfo<TTestForm>;
  protected
    procedure SetFormStand(const Value: TFormStand);
    function GetStyleBook: TStyleBook;
    function GetSelectedStyleName: string;
    function GetSelectedFormAlign: TAlignLayout;
    procedure Init; virtual;
    procedure DoFormStandChanged; virtual;
    procedure SetupTestBed;
    procedure SetupTestFormAndTestBed;
    property SelectedStyleName: string read GetSelectedStyleName;
    property SelectedFormAlign: TAlignLayout read GetSelectedFormAlign;
  public
    property FormStand: TFormStand read FFormStand write SetFormStand;
    property StyleBook: TStyleBook read GetStyleBook;
  end;

implementation

{$R *.fmx}

uses FMX.Ani
  , System.Rtti
  , System.TypInfo
  ;

procedure TFormStandTestForm.DoFormStandChanged;
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

procedure TFormStandTestForm.FormCreate(Sender: TObject);
begin
  Init;
end;

procedure TFormStandTestForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FFormInfo) then
    FFormInfo.Close;
end;

function TFormStandTestForm.GetSelectedFormAlign: TAlignLayout;
begin
  Result := TAlignLayout.Client;
  if Assigned(FormAlignComboBox.Selected) then
    Result := TRttiEnumerationType.GetValue<TAlignLayout>(FormAlignComboBox.Selected.Text);
end;

function TFormStandTestForm.GetSelectedStyleName: string;
begin
  Result := '';
  if Assigned(StandComboBox.Selected) then
    Result := StandComboBox.Selected.Text;
end;

function TFormStandTestForm.GetStyleBook: TStyleBook;
begin
  Result := nil;
  if Assigned(FFormStand) then
    Result := FFormStand.StyleBook;
end;

procedure TFormStandTestForm.HideActionExecute(Sender: TObject);
begin
  SetupTestBed;

  FFormInfo.Hide(StrToInt(DelayEdit.Text),
    procedure
    begin
      FFormInfo.Close;
      FFormInfo := nil;
    end
  );
end;

procedure TFormStandTestForm.HideActionUpdate(Sender: TObject);
begin
  HideAction.Enabled := Assigned(FFormInfo) and FFormInfo.IsVisible;
end;

procedure TFormStandTestForm.Init;
var
  LAlignment: TAlignLayout;
begin
  FormAlignComboBox.Items.Clear;
  for LAlignment := Low(TAlignLayout) to High(TAlignLayout) do
    FormAlignComboBox.Items.Add( TRttiEnumerationType.GetName<TAlignLayout>(LAlignment) );

  FormAlignComboBox.ItemIndex := FormAlignComboBox.Items.IndexOf('Client');
end;

procedure TFormStandTestForm.SetFormStand(const Value: TFormStand);
begin
  if FFormStand <> Value then
  begin
    FFormStand := Value;
    DoFormStandChanged;
  end;
end;


procedure TFormStandTestForm.SetupTestBed;
begin
  TestBed.ClipChildren := TestBedClipCheckBox.IsChecked;
end;

procedure TFormStandTestForm.SetupTestFormAndTestBed;
begin
  FFormInfo.FormContainer.Align := SelectedFormAlign;
  FFormInfo.FormContainer.Width := StrToInt(FormWidthEdit.Text);
  FFormInfo.FormContainer.Height := StrToInt(FormHeightEdit.Text);

  SetupTestBed;
end;

procedure TFormStandTestForm.ShowActionExecute(Sender: TObject);
begin
  FFormInfo := FormStand.New<TTestForm>(TestBed, SelectedStyleName);
  SetupTestFormAndTestBed;
  FFormInfo.Show();
end;

procedure TFormStandTestForm.ShowActionUpdate(Sender: TObject);
begin
  ShowAction.Enabled := not (Assigned(FFormInfo) and FFormInfo.IsVisible);
end;

end.
