// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Frames.Test.pas' rev: 30.00 (Windows)

#ifndef Frames_TestHPP
#define Frames_TestHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <System.Classes.hpp>
#include <System.Variants.hpp>
#include <FMX.Types.hpp>
#include <FMX.Graphics.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Dialogs.hpp>
#include <FMX.StdCtrls.hpp>
#include <FMX.Objects.hpp>

//-- user supplied -----------------------------------------------------------

namespace Frames
{
namespace Test
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TTestFrame;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TTestFrame : public Fmx::Forms::TFrame
{
	typedef Fmx::Forms::TFrame inherited;
	
__published:
	Fmx::Objects::TRectangle* Rectangle1;
	Fmx::Objects::TCircle* Circle1;
	Fmx::Objects::TCircle* Circle2;
public:
	/* TFrame.Create */ inline __fastcall virtual TTestFrame(System::Classes::TComponent* AOwner) : Fmx::Forms::TFrame(AOwner) { }
	
public:
	/* TControl.Destroy */ inline __fastcall virtual ~TTestFrame(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Test */
}	/* namespace Frames */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRAMES_TEST)
using namespace Frames::Test;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRAMES)
using namespace Frames;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Frames_TestHPP
