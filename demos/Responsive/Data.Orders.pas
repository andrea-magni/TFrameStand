unit Data.Orders;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TOrdersData = class(TDataModule)
    OrdersTable: TFDMemTable;
    EmployeesTable: TFDMemTable;
    OrdersDS: TDataSource;
    CustomersTable: TFDMemTable;
  private
    { Private declarations }
  public
    { Public declarations }
    function ShipToDescription(): string;
  end;

var
  OrdersData: TOrdersData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TOrdersData }

function TOrdersData.ShipToDescription: string;
begin
  Result := 'Via: ' + OrdersTable.FieldByName('ShipVIA').AsString;

  if (OrdersTable.FieldByName('ShipToContact').AsString.Trim <> '')
    or (OrdersTable.FieldByName('ShipToAddr1').AsString.Trim <> '')
    or (OrdersTable.FieldByName('ShipToAddr2').AsString.Trim <> '')
  then
    Result := Result + sLineBreak + string.Join(sLineBreak
      , [  OrdersTable.FieldByName('ShipToContact').AsString
        , OrdersTable.FieldByName('ShipToAddr1').AsString
        , OrdersTable.FieldByName('ShipToAddr2').AsString
        ]).Trim;
end;

end.
