// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FormStand.Editors.Forms.Test.pas' rev: 33.00 (Windows)

#ifndef Formstand_Editors_Forms_TestHPP
#define Formstand_Editors_Forms_TestHPP

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
#include <FormStand.hpp>
#include <FMX.ListBox.hpp>
#include <Forms.Test.hpp>
#include <System.Actions.hpp>
#include <FMX.ActnList.hpp>
#include <FMX.Objects.hpp>
#include <FMX.Edit.hpp>
#include <SubjectStand.hpp>
#include <System.Rtti.hpp>
#include <System.Threading.hpp>

//-- user supplied -----------------------------------------------------------

namespace Formstand
{
namespace Editors
{
namespace Forms
{
namespace Test
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFormStandTestForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFormStandTestForm : public Fmx::Forms::TForm
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
	Fmx::Listbox::TComboBox* FormAlignComboBox;
	Fmx::Stdctrls::TLabel* Label4;
	Fmx::Edit::TEdit* FormWidthEdit;
	Fmx::Stdctrls::TLabel* Label5;
	Fmx::Edit::TEdit* FormHeightEdit;
	Fmx::Stdctrls::TLabel* Label7;
	Fmx::Stdctrls::TLabel* Label6;
	Fmx::Stdctrls::TCheckBox* TestBedClipCheckBox;
	void __fastcall ShowActionExecute(System::TObject* Sender);
	void __fastcall HideActionExecute(System::TObject* Sender);
	void __fastcall HideActionUpdate(System::TObject* Sender);
	void __fastcall ShowActionUpdate(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	
private:
	Formstand::TFormStand* FFormStand;
	Formstand::TFormInfo__1<Forms::Test::TTestForm*>* FFormInfo;
	
protected:
	void __fastcall SetFormStand(Formstand::TFormStand* const Value);
	HIDESBASE Fmx::Controls::TStyleBook* __fastcall GetStyleBook();
	System::UnicodeString __fastcall GetSelectedStyleName();
	Fmx::Types::TAlignLayout __fastcall GetSelectedFormAlign();
	virtual void __fastcall Init();
	virtual void __fastcall DoFormStandChanged();
	void __fastcall SetupTestBed();
	void __fastcall SetupTestFormAndTestBed();
	__property System::UnicodeString SelectedStyleName = {read=GetSelectedStyleName};
	__property Fmx::Types::TAlignLayout SelectedFormAlign = {read=GetSelectedFormAlign, nodefault};
	
public:
	__property Formstand::TFormStand* FormStand = {read=FFormStand, write=SetFormStand};
	__property Fmx::Controls::TStyleBook* StyleBook = {read=GetStyleBook};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFormStandTestForm(System::Classes::TComponent* AOwner) : Fmx::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFormStandTestForm(System::Classes::TComponent* AOwner, NativeInt Dummy) : Fmx::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFormStandTestForm() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Test */
}	/* namespace Forms */
}	/* namespace Editors */
}	/* namespace Formstand */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FORMSTAND_EDITORS_FORMS_TEST)
using namespace Formstand::Editors::Forms::Test;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FORMSTAND_EDITORS_FORMS)
using namespace Formstand::Editors::Forms;
#endif
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
#endif	// Formstand_Editors_Forms_TestHPP
