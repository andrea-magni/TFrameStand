unit Frames.Orders_sm_Android;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Frames.Orders_sm, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView;

type
  TOrdersFrame_sm_Android = class(TOrdersFrame_sm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrdersFrame_sm_Android: TOrdersFrame_sm_Android;

implementation

{$R *.fmx}

end.
