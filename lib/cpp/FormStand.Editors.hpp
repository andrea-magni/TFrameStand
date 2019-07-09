// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FormStand.Editors.pas' rev: 33.00 (Windows)

#ifndef Formstand_EditorsHPP
#define Formstand_EditorsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <DesignEditors.hpp>
#include <FormStand.hpp>

//-- user supplied -----------------------------------------------------------

namespace Formstand
{
namespace Editors
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFormStandEditor;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TFormStandEditor : public Designeditors::TComponentEditor
{
	typedef Designeditors::TComponentEditor inherited;
	
private:
	Formstand::TFormStand* __fastcall CurrentObj();
	
public:
	virtual void __fastcall Edit();
public:
	/* TComponentEditor.Create */ inline __fastcall virtual TFormStandEditor(System::Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TComponentEditor(AComponent, ADesigner) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TFormStandEditor() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Editors */
}	/* namespace Formstand */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FORMSTAND_EDITORS)
using namespace Formstand::Editors;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FORMSTAND)
using namespace Formstand;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Formstand_EditorsHPP
