unit Frames.Wait;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Ani, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TWaitFrame = class(TFrame)
    MessageLabel: TLabel;
    Image1: TImage;
    OnShowRun: TFloatAnimation;
    BackgroundRectangle: TRectangle;
    ContentsLayout: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
