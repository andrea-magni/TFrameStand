unit ComponentRegistration;

interface

uses
  Classes, SysUtils
;

procedure Register;

implementation

// FRAMESTANDSPLASH48PNG and FRAMESTANDSPLASH24BMP (media\FrameStandSplash*) are RcItem
// resources of the design-time package (dclFrameStandPackage.dres)

uses
  Winapi.Windows, Vcl.Graphics, ToolsAPI
{$IF CompilerVersion >= 35} // Delphi 11 Alexandria
, Vcl.Imaging.pngimage
{$ENDIF}
, FrameStand, FormStand;

const
  // keep in sync with LibraryVersion in setup\Setup.iss and with version.txt
  TFrameStandVersion = '2.2';
  RsAboutTitle = 'TFrameStand';
  RsAboutDescription = 'TFrameStand and TFormStand - https://github.com/andrea-magni/TFrameStand' + sLineBreak +
    'FireMonkey components to show frames and forms on a stand, with animations, lifecycle events and responsive layouts.' + sLineBreak +
    'Documentation: https://andrea-magni.github.io/TFrameStand/';
  RsAboutLicense = 'MIT License (Free/Opensource)';

var
  AboutBoxServices: IOTAAboutBoxServices = nil;
  AboutBoxIndex: Integer = 0;

{$IF CompilerVersion >= 35}
// Delphi 11 and later: 48x48 PNG
function CreateLogoBitmap: Vcl.Graphics.TBitmap;
var
  LPngImage: TPngImage;
  LResStream: TResourceStream;
begin
  Result := Vcl.Graphics.TBitmap.Create;
  LPngImage := TPngImage.Create;
  try
    LResStream := TResourceStream.Create(HInstance, 'FRAMESTANDSPLASH48PNG', RT_RCDATA);
    try
      LPngImage.LoadFromStream(LResStream);
    finally
      LResStream.Free;
    end;
    Result.Assign(LPngImage);
  finally
    LPngImage.Free;
  end;
end;
{$ELSE}
// Delphi 10.4: 24x24 bitmap
function CreateLogoBitmap: Vcl.Graphics.TBitmap;
begin
  Result := Vcl.Graphics.TBitmap.Create;
  Result.LoadFromResourceName(HInstance, 'FRAMESTANDSPLASH24BMP');
end;
{$ENDIF}

procedure RegisterWithSplashScreen;
var
  LBitmap: Vcl.Graphics.TBitmap;
begin
  if not Assigned(SplashScreenServices) then
    Exit;
  LBitmap := CreateLogoBitmap;
  try
    SplashScreenServices.AddPluginBitmap(RsAboutTitle + ' ' + TFrameStandVersion,
      LBitmap.Handle, False, RsAboutLicense);
  finally
    LBitmap.Free;
  end;
end;

procedure RegisterAboutBox;
var
  LBitmap: Vcl.Graphics.TBitmap;
begin
  if not Supports(BorlandIDEServices, IOTAAboutBoxServices, AboutBoxServices) then
    Exit;
  LBitmap := CreateLogoBitmap;
  try
    AboutBoxIndex := AboutBoxServices.AddPluginInfo(RsAboutTitle + ' ' + TFrameStandVersion,
      RsAboutDescription, LBitmap.Handle, False, RsAboutLicense);
  finally
    LBitmap.Free;
  end;
end;

procedure UnregisterAboutBox;
begin
  if (AboutBoxIndex <> 0) and Assigned(AboutBoxServices) then
    AboutBoxServices.RemovePluginInfo(AboutBoxIndex);
  AboutBoxIndex := 0;
  AboutBoxServices := nil;
end;

procedure Register;
begin
  RegisterWithSplashScreen;
  RegisterComponents('TFrameStand - Andrea Magni', [TFrameStand, TFormStand]);
end;

initialization
  RegisterAboutBox;

finalization
  UnregisterAboutBox;

end.
