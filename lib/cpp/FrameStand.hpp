// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FrameStand.pas' rev: 33.00 (Windows)

#ifndef FramestandHPP
#define FramestandHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <System.Rtti.hpp>
#include <System.Masks.hpp>
#include <System.Threading.hpp>
#include <System.Generics.Collections.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Types.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Ani.hpp>
#include <System.Actions.hpp>
#include <FMX.ActnList.hpp>
#include <DeviceAndPlatformInfo.hpp>
#include <ResponsiveContainer.hpp>
#include <System.Generics.Defaults.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Framestand
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS SubjectStandCustomAttribute;
class DELPHICLASS ContextAttribute;
class DELPHICLASS SubjectStandAttribute;
class DELPHICLASS StandAttribute;
class DELPHICLASS ContainerAttribute;
class DELPHICLASS SubjectInfoAttribute;
class DELPHICLASS ParentAttribute;
class DELPHICLASS SubjectIsOwnedAttribute;
class DELPHICLASS BeforeShowAttribute;
class DELPHICLASS AfterShowAttribute;
class DELPHICLASS ShowAttribute;
class DELPHICLASS HideAttribute;
class DELPHICLASS TDelayedAction;
class DELPHICLASS TSubjectInfo;
class DELPHICLASS TCommonActionDictionary;
class DELPHICLASS TSubjectStand;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION SubjectStandCustomAttribute : public System::TCustomAttribute
{
	typedef System::TCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall SubjectStandCustomAttribute() : System::TCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~SubjectStandCustomAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION ContextAttribute : public SubjectStandCustomAttribute
{
	typedef SubjectStandCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall ContextAttribute() : SubjectStandCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~ContextAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION SubjectStandAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall SubjectStandAttribute() : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~SubjectStandAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION StandAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall StandAttribute() : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~StandAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION ContainerAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall ContainerAttribute() : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~ContainerAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION SubjectInfoAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall SubjectInfoAttribute() : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~SubjectInfoAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION ParentAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall ParentAttribute() : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~ParentAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION SubjectIsOwnedAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall SubjectIsOwnedAttribute() : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~SubjectIsOwnedAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION BeforeShowAttribute : public SubjectStandCustomAttribute
{
	typedef SubjectStandCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall BeforeShowAttribute() : SubjectStandCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~BeforeShowAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION AfterShowAttribute : public SubjectStandCustomAttribute
{
	typedef SubjectStandCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall AfterShowAttribute() : SubjectStandCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~AfterShowAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION ShowAttribute : public SubjectStandCustomAttribute
{
	typedef SubjectStandCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall ShowAttribute() : SubjectStandCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~ShowAttribute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION HideAttribute : public SubjectStandCustomAttribute
{
	typedef SubjectStandCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall HideAttribute() : SubjectStandCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~HideAttribute() { }
	
};

#pragma pack(pop)

typedef Fmx::Forms::TFrame TSubject;

typedef System::TMetaClass* TSubjectClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDelayedAction : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod void __fastcall Execute(const int ADelay, const System::Sysutils::_di_TProc AAction);
public:
	/* TObject.Create */ inline __fastcall TDelayedAction() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDelayedAction() { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TOnGetSubjectClassEvent)(TSubjectStand* const ASender, Fmx::Types::TFmxObject* &AParent, System::UnicodeString &AStandStyleName, TSubjectClass &ASubjectClass);

enum DECLSPEC_DENUM TSubjectStatus : unsigned char { Initializing, Ready, Showing, Visible, Hiding, Hidden, Closing };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSubjectInfo : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Fmx::Forms::TFrame* FSubject;
	bool FSubjectIsOwned;
	TSubjectStand* FSubjectStand;
	Fmx::Controls::TControl* FStand;
	Fmx::Types::TFmxObject* FParent;
	System::DynamicArray<System::Rtti::TRttiMethod*> FCustomBeforeShowMethods;
	System::DynamicArray<System::Rtti::TRttiMethod*> FCustomAfterShowMethods;
	System::DynamicArray<System::Rtti::TRttiMethod*> FCustomShowMethods;
	System::DynamicArray<System::Rtti::TRttiMethod*> FCustomHideMethods;
	Fmx::Types::TFmxObject* FContainer;
	System::UnicodeString FStandStyleName;
	bool FHiding;
	TSubjectStatus FStatus;
	bool __fastcall GetIsVisible();
	
protected:
	virtual bool __fastcall BindCommonActions(Fmx::Types::TFmxObject* const AObject);
	virtual bool __fastcall BindCommonActionList(Fmx::Types::TFmxObject* const AObject);
	template<typename A> A __fastcall HasAttribute(System::Rtti::TRttiObject* ARttiObject);
	virtual System::Rtti::TRttiInstanceProperty* __fastcall FindActionProperty(System::TObject* AObject);
	virtual void __fastcall InjectContext();
	virtual void __fastcall FindCustomMethods();
	virtual void __fastcall FindCommonActions(Fmx::Types::TFmxObject* const AFmxObject);
	virtual bool __fastcall FireCustomMethods(System::DynamicArray<System::Rtti::TRttiMethod*> AMethods);
	virtual bool __fastcall FireCustomBeforeShowMethods();
	virtual bool __fastcall FireCustomAfterShowMethods();
	virtual bool __fastcall FireCustomShowMethods();
	virtual bool __fastcall FireCustomHideMethods();
	virtual void __fastcall DoBeforeStartAnimation(Fmx::Ani::TAnimation* const AAnimation);
	bool __fastcall FireAnimations(Fmx::Types::TFmxObject* const AFmxObject, const System::UnicodeString APattern, const bool AStart = true, const System::DelphiInterface<System::Sysutils::TProc__1<Fmx::Ani::TAnimation*> > AOnBeforeStart = System::DelphiInterface<System::Sysutils::TProc__1<Fmx::Ani::TAnimation*> >(), const System::DelphiInterface<System::Sysutils::TProc__1<Fmx::Ani::TAnimation*> > AOnBeforeStop = System::DelphiInterface<System::Sysutils::TProc__1<Fmx::Ani::TAnimation*> >());
	virtual bool __fastcall FireShowAnimations();
	virtual bool __fastcall FireHideAnimations(/* out */ float &AHideDelay);
	void __fastcall DoCommonActionClick(System::TObject* Sender);
	
public:
	virtual void __fastcall DefaultShow();
	virtual void __fastcall DefaultHide();
	virtual void __fastcall StopAnimations();
	System::Threading::_di_ITask __fastcall Show(const System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> > ABackgroundTask = System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> >(), const System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> > AOnTaskComplete = System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> >(), const bool AOnTaskCompleteSynchronized = true);
	bool __fastcall Hide(const int ADelay = 0x0, const System::Sysutils::_di_TProc AThen = System::Sysutils::_di_TProc());
	void __fastcall Close();
	__fastcall virtual TSubjectInfo(TSubjectStand* const ASubjectStand, Fmx::Forms::TFrame* const ASubject, Fmx::Types::TFmxObject* const AParent, const System::UnicodeString AStandStyleName);
	__fastcall virtual ~TSubjectInfo();
	__property Fmx::Forms::TFrame* Subject = {read=FSubject};
	__property bool SubjectIsOwned = {read=FSubjectIsOwned, write=FSubjectIsOwned, nodefault};
	__property TSubjectStand* SubjectStand = {read=FSubjectStand};
	__property Fmx::Controls::TControl* Stand = {read=FStand, write=FStand};
	__property System::UnicodeString StandStyleName = {read=FStandStyleName};
	__property Fmx::Types::TFmxObject* Container = {read=FContainer, write=FContainer};
	__property Fmx::Types::TFmxObject* Parent = {read=FParent, write=FParent};
	__property bool IsVisible = {read=GetIsVisible, nodefault};
	__property bool Hiding = {read=FHiding, nodefault};
	__property TSubjectStatus Status = {read=FStatus, nodefault};
};

#pragma pack(pop)

typedef void __fastcall (__closure *TOnAfterShowEvent)(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo);

typedef void __fastcall (__closure *TOnBeforeShowEvent)(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo);

typedef TOnBeforeShowEvent TOnAfterHideEvent;

typedef void __fastcall (__closure *TOnBeforeStartAnimationEvent)(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo, Fmx::Ani::TAnimation* const AAnimation);

typedef void __fastcall (__closure *TOnBindCommonActionList)(TSubjectStand* ASender, TSubjectInfo* const ASubjectInfo, Fmx::Types::TFmxObject* const AObject, System::UnicodeString &ACommonActionName);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCommonActionDictionary : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Generics::Collections::TDictionary__2<System::UnicodeString,System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> > >* FDictionary;
	int __fastcall GetCount();
	System::DynamicArray<System::UnicodeString> __fastcall GetKeys();
	
public:
	void __fastcall Add(const System::UnicodeString APattern, const System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> > AAction);
	bool __fastcall TryGetValue(const System::UnicodeString APattern, /* out */ System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> > &AAction);
	__fastcall virtual TCommonActionDictionary();
	__fastcall virtual ~TCommonActionDictionary();
	__property int Count = {read=GetCount, nodefault};
	__property System::DynamicArray<System::UnicodeString> Keys = {read=GetKeys};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TSubjectStand : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	Fmx::Controls::TStyleBook* FStyleBook;
	System::UnicodeString FDefaultStyleName;
	System::UnicodeString FAnimationHide;
	System::UnicodeString FAnimationShow;
	TOnGetSubjectClassEvent FOnGetSubjectClass;
	TCommonActionDictionary* FCommonActions;
	TOnBeforeShowEvent FOnAfterHide;
	TOnAfterShowEvent FOnAfterShow;
	TOnBeforeShowEvent FOnBeforeShow;
	TOnBeforeStartAnimationEvent FOnBeforeStartAnimation;
	Fmx::Actnlist::TActionList* FCommonActionList;
	System::UnicodeString FCommonActionPrefix;
	TOnBindCommonActionList FOnBindCommonActionList;
	Fmx::Types::TFmxObject* FDefaultParent;
	System::Generics::Collections::TList__1<Fmx::Forms::TFrame*>* FVisibleSubjects;
	Responsivecontainer::TResponsiveContainer* FResponsive;
	Responsivecontainer::TBreakpoint __fastcall GetResponsiveBreakpoint(const System::UnicodeString AName);
	
protected:
	System::Generics::Collections::TObjectDictionary__2<Fmx::Forms::TFrame*,TSubjectInfo*>* FSubjectInfos;
	virtual Fmx::Types::TFmxObject* __fastcall GetDefaultParent();
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	System::UnicodeString __fastcall GetStandStyleName(System::UnicodeString AStandStyleName);
	TSubjectClass __fastcall GetSubjectClass(const TSubjectClass ASubjectClass, Fmx::Types::TFmxObject* &AParent, System::UnicodeString &AStandStyleName);
	int __fastcall GetCount();
	System::DynamicArray<Responsivecontainer::TBreakpoint> __fastcall GetResponsiveBreakpoints();
	void __fastcall SetResponsiveBreakpoints(const System::DynamicArray<Responsivecontainer::TBreakpoint> ABreakpoints);
	void __fastcall DoAfterShow(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo);
	void __fastcall DoBeforeShow(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo);
	void __fastcall DoAfterHide(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo);
	void __fastcall DoClose(Fmx::Forms::TFrame* const ASubject);
	void __fastcall DoResponsiveLookup(TSubjectClass &ASubjectClass, System::UnicodeString &AStandStyleName, Fmx::Types::TFmxObject* &AParent);
	
public:
	__fastcall virtual TSubjectStand(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TSubjectStand();
	TSubjectInfo* __fastcall Use(Fmx::Forms::TFrame* const ASubject, Fmx::Types::TFmxObject* const AParent = (Fmx::Types::TFmxObject*)(0x0), const System::UnicodeString AStandStyleName = System::UnicodeString());
	TSubjectInfo* __fastcall New(const TSubjectClass ASubjectClass, Fmx::Types::TFmxObject* const AParent = (Fmx::Types::TFmxObject*)(0x0), const System::UnicodeString AStandStyleName = System::UnicodeString());
	HIDESBASE void __fastcall Remove(Fmx::Forms::TFrame* ASubject);
	Fmx::Forms::TFrame* __fastcall LastShownSubject();
	TSubjectInfo* __fastcall SubjectInfo(Fmx::Forms::TFrame* const ASubject);
	Deviceandplatforminfo::TDeviceAndPlatformInfo __fastcall DeviceAndPlatformInfo(Fmx::Forms::TForm* const AForm = (Fmx::Forms::TForm*)(0x0));
	__property int Count = {read=GetCount, nodefault};
	__property TCommonActionDictionary* CommonActions = {read=FCommonActions};
	__property System::Generics::Collections::TObjectDictionary__2<Fmx::Forms::TFrame*,TSubjectInfo*>* SubjectInfos = {read=FSubjectInfos};
	__property System::Generics::Collections::TList__1<Fmx::Forms::TFrame*>* VisibleSubjects = {read=FVisibleSubjects};
	__property Responsivecontainer::TResponsiveContainer* Responsive = {read=FResponsive};
	__property System::DynamicArray<Responsivecontainer::TBreakpoint> ResponsiveBreakpoints = {read=GetResponsiveBreakpoints, write=SetResponsiveBreakpoints};
	__property Responsivecontainer::TBreakpoint ResponsiveBreakpoint[const System::UnicodeString AName] = {read=GetResponsiveBreakpoint};
	
__published:
	__property System::UnicodeString AnimationShow = {read=FAnimationShow, write=FAnimationShow};
	__property System::UnicodeString AnimationHide = {read=FAnimationHide, write=FAnimationHide};
	__property Fmx::Actnlist::TActionList* CommonActionList = {read=FCommonActionList, write=FCommonActionList};
	__property System::UnicodeString CommonActionPrefix = {read=FCommonActionPrefix, write=FCommonActionPrefix};
	__property System::UnicodeString DefaultStyleName = {read=FDefaultStyleName, write=FDefaultStyleName};
	__property Fmx::Types::TFmxObject* DefaultParent = {read=FDefaultParent, write=FDefaultParent};
	__property Fmx::Controls::TStyleBook* StyleBook = {read=FStyleBook, write=FStyleBook};
	__property TOnBeforeShowEvent OnAfterHide = {read=FOnAfterHide, write=FOnAfterHide};
	__property TOnAfterShowEvent OnAfterShow = {read=FOnAfterShow, write=FOnAfterShow};
	__property TOnBeforeShowEvent OnBeforeShow = {read=FOnBeforeShow, write=FOnBeforeShow};
	__property TOnBeforeStartAnimationEvent OnBeforeStartAnimation = {read=FOnBeforeStartAnimation, write=FOnBeforeStartAnimation};
	__property TOnBindCommonActionList OnBindCommonActionList = {read=FOnBindCommonActionList, write=FOnBindCommonActionList};
	__property TOnGetSubjectClassEvent OnGetSubjectClass = {read=FOnGetSubjectClass, write=FOnGetSubjectClass};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Framestand */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FRAMESTAND)
using namespace Framestand;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FramestandHPP
