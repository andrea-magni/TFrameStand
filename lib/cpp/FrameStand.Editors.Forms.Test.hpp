// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FrameStand.Editors.Forms.Test.pas' rev: 30.00 (Windows)

#ifndef Framestand_Editors_Forms_TestHPP
#define Framestand_Editors_Forms_TestHPP

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
#include <FMX.Layouts.hpp>
#include <FMX.Controls.Presentation.hpp>
#include <FMX.StdCtrls.hpp>
#include <FrameStand.hpp>
#include <FMX.ListBox.hpp>
#include <Frames.Test.hpp>
#include <System.Actions.hpp>
#include <FMX.ActnList.hpp>
#include <FMX.Objects.hpp>
#include <FMX.Edit.hpp>
#include <System.Rtti.hpp>
#include <FMX.Ani.hpp>
#include <System.Threading.hpp>

//-- user supplied -----------------------------------------------------------

namespace Framestand
{
namespace Editors
{
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
	Fmx::Layouts::TLayout* TopLayout;
	Fmx::Layouts::TLayout* TestBedLayout;
	Fmx::Listbox::TComboBox* StandComboBox;
	Fmx::Stdctrls::TLabel* Label1;
	Fmx::Actnlist::TActionList* MainActionList;
	Fmx::Actnlist::TAction* ShowAction;
	Fmx::Actnlist::TAction* HideAction;
	Fmx::Objects::TRectangle* TestBed;
	Fmx::Layouts::TLayout* TopButtonLayout;
	Fmx::Layouts::TFlowLayout* FlowLayout1;
	Fmx::Stdctrls::TButton* ShowButton;
	Fmx::Stdctrls::TButton* HideButton;
	Fmx::Edit::TEdit* DelayEdit;
	Fmx::Stdctrls::TLabel* Label2;
	Fmx::Stdctrls::TLabel* Label3;
	Fmx::Listbox::TComboBox* FrameAlignComboBox;
	Fmx::Stdctrls::TLabel* Label4;
	Fmx::Edit::TEdit* FrameWidthEdit;
	Fmx::Stdctrls::TLabel* Label5;
	Fmx::Edit::TEdit* FrameHeightEdit;
	Fmx::Stdctrls::TLabel* Label7;
	Fmx::Stdctrls::TLabel* Label6;
	Fmx::Stdctrls::TCheckBox* TestBedClipCheckBox;
	void __fastcall ShowActionExecute(System::TObject* Sender);
	void __fastcall HideActionExecute(System::TObject* Sender);
	void __fastcall HideActionUpdate(System::TObject* Sender);
	void __fastcall ShowActionUpdate(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	
private:
	Framestand::TFrameStand* FFrameStand;
	Framestand::TFrameInfo__1<Frames::Test::TTestFrame*>* FFrameInfo;
	void __fastcall SetFrameStand(Framestand::TFrameStand* const Value);
	HIDESBASE Fmx::Controls::TStyleBook* __fastcall GetStyleBook(void);
	System::UnicodeString __fastcall GetSelectedStyleName(void);
	Fmx::Types::TAlignLayout __fastcall GetSelectedFrameAlign(void);
	
protected:
	virtual void __fastcall Init(void);
	virtual void __fastcall DoFrameStandChanged(void);
	__property System::UnicodeString SelectedStyleName = {read=GetSelectedStyleName};
	__property Fmx::Types::TAlignLayout SelectedFrameAlign = {read=GetSelectedFrameAlign, nodefault};
	
public:
	__property Framestand::TFrameStand* FrameStand = {read=FFrameStand, write=SetFrameStand};
	__property Fmx::Controls::TStyleBook* StyleBook = {read=GetStyleBook};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TTestForm(System::Classes::TComponent* AOwner) : Fmx::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TTestForm(System::Classes::TComponent* AOwner, NativeInt Dummy) : Fmx::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TTestForm(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Test */
}	/* namespace Forms */
}	/* namespace Editors */
}	/* namespace Framestand */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRAMESTAND_EDITORS_FORMS_TEST)
using namespace Framestand::Editors::Forms::Test;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRAMESTAND_EDITORS_FORMS)
using namespace Framestand::Editors::Forms;
#endif
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
#endif	// Framestand_Editors_Forms_TestHPP
