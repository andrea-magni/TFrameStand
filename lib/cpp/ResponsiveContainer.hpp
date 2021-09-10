// CodeGear C++Builder
// Copyright (c) 1995, 2021 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ResponsiveContainer.pas' rev: 35.00 (Windows)

#ifndef ResponsivecontainerHPP
#define ResponsivecontainerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <FMX.Types.hpp>
#include <FMX.Forms.hpp>
#include <System.Generics.Collections.hpp>
#include <System.Generics.Defaults.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Responsivecontainer
{
//-- forward type declarations -----------------------------------------------
struct TBreakpoint;
class DELPHICLASS TBreakpoints;
struct TResponsiveDefinition;
struct TResponsiveOption;
class DELPHICLASS TResponsiveContainer;
//-- type declarations -------------------------------------------------------
typedef Fmx::Types::TFmxObject TSubject;

typedef System::TMetaClass* TSubjectClass;

struct DECLSPEC_DRECORD TBreakpoint
{
public:
	float MaxWidth;
	System::UnicodeString Name;
	System::UnicodeString __fastcall ToString();
	bool __fastcall IsEmpty();
	__fastcall TBreakpoint(const System::UnicodeString AName, const float AMaxWidth);
	static TBreakpoint __fastcall _op_Implicit(const System::UnicodeString AString);
	__fastcall operator System::UnicodeString();
	void __fastcall Clear();
	TBreakpoint() {}
	
	TBreakpoint& operator =(const System::UnicodeString AString) { *this = TBreakpoint::_op_Implicit(AString); return *this; }
};


class PASCALIMPLEMENTATION TBreakpoints : public System::Generics::Collections::TList__1<TBreakpoint>
{
	typedef System::Generics::Collections::TList__1<TBreakpoint> inherited;
	
public:
	__fastcall virtual TBreakpoints(const System::DynamicArray<TBreakpoint> ABreakpoints);
	virtual System::UnicodeString __fastcall ToString();
	int __fastcall IndexOfBP(const System::UnicodeString AName);
	TBreakpoint __fastcall ByName(const System::UnicodeString AName);
public:
	/* {System_Generics_Collections}TList<ResponsiveContainer_TBreakpoint>.Destroy */ inline __fastcall virtual ~TBreakpoints() { }
	
};


struct DECLSPEC_DRECORD TResponsiveDefinition
{
public:
	TSubjectClass SubjectClass;
	System::UnicodeString StandName;
	Fmx::Types::TFmxObject* Parent;
	__fastcall TResponsiveDefinition(const TSubjectClass ASubjectClass, const System::UnicodeString AStandName, Fmx::Types::TFmxObject* const AParent);
	TResponsiveDefinition() {}
};


struct DECLSPEC_DRECORD TResponsiveOption
{
public:
	TResponsiveDefinition Source;
	TResponsiveDefinition Target;
	System::UnicodeString Breakpoint;
	bool __fastcall Matches(const TResponsiveDefinition &ADef, const System::UnicodeString ABreakpoint, TBreakpoints* const AAvailableBreakpoints)/* overload */;
	bool __fastcall Matches(const TSubjectClass ASubjectClass, const System::UnicodeString AStandName, Fmx::Types::TFmxObject* const AParent, const System::UnicodeString ABreakpoint, TBreakpoints* const AAvailableBreakpoints)/* overload */;
	__fastcall TResponsiveOption(const TResponsiveDefinition &ASource, const TResponsiveDefinition &ATarget, const System::UnicodeString ABreakpoint);
	TResponsiveOption() {}
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TResponsiveContainer : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TBreakpoints* FBreakpoints;
	System::Generics::Collections::TList__1<TResponsiveOption>* FOptions;
	
public:
	__fastcall virtual TResponsiveContainer();
	__fastcall virtual ~TResponsiveContainer();
	void __fastcall Define(const TResponsiveDefinition &ASourceDef, const TResponsiveDefinition &ATargetDef, const System::UnicodeString ABreakpoint)/* overload */;
	void __fastcall Define(const TSubjectClass ASourceSubjectClass, const TSubjectClass ATargetSubjectClass, const System::UnicodeString ABreakpoint)/* overload */;
	TResponsiveDefinition __fastcall Lookup(const TResponsiveDefinition &ASourceDef, const System::UnicodeString ABreakpoint);
	TBreakpoint __fastcall CurrentBreakpoint(const float AWidth);
	void __fastcall AddBreakpoint(const float AWidth, const System::UnicodeString AName);
	void __fastcall SetBreakpoint(const float AWidth, const System::UnicodeString AName);
	__property TBreakpoints* Breakpoints = {read=FBreakpoints};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Responsivecontainer */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_RESPONSIVECONTAINER)
using namespace Responsivecontainer;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ResponsivecontainerHPP
