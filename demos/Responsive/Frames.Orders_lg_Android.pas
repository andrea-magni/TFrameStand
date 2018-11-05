unit Frames.Orders_lg_Android;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Frames.Orders_lg, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.Objects, FMX.ListBox, FMX.Layouts, FMX.ListView;

type
  TOrdersFrame_lg_Android = class(TOrdersFrame_lg)
    Line1: TLine;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrdersFrame_lg_Android: TOrdersFrame_lg_Android;

implementation

{$R *.fmx}

end.
