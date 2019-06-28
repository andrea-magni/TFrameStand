// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'SubjectStand.pas' rev: 33.00 (Windows)

#ifndef SubjectstandHPP
#define SubjectstandHPP

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

//-- user supplied -----------------------------------------------------------

namespace Subjectstand
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS SubjectStandCustomAttribute;
class DELPHICLASS ContextAttribute;
class DELPHICLASS SubjectStandAttribute;
class DELPHICLASS StandAttribute;
class DELPHICLASS ContainerAttribute;
class DELPHICLASS SubjectInfoAttribute;
class DELPHICLASS ParentAttribute;
class DELPHICLASS BeforeShowAttribute;
class DELPHICLASS AfterShowAttribute;
class DELPHICLASS ShowAttribute;
class DELPHICLASS HideAttribute;
class DELPHICLASS TDelayedAction;
class DELPHICLASS TSubjectInfo;
template<typename Info> class DELPHICLASS TCommonActionDictionary__1;
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

typedef Fmx::Types::TFmxObject TSubject;

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

enum DECLSPEC_DENUM TSubjectStatus : unsigned char { Initializing, Ready, Showing, Visible, Hiding, Hidden, Closing };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSubjectInfo : public System::TObject
{
	typedef System::TObject inherited;
	
private:
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
	virtual Fmx::Types::TFmxObject* __fastcall GetSubject() = 0 ;
	virtual void __fastcall SetSubject(Fmx::Types::TFmxObject* const Value) = 0 ;
	virtual bool __fastcall GetSubjectIsOwned() = 0 ;
	virtual void __fastcall SetSubjectIsOwned(const bool Value) = 0 ;
	virtual bool __fastcall BindCommonActions(Fmx::Types::TFmxObject* const AObject);
	virtual bool __fastcall BindCommonActionList(Fmx::Types::TFmxObject* const AObject);
	template<typename A> A __fastcall HasAttribute(System::Rtti::TRttiObject* ARttiObject);
	virtual System::Rtti::TRttiInstanceProperty* __fastcall FindActionProperty(System::TObject* AObject);
	virtual void __fastcall InjectContext();
	virtual void __fastcall InjectContextAttribute(ContextAttribute* const AAttribute, System::Rtti::TRttiField* const AField, const System::TClass AFieldClassType);
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
	virtual void __fastcall SetupStand();
	virtual void __fastcall SetupStandParent(Fmx::Types::TFmxObject* const AParent);
	virtual void __fastcall SetupContainer();
	virtual void __fastcall SetupSubjectContainer();
	virtual void __fastcall SetupCommonActions(Fmx::Types::TFmxObject* const AFmxObject);
	virtual void __fastcall SetupCustomMethods();
	virtual void __fastcall TeardownSubjectContainer();
	virtual void __fastcall TeardownStandParent();
	virtual void __fastcall TeardownStand();
	
public:
	virtual void __fastcall DefaultShow();
	virtual void __fastcall DefaultHide();
	virtual void __fastcall StopAnimations();
	System::Threading::_di_ITask __fastcall SubjectShow _DEPRECATED_ATTRIBUTE0 (const System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> > ABackgroundTask, const System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> > AOnTaskComplete = System::DelphiInterface<System::Sysutils::TProc__1<TSubjectInfo*> >(), const bool AOnTaskCompleteSynchronized = true)/* overload */;
	void __fastcall SubjectShow()/* overload */;
	bool __fastcall Hide(const int ADelay = 0x0, const System::Sysutils::_di_TProc AThen = System::Sysutils::_di_TProc());
	void __fastcall HideAndClose(const int ADeferExecutionMS = 0x0, const System::Sysutils::_di_TProc AThen = System::Sysutils::_di_TProc());
	void __fastcall Close();
	__fastcall virtual TSubjectInfo(TSubjectStand* const ASubjectStand, Fmx::Types::TFmxObject* const ASubject, Fmx::Types::TFmxObject* const AParent, const System::UnicodeString AStandStyleName);
	__fastcall virtual ~TSubjectInfo();
	__property Fmx::Types::TFmxObject* Subject = {read=GetSubject, write=SetSubject};
	__property bool SubjectIsOwned = {read=GetSubjectIsOwned, write=SetSubjectIsOwned, nodefault};
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

typedef TOnAfterShowEvent TOnBeforeShowEvent;

typedef TOnAfterShowEvent TOnAfterHideEvent;

typedef TOnAfterShowEvent TOnBeforeHideEvent;

typedef void __fastcall (__closure *TOnBeforeStartAnimationEvent)(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo, Fmx::Ani::TAnimation* const AAnimation);

typedef void __fastcall (__closure *TOnBindCommonActionList)(TSubjectStand* ASender, TSubjectInfo* const ASubjectInfo, Fmx::Types::TFmxObject* const AObject, System::UnicodeString &ACommonActionName);

#pragma pack(push,4)
// Template declaration generated by Delphi parameterized types is
// used only for accessing Delphi variables and fields.
// Don't instantiate with new type parameters in user code.
template<typename Info> class PASCALIMPLEMENTATION TCommonActionDictionary__1 : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Generics::Collections::TDictionary__2<System::UnicodeString,System::DelphiInterface<System::Sysutils::TProc__1<Info> > >* FDictionary;
	int __fastcall GetCount();
	System::DynamicArray<System::UnicodeString> __fastcall GetKeys();
	
public:
	void __fastcall Add(const System::UnicodeString APattern, const System::DelphiInterface<System::Sysutils::TProc__1<Info> > AAction);
	bool __fastcall TryGetValue(const System::UnicodeString APattern, /* out */ System::DelphiInterface<System::Sysutils::TProc__1<Info> > &AAction);
	__fastcall virtual TCommonActionDictionary__1();
	__fastcall virtual ~TCommonActionDictionary__1();
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
	TCommonActionDictionary__1<TSubjectInfo*>* FCommonActions;
	TOnAfterShowEvent FOnAfterHide;
	TOnAfterShowEvent FOnBeforeHide;
	TOnAfterShowEvent FOnAfterShow;
	TOnAfterShowEvent FOnBeforeShow;
	TOnBeforeStartAnimationEvent FOnBeforeStartAnimation;
	Fmx::Actnlist::TActionList* FCommonActionList;
	System::UnicodeString FCommonActionPrefix;
	TOnBindCommonActionList FOnBindCommonActionList;
	Fmx::Types::TFmxObject* FDefaultParent;
	Responsivecontainer::TResponsiveContainer* FResponsive;
	int FDefaultHideAndCloseDeferTimeMS;
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual Fmx::Types::TFmxObject* __fastcall GetDefaultParent();
	System::UnicodeString __fastcall GetStandStyleName(System::UnicodeString AStandStyleName);
	virtual int __fastcall GetCount() = 0 ;
	Responsivecontainer::TBreakpoint __fastcall GetResponsiveBreakpoint(const System::UnicodeString AName);
	System::DynamicArray<Responsivecontainer::TBreakpoint> __fastcall GetResponsiveBreakpoints();
	void __fastcall SetResponsiveBreakpoints(const System::DynamicArray<Responsivecontainer::TBreakpoint> ABreakpoints);
	void __fastcall DoResponsiveLookup(TSubjectClass &ASubjectClass, System::UnicodeString &AStandStyleName, Fmx::Types::TFmxObject* &AParent);
	virtual void __fastcall DoAfterShow(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo);
	virtual void __fastcall DoBeforeShow(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo);
	virtual void __fastcall DoAfterHide(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo);
	virtual void __fastcall DoBeforeHide(TSubjectStand* const ASender, TSubjectInfo* const ASubjectInfo);
	virtual void __fastcall DoClose(Fmx::Types::TFmxObject* const ASubject);
	
public:
	__fastcall virtual TSubjectStand(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TSubjectStand();
	HIDESBASE virtual void __fastcall Remove(Fmx::Types::TFmxObject* ASubject) = 0 ;
	Deviceandplatforminfo::TDeviceAndPlatformInfo __fastcall DeviceAndPlatformInfo(Fmx::Forms::TForm* const AForm = (Fmx::Forms::TForm*)(0x0));
	virtual void __fastcall CloseAll() = 0 /* overload */;
	virtual void __fastcall CloseAll(const System::DynamicArray<System::TClass> AExceptions) = 0 /* overload */;
	virtual void __fastcall CloseAll(const System::TClass AException)/* overload */;
	__property int Count = {read=GetCount, nodefault};
	__property TCommonActionDictionary__1<TSubjectInfo*>* CommonActions = {read=FCommonActions};
	__property Responsivecontainer::TResponsiveContainer* Responsive = {read=FResponsive};
	__property System::DynamicArray<Responsivecontainer::TBreakpoint> ResponsiveBreakpoints = {read=GetResponsiveBreakpoints, write=SetResponsiveBreakpoints};
	__property Responsivecontainer::TBreakpoint ResponsiveBreakpoint[const System::UnicodeString AName] = {read=GetResponsiveBreakpoint};
	
__published:
	__property System::UnicodeString AnimationShow = {read=FAnimationShow, write=FAnimationShow};
	__property System::UnicodeString AnimationHide = {read=FAnimationHide, write=FAnimationHide};
	__property Fmx::Actnlist::TActionList* CommonActionList = {read=FCommonActionList, write=FCommonActionList};
	__property System::UnicodeString CommonActionPrefix = {read=FCommonActionPrefix, write=FCommonActionPrefix};
	__property int DefaultHideAndCloseDeferTimeMS = {read=FDefaultHideAndCloseDeferTimeMS, write=FDefaultHideAndCloseDeferTimeMS, nodefault};
	__property System::UnicodeString DefaultStyleName = {read=FDefaultStyleName, write=FDefaultStyleName};
	__property Fmx::Types::TFmxObject* DefaultParent = {read=FDefaultParent, write=FDefaultParent};
	__property Fmx::Controls::TStyleBook* StyleBook = {read=FStyleBook, write=FStyleBook};
	__property TOnAfterShowEvent OnAfterHide = {read=FOnAfterHide, write=FOnAfterHide};
	__property TOnAfterShowEvent OnBeforeHide = {read=FOnBeforeHide, write=FOnBeforeHide};
	__property TOnAfterShowEvent OnAfterShow = {read=FOnAfterShow, write=FOnAfterShow};
	__property TOnAfterShowEvent OnBeforeShow = {read=FOnBeforeShow, write=FOnBeforeShow};
	__property TOnBeforeStartAnimationEvent OnBeforeStartAnimation = {read=FOnBeforeStartAnimation, write=FOnBeforeStartAnimation};
	__property TOnBindCommonActionList OnBindCommonActionList = {read=FOnBindCommonActionList, write=FOnBindCommonActionList};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Subjectstand */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_SUBJECTSTAND)
using namespace Subjectstand;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// SubjectstandHPP
