unit Tests.Responsive;

interface

uses
  System.SysUtils, DUnitX.TestFramework
, FMX.Types, ResponsiveContainer
;

type
  [TestFixture]
  TResponsiveFixture = class
  private
    FResponsive: TResponsiveContainer;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure DefaultBreakpoints;
    [Test] procedure SetBreakpointKeepsOrder;
    [Test] procedure UnsortedListStillWorks;
    [Test] procedure LookupLastMatchWins;
    [Test] procedure LookupOtherClassUnchanged;
    [Test] procedure LookupOnUnsortedBreakpoints;
    [Test] procedure LookupKeepsStandNameOfMatchingOption;
    [Test] procedure BreakpointTextIsInvariant;
  end;

implementation

type
  TA = class(TFmxObject);
  TB = class(TA);
  TC = class(TA);
  TX = class(TFmxObject);

{ TResponsiveFixture }

procedure TResponsiveFixture.Setup;
begin
  FResponsive := TResponsiveContainer.Create;
end;

procedure TResponsiveFixture.TearDown;
begin
  FreeAndNil(FResponsive);
end;

procedure TResponsiveFixture.DefaultBreakpoints;
begin
  Assert.AreEqual('xs', FResponsive.CurrentBreakpoint(100).Name);
  Assert.AreEqual('xs', FResponsive.CurrentBreakpoint(400).Name);
  Assert.AreEqual('sm', FResponsive.CurrentBreakpoint(401).Name);
  Assert.AreEqual('lg', FResponsive.CurrentBreakpoint(1000).Name);
  Assert.AreEqual('lg', FResponsive.CurrentBreakpoint(5000).Name, 'beyond the largest');
end;

procedure TResponsiveFixture.SetBreakpointKeepsOrder;
begin
  FResponsive.SetBreakpoint(300, 'xs');
  Assert.AreEqual('xs', FResponsive.CurrentBreakpoint(250).Name);
  Assert.AreEqual('sm', FResponsive.CurrentBreakpoint(350).Name);
  FResponsive.SetBreakpoint(2000, 'xl');
  Assert.AreEqual('xl', FResponsive.CurrentBreakpoint(1500).Name);
  Assert.AreEqual('xs', FResponsive.Breakpoints.First.Name, 'list sorted by width');
  Assert.AreEqual('xl', FResponsive.Breakpoints.Last.Name, 'list sorted by width');
end;

procedure TResponsiveFixture.UnsortedListStillWorks;
begin
  FResponsive.Breakpoints.Add(TBreakpoint.Create('tiny', 100)); // appended, unsorted
  Assert.AreEqual('tiny', FResponsive.CurrentBreakpoint(50).Name);
end;

procedure TResponsiveFixture.LookupLastMatchWins;
begin
  FResponsive.Breakpoints.Clear;
  FResponsive.AddBreakpoint(240, 'xs');
  FResponsive.AddBreakpoint(480, 'sm');
  FResponsive.AddBreakpoint(720, 'md');
  FResponsive.AddBreakpoint(1080, 'lg');
  FResponsive.Define(TA, TB, 'sm');
  FResponsive.Define(TA, TC, 'lg');

  Assert.AreEqual('TA', FResponsive.Lookup(TResponsiveDefinition.Create(TA), FResponsive.CurrentBreakpoint(200).Name).SubjectClass.ClassName);
  Assert.AreEqual('TB', FResponsive.Lookup(TResponsiveDefinition.Create(TA), FResponsive.CurrentBreakpoint(400).Name).SubjectClass.ClassName);
  Assert.AreEqual('TB', FResponsive.Lookup(TResponsiveDefinition.Create(TA), FResponsive.CurrentBreakpoint(700).Name).SubjectClass.ClassName);
  Assert.AreEqual('TC', FResponsive.Lookup(TResponsiveDefinition.Create(TA), FResponsive.CurrentBreakpoint(2000).Name).SubjectClass.ClassName);
end;

procedure TResponsiveFixture.LookupOtherClassUnchanged;
begin
  FResponsive.Define(TA, TB, 'xs');
  Assert.AreEqual('TX', FResponsive.Lookup(TResponsiveDefinition.Create(TX), 'lg').SubjectClass.ClassName);
end;

procedure TResponsiveFixture.LookupOnUnsortedBreakpoints;
begin
  FResponsive.Define(TA, TB, 'sm');
  FResponsive.Define(TA, TC, 'lg');
  FResponsive.Breakpoints.Clear;
  FResponsive.Breakpoints.Add(TBreakpoint.Create('lg', 1080));
  FResponsive.Breakpoints.Add(TBreakpoint.Create('xs', 240));
  FResponsive.Breakpoints.Add(TBreakpoint.Create('md', 720));
  FResponsive.Breakpoints.Add(TBreakpoint.Create('sm', 480));
  Assert.AreEqual('TB', FResponsive.Lookup(TResponsiveDefinition.Create(TA), FResponsive.CurrentBreakpoint(700).Name).SubjectClass.ClassName);
  Assert.AreEqual('TA', FResponsive.Lookup(TResponsiveDefinition.Create(TA), FResponsive.CurrentBreakpoint(100).Name).SubjectClass.ClassName);
end;

procedure TResponsiveFixture.LookupKeepsStandNameOfMatchingOption;
var
  LResult: TResponsiveDefinition;
begin
  FResponsive.Define(TResponsiveDefinition.Create(TA), TResponsiveDefinition.Create(TB, 'wide'), 'sm');
  FResponsive.Define(TResponsiveDefinition.Create(TX), TResponsiveDefinition.Create(TX, ''), 'sm'); // last, not matching
  LResult := FResponsive.Lookup(TResponsiveDefinition.Create(TA, 'framestand'), 'md');
  Assert.AreEqual('TB', LResult.SubjectClass.ClassName);
  Assert.AreEqual('wide', LResult.StandName);
end;

procedure TResponsiveFixture.BreakpointTextIsInvariant;
var
  LBreakpoint: TBreakpoint;
begin
  Assert.AreEqual('md (992.50)', TBreakpoint.Create('md', 992.5).ToString);
  LBreakpoint := 'md (992.50)';
  Assert.AreEqual(Double(992.5), Double(LBreakpoint.MaxWidth), 0.001);
  LBreakpoint := 'md (992,50)'; // saved with a decimal comma
  Assert.AreEqual(Double(992.5), Double(LBreakpoint.MaxWidth), 0.001);
end;

initialization
  TDUnitX.RegisterTestFixture(TResponsiveFixture);

end.
