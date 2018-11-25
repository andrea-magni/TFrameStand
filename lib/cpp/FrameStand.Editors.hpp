// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FrameStand.Editors.pas' rev: 33.00 (Windows)

#ifndef Framestand_EditorsHPP
#define Framestand_EditorsHPP

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
#include <FrameStand.hpp>

//-- user supplied -----------------------------------------------------------

namespace Framestand
{
namespace Editors
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrameStandEditor;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TFrameStandEditor : public Designeditors::TComponentEditor
{
	typedef Designeditors::TComponentEditor inherited;
	
private:
	Framestand::TFrameStand* __fastcall CurrentObj();
	
public:
	virtual void __fastcall Edit();
public:
	/* TComponentEditor.Create */ inline __fastcall virtual TFrameStandEditor(System::Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TComponentEditor(AComponent, ADesigner) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TFrameStandEditor() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Editors */
}	/* namespace Framestand */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRAMESTAND_EDITORS)
using namespace Framestand::Editors;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRAMESTAND)
using namespace Framestand;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Framestand_EditorsHPP
