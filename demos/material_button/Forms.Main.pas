unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FrameStand
  , Frames.MaterialButton, FMX.Edit, FMX.ListBox, System.Actions, FMX.ActnList
  ;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    Layout2: TLayout;
    ShowButton: TButton;
    HideButton: TButton;
    StyleNameComboBox: TComboBox;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ActionList1: TActionList;
    ShowAction: TAction;
    HideAction: TAction;
    procedure ShowActionExecute(Sender: TObject);
    procedure HideActionExecute(Sender: TObject);
    procedure ShowActionUpdate(Sender: TObject);
    procedure HideActionUpdate(Sender: TObject);
  private
    FMaterialButtonInfo: TFrameInfo<TMaterialButtonFrame>;
    procedure HideAndCloseMaterialButton;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.HideActionExecute(Sender: TObject);
begin
  FMaterialButtonInfo.Hide(500,
    procedure
    begin
      FMaterialButtonInfo.Close;
      FMaterialButtonInfo := nil;
    end
  );
end;

procedure TMainForm.HideActionUpdate(Sender: TObject);
begin
  HideAction.Enabled := Assigned(FMaterialButtonInfo) and (FMaterialButtonInfo.IsVisible);
end;

procedure TMainForm.HideAndCloseMaterialButton;
begin
end;

procedure TMainForm.ShowActionExecute(Sender: TObject);
begin
  FMaterialButtonInfo := FrameStand1.New<TMaterialButtonFrame>(Layout1, StyleNameComboBox.Selected.Text);

  FMaterialButtonInfo.Frame.OnClick :=
    procedure
    begin
      ShowMessage('This is my message!');
    end;

  FMaterialButtonInfo.Show();
end;

procedure TMainForm.ShowActionUpdate(Sender: TObject);
begin
  ShowAction.Enabled := not Assigned(FMaterialButtonInfo);
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
