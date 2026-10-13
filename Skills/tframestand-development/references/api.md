# API at a glance (declarations)

Units: `SubjectStand` (base classes, enums, lifecycle and context attributes), `FrameStand` (TFrameStand, TFrameInfo<T>, `[FrameInfo]`, `[FrameStand]`), `FormStand` (TFormStand, TFormInfo<T>, `[FormInfo]`, `[FormStand]`, `[Align]`, `[ClipChildren]`), `ResponsiveContainer` (TBreakpoint, TResponsiveDefinition: needed only to use `TResponsiveDefinition` or `TBreakpoint` explicitly), `System.UITypes` (`TModalResult`, `mrOk`, `vkHardwareBack`).

```pascal
// unit SubjectStand
type
  TSubject = TFmxObject;
  ESubjectStandError = class(Exception);
  TBackKeyAction = (baNone, baHide, baHideAndClose, baPop);
  TPushMode = (pmHide, pmKeepVisible, pmClose);
  TStackOperation = (soNone, soPush, soPop);
  TResponsiveMode = (rmOnCreate, rmLive);

  TSubjectInfo = class                       // base of TFrameInfo<T> and TFormInfo<T>
    procedure SubjectShow;                   // TFrameInfo<T>/TFormInfo<T> publish it as Show
    function Hide(const ADelay: Integer = 0; const AThen: TProc = nil): Boolean;
    procedure HideAndClose(const ADeferExecutionMS: Integer = 0; const AThen: TProc = nil);
    procedure HideAndCloseAfter(const ADelayMS: Integer);
    procedure Close;
    procedure ShowModal(const AResultProc: TProc<TModalResult>; const AClose: Boolean = True); overload;
    procedure DefaultShow; procedure DefaultHide;     // for your [Show] / [Hide] methods
    property Subject: TSubject; property Stand: TControl; property Container: TFmxObject;
    property Parent: TFmxObject; property StandStyleName: string; property Status: TSubjectStatus;
    property IsVisible: Boolean; property Hiding: Boolean;
    property ModalResult: TModalResult;      // read/write
    property IsModal: Boolean;               // read-only
    property BackKeyAction: TBackKeyAction;  // read/write, default baNone
  end;

  TSubjectStand = class(TComponent)          // base of TFrameStand and TFormStand
    procedure CloseAll; procedure HideAndCloseAll; // + overloads with TClass / TArray<TClass>, *Except
    function HandleBackKey(var AKey: Word; var AKeyChar: Char): Boolean;
    function Pop: Boolean;
    function PopToRoot: Boolean;
    property CommonActions: TCommonActionDictionary<TSubjectInfo>; // .Add(APattern: string; AAction: TProc<TSubjectInfo>)
    property Responsive: TResponsiveContainer;
    property StackCount: Integer; property StackTop: TSubjectInfo; property StackOperation: TStackOperation;
  published
    property StandBook: TStyleBook; property DefaultStandName: string; property DefaultParent: TFmxObject;
    property AnimationShow, AnimationHide: string;
    property CommonActionList: TActionList; property CommonActionPrefix: string;
    property DefaultHideAndCloseDeferTimeMS: Integer;
    property CatchBackKey: Boolean; property PushMode: TPushMode; property ResponsiveMode: TResponsiveMode;
    property OnBeforeShow, OnAfterShow, OnBeforeHide, OnAfterHide: TOnAfterShowEvent;
    property OnBeforeStartAnimation: TOnBeforeStartAnimationEvent;
    property OnResponsiveChange: TOnResponsiveChangeEvent;
  end;

  TOnAfterShowEvent = procedure(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo) of object;
  TOnBeforeStartAnimationEvent = procedure(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo;
    const AAnimation: TAnimation) of object;  // TAnimation: FMX.Types
  TOnResponsiveChangeEvent = procedure(const ASender: TSubjectStand; const AInfo: TSubjectInfo;
    const AOldSubject: TSubject) of object;

// unit FrameStand (TFormStand: same with Form/TForm/TFormInfo<T>)
  TFrameInfo<T: TFrame> = class(TSubjectInfo)
    procedure Show;
    procedure ShowModal(const AResultProc: TProc<T, TModalResult>; const AClose: Boolean = True); overload;
    property Frame: T; property FrameIsOwned: Boolean; property FrameStand: TFrameStand;
  end;
  TFrameStand = class(TSubjectStandBase<TFrame, TFrameInfo<TFrame>>)
    function New<T: TFrame>(const AParent: TFmxObject = nil; const AStandStyleName: string = ''): TFrameInfo<T>;
    function Use<T: TFrame>(const AFrame: T; const AParent: TFmxObject = nil; const AStandStyleName: string = ''): TFrameInfo<T>;
    function NewAndShow<T: TFrame>(const AParent: TFmxObject = nil; const AStandStyleName: string = '';
      const AConfigProc: TProc<T> = nil; const AConfigFIProc: TProc<TFrameInfo<T>> = nil): TFrameInfo<T>;
    function Push<T: TFrame>(const AParent: TFmxObject = nil; const AStandStyleName: string = '';
      const AConfigProc: TProc<T> = nil): TFrameInfo<T>;
    function FrameInfo<T: TFrame>: TFrameInfo<T>; function GetFrameInfo<T: TFrame>(...): TFrameInfo<T>;
    property FrameInfos: TObjectDictionary<TFrame, TFrameInfo<TFrame>>; property VisibleFrames: TList<TFrame>;
  published
    property OnGetSubjectClass: TOnGetFrameClassEvent;
  end;

// unit ResponsiveContainer
  TResponsiveContainer.AddBreakpoint(const AWidth: Single; const AName: string);
  TResponsiveContainer.Define(const ASourceSubjectClass, ATargetSubjectClass: TSubjectClass; const ABreakpoint: string);
  TResponsiveContainer.Define(const ASourceDef, ATargetDef: TResponsiveDefinition; const ABreakpoint: string);
  TResponsiveDefinition.Create(const ASubjectClass: TSubjectClass; const AStandName: string = ''; ...);
  TResponsiveContainer.CurrentBreakpoint(const AWidth: Single): TBreakpoint;   // .Name, .MaxWidth
```

Attributes are classes with the `Attribute` suffix (`FrameInfoAttribute`, `AlignAttribute`...): write them with or without it. `[Align(TAlignLayout.Left)]` is `FormStand.AlignAttribute`.

## Behaviors the declarations don't tell

- A definition applies **from its breakpoint up** (this breakpoint or larger); with several, the last defined that matches wins: define `sm` then `lg`, no need to repeat for `md`.
- `CatchBackKey` hooks the `OnKeyDown` the form has when the component is loaded (or when `CatchBackKey` is set), and calls it for the keys it does not handle: assigning `OnKeyDown` before is fine, assigning it afterwards replaces the hook. Calling `HandleBackKey` from your handler on a component that also has `CatchBackKey` does not act twice: the hook clears the key first.
- Frames and forms are designed with their `.fmx`: `New<T>` calls `T.Create(nil)`, which loads the resource (a TFrame/TForm descendant without `{$R *.fmx}` raises `EResNotFound`).
- Lifecycle methods may have no parameters or only context-attributed ones.
