unit Frames.MapNative;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Maps, FMX.Layouts, FMX.Controls.Presentation;

type
  TNativeMapFrame = class(TFrame)
    Button1: TButton;
    Layout1: TLayout;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TNativeMapFrame.Button1Click(Sender: TObject);
var
  LMapView: TMapView;
begin
  LMapView := TMapView.Create(Self);
  LMapView.Align := TAlignLayout.Client;
  LMapView.Visible := True;
  Self.AddObject(LMapView);
end;

end.
