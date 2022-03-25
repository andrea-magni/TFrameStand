unit Frames.Orders_lg;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView, Frames.Orders_xs;

type
  TOrdersFrame_lg = class(TOrdersFrame_xs)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrdersFrame_lg: TOrdersFrame_lg;

implementation

{$R *.fmx}

end.
