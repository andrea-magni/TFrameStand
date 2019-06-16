unit FormStand;

interface

uses
  Classes, SysUtils, Generics.Collections, System.Threading, System.Rtti
, FMX.Types, FMX.Controls, FMX.Forms, FMX.Layouts
, SubjectStand
;

type
  TFormClass = class of TForm;
  TFormStand = class; // fwd

  FormStandAttribute = class(ContextAttribute);
  FormInfoAttribute = class(ContextAttribute);
//  FormIsOwnedAttribute = class(ContextAttribute);
  AlignAttribute = class(ContextAttribute)
  private
    FAlign: TAlignLayout;
  protected
  public
    constructor Create(const AAlign: TAlignLayout);
    property Align: TAlignLayout read FAlign;
  end;

  TFormInfo<T: TForm> = class(TSubjectInfo)
  private
    FForm: T;
    FFormIsOwned: Boolean;
    FFormContainer: TLayout;
    function GetFormStand: TFormStand;
  protected
    function GetSubject: TSubject; override;
    procedure SetSubject(const Value: TSubject); override;
    function GetSubjectIsOwned: Boolean; override;
    procedure SetSubjectIsOwned(const Value: Boolean); override;

    procedure ParentAll(const AForm: TForm; const ANewParent: TFmxObject); virtual;
    procedure UnparentAll(const AForm: TForm); virtual;
    procedure SetupSubjectContainer; override;
    procedure TeardownSubjectContainer; override;
    procedure InjectContextAttribute(const AAttribute: ContextAttribute;
      const AField: TRttiField; const AFieldClassType: TClass); override;
  public
    constructor Create(const AFormStand: TFormStand; const AForm: T;
      const AParent: TFmxObject; const AStandStyleName: string); reintroduce; virtual;

    function Show(const ABackgroundTask: TProc<TFormInfo<T>> = nil;
      const AOnTaskComplete: TProc<TFormInfo<T>> = nil;
      const AOnTaskCompleteSynchronized: Boolean = True): ITask; overload; deprecated;
    procedure Show(); overload;

    property FormIsOwned: Boolean read FFormIsOwned write FFormIsOwned;
    property Form: T read FForm;
    property FormStand: TFormStand read GetFormStand;
    property FormContainer: TLayout read FFormContainer;
  end;

  TOnGetFormClassEvent = procedure (const ASender: TFormStand; var AParent: TFmxObject;
    var AStandStyleName: string; var AFormClass: TFormClass) of object;

  TFormStand = class(TSubjectStand)
  private
    FOnGetFormClass: TOnGetFormClassEvent;
    FVisibleForms : TList<TForm>;
  protected
    FFormInfos: TObjectDictionary<TForm, TFormInfo<TForm>>;
    function GetCount: Integer; override;
    function GetFormClass<T: TForm>(var AParent: TFmxObject; var AStandStyleName: string): TFormClass;
    procedure DoAfterHide(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo); override;
    procedure DoBeforeShow(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo); override;
    procedure DoClose(const ASubject: TFmxObject); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function FormInfo(const AForm: TForm): TFormInfo<TForm>;
    property FormInfos: TObjectDictionary<TForm, TFormInfo<TForm>> read FFormInfos;
    function LastShownForm: TForm;
    procedure Remove(ASubject: TSubject); override;

    function Use<T: TForm>(const AForm: T; const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFormInfo<T>;

    function New<T: TForm>(const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFormInfo<T>;

    property VisibleForms: TList<TForm> read FVisibleForms;
  published
    property OnGetSubjectClass: TOnGetFormClassEvent read FOnGetFormClass write FOnGetFormClass;
  end;

implementation

{ TFormStand }

constructor TFormStand.Create(AOwner: TComponent);
begin
  inherited;
  FFormInfos := TObjectDictionary<TForm, TFormInfo<TForm>>.Create();
  FVisibleForms := TList<TForm>.Create;
end;

destructor TFormStand.Destroy;
var
  LKey: TForm;
begin
  for LKey in FFormInfos.Keys.ToArray do
    Remove(LKey);
  FreeAndNil(FFormInfos);
  FreeAndNil(FVisibleForms);

  inherited;
end;

procedure TFormStand.DoAfterHide(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
  inherited;
  FVisibleForms.Remove(ASubjectInfo.Subject as TForm);
end;

procedure TFormStand.DoBeforeShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
  inherited;
  FVisibleForms.Add(ASubjectInfo.Subject as TForm);
end;

procedure TFormStand.DoClose(const ASubject: TFmxObject);
begin
  FVisibleForms.Remove(ASubject as TForm);
  inherited;
end;

function TFormStand.FormInfo(const AForm: TForm): TFormInfo<TForm>;
begin
  Result := nil;
  FFormInfos.TryGetValue(AForm, Result);
end;

function TFormStand.GetCount: Integer;
begin
  Result := FFormInfos.Count;
end;

function TFormStand.GetFormClass<T>(var AParent: TFmxObject;
  var AStandStyleName: string): TFormClass;
begin
  Result := TFormClass(T);
  DoResponsiveLookup(TSubjectClass(Result), AStandStyleName, AParent);
  if Assigned(FOnGetFormClass) then
    FOnGetFormClass(Self, AParent, AStandStyleName, Result);
end;

function TFormStand.LastShownForm: TForm;
begin
  Result := nil;
  if FVisibleForms.Count > 0 then
    Result := FVisibleForms.Last;
end;

function TFormStand.New<T>(const AParent: TFmxObject; const AStandStyleName: string): TFormInfo<T>;
var
  LForm: T;
  LParent: TFmxObject;
  LStandName: string;
begin
  LParent := AParent;
  if not Assigned(LParent) then
    LParent := GetDefaultParent;
  LStandName := AStandStyleName;
  LForm := T(GetFormClass<T>(LParent, LStandName).Create(nil));
  try
    LForm.Name := '';
    Result := Use<T>(LForm, LParent, LStandName);
    Result.FormIsOwned := True;
  except
    LForm.Free;
    raise;
  end;
end;

procedure TFormStand.Remove(ASubject: TSubject);
var
  LInfo: TFormInfo<TForm>;
  LForm: TForm;
begin
  inherited;
  LForm := ASubject as TForm;
  if Assigned(LForm) and FFormInfos.TryGetValue(LForm, LInfo) then
  begin
    FFormInfos.Remove(LForm);
    {$IFDEF AUTOREFCOUNT}
      LInfo.DisposeOf;
      LInfo := nil;
    {$ELSE}
      LInfo.Free;
    {$ENDIF}
  end;
end;

function TFormStand.Use<T>(const AForm: T; const AParent: TFmxObject;
  const AStandStyleName: string): TFormInfo<T>;
var
  LStandStyleName: string;
  LParent: TFmxObject;
begin
  LStandStyleName := GetStandStyleName(AStandStyleName);
  LParent := AParent;
  if not Assigned(LParent) then
    LParent := GetDefaultParent;

  Result := TFormInfo<T>.Create(Self, AForm, LParent, LStandStyleName);
  try
    Result.InjectContext;
    FFormInfos.Add(Result.Form, TFormInfo<TForm>(Result));
  except
    Result.Free;
    raise;
  end;
end;

{ TFormInfo<T> }

constructor TFormInfo<T>.Create(const AFormStand: TFormStand;
  const AForm: T; const AParent: TFmxObject; const AStandStyleName: string);
begin
  Assert(Assigned(AFormStand));
  Assert(Assigned(AForm));

  FForm := AForm;
  FFormIsOwned := False;
  FFormContainer := nil;

  inherited Create(AFormStand, AForm, AParent, AStandStyleName);
end;

procedure TFormInfo<T>.ParentAll(const AForm: TForm; const ANewParent: TFmxObject);
var
  LChild: TFmxObject;
  LChildren: TArray<TFmxObject>;
  LFormContainerAlign: TAlignLayout;
  LFormType: TRttiType;
  LAttribute: AlignAttribute;
begin
  Assert(not Assigned(FFormContainer));
  if not (Assigned(AForm) and Assigned(AForm.Children)) then
    Exit;

  LFormContainerAlign := TAlignLayout.Client; // default
  LChildren := AForm.Children.ToArray;
  if Length(LChildren) > 0 then
  begin
    FFormContainer := TLayout.Create(nil);
    try
      FFormContainer.Parent := ANewParent;
      LFormType := TRttiContext.Create.GetType(AForm.ClassType);
      LAttribute := HasAttribute<AlignAttribute>(LFormType);
      if Assigned(LAttribute) then
        LFormContainerAlign := LAttribute.Align;

      FFormContainer.Align := LFormContainerAlign;
    except
      FreeAndNil(FFormContainer);
      raise;
    end;

    for LChild in LChildren do
    begin
      if LChild.Parent = AForm then
        LChild.Parent := FFormContainer;
    end;
  end;
end;

function TFormInfo<T>.GetFormStand: TFormStand;
begin
  Result := SubjectStand as TFormStand;
end;

function TFormInfo<T>.GetSubject: TSubject;
begin
  Result := FForm;
end;

function TFormInfo<T>.GetSubjectIsOwned: Boolean;
begin
  Result := FFormIsOwned;
end;

procedure TFormInfo<T>.InjectContextAttribute(
  const AAttribute: ContextAttribute; const AField: TRttiField;
  const AFieldClassType: TClass);
begin
  inherited;
  if (AAttribute is FormStandAttribute) and (AFieldClassType.InheritsFrom(TFormStand)) then
      AField.SetValue(TObject(Form), FormStand)
  else if (AAttribute is FormInfoAttribute) then
    AField.SetValue(TObject(Form), Self);
end;

procedure TFormInfo<T>.SetSubject(const Value: TSubject);
begin
  inherited;
  if Assigned(Value) then
    FForm := Value as T
  else
    FForm := nil;
end;

procedure TFormInfo<T>.SetSubjectIsOwned(const Value: Boolean);
begin
  inherited;
  FFormIsOwned := Value;
end;

procedure TFormInfo<T>.SetupSubjectContainer;
begin
//  inherited;
  Assert(Assigned(Container));

  ParentAll(FForm, Container);
end;

procedure TFormInfo<T>.Show;
begin
  SubjectShow();
end;

procedure TFormInfo<T>.TeardownSubjectContainer;
begin
//  inherited;
  if FormIsOwned and Assigned(FForm) then
  begin
    if not (csDestroying in FormStand.ComponentState) then
    begin
      FForm.DisposeOf;
      FForm := nil;
    end;
  end
  else
  begin
    UnparentAll(FForm);
    Container.RemoveObject(FFormContainer);
  end;

  if Assigned(FFormContainer) then
    FreeAndNil(FFormContainer);
end;

procedure TFormInfo<T>.UnparentAll(const AForm: TForm);
var
  LChild: TFmxObject;
begin
  Assert(Assigned(AForm));
  Assert(Assigned(FFormContainer));

  for LChild in FFormContainer.Children do
  begin
    if LChild.Parent = FFormContainer then
      LChild.Parent := AForm;
  end;
end;

function TFormInfo<T>.Show(const ABackgroundTask,
  AOnTaskComplete: TProc<TFormInfo<T>>;
  const AOnTaskCompleteSynchronized: Boolean): ITask;
begin
{$WARN SYMBOL_DEPRECATED OFF}
  Result := SubjectShow(
    TProc<TSubjectInfo>(ABackgroundTask)
  , TProc<TSubjectInfo>(AOnTaskComplete)
  , AOnTaskCompleteSynchronized
  );
{$WARN SYMBOL_DEPRECATED ON}
end;

{ AlignAttribute }

constructor AlignAttribute.Create(const AAlign: TAlignLayout);
begin
  inherited Create;
  FAlign := AAlign;
end;

end.
