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
    procedure CloseMeActionExecute(Sender: TObject);
  private
    [FormInfoAttribute] FI: TFormInfo<TOrdersForm>;
  public
    [AfterShow]
    procedure AfterShow;
  end;

implementation

{$R *.fmx}

uses DateUtils, Data.Local, Data.DB;

procedure TOrdersForm.AfterShow;
begin
  TDelayedAction.Execute(100
  , procedure
    begin
      LocalData.OrdersTable.Resync([rmExact]);
    end
  );
end;

procedure TOrdersForm.CloseMeActionExecute(Sender: TObject);
begin
  FI.HideAndClose;
end;

end.
