unit DeviceAndPlatformInfo;

interface

uses
  Classes, SysUtils, Types, System.Devices
, FMX.Types, FMX.Objects, FMX.Forms, FMX.Controls
, FMX.Platform, FMX.BehaviorManager
;

type
  TDeviceAndPlatformInfo = record
    &Platform: TOSPlatform;
    DisplayMetrics: TDeviceDisplayMetrics;
    DeviceClass: TDeviceInfo.TDeviceClass;
    DeviceName: string;

    function ToString: string;

    // device class
    function IsPhone: Boolean;
    function IsTablet: Boolean;
    function IsDesktop: Boolean;

    // platforms
    function IsAndroid: Boolean;
    function IsWindows: Boolean;
    function IsiOS: Boolean;
    function IsOSX: Boolean;

    class function Retrieve(const AForm: TForm = nil): TDeviceAndPlatformInfo; static;
  end;

implementation

uses
  Rtti
;

type
  TSizeHelper = record helper for TSize
    function ToString: string;
  end;

{ TDeviceAndPlatformInfo }

function TDeviceAndPlatformInfo.IsAndroid: Boolean;
begin
  Result := Self.Platform = TOSPlatform.Android;
end;

function TDeviceAndPlatformInfo.IsDesktop: Boolean;
begin
  Result := Self.DeviceClass = TDeviceInfo.TDeviceClass.Desktop;
end;

function TDeviceAndPlatformInfo.IsiOS: Boolean;
begin
  Result := Self.Platform = TOSPlatform.iOS;
end;

function TDeviceAndPlatformInfo.IsOSX: Boolean;
begin
  Result := Self.Platform = TOSPlatform.OSX;
end;

function TDeviceAndPlatformInfo.IsPhone: Boolean;
begin
  Result := Self.DeviceClass = TDeviceInfo.TDeviceClass.Phone;
end;

function TDeviceAndPlatformInfo.IsTablet: Boolean;
begin
  Result := Self.DeviceClass = TDeviceInfo.TDeviceClass.Tablet;
end;

function TDeviceAndPlatformInfo.IsWindows: Boolean;
begin
  Result := Self.Platform = TOSPlatform.Windows;
end;

class function TDeviceAndPlatformInfo.Retrieve(
  const AForm: TForm): TDeviceAndPlatformInfo;
var
  LDeviceInfo: IDeviceBehavior;
  LContext: TForm;
  LDeviceName: string;
begin
  LContext := AForm;
  if not Assigned(LContext) and Assigned(Application.MainForm) then
    LContext := Application.MainForm as TForm;
  if TBehaviorServices.Current.SupportsBehaviorService(IDeviceBehavior, LDeviceInfo, LContext) then
  begin
    Result.Platform := LDeviceInfo.GetOSPlatform(LContext);
    Result.DisplayMetrics := LDeviceInfo.GetDisplayMetrics(LContext);
    Result.DeviceClass := LDeviceInfo.GetDeviceClass(LContext);

    LDeviceName := '';
    LDeviceInfo.GetName(LContext, LDeviceName);
    Result.DeviceName := LDeviceName;
  end;
end;

function TDeviceAndPlatformInfo.ToString: string;
begin
  Result := string.join(' - ', [
    TRttiEnumerationType.GetName<TOSPlatform>(Platform)
  , TRttiEnumerationType.GetName<TDeviceInfo.TDeviceClass>(DeviceClass)
  , DeviceName
  ])
  + sLineBreak
  + string.join(' - ', [
    'Screen Phys: ' + DisplayMetrics.PhysicalScreenSize.ToString
  , 'Log: ' + DisplayMetrics.LogicalScreenSize.ToString
  , 'Aspect: ' + DisplayMetrics.AspectRatio.ToString(TFloatFormat.ffFixed, 15, 3)
  , 'ppi: ' + DisplayMetrics.PixelsPerInch.ToString
  , 'Scale: ' + DisplayMetrics.ScreenScale.ToString(TFloatFormat.ffFixed, 15, 3)
  , 'FontScale: ' + DisplayMetrics.FontScale.ToString(TFloatFormat.ffFixed, 15, 3)
  ]);
end;


{ TSizeHelper }

function TSizeHelper.ToString: string;
begin
  Result := Format('(%d, %d)', [cx, cy]);
end;

end.
