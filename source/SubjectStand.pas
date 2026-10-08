(*
  Copyright 2019, TSubjectStand

  Author:
    Andrea Magni <andrea(dot)magni(at)gmail(dot)com>
*)
unit SubjectStand;

{$IF CompilerVersion < 34.0}
  {$MESSAGE FATAL 'TFrameStand requires Delphi 10.4 Sydney or later'}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Masks, System.Threading
, Generics.Collections
, FMX.Controls, FMX.Types, FMX.Forms, FMX.Ani
, System.Actions, FMX.ActnList
, DeviceAndPlatformInfo, ResponsiveContainer
;

type
  /// <summary>Raised when the context of a subject cannot be injected.</summary>
  ESubjectStandError = class(Exception);

  SubjectStandCustomAttribute = class(TCustomAttribute);

  ContextAttribute = class(SubjectStandCustomAttribute);
  SubjectStandAttribute = class(ContextAttribute);
  StandAttribute = class(ContextAttribute);
  ContainerAttribute = class(ContextAttribute);
  SubjectInfoAttribute = class(ContextAttribute);
  ParentAttribute = class(ContextAttribute);
//  SubjectIsOwnedAttribute = class(ContextAttribute);

  BeforeShowAttribute = class(SubjectStandCustomAttribute);
  AfterShowAttribute = class(SubjectStandCustomAttribute);
  ShowAttribute = class(SubjectStandCustomAttribute);
  HideAttribute = class(SubjectStandCustomAttribute);

  TSubject = TFmxObject;
  TSubjectClass = class of TSubject;

  TSubjectStand = class; //fwd

  /// <summary>A delayed action scheduled with TDelayedAction.Schedule.</summary>
  IDelayedAction = interface
    ['{2ECED4AE-D92A-4F2E-BA3F-15348B22095B}']
    function GetPending: Boolean;
    /// <summary>Cancels the action if it has not run yet (main thread only).</summary>
    procedure Cancel;
    property Pending: Boolean read GetPending;
  end;

  /// <summary>Runs a procedure in the main thread after a delay, using the
  /// FMX platform timer (no background thread involved).</summary>
  TDelayedAction = class
  public
    /// <summary>Runs AAction after ADelay ms (immediately, in the calling
    /// thread, when ADelay is 0).</summary>
    class procedure Execute(const ADelay: Integer; const AAction: TProc);
    /// <summary>Same as Execute, returns a handle to cancel the action.</summary>
    class function Schedule(const ADelay: Integer; const AAction: TProc): IDelayedAction;
  end;

  /// <summary>Tells callbacks whether the object that scheduled them still exists.</summary>
  ILifeGuard = interface
    ['{8D7971D3-0B0D-4AFF-AEFC-29FCAE7B2EF9}']
    function IsAlive: Boolean;
    procedure Kill;
  end;

  TSubjectStatus = (Initializing, Ready, Showing, Visible, Hiding, Hidden, Closing);

  TSubjectInfo = class
  private
    FSubjectStand: TSubjectStand;
    FStand: TControl;
    FParent: TFmxObject;
    FCustomBeforeShowMethods: TArray<TRttiMethod>;
    FCustomAfterShowMethods: TArray<TRttiMethod>;
    FCustomShowMethods: TArray<TRttiMethod>;
    FCustomHideMethods: TArray<TRttiMethod>;
    FContainer: TFmxObject;
    FStandStyleName: string;
    FHiding: Boolean;
    FStatus: TSubjectStatus;
    FGuard: ILifeGuard;
    FPendingActions: TList<IDelayedAction>;
    FHideContinuations: TList<TProc>;
    FCloseRequested: Boolean;
    FCloseContinuations: TList<TProc>;
    FTearingDown: Boolean;
    FDeferStandFree: Boolean;
    function GetIsVisible: Boolean;
  protected
    function GetSubject: TSubject; virtual; abstract;
    procedure SetSubject(const Value: TSubject); virtual; abstract;
    function GetSubjectIsOwned: Boolean; virtual; abstract;
    procedure SetSubjectIsOwned(const Value: Boolean); virtual; abstract;

    function BindCommonActions(const AObject: TFmxObject): Boolean; virtual;
    function BindCommonActionList(const AObject: TFmxObject): Boolean; virtual;

    function HasAttribute<A: TCustomAttribute>(ARttiObject: TRttiObject): A;
    function FindActionProperty(AObject: TObject): TRttiInstanceProperty; virtual;
    procedure InjectContext; virtual;
    procedure InjectContextAttribute(const AAttribute: ContextAttribute;
      const AField: TRttiField; const AFieldClassType: TClass); virtual;
    /// <summary>The object a context attribute refers to, for a field or a
    /// parameter of type AType. False if the attribute does not apply to
    /// that type. Override to support more attributes.</summary>
    function ResolveContext(const AAttribute: ContextAttribute;
      const AType: TRttiInstanceType; out AObject: TObject): Boolean; virtual;
    function ContextValue(const AObject: TObject; const AType: TRttiInstanceType;
      const AAttribute: ContextAttribute; const ATarget: string): TValue;
    function CustomMethodArguments(const AMethod: TRttiMethod): TArray<TValue>;

    function FireCustomMethods(AMethods: TArray<TRttiMethod>): Boolean; virtual;
    function FireCustomBeforeShowMethods: Boolean; virtual;
    function FireCustomAfterShowMethods: Boolean; virtual;
    function FireCustomShowMethods: Boolean; virtual;
    function FireCustomHideMethods: Boolean; virtual;
    procedure DoBeforeStartAnimation(const AAnimation: TAnimation); virtual;
    function FireAnimations(const AFmxObject: TFmxObject; const APattern: string;
      const AStart: Boolean = True;
      const AOnBeforeStart: TProc<TAnimation> = nil;
      const AOnBeforeStop: TProc<TAnimation> = nil): Boolean;
    function FireShowAnimations: Boolean; virtual;
    function FireHideAnimations(out AHideDelay: Single): Boolean; virtual;
    procedure DoCommonActionClick(Sender: TObject);
    // setup
    procedure SetupStand; virtual;
    procedure SetupStandParent(const AParent: TFmxObject); virtual;
    procedure SetupContainer; virtual;
    procedure SetupSubjectContainer; virtual;
    procedure SetupCommonActions(const AFmxObject: TFmxObject); virtual;
    procedure SetupCustomMethods; virtual;
    // teardown
    procedure TeardownSubjectContainer; virtual;
    procedure TeardownStandParent; virtual;
    procedure TeardownStand; virtual;
    // stand and subject destroyed by someone else (e.g. with their parent)
    procedure WatchComponents; virtual;
    procedure ComponentDestroyed(const AComponent: TComponent); virtual;
    class function IsUsable(const AObject: TFmxObject): Boolean; static;
    procedure DisposeComponent(const AComponent: TComponent);
    // delayed actions: cancelled when the info is destroyed
    procedure Track(const AAction: IDelayedAction);
    procedure CancelPendingActions;
    procedure CompleteHide(const AThen: TProc); virtual;
    procedure CloseAndContinue;
  public
    procedure DefaultShow; virtual;
    procedure DefaultHide; virtual;

    procedure StopAnimations; virtual;

    function SubjectShow(const ABackgroundTask: TProc<TSubjectInfo>;
      const AOnTaskComplete: TProc<TSubjectInfo> = nil;
      const AOnTaskCompleteSynchronized: Boolean = True): ITask; overload; deprecated;

    procedure SubjectShow; overload;

    function Hide(const ADelay: Integer = 0; const AThen: TProc = nil): Boolean;
    procedure HideAndClose(const ADeferExecutionMS: Integer = 0; const AThen: TProc = nil);
    procedure Close();

    constructor Create(const ASubjectStand: TSubjectStand; const ASubject: TSubject;
      const AParent: TFmxObject; const AStandStyleName: string); virtual;
    destructor Destroy; override;

    property Subject: TSubject read GetSubject write SetSubject;
    property SubjectIsOwned: Boolean read GetSubjectIsOwned write SetSubjectIsOwned;
    property SubjectStand: TSubjectStand read FSubjectStand;
    property Stand: TControl read FStand write FStand;
    property StandStyleName: string read FStandStyleName;
    property Container: TFmxObject read FContainer write FContainer;
    property Parent: TFmxObject read FParent write FParent;
    property IsVisible: Boolean read GetIsVisible;
    property Hiding: Boolean read FHiding;
    property Status: TSubjectStatus read FStatus;
  end;

  TOnAfterShowEvent = procedure(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo) of object;
  TOnBeforeShowEvent = TOnAfterShowEvent;
  TOnAfterHideEvent = TOnBeforeShowEvent;
  TOnBeforeHideEvent = TOnBeforeShowEvent;
  TOnBeforeStartAnimationEvent = procedure(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo; const AAnimation: TAnimation) of object;
  TOnBindCommonActionList = procedure(ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo; const AObject: TFmxObject; var ACommonActionName: string) of object;

  TCommonActionDictionary<Info: TSubjectInfo> = class
  private
    FDictionary: TDictionary<string, TProc<Info>>;
    FPatterns: TList<string>; // registration order
    function GetCount: Integer;
    function GetKeys: TArray<string>;
  protected
  public
    /// <summary>Registers AAction for the controls matching APattern. Adding
    /// a pattern again replaces its action (it keeps its place in the order).</summary>
    procedure Add(const APattern: string; const AAction: TProc<Info>);
    function TryGetValue(const APattern: string; out AAction: TProc<Info>): Boolean;

    constructor Create; virtual;
    destructor Destroy; override;

    property Count: Integer read GetCount;
    /// <summary>The patterns, in registration order (the order the actions
    /// matching the same control are run).</summary>
    property Keys: TArray<string> read GetKeys;
  end;

  TSubjectStand = class(TComponent)
  private
    FStandBook: TStyleBook;
    FDefaultStandName: string;
    FAnimationHide: string;
    FAnimationShow: string;
    FCommonActions: TCommonActionDictionary<TSubjectInfo>;
    FOnAfterHide: TOnAfterHideEvent;
    FOnBeforeHide: TOnBeforeHideEvent;
    FOnAfterShow: TOnAfterShowEvent;
    FOnBeforeShow: TOnBeforeShowEvent;
    FOnBeforeStartAnimation: TOnBeforeStartAnimationEvent;
    FCommonActionList: TActionList;
    FCommonActionPrefix: string;
    FOnBindCommonActionList: TOnBindCommonActionList;
    FDefaultParent: TFmxObject;
    FResponsive: TResponsiveContainer;
    FDefaultHideAndCloseDeferTimeMS: Integer;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetDefaultParent: TFmxObject; virtual;
    /// <summary>The parent for a new stand: AParent, else DefaultParent, else
    /// the owner when it is a FMX object. Raises ESubjectStandError if none.</summary>
    function ResolveParent(const AParent: TFmxObject): TFmxObject;
    /// <summary>Width (in logical pixels) used for the responsive lookup:
    /// Width of controls and forms, LayerWidth of 3D layers, else a Width
    /// property found through RTTI. Override for other kinds of parents.</summary>
    function GetParentWidth(const AParent: TFmxObject; out AWidth: Single): Boolean; virtual;
    procedure SetStandBook(const AValue: TStyleBook);
    procedure SetCommonActionList(const AValue: TActionList);
    procedure SetDefaultParent(const AValue: TFmxObject);
    function GetStandStyleName(AStandStyleName: string): string;
    function GetCount: Integer; virtual; abstract;
    function GetResponsiveBreakpoint(const AName: string): TBreakpoint;
    function GetResponsiveBreakpoints: TArray<TBreakpoint>;
    procedure SetResponsiveBreakpoints(const ABreakpoints: TArray<TBreakpoint>);
    procedure DoResponsiveLookup(var ASubjectClass: TSubjectClass; var AStandStyleName: string;
      var AParent: TFmxObject);
    procedure DoAfterShow(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo); virtual;
    procedure DoBeforeShow(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo); virtual;
    procedure DoAfterHide(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo); virtual;
    procedure DoBeforeHide(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo); virtual;
    procedure DoClose(const ASubject: TSubject); virtual;
    function GetSubjectInfos: TArray<TSubjectInfo>; virtual; abstract;
    procedure SubjectComponentRemoved(const AComponent: TComponent); virtual;
    /// <summary>True while AInfo belongs to this component (closing a subject
    /// can free others: stands shown inside its controls).</summary>
    function IsRegistered(const AInfo: TSubjectInfo): Boolean;
    /// <summary>Closes (or hides and closes) the subjects whose class is, or
    /// is not, in AClasses: the implementation of the CloseAll* and
    /// HideAndCloseAll* methods.</summary>
    procedure CloseSubjects(const AClasses: TArray<TClass>; const AExcept, AHide: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Remove(ASubject: TSubject); virtual; abstract;
    function DeviceAndPlatformInfo(const AForm: TForm = nil): TDeviceAndPlatformInfo;
    procedure CloseAll; overload; virtual;
    procedure CloseAll(const ARestrictTo: TArray<TClass>); overload; virtual;
    procedure CloseAll(const ARestrictTo: TClass); overload; virtual;
    procedure CloseAllExcept(const AExceptions: TArray<TClass>); overload; virtual;
    procedure CloseAllExcept(const AException: TClass); overload; virtual;
    procedure HideAndCloseAll; overload; virtual;
    procedure HideAndCloseAll(const ARestrictTo: TArray<TClass>); overload; virtual;
    procedure HideAndCloseAll(const ARestrictTo: TClass); overload; virtual;
    procedure HideAndCloseAllExcept(const AExceptions: TArray<TClass>); overload; virtual;
    procedure HideAndCloseAllExcept(const AException: TClass); overload; virtual;

    property Count: Integer read GetCount;
    property CommonActions: TCommonActionDictionary<TSubjectInfo> read FCommonActions;
    property Responsive: TResponsiveContainer read FResponsive;
    property ResponsiveBreakpoints: TArray<TBreakpoint> read GetResponsiveBreakpoints
      write SetResponsiveBreakpoints;
    property ResponsiveBreakpoint[const AName: string]: TBreakpoint read GetResponsiveBreakpoint;
  published
    property AnimationShow: string read FAnimationShow write FAnimationShow;
    property AnimationHide: string read FAnimationHide write FAnimationHide;
    property CommonActionList: TActionList read FCommonActionList write SetCommonActionList;
    property CommonActionPrefix: string read FCommonActionPrefix write FCommonActionPrefix;
    property DefaultHideAndCloseDeferTimeMS: Integer read FDefaultHideAndCloseDeferTimeMS write FDefaultHideAndCloseDeferTimeMS;
    property DefaultStyleName: string read FDefaultStandName write FDefaultStandName stored False; // deprecated: use DefaultStandName
    property DefaultStandName: string read FDefaultStandName write FDefaultStandName;
    property DefaultParent: TFmxObject read FDefaultParent write SetDefaultParent;
    property StyleBook: TStyleBook read FStandBook write SetStandBook stored False; // deprecated: use StandBook
    property StandBook: TStyleBook read FStandBook write SetStandBook;

    // Events
    property OnAfterHide: TOnAfterHideEvent read FOnAfterHide write FOnAfterHide;
    property OnBeforeHide: TOnBeforeHideEvent read FOnBeforeHide write FOnBeforeHide;
    property OnAfterShow: TOnAfterShowEvent read FOnAfterShow write FOnAfterShow;
    property OnBeforeShow: TOnBeforeShowEvent read FOnBeforeShow write FOnBeforeShow;
    property OnBeforeStartAnimation: TOnBeforeStartAnimationEvent read FOnBeforeStartAnimation write FOnBeforeStartAnimation;
    property OnBindCommonActionList: TOnBindCommonActionList read FOnBindCommonActionList write FOnBindCommonActionList;
  end;

  /// <summary>Registry of the subjects of one kind, shared by TFrameStand
  /// (TFrame, TFrameInfo<TFrame>) and TFormStand (TForm, TFormInfo<TForm>):
  /// infos by subject, Show/Hide history, lookups.</summary>
  TSubjectStandBase<S: TSubject; I: TSubjectInfo> = class(TSubjectStand)
  private
    FVisibleSubjects: TList<S>;
  protected
    FInfos: TObjectDictionary<S, I>;
    function GetCount: Integer; override;
    function GetSubjectInfos: TArray<TSubjectInfo>; override;
    procedure DoAfterHide(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo); override;
    procedure DoBeforeShow(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo); override;
    procedure DoClose(const ASubject: TSubject); override;
    procedure AddInfo(const ASubject: S; const AInfo: I);
    function FindInfo(const ASubject: S): I; overload;
    function FindInfo(const AClass: TClass): I; overload;
    function LastShownSubject: S;
    property VisibleSubjects: TList<S> read FVisibleSubjects;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Remove(ASubject: TSubject); override;
  end;

  function ClassInArray(const AObject: TObject; const AArray: TArray<TClass>): Boolean; overload;
  function ClassInArray(const AClass: TClass; const AArray: TArray<TClass>): Boolean; overload;

implementation

uses
    System.TypInfo, FMX.Layouts, FMX.StdCtrls, FMX.Platform
  ;

type
  TLifeGuard = class(TInterfacedObject, ILifeGuard)
  private
    FAlive: Boolean;
  public
    constructor Create;
    function IsAlive: Boolean;
    procedure Kill;
  end;

  TDelayedActionItem = class(TInterfacedObject, IDelayedAction)
  private
    class var FActiveItems: TList<TDelayedActionItem>;
  private
    FAction: TProc;
    FDelay: Integer;
    FPending: Boolean;
    FTimerService: IFMXTimerService;
    FTimerHandle: TFmxHandle;
    FTimerActive: Boolean;
    FSelfRef: IDelayedAction; // keeps the item alive while its timer is active
    procedure Start;
    procedure TimerProc;
    procedure Stop;
  public
    constructor Create(const ADelay: Integer; const AAction: TProc);
    function GetPending: Boolean;
    procedure Cancel;
    class procedure CancelAll;
  end;

{ TLifeGuard }

constructor TLifeGuard.Create;
begin
  inherited Create;
  FAlive := True;
end;

function TLifeGuard.IsAlive: Boolean;
begin
  Result := FAlive;
end;

procedure TLifeGuard.Kill;
begin
  FAlive := False;
end;

{ TDelayedActionItem }

constructor TDelayedActionItem.Create(const ADelay: Integer; const AAction: TProc);
begin
  inherited Create;
  FDelay := ADelay;
  FAction := AAction;
  FPending := True;
end;

function TDelayedActionItem.GetPending: Boolean;
begin
  Result := FPending;
end;

procedure TDelayedActionItem.Start;
var
  LSelf: IDelayedAction;
begin
  if not FPending then
    Exit;

  if TPlatformServices.Current.SupportsPlatformService(IFMXTimerService, FTimerService) then
  begin
    FTimerHandle := FTimerService.CreateTimer(FDelay, TimerProc);
    if FTimerHandle = 0 then // the application is terminating
    begin
      FPending := False;
      FAction := nil;
      Exit;
    end;
    FTimerActive := True;
    FSelfRef := Self;
    FActiveItems.Add(Self);
  end
  else
  begin
    // no FMX timer service (not expected in an FMX application)
    LSelf := Self;
    TThread.CreateAnonymousThread(
      procedure
      begin
        Sleep(FDelay);
        TThread.Queue(nil,
          procedure
          begin
            (LSelf as TDelayedActionItem).TimerProc;
            LSelf := nil;
          end);
      end
    ).Start;
  end;
end;

procedure TDelayedActionItem.Stop;
begin
  if FTimerActive then
  begin
    FTimerActive := False;
    FTimerService.DestroyTimer(FTimerHandle);
    FActiveItems.Remove(Self);
  end;
  FSelfRef := nil; // may free Self: keep it last
end;

procedure TDelayedActionItem.TimerProc;
var
  LKeep: IDelayedAction;
  LAction: TProc;
begin
  LKeep := Self; // Stop releases the self-reference
  Stop;          // one-shot: destroy the platform timer
  if not FPending then
    Exit;
  FPending := False;
  LAction := FAction;
  FAction := nil;
  LAction();
end;

procedure TDelayedActionItem.Cancel;
var
  LKeep: IDelayedAction;
begin
  LKeep := Self;
  FPending := False;
  FAction := nil;
  Stop;
end;

class procedure TDelayedActionItem.CancelAll;
var
  LItem: TDelayedActionItem;
begin
  for LItem in FActiveItems.ToArray do
    LItem.Cancel;
end;

function ClassInArray(const AObject: TObject; const AArray: TArray<TClass>): Boolean;
begin
  Result := False;
  if Assigned(AObject) then
    Result := ClassInArray(AObject.ClassType, AArray);
end;


function ClassInArray(const AClass: TClass; const AArray: TArray<TClass>): Boolean;
var
  LClass: TClass;
begin
  Result := False;
  for LClass in AArray do
    if AClass.InheritsFrom(LClass) then
    begin
      Result := True;
      Break;
    end;
end;

{ TSubjectStand }

procedure TSubjectStand.CloseSubjects(const AClasses: TArray<TClass>;
  const AExcept, AHide: Boolean);
var
  LInfo: TSubjectInfo;
begin
  for LInfo in GetSubjectInfos do
  begin
    // closing a subject frees the subjects shown inside its controls too:
    // skip the infos already gone (do not even read them)
    if not IsRegistered(LInfo) then
      Continue;
    if (Length(AClasses) = 0) or (ClassInArray(LInfo.Subject, AClasses) <> AExcept) then
      if AHide then
        LInfo.HideAndClose
      else
        LInfo.Close;
  end;
end;

function TSubjectStand.IsRegistered(const AInfo: TSubjectInfo): Boolean;
var
  LInfo: TSubjectInfo;
begin
  Result := False;
  for LInfo in GetSubjectInfos do
    if LInfo = AInfo then
      Exit(True);
end;

procedure TSubjectStand.CloseAll(const ARestrictTo: TArray<TClass>);
begin
  CloseSubjects(ARestrictTo, False, False);
end;

procedure TSubjectStand.CloseAllExcept(const AExceptions: TArray<TClass>);
begin
  CloseSubjects(AExceptions, True, False);
end;

procedure TSubjectStand.HideAndCloseAll(const ARestrictTo: TArray<TClass>);
begin
  CloseSubjects(ARestrictTo, False, True);
end;

procedure TSubjectStand.HideAndCloseAllExcept(const AExceptions: TArray<TClass>);
begin
  CloseSubjects(AExceptions, True, True);
end;

procedure TSubjectStand.CloseAll(const ARestrictTo: TClass);
begin
  CloseAll([ARestrictTo]);
end;

procedure TSubjectStand.CloseAll;
begin
  CloseAllExcept([]);
end;

procedure TSubjectStand.CloseAllExcept(const AException: TClass);
begin
  CloseAllExcept([AException]);
end;

constructor TSubjectStand.Create(AOwner: TComponent);
begin
  inherited;
  FDefaultStandName := ClassName.Substring(1).ToLower;
  DefaultHideAndCloseDeferTimeMS := 100;
  FAnimationShow := 'OnShow*';
  FAnimationHide := 'OnHide*';
  FCommonActionPrefix := 'ca_';
  FCommonActions := TCommonActionDictionary<TSubjectInfo>.Create;
  FResponsive := TResponsiveContainer.Create;
end;

destructor TSubjectStand.Destroy;
begin
  FreeAndNil(FCommonActions);
  FreeAndNil(FResponsive);
  inherited;
end;

function TSubjectStand.DeviceAndPlatformInfo(const AForm: TForm): TDeviceAndPlatformInfo;
begin
  Result := TDeviceAndPlatformInfo.Retrieve(AForm);
end;

procedure TSubjectStand.DoAfterHide(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
  if Assigned(FOnAfterHide) then
    FOnAfterHide(ASender, ASubjectInfo);
end;

procedure TSubjectStand.DoAfterShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
   if Assigned(FOnAfterShow) then
    FOnAfterShow(ASender, ASubjectInfo);
end;

procedure TSubjectStand.DoBeforeHide(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
  if Assigned(FOnBeforeHide) then
    FOnBeforeHide(ASender, ASubjectInfo);
end;

procedure TSubjectStand.DoBeforeShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
  if Assigned(FOnBeforeShow) then
    FOnBeforeShow(ASender, ASubjectInfo);
end;

procedure TSubjectStand.DoClose(const ASubject: TSubject);
begin
  Remove(ASubject);
end;

procedure TSubjectStand.DoResponsiveLookup(var ASubjectClass: TSubjectClass;
  var AStandStyleName: string; var AParent: TFmxObject);
var
  FTarget: TResponsiveDefinition;
  LWidth: Single;
begin
  // nothing to look up: any kind of parent is fine
  if not FResponsive.HasDefinitions then
    Exit;

  if not GetParentWidth(AParent, LWidth) then
    raise ESubjectStandError.CreateFmt('%s: responsive definitions need the width '
      + 'of the parent, and a %s has none (override GetParentWidth to provide it)'
    , [ClassName, AParent.ClassName]);

  FTarget := FResponsive.Lookup(
    TResponsiveDefinition.Create(ASubjectClass, AStandStyleName, AParent)
  , FResponsive.CurrentBreakpoint(LWidth).Name);

  ASubjectClass := FTarget.SubjectClass;
  AStandStyleName := FTarget.StandName;
  AParent := FTarget.Parent;
end;

// The referenced components may live elsewhere (another form, a data module)
// and be freed before this one: FreeNotification clears the references.

procedure TSubjectStand.SetCommonActionList(const AValue: TActionList);
begin
  if FCommonActionList = AValue then
    Exit;
  if Assigned(FCommonActionList) then
    FCommonActionList.RemoveFreeNotification(Self);
  FCommonActionList := AValue;
  if Assigned(FCommonActionList) then
    FCommonActionList.FreeNotification(Self);
end;

procedure TSubjectStand.SetDefaultParent(const AValue: TFmxObject);
begin
  if FDefaultParent = AValue then
    Exit;
  if Assigned(FDefaultParent) then
    FDefaultParent.RemoveFreeNotification(Self);
  FDefaultParent := AValue;
  if Assigned(FDefaultParent) then
    FDefaultParent.FreeNotification(Self);
end;

procedure TSubjectStand.SetStandBook(const AValue: TStyleBook);
begin
  if FStandBook = AValue then
    Exit;
  if Assigned(FStandBook) then
    FStandBook.RemoveFreeNotification(Self);
  FStandBook := AValue;
  if Assigned(FStandBook) then
    FStandBook.FreeNotification(Self);
end;

function TSubjectStand.GetDefaultParent: TFmxObject;
begin
  if Assigned(FDefaultParent) then
    Result := FDefaultParent
  else if Owner is TFmxObject then
    Result := TFmxObject(Owner)
  else
    Result := nil; // e.g. owned by a data module
end;

function TSubjectStand.ResolveParent(const AParent: TFmxObject): TFmxObject;
var
  LOwnerName: string;
begin
  Result := AParent;
  if not Assigned(Result) then
    Result := GetDefaultParent;
  if not Assigned(Result) then
  begin
    LOwnerName := 'none';
    if Assigned(Owner) then
      LOwnerName := Owner.ClassName;
    raise ESubjectStandError.CreateFmt('%s: no parent for the stand. Pass AParent, '
      + 'set DefaultParent, or let a FMX object (a form, a frame) own the component '
      + '(owner: %s)', [ClassName, LOwnerName]);
  end;
end;

function TSubjectStand.GetParentWidth(const AParent: TFmxObject; out AWidth: Single): Boolean;

  function ReadNumber(const AType: TRttiType; const AName: string; out ANumber: Single): Boolean;
  var
    LProperty: TRttiProperty;
  begin
    LProperty := AType.GetProperty(AName);
    Result := Assigned(LProperty) and LProperty.IsReadable
      and (LProperty.PropertyType.TypeKind in [tkInteger, tkInt64, tkFloat]);
    if Result then
      if LProperty.PropertyType.TypeKind = tkFloat then
        ANumber := LProperty.GetValue(AParent).AsExtended
      else
        ANumber := LProperty.GetValue(AParent).AsInt64;
  end;

var
  LType: TRttiType;
  LProjection: TRttiProperty;
  LResolution: Single;
begin
  Result := True;
  if AParent is TControl then
    AWidth := TControl(AParent).Width
  else if AParent is TCommonCustomForm then // TForm, TForm3D
    AWidth := TCommonCustomForm(AParent).Width
  else
  begin
    LType := TRttiContext.Create.GetType(AParent.ClassType);
    Result := ReadNumber(LType, 'Width', AWidth);
    // 3D layers (TLayer3D, TTextLayer3D...): Width is in 3D units, their 2D
    // content is Width * Resolution pixels wide, or Width pixels with the
    // Screen projection (TAbstractLayer3D.LayerWidth, which is protected)
    if Result and ReadNumber(LType, 'Resolution', LResolution) then
    begin
      LProjection := LType.GetProperty('Projection');
      if not (Assigned(LProjection)
        and SameText(LProjection.GetValue(AParent).ToString, 'Screen')) then
        AWidth := AWidth * LResolution;
    end;
  end;
end;

function TSubjectStand.GetResponsiveBreakpoint(const AName: string): TBreakpoint;
begin
  Result := Responsive.Breakpoints.ByName(AName);
end;

function TSubjectStand.GetResponsiveBreakpoints: TArray<TBreakpoint>;
begin
  Result := Responsive.Breakpoints.ToArray;
end;

function TSubjectStand.GetStandStyleName(AStandStyleName: string): string;
begin
  Result := DefaultStandName;
  if AStandStyleName <> '' then
    Result := AStandStyleName;
end;

procedure TSubjectStand.HideAndCloseAll;
begin
  HideAndCloseAllExcept([]);
end;

procedure TSubjectStand.HideAndCloseAll(const ARestrictTo: TClass);
begin
  HideAndCloseAll([ARestrictTo]);
end;

procedure TSubjectStand.HideAndCloseAllExcept(const AException: TClass);
begin
  HideAndCloseAllExcept([AException]);
end;

procedure TSubjectStand.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (Operation = TOperation.opRemove) then
  begin
    if (AComponent = FStandBook) then
      FStandBook := nil
    else if (AComponent = FCommonActionList) then
      FCommonActionList := nil
    else if (AComponent = FDefaultParent) then
      FDefaultParent := nil;

    SubjectComponentRemoved(AComponent);
  end;
end;

procedure TSubjectStand.SubjectComponentRemoved(const AComponent: TComponent);
var
  LInfo: TSubjectInfo;
  LSubject: TSubject;
begin
  // a stand or a subject is being destroyed by someone else (typically by
  // FMX, with its parent or its form): forget it and drop the info, without
  // touching the objects already gone
  for LInfo in GetSubjectInfos do
    if (not LInfo.FTearingDown)
      and ((AComponent = LInfo.FStand) or (AComponent = LInfo.Subject)) then
    begin
      LSubject := LInfo.Subject;
      LInfo.ComponentDestroyed(AComponent);
      DoClose(LSubject); // frees LInfo
      Break;
    end;
end;

procedure TSubjectStand.SetResponsiveBreakpoints(
  const ABreakpoints: TArray<TBreakpoint>);
begin
  Responsive.Breakpoints.Clear;
  Responsive.Breakpoints.AddRange(ABreakpoints);
  Responsive.Breakpoints.Sort;
end;

{ TSubjectInfo }

procedure TSubjectInfo.DoBeforeStartAnimation(const AAnimation: TAnimation);
begin
  if Assigned(FSubjectStand) and Assigned(FSubjectStand.OnBeforeStartAnimation) then
    FSubjectStand.OnBeforeStartAnimation(FSubjectStand, Self, AAnimation);
end;

function TSubjectInfo.BindCommonActionList(const AObject: TFmxObject): Boolean;
var
  LProperty: TRttiInstanceProperty;
  LAction: TContainedAction;
  LName, LCommonActionPrefix, LCommonActionName: string;

begin
  Result := False;
  if not Assigned(FSubjectStand.CommonActionList) then
    Exit;

  LCommonActionName := '';
  // stylename or name selection
  LName := AObject.StyleName;
  if LName = '' then
    LName := AObject.Name;

  LCommonActionPrefix := FSubjectStand.CommonActionPrefix;
  // stylename match
  if (LName.StartsWith(LCommonActionPrefix, True)) then
    LCommonActionName := LName.Substring(LCommonActionPrefix.Length);

  // allow custom matching
  if Assigned(FSubjectStand.OnBindCommonActionList) then
    FSubjectStand.OnBindCommonActionList(FSubjectStand, Self, AObject, LCommonActionName);

  if LCommonActionName = '' then
    Exit;

  // has a Action property
  LProperty := FindActionProperty(AObject);
  if not Assigned(LProperty) then
    Exit;

  // bind the corresponding Action, if any
  for LAction in FSubjectStand.CommonActionList do
  begin
    if SameText(LAction.Name, LCommonActionName)  then
    begin
      LProperty.SetValue(AObject, LAction);
      Result := True;
      Break;
    end;
  end;
end;

function TSubjectInfo.BindCommonActions(const AObject: TFmxObject): Boolean;
var
  LCommonActionPattern: string;
begin
  Result := False;
  if not (AObject is TControl) then
    Exit;

  for LCommonActionPattern in SubjectStand.CommonActions.Keys do
  begin
    if ( // matches StyleName or Name (if no StyleName is provided)
         ((AObject.StyleName <> '') and  MatchesMask(AObject.StyleName, LCommonActionPattern))
         or ((AObject.StyleName = '') and  MatchesMask(AObject.Name, LCommonActionPattern))
       )
    then
    begin
      TControl(AObject).OnClick := DoCommonActionClick;
      Result := True;
      Break; // no need to continue since DoCommonActionClick will fire all CommonActions that match
    end;
  end;
end;

procedure TSubjectInfo.Close;
begin
  FStatus := TSubjectStatus.Closing;
  if Assigned(FSubjectStand) then
    FSubjectStand.DoClose(Subject);
end;

constructor TSubjectInfo.Create(const ASubjectStand: TSubjectStand;
  const ASubject: TSubject; const AParent: TFmxObject; const AStandStyleName: string);
begin
  Assert(Assigned(ASubjectStand));
  Assert(Assigned(ASubject));

  inherited Create;

  FGuard := TLifeGuard.Create;
  FPendingActions := TList<IDelayedAction>.Create;
  FHideContinuations := TList<TProc>.Create;
  FCloseContinuations := TList<TProc>.Create;

  FStatus := Initializing;
  FSubjectStand := ASubjectStand;
  Subject := ASubject;
  SubjectIsOwned := False;
  FStandStyleName := AStandStyleName;
  FParent := AParent;

  SetupCustomMethods;
  SetupStand;
  SetupStandParent(AParent);
  SetupContainer;
  SetupSubjectContainer;
  SetupCommonActions(FStand);

  WatchComponents;
  FStatus := Ready;
end;

procedure TSubjectInfo.DefaultHide;
begin
  StopAnimations;
  Stand.Visible := False;
end;

procedure TSubjectInfo.DefaultShow;
begin
  Stand.Visible := True;
  Stand.BringToFront;
end;

destructor TSubjectInfo.Destroy;
begin
  FTearingDown := True;
  // pending hides and closes must not run on a destroyed info
  if Assigned(FGuard) then
    FGuard.Kill;
  CancelPendingActions;

  TeardownSubjectContainer;
  TeardownStandParent;
  TeardownStand;

  FreeAndNil(FCloseContinuations);
  FreeAndNil(FHideContinuations);
  FreeAndNil(FPendingActions);
  inherited;
end;

procedure TSubjectInfo.Track(const AAction: IDelayedAction);
var
  LIndex: Integer;
begin
  for LIndex := FPendingActions.Count - 1 downto 0 do
    if not FPendingActions[LIndex].Pending then
      FPendingActions.Delete(LIndex);
  if Assigned(AAction) and AAction.Pending then
    FPendingActions.Add(AAction);
end;

procedure TSubjectInfo.CancelPendingActions;
var
  LAction: IDelayedAction;
begin
  if not Assigned(FPendingActions) then
    Exit;
  for LAction in FPendingActions.ToArray do
    LAction.Cancel;
  FPendingActions.Clear;
end;

procedure TSubjectInfo.DoCommonActionClick(Sender: TObject);
var
  LName: string;
  LObj: TFmxObject;
  LPattern: string;
  LAction: TProc<TSubjectInfo>;
  LGuard: ILifeGuard;
  LCommonActions: TCommonActionDictionary<TSubjectInfo>;
begin
  LObj := TFmxObject(Sender);
  LName := LObj.StyleName;
  if LName = '' then
    LName := LObj.Name;

  LGuard := FGuard;
  LCommonActions := SubjectStand.CommonActions;
  // registration order; an action may close (free) this info: stop there
  for LPattern in LCommonActions.Keys do
  begin
    if not LGuard.IsAlive then
      Break;
    if MatchesMask(LName, LPattern) and LCommonActions.TryGetValue(LPattern, LAction) then
      LAction(Self);
  end;
end;

procedure TSubjectInfo.SetupCommonActions(const AFmxObject: TFmxObject);
var
  LChild: TFmxObject;
begin
  Assert(Assigned(AFmxObject));

  if (SubjectStand.CommonActions.Count = 0) and not Assigned(SubjectStand.CommonActionList) then
    Exit;

  if not Assigned(AFmxObject.Children) then
    Exit;

  for LChild in AFmxObject.Children do
  begin
    BindCommonActions(LChild);
    BindCommonActionList(LChild);

    if LChild.ChildrenCount > 0 then // recursion
      SetupCommonActions(LChild);
  end;
end;

procedure TSubjectInfo.SetupCustomMethods;
var
  LRttiContext: TRttiContext;
  LType: TRttiType;
  LMethod: TRttiMethod;
begin
  LRttiContext := TRttiContext.Create;
  LType := LRttiContext.GetType(Subject.ClassInfo);

  FCustomBeforeShowMethods := [];
  FCustomAfterShowMethods := [];
  FCustomShowMethods := [];
  FCustomHideMethods := [];
  for LMethod in LType.GetMethods do
  begin
    if HasAttribute<BeforeShowAttribute>(LMethod) <> nil then
      FCustomBeforeShowMethods := FCustomBeforeShowMethods + [LMethod];

    if HasAttribute<AfterShowAttribute>(LMethod) <> nil then
      FCustomAfterShowMethods := FCustomAfterShowMethods + [LMethod];

    if HasAttribute<ShowAttribute>(LMethod) <> nil then
      FCustomShowMethods := FCustomShowMethods + [LMethod];

    if HasAttribute<HideAttribute>(LMethod) <> nil then
      FCustomHideMethods := FCustomHideMethods + [LMethod];
  end;
end;

function TSubjectInfo.FireAnimations(const AFmxObject: TFmxObject;
  const APattern: string; const AStart: Boolean = True;
  const AOnBeforeStart: TProc<TAnimation> = nil;
  const AOnBeforeStop: TProc<TAnimation> = nil
): Boolean;
var
  LChild: TFmxObject;
begin
  Result := False;
  if APattern = '' then
    Exit;

  if Assigned(AFmxObject.Children) then
  begin
    for LChild in AFmxObject.Children do
    begin
      if (LChild is TAnimation)
         and ( // matches StyleName or Name (if no StyleName is provided)
            ((LChild.StyleName <> '') and  MatchesMask(LChild.StyleName, APattern))
         or ((LChild.StyleName = '') and  MatchesMask(LChild.Name, APattern))
         )
      then
      begin
        Result := True;
        if AStart then
        begin
          DoBeforeStartAnimation(TAnimation(LChild));
          if Assigned(AOnBeforeStart) then
            AOnBeforeStart(TAnimation(LChild));

          TAnimation(LChild).Start;
        end
        else
        begin
          if Assigned(AOnBeforeStop) then
            AOnBeforeStop(TAnimation(LChild));
          TAnimation(LChild).Stop;
        end;
      end
      else if LChild.ChildrenCount > 0 then // recursion
      begin
        if FireAnimations(LChild, APattern, AStart, AOnBeforeStart, AOnBeforeStop) then
          Result := True;
      end;
    end;
  end;
end;

function TSubjectInfo.FireCustomAfterShowMethods: Boolean;
begin
  Result := FireCustomMethods(FCustomAfterShowMethods);
end;

function TSubjectInfo.FireCustomBeforeShowMethods: Boolean;
begin
  Result := FireCustomMethods(FCustomBeforeShowMethods);
end;

function TSubjectInfo.FireCustomHideMethods: Boolean;
begin
  Result := FireCustomMethods(FCustomHideMethods);
end;

function TSubjectInfo.FireCustomMethods(
  AMethods: TArray<TRttiMethod>): Boolean;
var
  LMethod: TRttiMethod;
begin
  Result := False;
  for LMethod in AMethods do
  begin
    Result := True;
    LMethod.Invoke(Subject, CustomMethodArguments(LMethod));
  end;
end;

function TSubjectInfo.CustomMethodArguments(const AMethod: TRttiMethod): TArray<TValue>;
var
  LParameter: TRttiParameter;
  LAttribute: ContextAttribute;
  LObject: TObject;
begin
  Result := [];
  for LParameter in AMethod.GetParameters do
  begin
    LAttribute := nil;
    if Assigned(LParameter.ParamType) and LParameter.ParamType.IsInstance then
      LAttribute := HasAttribute<ContextAttribute>(LParameter);

    if not (Assigned(LAttribute)
      and ResolveContext(LAttribute, TRttiInstanceType(LParameter.ParamType), LObject))
    then
      raise ESubjectStandError.CreateFmt(
        '%s.%s: cannot inject parameter %s. Parameters of [BeforeShow], [Show], '
        + '[AfterShow] and [Hide] methods must be objects marked with a context '
        + 'attribute: [SubjectStand], [SubjectInfo], [Stand], [Parent], [Container], '
        + 'or the stand/info attribute of the component ([FrameStand], [FrameInfo], '
        + '[FormStand], [FormInfo]) with a compatible type'
      , [Subject.ClassName, AMethod.Name, LParameter.Name]);

    Result := Result + [ContextValue(LObject, TRttiInstanceType(LParameter.ParamType)
      , LAttribute, Format('parameter %s of %s', [LParameter.Name, AMethod.Name]))];
  end;
end;

function TSubjectInfo.FireCustomShowMethods: Boolean;
begin
  Result := FireCustomMethods(FCustomShowMethods);
end;

function TSubjectInfo.FireHideAnimations(out AHideDelay: Single): Boolean;
var
  LHideDelay: Single;
begin
  LHideDelay := 0;
  Result := FireAnimations(FStand, FSubjectStand.AnimationHide, True,
     procedure (AAnimation: TAnimation)
     var
       LThisAnimationTime: Single;
     begin
       LThisAnimationTime := AAnimation.Delay + AAnimation.Duration;

       if LThisAnimationTime > LHideDelay then
         LHideDelay := LThisAnimationTime;
     end
  );

  AHideDelay := LHideDelay;
end;

function TSubjectInfo.FireShowAnimations: Boolean;
begin
  Result := FireAnimations(FStand, FSubjectStand.AnimationShow);
end;


function TSubjectInfo.GetIsVisible: Boolean;
begin
  Result := Assigned(FStand) and FStand.Visible;
end;

function TSubjectInfo.FindActionProperty(AObject: TObject): TRttiInstanceProperty;
var
  LProperty: TRttiProperty;
begin
  Result := nil;
  LProperty := TRttiContext.Create.GetType(AObject.ClassType).GetProperty('Action');
  if Assigned(LProperty)
     and (LProperty is TRttiInstanceProperty)
     and (TRttiInstanceProperty(LProperty).PropertyType is TRttiInstanceType)
     and TRttiInstanceType(TRttiInstanceProperty(LProperty).PropertyType).MetaclassType.InheritsFrom(TBasicAction)
  then
    Result := TRttiInstanceProperty(LProperty);
end;

function TSubjectInfo.HasAttribute<A>(ARttiObject: TRttiObject): A;
var
  LAttribute: TCustomAttribute;
begin
  Result := nil;
  for LAttribute in ARttiObject.GetAttributes do
  begin
    if LAttribute is A then
    begin
      Result := A(LAttribute);
      Break;
    end;
  end;
end;


function TSubjectInfo.Hide(const ADelay: Integer = 0; const AThen: TProc = nil): Boolean;
var
  LAutoDelayS: Single;
  LDelay: Integer;
  LGuard: ILifeGuard;
begin
  Result := False;
  if FHiding then
  begin
    // a hide is already in progress: AThen runs when it completes
    if Assigned(AThen) then
      FHideContinuations.Add(AThen);
    Exit;
  end;

  LGuard := FGuard;
  if Assigned(SubjectStand) then
    SubjectStand.DoBeforeHide(SubjectStand, Self);
  if not LGuard.IsAlive then // closed by OnBeforeHide
    Exit;

  FStatus := TSubjectStatus.Hiding;
  Result := True;
  FHiding := True;

  FireHideAnimations(LAutoDelayS);
  LDelay := Round(LAutoDelayS * 1000);
  if ADelay <> 0 then
    LDelay := ADelay;

  if LDelay <= 0 then
    CompleteHide(AThen)
  else
    Track(TDelayedAction.Schedule(LDelay
    , procedure
      begin
        CompleteHide(AThen);
      end
    ));
end;

procedure TSubjectInfo.CompleteHide(const AThen: TProc);
var
  LGuard: ILifeGuard;
  LSubjectStand: TSubjectStand;
  LContinuations: TArray<TProc>;
  LContinuation: TProc;
begin
  LGuard := FGuard;
  if not FireCustomHideMethods then
    DefaultHide;
  if not LGuard.IsAlive then // closed by a [Hide] method
    Exit;

  FHiding := False;
  FStatus := TSubjectStatus.Hidden;
  LContinuations := FHideContinuations.ToArray;
  FHideContinuations.Clear;
  LSubjectStand := SubjectStand;

  // AThen and the continuations may close (free) this info: from here on,
  // check LGuard before touching Self
  if Assigned(AThen) then
    AThen();
  for LContinuation in LContinuations do
    LContinuation();

  if LGuard.IsAlive and Assigned(LSubjectStand) then
    LSubjectStand.DoAfterHide(LSubjectStand, Self);
end;

procedure TSubjectInfo.HideAndClose(const ADeferExecutionMS: Integer; const AThen: TProc);
var
  LDeferExecutionMS: Integer;
  LGuard: ILifeGuard;
begin
  if Assigned(AThen) then
    FCloseContinuations.Add(AThen);
  if FCloseRequested then // already hiding and closing: AThen runs after that close
    Exit;
  FCloseRequested := True;

  LDeferExecutionMS := 100;
  if Assigned(SubjectStand) then
    LDeferExecutionMS := SubjectStand.DefaultHideAndCloseDeferTimeMS;
  if ADeferExecutionMS <> 0 then
    LDeferExecutionMS := ADeferExecutionMS;

  LGuard := FGuard;
  // if a Hide is already in progress, this continuation runs when it completes
  Hide(0
  , procedure
    begin
      if not LGuard.IsAlive then
        Exit;
      if LDeferExecutionMS <= 0 then
        CloseAndContinue
      else
        Track(TDelayedAction.Schedule(LDeferExecutionMS
        , procedure
          begin
            CloseAndContinue;
          end
        ));
    end
  );
end;

procedure TSubjectInfo.CloseAndContinue;
var
  LContinuations: TArray<TProc>;
  LContinuation: TProc;
begin
  LContinuations := FCloseContinuations.ToArray;
  FCloseContinuations.Clear;
  Close; // frees Self
  for LContinuation in LContinuations do
    LContinuation();
end;

procedure TSubjectInfo.InjectContext;
var
  LType: TRttiType;
  LField: TRttiField;
  LAttribute: ContextAttribute;
  LMethod: TRttiMethod;
begin
  LType := TRttiContext.Create.GetType(Subject.ClassInfo);

  // enumerate type's fields
  for LField in LType.GetFields do
  begin
    // only consider object types
    if Assigned(LField.FieldType) and LField.FieldType.IsInstance then
    begin
      LAttribute := HasAttribute<ContextAttribute>(LField);
      if Assigned(LAttribute) then
        InjectContextAttribute(LAttribute, LField, TRttiInstanceType(LField.FieldType).MetaclassType);
    end;
  end;

  // check the parameters of the lifecycle methods now, rather than at Show/Hide
  for LMethod in FCustomBeforeShowMethods + FCustomShowMethods
    + FCustomAfterShowMethods + FCustomHideMethods
  do
    CustomMethodArguments(LMethod);
end;

procedure TSubjectInfo.InjectContextAttribute(const AAttribute: ContextAttribute;
  const AField: TRttiField; const AFieldClassType: TClass);
var
  LObject: TObject;
begin
  // attributes that do not apply to the type of the field are ignored
  if ResolveContext(AAttribute, TRttiInstanceType(AField.FieldType), LObject) then
    AField.SetValue(TObject(Subject), ContextValue(LObject
      , TRttiInstanceType(AField.FieldType), AAttribute, 'field ' + AField.Name));
end;

function TSubjectInfo.ResolveContext(const AAttribute: ContextAttribute;
  const AType: TRttiInstanceType; out AObject: TObject): Boolean;
var
  LClass: TClass;
begin
  AObject := nil;
  LClass := AType.MetaclassType;
  Result := True;
  if (AAttribute is SubjectStandAttribute) and LClass.InheritsFrom(TSubjectStand) then
    AObject := SubjectStand
  else if (AAttribute is StandAttribute) and LClass.InheritsFrom(TControl) then
    AObject := Stand
  else if (AAttribute is ParentAttribute) and LClass.InheritsFrom(TFmxObject) then
    AObject := Parent
  else if (AAttribute is SubjectInfoAttribute)
    and (InheritsFrom(LClass) or LClass.InheritsFrom(TSubjectInfo)) then
    AObject := Self
  // [Container], [Context] (and, as before, any other context attribute on a
  // TFmxObject) give the container
  else if LClass.InheritsFrom(TFmxObject)
    and not ((AAttribute is SubjectStandAttribute) or (AAttribute is StandAttribute)
      or (AAttribute is ParentAttribute) or (AAttribute is SubjectInfoAttribute)) then
    AObject := Container
  else
    Result := False;
end;

function TSubjectInfo.ContextValue(const AObject: TObject;
  const AType: TRttiInstanceType; const AAttribute: ContextAttribute;
  const ATarget: string): TValue;
var
  LObject: TObject;
  LAttributeName, LHint: string;
begin
  if Assigned(AObject) and not AObject.InheritsFrom(AType.MetaclassType) then
  begin
    LAttributeName := AAttribute.ClassName;
    if LAttributeName.EndsWith('Attribute') then
      LAttributeName := LAttributeName.Substring(0, LAttributeName.Length - Length('Attribute'));
    LHint := '';
    // generic infos are unrelated types: TFrameInfo<TBase> (a TDerived frame
    // created by New<TBase>, e.g. through responsive substitution) does not
    // fit a TFrameInfo<TDerived>
    if AObject is TSubjectInfo then
      LHint := Format(' (declare it as %s or TSubjectInfo)', [AObject.ClassName]);
    raise ESubjectStandError.CreateFmt('%s: cannot inject [%s] into %s: '
      + 'the value is a %s, the declared type is %s%s'
    , [Subject.ClassName, LAttributeName, ATarget, AObject.ClassName, AType.Name, LHint]);
  end;

  LObject := AObject;
  TValue.Make(@LObject, AType.Handle, Result);
end;

function TSubjectInfo.SubjectShow(const ABackgroundTask: TProc<TSubjectInfo>;
  const AOnTaskComplete: TProc<TSubjectInfo> = nil;
  const AOnTaskCompleteSynchronized: Boolean = True
): ITask;
begin
  SubjectShow();

  if Assigned(ABackgroundTask) then
  begin
    Result := TTask.Create(
      procedure
      begin
        ABackgroundTask(Self);

        if Assigned(AOnTaskComplete) then
        begin
          if AOnTaskCompleteSynchronized then
            TThread.Synchronize(nil,
              procedure
              begin
                AOnTaskComplete(Self);
              end
            )
          else
            AOnTaskComplete(Self);
        end;
      end
    ).Start;
  end;
end;

procedure TSubjectInfo.SetupContainer;
begin
  Assert(Assigned(FStand));

  FContainer := FStand.FindStyleResource('container');
  if not Assigned(FContainer) then
    FContainer := FStand;
end;

procedure TSubjectInfo.SetupStand;
begin
  FStand := nil;
  if Assigned(FSubjectStand.StandBook) and Assigned(FSubjectStand.StandBook.Style) then
    FStand := FSubjectStand.StandBook.Style.FindStyleResource(FStandStyleName, True) as TControl;
  if not Assigned(FStand) then
  begin
    FStand := TLayout.Create(nil);
    FStand.Align := TAlignLayout.Contents;
    FStand.StyleName := 'container';
  end;
  // See https://github.com/andrea-magni/TSubjectStand/issues/12
  // also see https://quality.embarcadero.com/browse/RSP-14806
  FStand.Align := TAlignLayout.Contents;
  FStand.Visible := False;
end;

procedure TSubjectInfo.SetupStandParent(const AParent: TFmxObject);
begin
  if Assigned(FParent) and Assigned(FStand) then
    FParent.AddObject(FStand); // move to SetParent?
end;

procedure TSubjectInfo.SetupSubjectContainer;
begin
  Assert(Assigned(FContainer));

  FContainer.AddObject(Subject);
end;

procedure TSubjectInfo.StopAnimations;
begin
  // FMX does not like if you free an object when animation are still running,
  // so stop them all
  FireAnimations(FStand, FSubjectStand.AnimationHide, False);
  FireAnimations(FStand, FSubjectStand.AnimationShow, False);
end;

procedure TSubjectInfo.SubjectShow;
begin
  FStatus := TSubjectStatus.Showing;

  FireCustomBeforeShowMethods;
  if Assigned(SubjectStand) then
    SubjectStand.DoBeforeShow(SubjectStand, Self);

  if not FireCustomShowMethods then
    DefaultShow;
  FireShowAnimations;

  FStatus := TSubjectStatus.Visible;

  FireCustomAfterShowMethods;
  if Assigned(SubjectStand) then
    SubjectStand.DoAfterShow(SubjectStand, Self);
end;

// Objects destroyed by someone else have already been reported through
// ComponentDestroyed (references cleared); objects being destroyed right now
// (csDestroying) are left to their destructor.

class function TSubjectInfo.IsUsable(const AObject: TFmxObject): Boolean;
begin
  Result := Assigned(AObject) and not (csDestroying in AObject.ComponentState);
end;

procedure TSubjectInfo.DisposeComponent(const AComponent: TComponent);
begin
  AComponent.RemoveFreeNotification(FSubjectStand);
  AComponent.Free;
end;

procedure TSubjectInfo.TeardownStand;
var
  LStand: TControl;
begin
  if IsUsable(FStand) then
  begin
    if FDeferStandFree then
    begin
      // the subject is being destroyed and still references the stand (its
      // former parent): detach the stand now, free it once the subject is gone
      LStand := FStand;
      LStand.RemoveFreeNotification(FSubjectStand);
      LStand.Visible := False;
      LStand.Parent := nil;
      TThread.ForceQueue(nil
      , procedure
        begin
          LStand.Free;
        end
      );
    end
    else
      DisposeComponent(FStand); // also removes it from its parent
  end;
  FStand := nil;
  FContainer := nil;
end;

procedure TSubjectInfo.TeardownStandParent;
begin
  // the stand is a child of the parent: if the stand is usable, so is the parent
  if IsUsable(FStand) and IsUsable(FParent) and (FStand.Parent = FParent) then
    FParent.RemoveObject(FStand);
  FParent := nil;
end;

procedure TSubjectInfo.TeardownSubjectContainer;
begin
  if not IsUsable(Subject) then
    Exit;

  if SubjectIsOwned then
  begin
    DisposeComponent(Subject);
    Subject := nil;
  end
  else
  begin
    Subject.RemoveFreeNotification(FSubjectStand);
    if IsUsable(FStand) and IsUsable(FContainer) then
      FContainer.RemoveObject(Subject);
  end;
end;

procedure TSubjectInfo.WatchComponents;
begin
  if Assigned(FStand) then
    FStand.FreeNotification(FSubjectStand);
  if Assigned(Subject) then
    Subject.FreeNotification(FSubjectStand);
end;

procedure TSubjectInfo.ComponentDestroyed(const AComponent: TComponent);
begin
  if AComponent = FStand then
  begin
    // its children (the container and what it held) are gone too
    FStand := nil;
    FContainer := nil;
    FParent := nil;
  end;
  if AComponent = Subject then
  begin
    Subject := nil;
    FDeferStandFree := True;
  end;
end;

{ TDelayedAction }

class procedure TDelayedAction.Execute(const ADelay: Integer;
  const AAction: TProc);
begin
  Schedule(ADelay, AAction);
end;

class function TDelayedAction.Schedule(const ADelay: Integer;
  const AAction: TProc): IDelayedAction;
var
  LItem: TDelayedActionItem;
  LResult: IDelayedAction;
begin
  LItem := TDelayedActionItem.Create(ADelay, AAction);
  Result := LItem;

  if ADelay <= 0 then
  begin
    LItem.FPending := False;
    LItem.FAction := nil;
    AAction();
  end
  else if TThread.CurrentThread.ThreadID = MainThreadID then
    LItem.Start
  else
  begin
    // timers live in the main thread
    LResult := Result;
    TThread.Queue(nil
    , procedure
      begin
        (LResult as TDelayedActionItem).Start;
        LResult := nil;
      end
    );
  end;
end;

{ TCommonActionDictionary<Info> }

procedure TCommonActionDictionary<Info>.Add(const APattern: string;
  const AAction: TProc<Info>);
begin
  if not FDictionary.ContainsKey(APattern) then
    FPatterns.Add(APattern);
  FDictionary.AddOrSetValue(APattern, AAction);
end;

constructor TCommonActionDictionary<Info>.Create;
begin
  inherited Create;
  FDictionary := TDictionary<string, TProc<Info>>.Create;
  FPatterns := TList<string>.Create;
end;

destructor TCommonActionDictionary<Info>.Destroy;
begin
  FPatterns.Free;
  FDictionary.Free;
  inherited;
end;

function TCommonActionDictionary<Info>.GetCount: Integer;
begin
  Result := FDictionary.Count;
end;

function TCommonActionDictionary<Info>.GetKeys: TArray<string>;
begin
  Result := FPatterns.ToArray;
end;

function TCommonActionDictionary<Info>.TryGetValue(const APattern: string;
  out AAction: TProc<Info>): Boolean;
begin
  Result := FDictionary.TryGetValue(APattern, AAction);
end;

{ TSubjectStandBase<S, I> }

constructor TSubjectStandBase<S, I>.Create(AOwner: TComponent);
begin
  inherited;
  FInfos := TObjectDictionary<S, I>.Create;
  FVisibleSubjects := TList<S>.Create;
end;

destructor TSubjectStandBase<S, I>.Destroy;
var
  LSubject: S;
begin
  for LSubject in FInfos.Keys.ToArray do
    Remove(LSubject);
  FreeAndNil(FInfos);
  FreeAndNil(FVisibleSubjects);
  inherited;
end;

procedure TSubjectStandBase<S, I>.AddInfo(const ASubject: S; const AInfo: I);
begin
  FInfos.Add(ASubject, AInfo);
end;

function TSubjectStandBase<S, I>.GetCount: Integer;
begin
  Result := FInfos.Count;
end;

function TSubjectStandBase<S, I>.GetSubjectInfos: TArray<TSubjectInfo>;
var
  LInfo: I;
begin
  Result := [];
  if Assigned(FInfos) then
    for LInfo in FInfos.Values do
      Result := Result + [LInfo];
end;

procedure TSubjectStandBase<S, I>.DoBeforeShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
  inherited;
  FVisibleSubjects.Add(S(ASubjectInfo.Subject));
end;

procedure TSubjectStandBase<S, I>.DoAfterHide(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
var
  LIndex: Integer;
begin
  inherited;
  // the visible list tracks the Show/Hide history: a subject shown twice is
  // listed twice, a Hide takes back its most recent Show
  LIndex := FVisibleSubjects.LastIndexOf(S(ASubjectInfo.Subject));
  if LIndex <> -1 then
    FVisibleSubjects.Delete(LIndex);
end;

procedure TSubjectStandBase<S, I>.DoClose(const ASubject: TSubject);
begin
  // the subject is going away: remove every entry, not just one
  while FVisibleSubjects.Remove(S(ASubject)) <> -1 do
    ;
  inherited;
end;

function TSubjectStandBase<S, I>.FindInfo(const ASubject: S): I;
begin
  Result := nil;
  FInfos.TryGetValue(ASubject, Result);
end;

function TSubjectStandBase<S, I>.FindInfo(const AClass: TClass): I;
var
  LPair: TPair<S, I>;
begin
  Result := nil;
  for LPair in FInfos do
    if LPair.Key is AClass then
      Exit(LPair.Value);
end;

function TSubjectStandBase<S, I>.LastShownSubject: S;
begin
  Result := nil;
  if FVisibleSubjects.Count > 0 then
    Result := FVisibleSubjects.Last;
end;

procedure TSubjectStandBase<S, I>.Remove(ASubject: TSubject);
var
  LInfo: I;
begin
  inherited;
  if Assigned(ASubject) and FInfos.TryGetValue(S(ASubject), LInfo) then
  begin
    FInfos.Remove(S(ASubject));
    LInfo.Free;
  end;
end;

initialization
  TDelayedActionItem.FActiveItems := TList<TDelayedActionItem>.Create;

finalization
  // drop the actions still waiting (their platform timers included)
  TDelayedActionItem.CancelAll;
  FreeAndNil(TDelayedActionItem.FActiveItems);

end.
