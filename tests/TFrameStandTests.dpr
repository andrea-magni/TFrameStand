program TFrameStandTests;

// DUnitX test suite for TFrameStand / TFormStand, console runner.
// FMX runs headless enough on Windows for these tests (no form is shown).
//
//   TFrameStandTests.exe           run all the tests, exit code 0 when all pass
//   TFrameStandTests.exe --pause   wait for Enter at the end
//
// Built and run by build.cmd in the repository root.

{$APPTYPE CONSOLE}
{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  FMX.Forms,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.XML.NUnit,
  Tests.Subjects in 'Tests.Subjects.pas',
  Tests.Responsive in 'Tests.Responsive.pas',
  Tests.Lifecycle in 'Tests.Lifecycle.pas',
  Tests.Injection in 'Tests.Injection.pas',
  Tests.Teardown in 'Tests.Teardown.pas',
  Tests.CommonActions in 'Tests.CommonActions.pas';

var
  LResults: IRunResults;
  LPause: Boolean;
begin
  LPause := FindCmdLineSwitch('pause', ['-', '/'], True);
  try
    Application.Initialize;
    // string assertions are case sensitive (DUnitX ignores case by default)
    Assert.IgnoreCaseDefault := False;
    LResults := TDUnitX.CreateRunner([
      TDUnitXConsoleLogger.Create(True),
      TDUnitXXMLNUnitFileLogger.Create(ChangeFileExt(ParamStr(0), '.xml'))
    ]).Execute;
    if not LResults.AllPassed then
      System.ExitCode := EXIT_ERRORS;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      System.ExitCode := EXIT_ERRORS;
    end;
  end;
  if LPause then
  begin
    Write('Press Enter...');
    Readln;
  end;
end.
