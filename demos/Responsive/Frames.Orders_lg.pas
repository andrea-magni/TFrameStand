unit Frames.Orders_lg;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Frames.Orders_sm, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView, FMX.ListBox, FMX.Layouts, FMX.Objects,
  Data.Orders;

type
  TOrdersFrame_lg = class(TOrdersFrame_sm)
    RightPanel: TLayout;
    ListBox1: TListBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxGroupHeader2: TListBoxGroupHeader;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    TermsText: TText;
    MethodText: TText;
    TaxRateText: TText;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldText3: TLinkPropertyToField;
    EmpFullNameText: TText;
    EmpPhoneExtText: TText;
    EmpSalaryText: TText;
    EmployeeBS: TBindSourceDB;
    LinkPropertyToFieldText4: TLinkPropertyToField;
    LinkPropertyToFieldText5: TLinkPropertyToField;
    LinkPropertyToFieldText6: TLinkPropertyToField;
    CustomersBS: TBindSourceDB;
    ListBoxGroupHeader3: TListBoxGroupHeader;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    CustCompanyText: TText;
    CustAddress: TText;
    CustPhone: TText;
    LinkPropertyToFieldText7: TLinkPropertyToField;
    LinkPropertyToFieldText8: TLinkPropertyToField;
    LinkPropertyToFieldText9: TLinkPropertyToField;
  private
  protected
    procedure SetDM(const Value: TOrdersData); override;
  public
  end;

implementation

{$R *.fmx}

{ TOrdersFrame_lg }

procedure TOrdersFrame_lg.SetDM(const Value: TOrdersData);
begin
  inherited;
  if Assigned(DM) then
  begin
    EmployeeBS.DataSet := DM.EmployeesTable;
    CustomersBS.DataSet := DM.CustomersTable;
  end
  else
  begin
    EmployeeBS.DataSet := nil;
    CustomersBS.DataSet := nil;
  end;
end;

end.
