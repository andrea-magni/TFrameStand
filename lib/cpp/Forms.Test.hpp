// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Forms.Test.pas' rev: 33.00 (Windows)

#ifndef Forms_TestHPP
#define Forms_TestHPP

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
#include <FMX.Controls.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Graphics.hpp>
#include <FMX.Dialogs.hpp>
#include <FMX.Objects.hpp>

//-- user supplied -----------------------------------------------------------

namespace Forms
{
namespace Test
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TTestForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TTestForm : public Fmx::Forms::TForm
{
	typedef Fmx::Forms::TForm inherited;
	
__published:
	Fmx::Objects::TRectangle* Rectangle1;
	Fmx::Objects::TCircle* Circle1;
	Fmx::Objects::TCircle* Circle2;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TTestForm(System::Classes::TComponent* AOwner) : Fmx::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TTestForm(System::Classes::TComponent* AOwner, NativeInt Dummy) : Fmx::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TTestForm() { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TTestForm* TestForm;
}	/* namespace Test */
}	/* namespace Forms */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FORMS_TEST)
using namespace Forms::Test;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FORMS)
using namespace Forms;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Forms_TestHPP
