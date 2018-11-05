unit Frames.Dashboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ImgList, FMX.Layouts, System.ImageList;

type
  TDashboardFrame = class(TFrame)
    ImageList1: TImageList;
    FlowLayout1: TFlowLayout;
    OrdersGlyph: TGlyph;
    Glyph2: TGlyph;
    Glyph3: TGlyph;
    Glyph4: TGlyph;
    Glyph5: TGlyph;
    Layout1: TLayout;
    procedure Layout1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  Utils.Application;

procedure TDashboardFrame.Layout1Click(Sender: TObject);
begin
  TSwitchToMessage.Send(maOrders, Self);
end;

end.
