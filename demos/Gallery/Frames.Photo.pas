unit Frames.Photo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.StdCtrls, FMX.Objects,
  FMX.Controls.Presentation;

type
  // a picture for the 'lightbox' stand (a gradient stands in for a photo)
  TPhotoFrame = class(TFrame)
    Photo: TRectangle;
    CaptionLabel: TLabel;
    Close_cancel: TButton; // '*_cancel': the Common Action of the main form
  end;

implementation

{$R *.fmx}

end.
