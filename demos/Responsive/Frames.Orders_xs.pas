unit Frames.Orders_xs;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  FMX.Objects, FMX.Controls.Presentation
, FrameStand, Data.Orders
;

type
  TOrdersFrame_xs = class(TFrame)
    ListView1: TListView;
    OrdersBS: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
  private
    FDM: TOrdersData;
  protected
    [FrameInfo] FI: TFrameInfo<TOrdersFrame_xs>;
    procedure SetDM(const Value: TOrdersData); virtual;
  public
    property DM: TOrdersData read FDM write SetDM;
  end;

implementation

{$R *.fmx}

{ TOrdersFrame }

procedure TOrdersFrame_xs.SetDM(const Value: TOrdersData);
begin
  if FDM <> Value then
  begin
    FDM := Value;
    if Assigned(FDM) then
      OrdersBS.DataSet := FDM.OrdersTable;
  end;
end;

end.
