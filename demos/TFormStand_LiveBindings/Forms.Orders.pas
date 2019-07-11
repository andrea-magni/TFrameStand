unit Forms.Orders;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  SubjectStand, FormStand, System.Actions, FMX.ActnList, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
//  [Align(TAlignLayout.Left), ClipChildren(True)]
  TOrdersForm = class(TForm)
    CloseButton: TButton;
    ToolBar1: TToolBar;
    OrdersListView: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    Button1: TButton;
    procedure CloseMeActionExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    [FormInfoAttribute] FI: TFormInfo<TOrdersForm>;
  public
    { Public declarations }
  end;

var
  OrdersForm: TOrdersForm;

implementation

{$R *.fmx}

uses DateUtils, Data.Local;

procedure TOrdersForm.Button1Click(Sender: TObject);
begin
  ShowMessage(LocalData.OrdersTable.RecNo.ToString);
end;

procedure TOrdersForm.CloseMeActionExecute(Sender: TObject);
begin
  FI.HideAndClose;
end;

end.
