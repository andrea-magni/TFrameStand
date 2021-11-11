unit ResponsiveContainer;

interface

uses
  Classes, SysUtils, FMX.Types, FMX.Forms, Generics.Collections
;


type
  TSubject = TFmxObject;
  TSubjectClass = class of TSubject;

  TBreakpoint = record
    MaxWidth: Single;
    Name: string;

    function ToString: string;
    function IsEmpty: Boolean;
    constructor Create(const AName: string; const AMaxWidth: Single);
    class operator Implicit(const AString: string): TBreakpoint;
    class operator Implicit(const ABreakpoint: TBreakpoint): string;
    procedure Clear;
  end;

  TBreakpoints = class(TList<TBreakpoint>)
  private
  protected
  public
    constructor Create(const ABreakpoints: TArray<TBreakpoint> = []); virtual;
    function ToString: string; override;
    function IndexOfBP(const AName: string): Integer;
    function ByName(const AName: string): TBreakpoint;
  end;

  TResponsiveDefinition = record
    SubjectClass: TSubjectClass;
    StandName: string;
    Parent: TFmxObject;
    constructor Create(const ASubjectClass: TSubjectClass; const AStandName: string = '';
      const AParent: TFmxObject = nil);
  end;

  TResponsiveOption = record
    Source: TResponsiveDefinition;
    Target: TResponsiveDefinition;
    Breakpoint: string;

    function Matches(const ADef: TResponsiveDefinition; const ABreakpoint: string;
      const AAvailableBreakpoints: TBreakpoints): Boolean; overload;

    function Matches(const ASubjectClass: TSubjectClass; const AStandName: string;
      const AParent: TFmxObject; const ABreakpoint: string; const AAvailableBreakpoints: TBreakpoints): Boolean; overload;
    constructor Create(const ASource, ATarget: TResponsiveDefinition; const ABreakpoint: string);
  end;

  TResponsiveContainer = class
  private
    FBreakpoints: TBreakpoints;
    FOptions: TList<TResponsiveOption>;
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Define(const ASourceDef, ATargetDef: TResponsiveDefinition; const ABreakpoint: string); overload;
    procedure Define(const ASourceSubjectClass, ATargetSubjectClass: TSubjectClass; const ABreakpoint: string); overload;
    function Lookup(const ASourceDef: TResponsiveDefinition; const ABreakpoint: string): TResponsiveDefinition;
    function CurrentBreakpoint(const AWidth: Single): TBreakpoint;

    procedure AddBreakpoint(const AWidth: Single; const AName: string);
    procedure SetBreakpoint(const AWidth: Single; const AName: string);

    property Breakpoints: TBreakpoints read FBreakpoints;
  end;

implementation

uses
  Masks, System.Generics.Defaults;

{ TBreakpoint }

procedure TBreakpoint.Clear;
begin
  Name := '';
  MaxWidth := 0;
end;

constructor TBreakpoint.Create(const AName: string; const AMaxWidth: Single);
begin
  Name := AName;
  MaxWidth := AMaxWidth;
end;

class operator TBreakpoint.Implicit(const AString: string): TBreakpoint;
var
  LTokens: TArray<string>;
begin
  Result.Clear;
  LTokens := AString.Split([' ']);
  if Length(LTokens) = 2 then
  begin
    Result.Name := LTokens[0].Trim;
    Result.MaxWidth := LTokens[1].Substring(1, Length(LTokens[1])-2).ToSingle;
  end;
end;

class operator TBreakpoint.Implicit(const ABreakpoint: TBreakpoint): string;
begin
  Result := ABreakpoint.ToString;
end;

function TBreakpoint.IsEmpty: Boolean;
begin
  Result := Name.IsEmpty and (MaxWidth = 0)
end;

function TBreakpoint.ToString: string;
begin
  Result := Format('%s (%.2f)', [Name, MaxWidth]);
end;

{ TResponsiveOption }

constructor TResponsiveOption.Create(const ASource,
  ATarget: TResponsiveDefinition; const ABreakpoint: string);
begin
  Source := ASource;
  Target := ATarget;
  Breakpoint := ABreakpoint;
end;

function TResponsiveOption.Matches(const ASubjectClass: TSubjectClass;
  const AStandName: string; const AParent: TFmxObject;
  const ABreakpoint: string; const AAvailableBreakpoints: TBreakpoints): Boolean;
var
  LIndexBreakpoint, LIndexABreakpoint: Integer;
begin
  Result := True;
  if Assigned(ASubjectClass) then
    Result := Assigned(Source.SubjectClass) and ASubjectClass.InheritsFrom(Source.SubjectClass);
  if not Result then
    Exit;

  if (AStandName <> '') and (Source.StandName <> '') then
    Result := ((Source.StandName = AStandName) or (MatchesMask(AStandName, Source.StandName)));
  if not Result then
    Exit;

  if Assigned(AParent) and Assigned(Source.Parent) then
    Result := (Source.Parent = AParent);
  if not Result then
    Exit;

  if (ABreakpoint <> '') and (Breakpoint <> '') then
  begin
    LIndexBreakpoint := AAvailableBreakpoints.IndexOfBP(Breakpoint);
    LIndexABreakpoint := AAvailableBreakpoints.IndexOfBP(ABreakpoint);
    Result := (LIndexBreakpoint <> -1)
          and (LIndexABreakpoint <> -1)
          and (LIndexABreakpoint >= LIndexBreakpoint);
  end;
end;

function TResponsiveOption.Matches(const ADef: TResponsiveDefinition;
  const ABreakpoint: string; const AAvailableBreakpoints: TBreakpoints): Boolean;
begin
  Result := Matches(ADef.SubjectClass, ADef.StandName, ADef.Parent, ABreakpoint, AAvailableBreakpoints);
end;

{ TResponsiveContainer }

procedure TResponsiveContainer.AddBreakpoint(const AWidth: Single;
  const AName: string);
begin
  Breakpoints.Add(TBreakpoint.Create(AName, AWidth));
end;

constructor TResponsiveContainer.Create;
begin
  inherited Create;
  FBreakpoints := TBreakpoints.Create(['xs (400)', 'sm (768)', 'md (992)', 'lg (1200)']);
  FOptions := TList<TResponsiveOption>.Create;
end;


function TResponsiveContainer.CurrentBreakpoint(
  const AWidth: Single): TBreakpoint;
var
  LIndex: Integer;
begin
  Result.Clear;
  for LIndex := 0 to Breakpoints.Count-1 do
    if AWidth <= Breakpoints[LIndex].MaxWidth then
    begin
      Result := Breakpoints[LIndex];
      Break;
    end;

  if Result.IsEmpty and (Breakpoints.Count > 0) then
  begin
    if AWidth <= Breakpoints.First.MaxWidth then
      Result := Breakpoints.First
    else if AWidth > Breakpoints.Last.MaxWidth then
      Result := Breakpoints.Last;
  end;
end;

procedure TResponsiveContainer.Define(const ASourceDef,
  ATargetDef: TResponsiveDefinition; const ABreakpoint: string);
begin
  FOptions.Add(TResponsiveOption.Create(ASourceDef, ATargetDef, ABreakpoint));
end;

procedure TResponsiveContainer.Define(const ASourceSubjectClass,
  ATargetSubjectClass: TSubjectClass; const ABreakpoint: string);
begin
  Define(
    TResponsiveDefinition.Create(ASourceSubjectClass)
  , TResponsiveDefinition.Create(ATargetSubjectClass)
  , ABreakpoint
  );
end;

destructor TResponsiveContainer.Destroy;
begin
  FreeAndNil(FOptions);
  FreeAndNil(FBreakpoints);
  inherited;
end;

function TResponsiveContainer.Lookup(const ASourceDef: TResponsiveDefinition;
  const ABreakpoint: string): TResponsiveDefinition;
var
  LOption: TResponsiveOption;
  LMatch: TResponsiveDefinition;
  LFound: Boolean;
begin
  Result := ASourceDef;
  LFound := False;
  for LOption in FOptions do
    if LOption.Matches(ASourceDef, ABreakpoint, Breakpoints) then
    begin
      LMatch := LOption.Target;
      LFound := True;
    end;

  if LFound then
  begin
    if Assigned(LMatch.SubjectClass) then
      Result.SubjectClass := LMatch.SubjectClass;
    if (LOption.Target.StandName <> '') then
      Result.StandName := LMatch.StandName;
    if Assigned(LOption.Target.Parent) then
      Result.Parent := LMatch.Parent;
  end;
end;

procedure TResponsiveContainer.SetBreakpoint(const AWidth: Single;
  const AName: string);
var
  LIndex: Integer;
begin
  LIndex := Breakpoints.IndexOfBP(AName);
  if LIndex <> -1 then
    Breakpoints.Delete(LIndex);
  Breakpoints.Add(TBreakpoint.Create(AName, AWidth));
end;

{ TBreakpoints }

function TBreakpoints.ByName(const AName: string): TBreakpoint;
var
  LIndex: Integer;
begin
  LIndex := IndexOfBP(AName);
  Result.Clear;
  if LIndex <> -1 then
    Result := Items[LIndex];
end;

constructor TBreakpoints.Create(const ABreakpoints: TArray<TBreakpoint>);
begin
  inherited Create(
    TComparer<TBreakpoint>.Construct(
      function (const Left, Right: TBreakpoint): Integer
      begin
        Result := 0;
        if Left.MaxWidth > Right.MaxWidth then
          Result := -1
        else if Left.MaxWidth < Right.MaxWidth then
          Result := 1;
      end
    )
  );
  AddRange(ABreakpoints);
end;

function TBreakpoints.IndexOfBP(const AName: string): Integer;
var
  LIndex: Integer;
begin
  Result := -1;
  for LIndex := 0 to Count-1 do
    if SameText(Items[LIndex].Name, AName) then
    begin
      Result := LIndex;
      Break;
    end;
end;

function TBreakpoints.ToString: string;
var
  LIndex: Integer;
begin
  Result := '';
  for LIndex := 0 to Count -1 do
  begin
    if Result <> '' then
      Result := Result + sLineBreak;
    Result := Result + Items[LIndex].ToString;
  end;
end;

{ TResponsiveDefinition }

constructor TResponsiveDefinition.Create(const ASubjectClass: TSubjectClass;
  const AStandName: string; const AParent: TFmxObject);
begin
  SubjectClass := ASubjectClass;
  StandName := AStandName;
  Parent := AParent;
end;

end.

