// CodeGear C++Builder
// Copyright (c) 1995, 2018 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DeviceAndPlatformInfo.pas' rev: 33.00 (Windows)

#ifndef DeviceandplatforminfoHPP
#define DeviceandplatforminfoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <System.Types.hpp>
#include <System.Devices.hpp>
#include <FMX.Types.hpp>
#include <FMX.Objects.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Platform.hpp>
#include <FMX.BehaviorManager.hpp>

//-- user supplied -----------------------------------------------------------

namespace Deviceandplatforminfo
{
//-- forward type declarations -----------------------------------------------
struct TDeviceAndPlatformInfo;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TDeviceAndPlatformInfo
{
public:
	Fmx::Types::TOSPlatform Platform;
	Fmx::Types::TDeviceDisplayMetrics DisplayMetrics;
	System::Devices::TDeviceInfo::TDeviceClass DeviceClass;
	System::UnicodeString DeviceName;
	System::UnicodeString __fastcall ToString();
	bool __fastcall IsPhone();
	bool __fastcall IsTablet();
	bool __fastcall IsDesktop();
	bool __fastcall IsAndroid();
	bool __fastcall IsWindows();
	bool __fastcall IsiOS();
	bool __fastcall IsOSX();
	static TDeviceAndPlatformInfo __fastcall Retrieve(Fmx::Forms::TForm* const AForm = (Fmx::Forms::TForm*)(0x0));
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Deviceandplatforminfo */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DEVICEANDPLATFORMINFO)
using namespace Deviceandplatforminfo;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DeviceandplatforminfoHPP
