unit FrameStand;

interface

uses
  Classes, SysUtils, Generics.Collections, System.Threading, System.Rtti
, FMX.Types, FMX.Controls, FMX.Forms
, SubjectStand
;

type
  TFrameClass = class of TFrame;
  TFrameStand = class; // fwd

  FrameStandAttribute = class(ContextAttribute);
  FrameInfoAttribute = class(ContextAttribute);
//  FrameIsOwnedAttribute = class(ContextAttribute);

  TFrameInfo<T: TFrame> = class(TSubjectInfo)
  private
    FFrame: T;
    FFrameIsOwned: Boolean;
    function GetFrameStand: TFrameStand;
  protected
    function GetSubject: TSubject; override;
    procedure SetSubject(const Value: TSubject); override;
    function GetSubjectIsOwned: Boolean; override;
    procedure SetSubjectIsOwned(const Value: Boolean); override;
    function ResolveContext(const AAttribute: ContextAttribute;
      const AType: TRttiInstanceType; out AObject: TObject): Boolean; override;
  public
    constructor Create(const AFrameStand: TFrameStand; const AFrame: T;
      const AParent: TFmxObject; const AStandStyleName: string); reintroduce; virtual;

    function Show(const ABackgroundTask: TProc<TFrameInfo<T>> = nil;
      const AOnTaskComplete: TProc<TFrameInfo<T>> = nil;
      const AOnTaskCompleteSynchronized: Boolean = True): ITask; overload; deprecated;

    procedure Show(); overload;

    property FrameIsOwned: Boolean read FFrameIsOwned write FFrameIsOwned;
    property Frame: T read FFrame;
    property FrameStand: TFrameStand read GetFrameStand;

  end;

  TOnGetFrameClassEvent = procedure (const ASender: TFrameStand; var AParent: TFmxObject;
    var AStandStyleName: string; var AFrameClass: TFrameClass) of object;

  TFrameStand = class(TSubjectStandBase<TFrame, TFrameInfo<TFrame>>)
  private
    FOnGetFrameClass: TOnGetFrameClassEvent;
  protected
    function GetFrameClass<T: TFrame>(var AParent: TFmxObject;
      var AStandStyleName: string): TFrameClass; overload;
    function GetFrameClass(const AClassName: string; var AParent: TFmxObject;
      var AStandStyleName: string): TFrameClass; overload;
  public
    function LastShownFrame: TFrame;
    function GetVisibleFrames: TList<TFrame>;

    function FrameInfo(const AFrame: TFrame): TFrameInfo<TFrame>; overload;
    function FrameInfo(const AFrameClass: TFrameClass): TFrameInfo<TFrame>; overload;
    function FrameInfo<T: TFrame>: TFrameInfo<T>; overload;
    function GetFrameInfo<T: TFrame>(const ANewIfNotFound: Boolean = True;
      const AParent: TFmxObject = nil; const AStandStyleName: string = ''): TFrameInfo<T>;

    function Use<T: TFrame>(const AFrame: T; const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFrameInfo<T>; overload;
    function Use(const AFrame: TFrame; const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFrameInfo<TFrame>; overload;


    function New<T: TFrame>(const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFrameInfo<T>; overload;

    function New(const AFrameClassName: string; const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFrameInfo<TFrame>; overload;


    function NewAndShow<T: TFrame>(const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''; const AConfigProc: TProc<T> = nil;
      const AConfigFIProc: TProc<TFrameInfo<T>> = nil): TFrameInfo<T>;

    property FrameInfos: TObjectDictionary<TFrame, TFrameInfo<TFrame>> read FInfos;
    property VisibleFrames: TList<TFrame> read GetVisibleFrames;
  published
    property OnGetSubjectClass: TOnGetFrameClassEvent read FOnGetFrameClass write FOnGetFrameClass;
  end;

implementation

{ TFrameStand }

function TFrameStand.FrameInfo(const AFrameClass: TFrameClass): TFrameInfo<TFrame>;
begin
  Result := FindInfo(AFrameClass);
end;

function TFrameStand.FrameInfo<T>: TFrameInfo<T>;
begin
  Result := TFrameInfo<T>(FrameInfo(TFrameClass(T)));
end;

function TFrameStand.FrameInfo(const AFrame: TFrame): TFrameInfo<TFrame>;
begin
  Result := FindInfo(AFrame);
end;

function TFrameStand.GetVisibleFrames: TList<TFrame>;
begin
  Result := VisibleSubjects;
end;

function TFrameStand.GetFrameClass(const AClassName: string;
  var AParent: TFmxObject; var AStandStyleName: string): TFrameClass;
begin
  var LContext := TRttiContext.Create;
  var LType := LContext.FindType(AClassName);

  if not Assigned(LType) then
    raise Exception.CreateFmt('Type not found: %s', [AClassName]);

  if not (LType is TRttiInstanceType) then
    raise Exception.CreateFmt('Type %s is not an instance type', [AClassName]);

  var LInstanceType := LType as TRttiInstanceType;

  if not (LInstanceType.MetaclassType.InheritsFrom(TFrame)) then
    raise Exception.CreateFmt('Type %s is not a TFrame descendant', [AClassName]);

  Result := TFrameClass(LInstanceType.MetaclassType);
  DoResponsiveLookup(TSubjectClass(Result), AStandStyleName, AParent);
  if Assigned(FOnGetFrameClass) then
    FOnGetFrameClass(Self, AParent, AStandStyleName, Result);
end;

function TFrameStand.GetFrameClass<T>(var AParent: TFmxObject;
  var AStandStyleName: string): TFrameClass;
begin
  Result := TFrameClass(T);
  DoResponsiveLookup(TSubjectClass(Result), AStandStyleName, AParent);
  if Assigned(FOnGetFrameClass) then
    FOnGetFrameClass(Self, AParent, AStandStyleName, Result);
end;

function TFrameStand.GetFrameInfo<T>(const ANewIfNotFound: Boolean = True;
  const AParent: TFmxObject = nil; const AStandStyleName: string = ''): TFrameInfo<T>;
begin
  Result := FrameInfo<T>;
  if ANewIfNotFound and not Assigned(Result) then
    Result := New<T>(AParent, AStandStyleName);
end;

function TFrameStand.LastShownFrame: TFrame;
begin
  Result := LastShownSubject;
end;

function TFrameStand.New(const AFrameClassName: string;
  const AParent: TFmxObject; const AStandStyleName: string): TFrameInfo<TFrame>;
var
  LFrame: TFrame;
  LParent: TFmxObject;
  LStandName: string;
begin
  LParent := ResolveParent(AParent);
  LStandName := AStandStyleName;
  LFrame := GetFrameClass(AFrameClassName, LParent, LStandName).Create(nil);
  try
    LFrame.Name := '';
    Result := Use(LFrame, LParent, LStandName);
    Result.FrameIsOwned := True;
  except
    LFrame.Free;
    raise;
  end;
end;

function TFrameStand.New<T>(const AParent: TFmxObject; const AStandStyleName: string): TFrameInfo<T>;
var
  LFrame: T;
  LParent: TFmxObject;
  LStandName: string;
begin
  LParent := ResolveParent(AParent);
  LStandName := AStandStyleName;
  LFrame := T(GetFrameClass<T>(LParent, LStandName).Create(nil));
  try
    LFrame.Name := '';
    Result := Use<T>(LFrame, LParent, LStandName);
    Result.FrameIsOwned := True;
  except
    LFrame.Free;
    raise;
  end;
end;

function TFrameStand.NewAndShow<T>(const AParent: TFmxObject;
  const AStandStyleName: string; const AConfigProc: TProc<T>;
  const AConfigFIProc: TProc<TFrameInfo<T>>): TFrameInfo<T>;
begin
  Result := New<T>(AParent, AStandStyleName);
  if Assigned(AConfigProc) then
    AConfigProc(Result.Frame);
  if Assigned(AConfigFIProc) then
    AConfigFIProc(Result);
  Result.Show();
end;

function TFrameStand.Use(const AFrame: TFrame; const AParent: TFmxObject;
  const AStandStyleName: string): TFrameInfo<TFrame>;
begin
  Result := Use<TFrame>(AFrame, AParent, AStandStyleName);
end;

function TFrameStand.Use<T>(const AFrame: T; const AParent: TFmxObject;
  const AStandStyleName: string): TFrameInfo<T>;
var
  LStandStyleName: string;
  LParent: TFmxObject;
begin
  LStandStyleName := GetStandStyleName(AStandStyleName);
  LParent := ResolveParent(AParent);

  Result := TFrameInfo<T>.Create(Self, AFrame, LParent, LStandStyleName);
  try
    Result.InjectContext;
    AddInfo(Result.Frame, TFrameInfo<TFrame>(Result));
  except
    Result.Free;
    raise;
  end;
end;

{ TFrameInfo<T> }

constructor TFrameInfo<T>.Create(const AFrameStand: TFrameStand;
  const AFrame: T; const AParent: TFmxObject; const AStandStyleName: string);
begin
  Assert(Assigned(AFrameStand));
  Assert(Assigned(AFrame));

  FFrame := AFrame;
  FFrameIsOwned := False;

  inherited Create(AFrameStand, AFrame, AParent, AStandStyleName);
end;

function TFrameInfo<T>.GetFrameStand: TFrameStand;
begin
  Result := SubjectStand as TFrameStand;
end;

function TFrameInfo<T>.GetSubject: TSubject;
begin
  Result := FFrame;
end;

function TFrameInfo<T>.GetSubjectIsOwned: Boolean;
begin
  Result := FFrameIsOwned;
end;

function TFrameInfo<T>.ResolveContext(const AAttribute: ContextAttribute;
  const AType: TRttiInstanceType; out AObject: TObject): Boolean;
begin
  if (AAttribute is FrameStandAttribute) and AType.MetaclassType.InheritsFrom(TFrameStand) then
  begin
    AObject := FrameStand;
    Result := True;
  end
  else if (AAttribute is FrameInfoAttribute)
    and (InheritsFrom(AType.MetaclassType) or AType.MetaclassType.InheritsFrom(TSubjectInfo)) then
  begin
    AObject := Self;
    Result := True;
  end
  else
    Result := inherited;
end;

procedure TFrameInfo<T>.SetSubject(const Value: TSubject);
begin
  inherited;
  FFrame := T(Value);
end;

procedure TFrameInfo<T>.SetSubjectIsOwned(const Value: Boolean);
begin
  inherited;
  FFrameIsOwned := Value;
end;

procedure TFrameInfo<T>.Show;
begin
  SubjectShow();
end;

function TFrameInfo<T>.Show(const ABackgroundTask,
  AOnTaskComplete: TProc<TFrameInfo<T>>;
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

end.
