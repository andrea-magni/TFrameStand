(*
  Copyright 2019, TSubjectStand

  Author:
    Andrea Magni <andrea(dot)magni(at)gmail(dot)com>
*)
unit SubjectStand;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Masks, System.Threading
, Generics.Collections
, FMX.Controls, FMX.Types, FMX.Forms, FMX.Ani
, System.Actions, FMX.ActnList
, DeviceAndPlatformInfo, ResponsiveContainer
;

type
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

  TDelayedAction = class
  public
    class procedure Execute(const ADelay: Integer; const AAction: TProc);
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

    procedure SetupStand; virtual;
    procedure SetupStandParent(const AParent: TFmxObject); virtual;
    procedure SetupContainer; virtual;
    procedure SetupSubjectContainer; virtual;
    procedure SetupCommonActions(const AFmxObject: TFmxObject); virtual;
    procedure SetupCustomMethods; virtual;
  public
    procedure DefaultShow; virtual;
    procedure DefaultHide; virtual;

    procedure StopAnimations; virtual;

    function SubjectShow(const ABackgroundTask: TProc<TSubjectInfo>;
      const AOnTaskComplete: TProc<TSubjectInfo> = nil;
      const AOnTaskCompleteSynchronized: Boolean = True): ITask; overload; deprecated;

    procedure SubjectShow; overload;

    function Hide(const ADelay: Integer = 0; const AThen: TProc = nil): Boolean;
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
  TOnBeforeShowEvent = procedure(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo) of object;
  TOnAfterHideEvent = TOnBeforeShowEvent;
  TOnBeforeStartAnimationEvent = procedure(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo; const AAnimation: TAnimation) of object;
  TOnBindCommonActionList = procedure(ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo; const AObject: TFmxObject; var ACommonActionName: string) of object;

  TCommonActionDictionary<Info: TSubjectInfo> = class
  private
    FDictionary: TDictionary<string, TProc<Info>>;
    function GetCount: Integer;
    function GetKeys: TArray<string>;
  protected
  public
    procedure Add(const APattern: string; const AAction: TProc<Info>);
    function TryGetValue(const APattern: string; out AAction: TProc<Info>): Boolean;

    constructor Create; virtual;
    destructor Destroy; override;

    property Count: Integer read GetCount;
    property Keys: TArray<string> read GetKeys;
  end;

  TSubjectStand = class(TComponent)
  private
    FStyleBook: TStyleBook;
    FDefaultStyleName: string;
    FAnimationHide: string;
    FAnimationShow: string;
    FCommonActions: TCommonActionDictionary<TSubjectInfo>;
    FOnAfterHide: TOnAfterHideEvent;
    FOnAfterShow: TOnAfterShowEvent;
    FOnBeforeShow: TOnBeforeShowEvent;
    FOnBeforeStartAnimation: TOnBeforeStartAnimationEvent;
    FCommonActionList: TActionList;
    FCommonActionPrefix: string;
    FOnBindCommonActionList: TOnBindCommonActionList;
    FDefaultParent: TFmxObject;
    FResponsive: TResponsiveContainer;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetDefaultParent: TFmxObject; virtual;
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
    procedure DoClose(const ASubject: TSubject); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Remove(ASubject: TSubject); virtual; abstract;
    function DeviceAndPlatformInfo(const AForm: TForm = nil): TDeviceAndPlatformInfo;

    property Count: Integer read GetCount;
    property CommonActions: TCommonActionDictionary<TSubjectInfo> read FCommonActions;
    property Responsive: TResponsiveContainer read FResponsive;
    property ResponsiveBreakpoints: TArray<TBreakpoint> read GetResponsiveBreakpoints
      write SetResponsiveBreakpoints;
    property ResponsiveBreakpoint[const AName: string]: TBreakpoint read GetResponsiveBreakpoint;
  published
    property AnimationShow: string read FAnimationShow write FAnimationShow;
    property AnimationHide: string read FAnimationHide write FAnimationHide;
    property CommonActionList: TActionList read FCommonActionList write FCommonActionList;
    property CommonActionPrefix: string read FCommonActionPrefix write FCommonActionPrefix;
    property DefaultStyleName: string read FDefaultStyleName write FDefaultStyleName;
    property DefaultParent: TFmxObject read FDefaultParent write FDefaultParent;
    property StyleBook: TStyleBook read FStyleBook write FStyleBook;

    // Events
    property OnAfterHide: TOnAfterHideEvent read FOnAfterHide write FOnAfterHide;
    property OnAfterShow: TOnAfterShowEvent read FOnAfterShow write FOnAfterShow;
    property OnBeforeShow: TOnBeforeShowEvent read FOnBeforeShow write FOnBeforeShow;
    property OnBeforeStartAnimation: TOnBeforeStartAnimationEvent read FOnBeforeStartAnimation write FOnBeforeStartAnimation;
    property OnBindCommonActionList: TOnBindCommonActionList read FOnBindCommonActionList write FOnBindCommonActionList;
  end;

implementation

uses
    FMX.Layouts, FMX.StdCtrls
  ;

{ TSubjectStand }

constructor TSubjectStand.Create(AOwner: TComponent);
begin
  inherited;
  FDefaultStyleName := 'Subjectstand';
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
  if (AParent is TControl) then
    LWidth := TControl(AParent).Width
  else if (AParent is TForm) then
    LWidth := TForm(AParent).Width
 else
    raise Exception.Create('Error in DoResponsiveLookup: cannot determine parent Width');

  FTarget := FResponsive.Lookup(
    TResponsiveDefinition.Create(ASubjectClass, AStandStyleName, AParent)
  , FResponsive.CurrentBreakpoint(LWidth).Name);

  ASubjectClass := FTarget.SubjectClass;
  AStandStyleName := FTarget.StandName;
  AParent := FTarget.Parent;
end;

function TSubjectStand.GetDefaultParent: TFmxObject;
begin
  if Assigned(FDefaultParent) then
    Result := FDefaultParent
  else
    Result := Self.Owner as TFmxObject;
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
  Result := DefaultStyleName;
  if AStandStyleName <> '' then
    Result := AStandStyleName;
end;

procedure TSubjectStand.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (Operation = TOperation.opRemove) then
  begin
    if (AComponent = FStyleBook) then
      FStyleBook := nil
    else if (AComponent = FCommonActionList) then
      FCommonActionList := nil
    else if (AComponent = FDefaultParent) then
      FDefaultParent := nil;
  end;
end;

procedure TSubjectStand.SetResponsiveBreakpoints(
  const ABreakpoints: TArray<TBreakpoint>);
begin
  Responsive.Breakpoints.Clear;
  Responsive.Breakpoints.AddRange(ABreakpoints);
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
  if SubjectIsOwned and Assigned(Subject) then
  begin
    if not (csDestroying in FSubjectStand.ComponentState) then
    begin
      Subject.DisposeOf;
      Subject := nil;
    end;
  end
  else
  begin
    FContainer.RemoveObject(Subject);
  end;

  if not (csDestroying in FSubjectStand.ComponentState) then
    Parent.RemoveObject(Stand);
  Parent := nil;

  if not (csDestroying in FSubjectStand.ComponentState) then
  begin
    Stand.DisposeOf;
    Stand := nil;
  end;

  inherited;
end;

procedure TSubjectInfo.DoCommonActionClick(Sender: TObject);
var
  LName: string;
  LObj: TFmxObject;
  LPattern: string;
  LAction: TProc<TSubjectInfo>;
begin
  LObj := TFmxObject(Sender);
  LName := LObj.StyleName;
  if LName = '' then
    LName := LObj.Name;

  for LPattern in SubjectStand.CommonActions.Keys do
  begin
    if MatchesMask(LName, LPattern) then
    begin
      if SubjectStand.CommonActions.TryGetValue(LPattern, LAction) then
        LAction(Self);
    end;
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
  LParameter: TRttiParameter;
  LAttribute: ContextAttribute;
  LArguments: array of TValue;
  LMetaClassType: TClass;
begin
  Result := False;
  for LMethod in AMethods do
  begin
    Result := True;

    LArguments := [];
    for LParameter in LMethod.GetParameters do
    begin
      if LParameter.ParamType.IsInstance then
      begin
        LMetaClassType := TRttiInstanceType(LParameter.ParamType).MetaclassType;

        LAttribute := HasAttribute<ContextAttribute>(LParameter);
        // injection
        if (LAttribute is SubjectStandAttribute) and (LMetaClassType.InheritsFrom(TSubjectStand)) then
          LArguments := LArguments + [SubjectStand]
        else if (LAttribute is StandAttribute) and (LMetaClassType.InheritsFrom(TControl)) then
          LArguments := LArguments + [Stand]
        else if (LAttribute is ParentAttribute) and (LMetaClassType.InheritsFrom(TFmxObject)) then
          LArguments := LArguments + [Parent]
        else if (LAttribute is ContextAttribute) and (LMetaClassType.InheritsFrom(TFmxObject)) then
          LArguments := LArguments + [Container]
        else if (LAttribute is SubjectInfoAttribute) then
          LArguments := LArguments + [Self];
      end;
    end;

    LMethod.Invoke(Subject, LArguments);
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
begin
  Result := False;
  if not FHiding then
  begin
    FStatus := TSubjectStatus.Hiding;
    Result := True;
    FHiding := True;

    FireHideAnimations(LAutoDelayS);
    LDelay := Round(LAutoDelayS * 1000);
    if ADelay <> 0 then
      LDelay := ADelay;

    TDelayedAction.Execute(LDelay
    , procedure
      begin
        if not FireCustomHideMethods then
          DefaultHide;

        FHiding := False;
        FStatus := TSubjectStatus.Hidden;

        if Assigned(AThen) then
          AThen();

        if Assigned(SubjectStand) {and Assigned(SubjectStand.OnAfterHide)} then
          SubjectStand.DoAfterHide(SubjectStand, Self);
      end
    );
  end;
end;

procedure TSubjectInfo.InjectContext;
var
  LType: TRttiType;
  LField: TRttiField;
  LAttribute: ContextAttribute;
  LFieldClassType: TClass;
begin
  LType := TRttiContext.Create.GetType(Subject.ClassInfo);

  // enumerate type's fields
  for LField in LType.GetFields do
  begin
    // only consider object types
    if LField.FieldType.IsInstance then
    begin
      LFieldClassType := TRttiInstanceType(LField.FieldType).MetaclassType;
      LAttribute := HasAttribute<ContextAttribute>(LField);
      InjectContextAttribute(LAttribute, LField, LFieldClassType);
    end;
  end;
end;

procedure TSubjectInfo.InjectContextAttribute(const AAttribute: ContextAttribute;
  const AField: TRttiField; const AFieldClassType: TClass);
begin
  if (AAttribute is SubjectStandAttribute) and (AFieldClassType.InheritsFrom(TSubjectStand)) then
      AField.SetValue(TObject(Subject), SubjectStand)
  else if (AAttribute is StandAttribute) and (AFieldClassType.InheritsFrom(TControl)) then
    AField.SetValue(TObject(Subject), Stand)
  else if (AAttribute is ParentAttribute) and (AFieldClassType.InheritsFrom(TFmxObject)) then
    AField.SetValue(TObject(Subject), Parent)
  else if (AAttribute is ContextAttribute) and (AFieldClassType.InheritsFrom(TFmxObject)) then
    AField.SetValue(TObject(Subject), Container)
  else if (AAttribute is SubjectInfoAttribute) then
    AField.SetValue(TObject(Subject), Self);
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
  if Assigned(FSubjectStand.StyleBook) and Assigned(FSubjectStand.StyleBook.Style) then
    FStand := FSubjectStand.StyleBook.Style.FindStyleResource(FStandStyleName, True) as TControl;
  if not Assigned(FStand) then
  begin
    FStand := TLayout.Create(nil);
    FStand.Align := TAlignLayout.Contents;
    FStand.StyleName := 'container';
  end;
{$if compilerversion >= 31}
  // 10.1 Berlin and later
  // See https://github.com/andrea-magni/TSubjectStand/issues/12
  // also see https://quality.embarcadero.com/browse/RSP-14806
  FStand.Align := TAlignLayout.Contents;
{$ifend}
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

{ TDelayedAction }

class procedure TDelayedAction.Execute(const ADelay: Integer;
  const AAction: TProc);
begin
  if ADelay = 0 then
    AAction()
  else
    TThread.CreateAnonymousThread(
      procedure
      begin
        Sleep(ADelay);
        TThread.Synchronize(nil, TThreadProcedure(AAction));
      end
    ).Start;
end;

{ TCommonActionDictionary<Info> }

procedure TCommonActionDictionary<Info>.Add(const APattern: string;
  const AAction: TProc<Info>);
begin
  FDictionary.Add(APattern, AAction);
end;

constructor TCommonActionDictionary<Info>.Create;
begin
  inherited Create;
  FDictionary := TDictionary<string, TProc<Info>>.Create;
end;

destructor TCommonActionDictionary<Info>.Destroy;
begin
  FDictionary.Free;
  inherited;
end;

function TCommonActionDictionary<Info>.GetCount: Integer;
begin
  Result := FDictionary.Count;
end;

function TCommonActionDictionary<Info>.GetKeys: TArray<string>;
begin
  Result := FDictionary.Keys.ToArray;
end;

function TCommonActionDictionary<Info>.TryGetValue(const APattern: string;
  out AAction: TProc<Info>): Boolean;
begin
  Result := FDictionary.TryGetValue(APattern, AAction);
end;

end.
