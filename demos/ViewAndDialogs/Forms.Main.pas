unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FrameStand, FMX.Edit, FMX.ListBox, System.Actions, FMX.ActnList,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  Data.Bind.GenData, Fmx.Bind.GenData, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListView, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, FMX.Objects
  , Frames.EmployeeDetails
  , Frames.RatingDialog, SubjectStand
  ;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    Layout1: TLayout;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    ActionList1: TActionList;
    ShowAction: TAction;
    HideAction: TAction;
    ListView1: TListView;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    Rectangle1: TRectangle;
    procedure FrameStand1BeforeShow(const ASender: TFrameStand;
      const AFrameInfo: TFrameInfo<FMX.Forms.TFrame>);
    procedure ListView1ButtonClick(const Sender: TObject;
      const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const [Ref] LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    FEmployeeDetailsInfo: TFrameInfo<TEmployeeDetailsFrame>;
    FRatingDialogInfo: TFrameInfo<TRatingDialogFrame>;

    function GetEmployeeDetailsInfo: TFrameInfo<TEmployeeDetailsFrame>;
    function GetRatingDialogInfo: TFrameInfo<TRatingDialogFrame>;
  protected
    property EmployeeDetailsInfo: TFrameInfo<TEmployeeDetailsFrame> read GetEmployeeDetailsInfo;
    property RatingDialogInfo: TFrameInfo<TRatingDialogFrame> read GetRatingDialogInfo;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses DataModules.Main;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  // handle hardware back to close frames
end;

procedure TMainForm.FrameStand1BeforeShow(const ASender: TFrameStand;
  const AFrameInfo: TFrameInfo<FMX.Forms.TFrame>);
var
  LContainer_bkg: TRectangle;
begin
  if (AFrameInfo.StandStyleName = 'expand') then
  begin
    LContainer_bkg := AFrameInfo.Stand.FindStyleResource('container_bkg') as TRectangle;
    LContainer_bkg.Margins.Top := ListView1.Height / 2;
    LContainer_bkg.Margins.Bottom := ListView1.Height / 2;
  end;
end;

function TMainForm.GetEmployeeDetailsInfo: TFrameInfo<TEmployeeDetailsFrame>;
begin
  if not Assigned(FEmployeeDetailsInfo) then
    FEmployeeDetailsInfo := FrameStand1.New<TEmployeeDetailsFrame>(ListView1);
  Result := FEmployeeDetailsInfo;
end;

function TMainForm.GetRatingDialogInfo: TFrameInfo<TRatingDialogFrame>;
begin
  if not Assigned(FRatingDialogInfo) then
  begin
    FRatingDialogInfo := FrameStand1.New<TRatingDialogFrame>(ListView1);

    FRatingDialogInfo.Frame.OnRatingChanged :=
      procedure (ARating: Integer)
      begin
        ShowMessage('Rated: ' + ARating.ToString);
        FRatingDialogInfo.Hide();
      end;

    FRatingDialogInfo.Frame.OnCancel :=
      procedure
      begin
        ShowMessage('Rating cancelled!');
        FRatingDialogInfo.Hide();
      end;

  end;
  Result := FRatingDialogInfo;
end;

procedure TMainForm.ListView1ButtonClick(const Sender: TObject;
  const AItem: TListItem; const AObject: TListItemSimpleControl);
begin
  EmployeeDetailsInfo.Show();
end;

procedure TMainForm.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const [Ref] LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject is TListItemImage then
    RatingDialogInfo.Show();
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
