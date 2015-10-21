unit Frames.HelloWorld;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation
  , FrameStand, FMX.Ani;

type
  THelloWorldFrame = class(TFrame)
    Label1: TLabel;
    OnShowSpin: TFloatAnimation;
  private
  public
  end;

implementation

{$R *.fmx}

end.
