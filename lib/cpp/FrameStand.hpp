// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FrameStand.pas' rev: 32.00 (Windows)

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
#include <System.Generics.Defaults.hpp>

//-- user supplied -----------------------------------------------------------

namespace Framestand
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS FrameStandCustomAttribute;
class DELPHICLASS ContextAttribute;
class DELPHICLASS FrameStandAttribute;
class DELPHICLASS StandAttribute;
class DELPHICLASS ContainerAttribute;
class DELPHICLASS FrameInfoAttribute;
class DELPHICLASS ParentAttribute;
class DELPHICLASS FrameIsOwnedAttribute;
class DELPHICLASS BeforeShowAttribute;
class DELPHICLASS ShowAttribute;
class DELPHICLASS HideAttribute;
class DELPHICLASS TDelayedAction;
template<typename T> class DELPHICLASS TFrameInfo__1;
class DELPHICLASS TCommonActionDictionary;
class DELPHICLASS TFrameStand;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION FrameStandCustomAttribute : public System::TCustomAttribute
{
	typedef System::TCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall FrameStandCustomAttribute(void) : System::TCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~FrameStandCustomAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION ContextAttribute : public FrameStandCustomAttribute
{
	typedef FrameStandCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall ContextAttribute(void) : FrameStandCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~ContextAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION FrameStandAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall FrameStandAttribute(void) : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~FrameStandAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION StandAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall StandAttribute(void) : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~StandAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION ContainerAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall ContainerAttribute(void) : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~ContainerAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION FrameInfoAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall FrameInfoAttribute(void) : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~FrameInfoAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION ParentAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall ParentAttribute(void) : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~ParentAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION FrameIsOwnedAttribute : public ContextAttribute
{
	typedef ContextAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall FrameIsOwnedAttribute(void) : ContextAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~FrameIsOwnedAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION BeforeShowAttribute : public FrameStandCustomAttribute
{
	typedef FrameStandCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall BeforeShowAttribute(void) : FrameStandCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~BeforeShowAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION ShowAttribute : public FrameStandCustomAttribute
{
	typedef FrameStandCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall ShowAttribute(void) : FrameStandCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~ShowAttribute(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION HideAttribute : public FrameStandCustomAttribute
{
	typedef FrameStandCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall HideAttribute(void) : FrameStandCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~HideAttribute(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TFrameClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDelayedAction : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod void __fastcall Execute(const int ADelay, const System::Sysutils::_di_TProc AAction);
public:
	/* TObject.Create */ inline __fastcall TDelayedAction(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDelayedAction(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TOnGetFrameClassEvent)(TFrameStand* const ASender, Fmx::Types::TFmxObject* const AParent, const System::UnicodeString AStandStyleName, TFrameClass &AFrameClass);

enum DECLSPEC_DENUM TFrameStatus : unsigned char { Initializing, Ready, Showing, Visible, Hiding, Hidden, Closing };

#pragma pack(push,4)
// Template declaration generated by Delphi parameterized types is
// used only for accessing Delphi variables and fields.
// Don't instantiate with new type parameters in user code.
template<typename T> class PASCALIMPLEMENTATION TFrameInfo__1 : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	T FFrame;
	bool FFrameIsOwned;
	TFrameStand* FFrameStand;
	Fmx::Controls::TControl* FStand;
	Fmx::Types::TFmxObject* FParent;
	System::DynamicArray<System::Rtti::TRttiMethod*> FCustomBeforeShowMethods;
	System::DynamicArray<System::Rtti::TRttiMethod*> FCustomShowMethods;
	System::DynamicArray<System::Rtti::TRttiMethod*> FCustomHideMethods;
	Fmx::Types::TFmxObject* FContainer;
	System::UnicodeString FStandStyleName;
	bool FHiding;
	TFrameStatus FStatus;
	bool __fastcall GetIsVisible(void);
	
protected:
	virtual bool __fastcall BindCommonActions(Fmx::Types::TFmxObject* const AObject);
	virtual bool __fastcall BindCommonActionList(Fmx::Types::TFmxObject* const AObject);
	template<typename A> A __fastcall HasAttribute(System::Rtti::TRttiObject* ARttiObject);
	virtual System::Rtti::TRttiInstanceProperty* __fastcall FindActionProperty(System::TObject* AObject);
	virtual void __fastcall InjectContext(void);
	virtual void __fastcall FindCustomMethods(void);
	virtual void __fastcall FindCommonActions(Fmx::Types::TFmxObject* const AFmxObject);
	virtual bool __fastcall FireCustomMethods(System::DynamicArray<System::Rtti::TRttiMethod*> AMethods);
	virtual bool __fastcall FireCustomBeforeShowMethods(void);
	virtual bool __fastcall FireCustomShowMethods(void);
	virtual bool __fastcall FireCustomHideMethods(void);
	virtual void __fastcall DoBeforeStartAnimation(Fmx::Ani::TAnimation* const AAnimation);
	bool __fastcall FireAnimations(Fmx::Types::TFmxObject* const AFmxObject, const System::UnicodeString APattern, const bool AStart = true, const System::DelphiInterface<System::Sysutils::TProc__1<Fmx::Ani::TAnimation*> > AOnBeforeStart = (System::DelphiInterface<System::Sysutils::TProc__1<Fmx::Ani::TAnimation*> >)(0x0), const System::DelphiInterface<System::Sysutils::TProc__1<Fmx::Ani::TAnimation*> > AOnBeforeStop = (System::DelphiInterface<System::Sysutils::TProc__1<Fmx::Ani::TAnimation*> >)(0x0));
	virtual bool __fastcall FireShowAnimations(void);
	virtual bool __fastcall FireHideAnimations(/* out */ float &AHideDelay);
	void __fastcall DoCommonActionClick(System::TObject* Sender);
	
public:
	virtual void __fastcall DefaultShow(void);
	virtual void __fastcall DefaultHide(void);
	virtual void __fastcall StopAnimations(void);
	System::Threading::_di_ITask __fastcall Show(const System::DelphiInterface<System::Sysutils::TProc__1<TFrameInfo__1<T>*> > ABackgroundTask = (System::DelphiInterface<System::Sysutils::TProc__1<TFrameInfo__1<T>*> >)(0x0), const System::DelphiInterface<System::Sysutils::TProc__1<TFrameInfo__1<T>*> > AOnTaskComplete = (System::DelphiInterface<System::Sysutils::TProc__1<TFrameInfo__1<T>*> >)(0x0), const bool AOnTaskCompleteSynchronized = true);
	bool __fastcall Hide(const int ADelay = 0x0, const System::Sysutils::_di_TProc AThen = System::Sysutils::_di_TProc());
	void __fastcall Close(void);
	__fastcall virtual TFrameInfo__1(TFrameStand* const AFrameStand, const T AFrame, Fmx::Types::TFmxObject* const AParent, const System::UnicodeString AStandStyleName);
	__fastcall virtual ~TFrameInfo__1(void);
	__property T Frame = {read=FFrame};
	__property bool FrameIsOwned = {read=FFrameIsOwned, write=FFrameIsOwned, nodefault};
	__property TFrameStand* FrameStand = {read=FFrameStand};
	__property Fmx::Controls::TControl* Stand = {read=FStand, write=FStand};
	__property System::UnicodeString StandStyleName = {read=FStandStyleName};
	__property Fmx::Types::TFmxObject* Container = {read=FContainer, write=FContainer};
	__property Fmx::Types::TFmxObject* Parent = {read=FParent, write=FParent};
	__property bool IsVisible = {read=GetIsVisible, nodefault};
	__property bool Hiding = {read=FHiding, nodefault};
	__property TFrameStatus Status = {read=FStatus, nodefault};
};

#pragma pack(pop)

typedef void __fastcall (__closure *TOnBeforeShowEvent)(TFrameStand* const ASender, TFrameInfo__1<Fmx::Forms::TFrame*>* const AFrameInfo);

typedef TOnBeforeShowEvent TOnAfterHideEvent;

typedef void __fastcall (__closure *TOnBeforeStartAnimationEvent)(TFrameStand* const ASender, TFrameInfo__1<Fmx::Forms::TFrame*>* const AFrameInfo, Fmx::Ani::TAnimation* const AAnimation);

typedef void __fastcall (__closure *TOnBindCommonActionList)(TFrameStand* ASender, TFrameInfo__1<Fmx::Forms::TFrame*>* const AFrameInfo, Fmx::Types::TFmxObject* const AObject, System::UnicodeString &ACommonActionName);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCommonActionDictionary : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Generics::Collections::TDictionary__2<System::UnicodeString,System::DelphiInterface<System::Sysutils::TProc__1<TFrameInfo__1<Fmx::Forms::TFrame*>*> > >* FDictionary;
	int __fastcall GetCount(void);
	System::DynamicArray<System::UnicodeString> __fastcall GetKeys(void);
	
public:
	void __fastcall Add(const System::UnicodeString APattern, const System::DelphiInterface<System::Sysutils::TProc__1<TFrameInfo__1<Fmx::Forms::TFrame*>*> > AAction);
	bool __fastcall TryGetValue(const System::UnicodeString APattern, /* out */ System::DelphiInterface<System::Sysutils::TProc__1<TFrameInfo__1<Fmx::Forms::TFrame*>*> > &AAction);
	__fastcall virtual TCommonActionDictionary(void);
	__fastcall virtual ~TCommonActionDictionary(void);
	__property int Count = {read=GetCount, nodefault};
	__property System::DynamicArray<System::UnicodeString> Keys = {read=GetKeys};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TFrameStand : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	Fmx::Controls::TStyleBook* FStyleBook;
	System::UnicodeString FDefaultStyleName;
	System::UnicodeString FAnimationHide;
	System::UnicodeString FAnimationShow;
	TOnGetFrameClassEvent FOnGetFrameClass;
	TCommonActionDictionary* FCommonActions;
	TOnBeforeShowEvent FOnAfterHide;
	TOnBeforeShowEvent FOnBeforeShow;
	TOnBeforeStartAnimationEvent FOnBeforeStartAnimation;
	Fmx::Actnlist::TActionList* FCommonActionList;
	System::UnicodeString FCommonActionPrefix;
	TOnBindCommonActionList FOnBindCommonActionList;
	Fmx::Types::TFmxObject* FDefaultParent;
	int __fastcall GetCount(void);
	
protected:
	System::Generics::Collections::TObjectDictionary__2<Fmx::Forms::TFrame*,TFrameInfo__1<Fmx::Forms::TFrame*>*>* FFrameInfos;
	virtual Fmx::Types::TFmxObject* __fastcall GetDefaultParent(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	System::UnicodeString __fastcall GetStandStyleName(System::UnicodeString AStandStyleName);
	template<typename T> TFrameClass __fastcall GetFrameClass(Fmx::Types::TFmxObject* const AParent, const System::UnicodeString AStandStyleName);
	
public:
	__fastcall virtual TFrameStand(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TFrameStand(void);
	template<typename T> TFrameInfo__1<T>* __fastcall Use(const T AFrame, Fmx::Types::TFmxObject* const AParent = (Fmx::Types::TFmxObject*)(0x0), const System::UnicodeString AStandStyleName = System::UnicodeString());
	template<typename T> TFrameInfo__1<T>* __fastcall New(Fmx::Types::TFmxObject* const AParent = (Fmx::Types::TFmxObject*)(0x0), const System::UnicodeString AStandStyleName = System::UnicodeString());
	HIDESBASE void __fastcall Remove(Fmx::Forms::TFrame* AFrame);
	__property int Count = {read=GetCount, nodefault};
	__property TCommonActionDictionary* CommonActions = {read=FCommonActions};
	__property System::Generics::Collections::TObjectDictionary__2<Fmx::Forms::TFrame*,TFrameInfo__1<Fmx::Forms::TFrame*>*>* FrameInfos = {read=FFrameInfos};
	
__published:
	__property System::UnicodeString AnimationShow = {read=FAnimationShow, write=FAnimationShow};
	__property System::UnicodeString AnimationHide = {read=FAnimationHide, write=FAnimationHide};
	__property Fmx::Actnlist::TActionList* CommonActionList = {read=FCommonActionList, write=FCommonActionList};
	__property System::UnicodeString CommonActionPrefix = {read=FCommonActionPrefix, write=FCommonActionPrefix};
	__property System::UnicodeString DefaultStyleName = {read=FDefaultStyleName, write=FDefaultStyleName};
	__property Fmx::Types::TFmxObject* DefaultParent = {read=FDefaultParent, write=FDefaultParent};
	__property Fmx::Controls::TStyleBook* StyleBook = {read=FStyleBook, write=FStyleBook};
	__property TOnBeforeShowEvent OnAfterHide = {read=FOnAfterHide, write=FOnAfterHide};
	__property TOnBeforeShowEvent OnBeforeShow = {read=FOnBeforeShow, write=FOnBeforeShow};
	__property TOnBeforeStartAnimationEvent OnBeforeStartAnimation = {read=FOnBeforeStartAnimation, write=FOnBeforeStartAnimation};
	__property TOnBindCommonActionList OnBindCommonActionList = {read=FOnBindCommonActionList, write=FOnBindCommonActionList};
	__property TOnGetFrameClassEvent OnGetFrameClass = {read=FOnGetFrameClass, write=FOnGetFrameClass};
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
