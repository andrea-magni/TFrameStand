(*
  Copyright 2016, TFrameStand

  Author:
    Andrea Magni <andrea(dot)magni(at)gmail(dot)com>
*)
unit FrameStand;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Masks, System.Threading
  , Generics.Collections
  , FMX.Controls, FMX.Types, FMX.Forms, FMX.Ani
  , System.Actions, FMX.ActnList
  ;

type
  FrameStandAttribute = class(TCustomAttribute);

  ContextAttribute = class(FrameStandAttribute);
  StandAttribute = class(ContextAttribute);
  ContainerAttribute = class(ContextAttribute);
  FrameInfoAttribute = class(ContextAttribute);
  ParentAttribute = class(ContextAttribute);
  FrameIsOwnedAttribute = class(ContextAttribute);

  BeforeShowAttribute = class(FrameStandAttribute);
  ShowAttribute = class(FrameStandAttribute);
  HideAttribute = class(FrameStandAttribute);

  TFrameClass = class of TFrame;

  TFrameStand = class; //fwd

  TDelayedAction = class
  public
    class procedure Execute(const ADelay: Integer; const AAction: TProc);
  end;

  TOnGetFrameClassEvent = procedure (const ASender: TFrameStand; const AParent: TFmxObject;
    const AStandStyleName: string; var AFrameClass: TFrameClass) of object;

  TFrameStatus = (Initializing, Ready, Showing, Visible, Hiding, Hidden, Closing);

  TFrameInfo<T: TFrame> = class
  private
    FFrame: T;
    FFrameIsOwned: Boolean;
    FFrameStand: TFrameStand;
    FStand: TControl;
    FParent: TFmxObject;
    FCustomBeforeShowMethods: TArray<TRttiMethod>;
    FCustomShowMethods: TArray<TRttiMethod>;
    FCustomHideMethods: TArray<TRttiMethod>;
    FContainer: TFmxObject;
    FStandStyleName: string;
    FHiding: Boolean;
    FStatus: TFrameStatus;
    function GetIsVisible: Boolean;
  protected
    function BindCommonActions(const AObject: TFmxObject): Boolean; virtual;
    function BindCommonActionList(const AObject: TFmxObject): Boolean; virtual;

    function HasAttribute<A: TCustomAttribute>(ARttiObject: TRttiObject): A;
    function FindActionProperty(AObject: TObject): TRttiInstanceProperty; virtual;
    procedure InjectContext; virtual;
    procedure FindCustomMethods; virtual;
    procedure FindCommonActions(const AFmxObject: TFmxObject); virtual;
    function FireCustomMethods(AMethods: TArray<TRttiMethod>): Boolean; virtual;
    function FireCustomBeforeShowMethods: Boolean; virtual;
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
  public
    procedure DefaultShow; virtual;
    procedure DefaultHide; virtual;

    procedure StopAnimations; virtual;

    function Show(const ABackgroundTask: TProc<TFrameInfo<T>> = nil;
      const AOnTaskComplete: TProc<TFrameInfo<T>> = nil;
      const AOnTaskCompleteSynchronized: Boolean = True): ITask;
    function Hide(const ADelay: Integer = 0; const AThen: TProc = nil): Boolean;
    procedure Close();

    constructor Create(const AFrameStand: TFrameStand; const AFrame: T;
      const AParent: TFmxObject; const AStandStyleName: string); virtual;
    destructor Destroy; override;

    property Frame: T read FFrame;
    property FrameIsOwned: Boolean read FFrameIsOwned write FFrameIsOwned;
    property FrameStand: TFrameStand read FFrameStand;
    property Stand: TControl read FStand write FStand;
    property StandStyleName: string read FStandStyleName;
    property Container: TFmxObject read FContainer write FContainer;
    property Parent: TFmxObject read FParent write FParent;
    property IsVisible: Boolean read GetIsVisible;
    property Hiding: Boolean read FHiding;
    property Status: TFrameStatus read FStatus;
  end;

  TOnBeforeShowEvent = procedure(const ASender: TFrameStand; const AFrameInfo: TFrameInfo<TFrame>) of object;
  TOnBeforeStartAnimationEvent = procedure(const ASender: TFrameStand; const AFrameInfo: TFrameInfo<TFrame>; const AAnimation: TAnimation) of object;
  TOnBindCommonActionList = procedure(ASender: TFrameStand; const AFrameInfo: TFrameInfo<TFrame>; const AObject: TFmxObject; var ACommonActionName: string) of object;

  TCommonActionDictionary = class
  private
    FDictionary: TDictionary<string, TProc<TFrameInfo<TFrame>>>;
    function GetCount: Integer;
    function GetKeys: TArray<string>;
  protected
  public
    procedure Add(const APattern: string; const AAction: TProc<TFrameInfo<TFrame>>);
    function TryGetValue(const APattern: string; out AAction: TProc<TFrameInfo<TFrame>>): Boolean;

    constructor Create; virtual;
    destructor Destroy; override;

    property Count: Integer read GetCount;
    property Keys: TArray<string> read GetKeys;
  end;

  TFrameStand = class(TComponent)
  private
    FStyleBook: TStyleBook;
    FDefaultStyleName: string;
    FAnimationHide: string;
    FAnimationShow: string;
    FOnGetFrameClass: TOnGetFrameClassEvent;
    FCommonActions: TCommonActionDictionary;
    FOnBeforeShow: TOnBeforeShowEvent;
    FOnBeforeStartAnimation: TOnBeforeStartAnimationEvent;
    FCommonActionList: TActionList;
    FCommonActionPrefix: string;
    FOnBindCommonActionList: TOnBindCommonActionList;
    FDefaultParent: TFmxObject;
    function GetCount: Integer;
  protected
    FFrameInfos: TObjectDictionary<TFrame, TFrameInfo<TFrame>>;
    function GetDefaultParent: TFmxObject; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetStandStyleName(AStandStyleName: string): string;
    function GetFrameClass<T: TFrame>(const AParent: TFmxObject; const AStandStyleName: string): TFrameClass;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Use<T: TFrame>(const AFrame: T; const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFrameInfo<T>;

    function New<T: TFrame>(const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFrameInfo<T>;

    procedure Remove(AFrame: TFrame);

    property Count: Integer read GetCount;
    property CommonActions: TCommonActionDictionary read FCommonActions;
    property FrameInfos: TObjectDictionary<TFrame, TFrameInfo<TFrame>> read FFrameInfos;
  published
    property AnimationShow: string read FAnimationShow write FAnimationShow;
    property AnimationHide: string read FAnimationHide write FAnimationHide;
    property CommonActionList: TActionList read FCommonActionList write FCommonActionList;
    property CommonActionPrefix: string read FCommonActionPrefix write FCommonActionPrefix;
    property DefaultStyleName: string read FDefaultStyleName write FDefaultStyleName;
    property DefaultParent: TFmxObject read FDefaultParent write FDefaultParent;
    property StyleBook: TStyleBook read FStyleBook write FStyleBook;

    // Events
    property OnBeforeShow: TOnBeforeShowEvent read FOnBeforeShow write FOnBeforeShow;
    property OnBeforeStartAnimation: TOnBeforeStartAnimationEvent read FOnBeforeStartAnimation write FOnBeforeStartAnimation;
    property OnBindCommonActionList: TOnBindCommonActionList read FOnBindCommonActionList write FOnBindCommonActionList;
    property OnGetFrameClass: TOnGetFrameClassEvent read FOnGetFrameClass write FOnGetFrameClass;
  end;

procedure Register;

implementation

uses
    FMX.Layouts, FMX.StdCtrls
  ;

procedure Register;
begin
  RegisterComponents('Andrea Magni', [TFrameStand]);
end;

{ TFrameStand }

constructor TFrameStand.Create(AOwner: TComponent);
begin
  inherited;
  FDefaultStyleName := 'framestand';
  FAnimationShow := 'OnShow*';
  FAnimationHide := 'OnHide*';
  FCommonActionPrefix := 'ca_';
  FFrameInfos := TObjectDictionary<TFrame, TFrameInfo<TFrame>>.Create();
  FCommonActions := TCommonActionDictionary.Create;
end;

destructor TFrameStand.Destroy;
var
  LKey: TFrame;
begin
  for LKey in FFrameInfos.Keys.ToArray do
    Remove(LKey);

  FFrameInfos.Free;
  FCommonActions.Free;
  inherited;
end;

function TFrameStand.GetCount: Integer;
begin
  Result := FFrameInfos.Count;
end;

function TFrameStand.GetDefaultParent: TFmxObject;
begin
  if Assigned(FDefaultParent) then
    Result := FDefaultParent
  else
    Result := Self.Owner as TFmxObject;
end;

function TFrameStand.GetFrameClass<T>(const AParent: TFmxObject; const AStandStyleName: string): TFrameClass;
begin
  Result := TFrameClass(T);
  if Assigned(FOnGetFrameClass) then
    FOnGetFrameClass(Self, AParent, AStandStyleName, Result);
end;

function TFrameStand.GetStandStyleName(AStandStyleName: string): string;
begin
  Result := DefaultStyleName;
  if AStandStyleName <> '' then
    Result := AStandStyleName;
end;

function TFrameStand.Use<T>(const AFrame: T; const AParent: TFmxObject; const AStandStyleName: string): TFrameInfo<T>;
var
  LStandStyleName: string;
  LParent: TFmxObject;
begin
  LStandStyleName := GetStandStyleName(AStandStyleName);
  LParent := AParent;
  if not Assigned(LParent) then
    LParent := GetDefaultParent;

  Result := TFrameInfo<T>.Create(Self, AFrame, LParent, LStandStyleName);
  try
    Result.InjectContext;
    FFrameInfos.Add(Result.Frame, TFrameInfo<TFrame>(Result));
  except
    Result.Free;
    raise;
  end;
end;

function TFrameStand.New<T>(const AParent: TFmxObject; const AStandStyleName: string): TFrameInfo<T>;
var
  LFrame: T;
  LParent: TFmxObject;
begin
  LParent := AParent;
  if not Assigned(LParent) then
    LParent := GetDefaultParent;

  LFrame := T(GetFrameClass<T>(LParent, AStandStyleName).Create(nil));
  try
    LFrame.Name := '';
    Result := Use<T>(LFrame, LParent, AStandStyleName);
    Result.FrameIsOwned := True;
  except
    LFrame.Free;
    raise;
  end;
end;

procedure TFrameStand.Notification(AComponent: TComponent;
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

procedure TFrameStand.Remove(AFrame: TFrame);
var
  LInfo: TFrameInfo<TFrame>;
begin
  if FFrameInfos.TryGetValue(AFrame, LInfo) then
  begin
    FFrameInfos.Remove(AFrame);
    {$IFDEF AUTOREFCOUNT}
      LInfo.DisposeOf;
      LInfo := nil;
    {$ELSE}
      LInfo.Free;
    {$ENDIF}
  end;
end;

{ TFrameInfo<T> }

procedure TFrameInfo<T>.DoBeforeStartAnimation(const AAnimation: TAnimation);
begin
  if Assigned(FFrameStand) and Assigned(FFrameStand.OnBeforeStartAnimation) then
    FFrameStand.OnBeforeStartAnimation(FFrameStand, TFrameInfo<TFrame>(Self), AAnimation);
end;

function TFrameInfo<T>.BindCommonActionList(const AObject: TFmxObject): Boolean;
var
  LProperty: TRttiInstanceProperty;
  LAction: TContainedAction;
  LName, LCommonActionPrefix, LCommonActionName: string;

begin
  Result := False;
  if not Assigned(FFrameStand.CommonActionList) then
    Exit;

  LCommonActionName := '';
  // stylename or name selection
  LName := AObject.StyleName;
  if LName = '' then
    LName := AObject.Name;

  LCommonActionPrefix := FFrameStand.CommonActionPrefix;
  // stylename match
  if (LName.StartsWith(LCommonActionPrefix, True)) then
    LCommonActionName := LName.Substring(LCommonActionPrefix.Length);

  // allow custom matching
  if Assigned(FFrameStand.OnBindCommonActionList) then
    FFrameStand.OnBindCommonActionList(FFrameStand, TFrameInfo<TFrame>(Self), AObject, LCommonActionName);

  if LCommonActionName = '' then
    Exit;

  // has a Action property
  LProperty := FindActionProperty(AObject);
  if not Assigned(LProperty) then
    Exit;

  // bind the corresponding Action, if any
  for LAction in FFrameStand.CommonActionList do
  begin
    if SameText(LAction.Name, LCommonActionName)  then
    begin
      LProperty.SetValue(AObject, LAction);
      Result := True;
      Break;
    end;
  end;
end;

function TFrameInfo<T>.BindCommonActions(const AObject: TFmxObject): Boolean;
var
  LCommonActionPattern: string;
begin
  Result := False;
  if not (AObject is TButton) then
    Exit;

  for LCommonActionPattern in FrameStand.CommonActions.Keys do
  begin
    if ( // matches StyleName or Name (if no StyleName is provided)
         ((AObject.StyleName <> '') and  MatchesMask(AObject.StyleName, LCommonActionPattern))
         or ((AObject.StyleName = '') and  MatchesMask(AObject.Name, LCommonActionPattern))
       )
    then
    begin
      TButton(AObject).OnClick := DoCommonActionClick;
      Result := True;
      Break; // no need to continue since DoCommonActionClick will fire all CommonActions that match
    end;
  end;
end;

procedure TFrameInfo<T>.Close;
begin
  FStatus := TFrameStatus.Closing;
  if Assigned(FFrameStand) then
    FFrameStand.Remove(FFrame);
end;

constructor TFrameInfo<T>.Create(const AFrameStand: TFrameStand;
  const AFrame: T; const AParent: TFmxObject; const AStandStyleName: string);
begin
  Assert(Assigned(AFrameStand));
  Assert(Assigned(AFrame));

  inherited Create;

  FStatus := Initializing;
  FFrameStand := AFrameStand;
  FFrame := AFrame;
  FFrameIsOwned := False;
  FStandStyleName := AStandStyleName;

  FindCustomMethods;

  // STAND
  FStand := nil;
  if Assigned(FFrameStand.StyleBook) and Assigned(FFrameStand.StyleBook.Style) then
    FStand := FFrameStand.StyleBook.Style.FindStyleResource(FStandStyleName, True) as TControl;
  if not Assigned(FStand) then
  begin
    FStand := TLayout.Create(nil);
    FStand.Align := TAlignLayout.Contents;
    FStand.StyleName := 'container';
  end;
{$if compilerversion >= 31}
  // 10.1 Berlin and later
  // See https://github.com/andrea-magni/TFrameStand/issues/12
  // also see https://quality.embarcadero.com/browse/RSP-14806
  FStand.Align := TAlignLayout.Contents;
{$ifend}
  FStand.Visible := False;

  // PARENT
  FParent := AParent;
  FParent.AddObject(FStand); // move to SetParent?

  // CONTAINER
  FContainer := FStand.FindStyleResource('container');
  if not Assigned(FContainer) then
    FContainer := FStand;

  // FRAME
  FContainer.AddObject(FFrame);

  // CommonActions
  FindCommonActions(FStand);

  FStatus := Ready;
end;

procedure TFrameInfo<T>.DefaultHide;
begin
  StopAnimations;
  Stand.Visible := False;
end;

procedure TFrameInfo<T>.DefaultShow;
begin
  Stand.Visible := True;
  Stand.BringToFront;
end;

destructor TFrameInfo<T>.Destroy;
begin
  if FrameIsOwned and Assigned(FFrame) then
  begin
    if not (csDestroying in FFrameStand.ComponentState) then
    begin
      FFrame.DisposeOf;
      FFrame := nil;
    end;
  end
  else
  begin
    FContainer.RemoveObject(FFrame);
  end;

  Parent.RemoveObject(Stand);
  Parent := nil;

  if not (csDestroying in FFrameStand.ComponentState) then
  begin
    Stand.DisposeOf;
    Stand := nil;
  end;

  inherited;
end;

procedure TFrameInfo<T>.DoCommonActionClick(Sender: TObject);
var
  LName: string;
  LObj: TFmxObject;
  LPattern: string;
  LAction: TProc<TFrameInfo<TFrame>>;
begin
  LObj := TFmxObject(Sender);
  LName := LObj.StyleName;
  if LName = '' then
    LName := LObj.Name;

  for LPattern in FrameStand.CommonActions.Keys do
  begin
    if MatchesMask(LName, LPattern) then
    begin
      if FrameStand.CommonActions.TryGetValue(LPattern, LAction) then
        LAction(TFrameInfo<TFrame>(Self));
    end;
  end;
end;

procedure TFrameInfo<T>.FindCommonActions(const AFmxObject: TFmxObject);
var
  LChild: TFmxObject;
  LCommonActionPattern: string;
begin
  if (FrameStand.CommonActions.Count = 0) and not Assigned(FrameStand.CommonActionList) then
    Exit;

  if Assigned(AFmxObject.Children) then
  begin
    for LChild in AFmxObject.Children do
    begin
      BindCommonActions(LChild);
      BindCommonActionList(LChild);

      if LChild.ChildrenCount > 0 then // recursion
        FindCommonActions(LChild);
    end;
  end;
end;

procedure TFrameInfo<T>.FindCustomMethods;
var
  LRttiContext: TRttiContext;
  LType: TRttiType;
  LMethod: TRttiMethod;
begin
  LRttiContext := TRttiContext.Create;
  LType := LRttiContext.GetType(Frame.ClassInfo);

  FCustomBeforeShowMethods := [];
  FCustomShowMethods := [];
  FCustomHideMethods := [];
  for LMethod in LType.GetMethods do
  begin
    if HasAttribute<BeforeShowAttribute>(LMethod) <> nil then
      FCustomBeforeShowMethods := FCustomBeforeShowMethods + [LMethod];

    if HasAttribute<ShowAttribute>(LMethod) <> nil then
      FCustomShowMethods := FCustomShowMethods + [LMethod];

    if HasAttribute<HideAttribute>(LMethod) <> nil then
      FCustomHideMethods := FCustomHideMethods + [LMethod];
  end;
end;

function TFrameInfo<T>.FireAnimations(const AFmxObject: TFmxObject;
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

function TFrameInfo<T>.FireCustomBeforeShowMethods: Boolean;
begin
  Result := FireCustomMethods(FCustomBeforeShowMethods);
end;

function TFrameInfo<T>.FireCustomHideMethods: Boolean;
begin
  Result := FireCustomMethods(FCustomHideMethods);
end;

function TFrameInfo<T>.FireCustomMethods(
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
        if (LAttribute is FrameStandAttribute) and (LMetaClassType.InheritsFrom(TFrameStand)) then
          LArguments := LArguments + [FrameStand]
        else if (LAttribute is StandAttribute) and (LMetaClassType.InheritsFrom(TControl)) then
          LArguments := LArguments + [Stand]
        else if (LAttribute is ParentAttribute) and (LMetaClassType.InheritsFrom(TFmxObject)) then
          LArguments := LArguments + [Parent]
        else if (LAttribute is ContextAttribute) and (LMetaClassType.InheritsFrom(TFmxObject)) then
          LArguments := LArguments + [Container]
        else if (LAttribute is FrameInfoAttribute) then
          LArguments := LArguments + [Self];
      end;
    end;

    LMethod.Invoke(FFrame, LArguments);
  end;
end;

function TFrameInfo<T>.FireCustomShowMethods: Boolean;
begin
  Result := FireCustomMethods(FCustomShowMethods);
end;

function TFrameInfo<T>.FireHideAnimations(out AHideDelay: Single): Boolean;
var
  LHideDelay: Single;
begin
  LHideDelay := 0;
  Result := FireAnimations(FStand, FFrameStand.AnimationHide, True,
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

function TFrameInfo<T>.FireShowAnimations: Boolean;
begin
  Result := FireAnimations(FStand, FFrameStand.AnimationShow);
end;

function TFrameInfo<T>.GetIsVisible: Boolean;
begin
  Result := Assigned(FStand) and FStand.Visible;
end;

function TFrameInfo<T>.FindActionProperty(AObject: TObject): TRttiInstanceProperty;
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

function TFrameInfo<T>.HasAttribute<A>(ARttiObject: TRttiObject): A;
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


function TFrameInfo<T>.Hide(const ADelay: Integer = 0; const AThen: TProc = nil): Boolean;
var
  LAutoDelayS: Single;
  LDelay: Integer;
begin
  Result := False;
  if not FHiding then
  begin
    FStatus := TFrameStatus.Hiding;
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
        FStatus := TFrameStatus.Hidden;

        if Assigned(AThen) then
          AThen();
      end
    );
  end;
end;

procedure TFrameInfo<T>.InjectContext;
var
  LRttiContext: TRttiContext;
  LType: TRttiType;
  LField: TRttiField;
  LAttribute: ContextAttribute;
  LFieldClassType: TClass;
begin
  LRttiContext := TRttiContext.Create;
  LType := LRttiContext.GetType(Frame.ClassInfo);

  // enumerate type's fields
  for LField in LType.GetFields do
  begin
    // only consider object types
    if LField.FieldType.IsInstance then
    begin
      LFieldClassType := TRttiInstanceType(LField.FieldType).MetaclassType;


      LAttribute := HasAttribute<ContextAttribute>(LField);

      // injection
      if (LAttribute is FrameStandAttribute) and (LFieldClassType.InheritsFrom(TFrameStand)) then
          LField.SetValue(TObject(Frame), FrameStand)
      else if (LAttribute is StandAttribute) and (LFieldClassType.InheritsFrom(TControl)) then
        LField.SetValue(TObject(Frame), Stand)
      else if (LAttribute is ParentAttribute) and (LFieldClassType.InheritsFrom(TFmxObject)) then
        LField.SetValue(TObject(Frame), Parent)
      else if (LAttribute is ContextAttribute) and (LFieldClassType.InheritsFrom(TFmxObject)) then
        LField.SetValue(TObject(Frame), Container)
      else if (LAttribute is FrameInfoAttribute) then
        LField.SetValue(TObject(Frame), Self);

    end;
  end;

end;

function TFrameInfo<T>.Show(const ABackgroundTask: TProc<TFrameInfo<T>> = nil;
  const AOnTaskComplete: TProc<TFrameInfo<T>> = nil;
  const AOnTaskCompleteSynchronized: Boolean = True
): ITask;
begin
  FStatus := Showing;

  Result := nil;
  FireCustomBeforeShowMethods;
  if Assigned(FrameStand) and Assigned(FrameStand.OnBeforeShow) then
    FrameStand.OnBeforeShow(FrameStand, TFrameInfo<TFrame>(Self));

  if not FireCustomShowMethods then
    DefaultShow;
  FireShowAnimations;

  FStatus := TFrameStatus.Visible;

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

procedure TFrameInfo<T>.StopAnimations;
begin
  // FMX does not like if you free an object when animation are still running,
  // so stop them all
  FireAnimations(FStand, FFrameStand.AnimationHide, False);
  FireAnimations(FStand, FFrameStand.AnimationShow, False);
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

{ TActionDictionary }

procedure TCommonActionDictionary.Add(const APattern: string;
  const AAction: TProc<TFrameInfo<TFrame>>);
begin
  FDictionary.Add(APattern, AAction);
end;

constructor TCommonActionDictionary.Create;
begin
  inherited Create;
  FDictionary := TDictionary<string, TProc<TFrameInfo<TFrame>>>.Create;
end;

destructor TCommonActionDictionary.Destroy;
begin
  FDictionary.Free;
  inherited;
end;

function TCommonActionDictionary.GetCount: Integer;
begin
  Result := FDictionary.Count;
end;

function TCommonActionDictionary.GetKeys: TArray<string>;
begin
  Result := FDictionary.Keys.ToArray;
end;

function TCommonActionDictionary.TryGetValue(const APattern: string;
  out AAction: TProc<TFrameInfo<TFrame>>): Boolean;
begin
  Result := FDictionary.TryGetValue(APattern, AAction);
end;

end.
