unit ResponsiveContainer;

interface

uses
  Classes, SysUtils, FMX.Types, FMX.Forms, Generics.Collections
;


type
  TFrameClass = class of TFrame;

  TBreakpoint = record
    MaxWidth: Single;
    Name: string;

    function ToString: string;
    function IsEmpty: Boolean;
    constructor Create(const AName: string; const AMaxWidth: Single);
    procedure Clear;
  end;

  TBreakpoints = class(TList<TBreakpoint>)
  private
  protected
  public
    constructor Create; virtual;
    function ToString: string; override;
    function IndexOfBP(const AName: string): Integer;
    function ByName(const AName: string): TBreakpoint;
  end;

  TResponsiveDefinition = record
    FrameClass: TFrameClass;
    StandName: string;
    Parent: TFmxObject;
    constructor Create(const AFrameClass: TFrameClass; const AStandName: string = '';
      const AParent: TFmxObject = nil);
  end;

  TResponsiveOption = record
    Source: TResponsiveDefinition;
    Target: TResponsiveDefinition;
    Breakpoint: string;

    function Matches(const ADef: TResponsiveDefinition; const ABreakpoint: string;
      const AAvailableBreakpoints: TBreakpoints): Boolean; overload;

    function Matches(const AFrameClass: TFrameClass; const AStandName: string;
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
    procedure Define(const ASourceFrameClass, ATargetFrameClass: TFrameClass; const ABreakpoint: string); overload;
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

function TResponsiveOption.Matches(const AFrameClass: TFrameClass;
  const AStandName: string; const AParent: TFmxObject;
  const ABreakpoint: string; const AAvailableBreakpoints: TBreakpoints): Boolean;
var
  LIndexBreakpoint, LIndexABreakpoint: Integer;
begin
  Result := True;
  if Assigned(AFrameClass) then
    Result := Assigned(Source.FrameClass) and AFrameClass.InheritsFrom(Source.FrameClass);
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
  Result := Matches(ADef.FrameClass, ADef.StandName, ADef.Parent, ABreakpoint, AAvailableBreakpoints);
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
  FBreakpoints := TBreakpoints.Create;

  AddBreakpoint(400, 'xs');
  AddBreakpoint(768, 'sm');
  AddBreakpoint(992, 'md');
  AddBreakpoint(1200, 'lg');

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

procedure TResponsiveContainer.Define(const ASourceFrameClass,
  ATargetFrameClass: TFrameClass; const ABreakpoint: string);
begin
  Define(
    TResponsiveDefinition.Create(ASourceFrameClass)
  , TResponsiveDefinition.Create(ATargetFrameClass)
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
    if Assigned(LMatch.FrameClass) then
      Result.FrameClass := LMatch.FrameClass;
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

constructor TBreakpoints.Create;
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

constructor TResponsiveDefinition.Create(const AFrameClass: TFrameClass;
  const AStandName: string; const AParent: TFmxObject);
begin
  FrameClass := AFrameClass;
  StandName := AStandName;
  Parent := AParent;
end;

end.
