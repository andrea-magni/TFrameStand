@echo off
REM ==========================================================================
REM  TFrameStand - build and test
REM
REM  build.cmd [version] [all]
REM
REM    version  package suffix of the Delphi version to use:
REM             13 (default, Delphi 13 Florence), 12, 11_1, 11, 10_4
REM    all      also build the runtime package for Android64, iOSDevice64
REM             and OSXARM64 (the SDKs must be installed in the IDE)
REM
REM  Steps: runtime package (Win32, Win64 [, mobile/macOS]), design-time
REM  package (Win32 [, Win64x for Delphi 13]), all the demos (Win32), the
REM  DUnitX test suite (built and run).
REM
REM  Everything is written under build\<version>: lib\ and the .res files of
REM  the projects are not touched. Exit code 0 when every step succeeds.
REM ==========================================================================
setlocal EnableDelayedExpansion

set "ROOT=%~dp0"
set "VER=%~1"
if "%VER%"=="" set "VER=13"

if "%VER%"=="13"   set "BDSVER=37.0"
if "%VER%"=="12"   set "BDSVER=23.0"
if "%VER%"=="11_1" set "BDSVER=22.0"
if "%VER%"=="11"   set "BDSVER=22.0"
if "%VER%"=="10_4" set "BDSVER=21.0"
if not defined BDSVER (
  echo Unknown version "%VER%": use 13, 12, 11_1, 11 or 10_4
  exit /b 2
)

set "RSVARS=%ProgramFiles(x86)%\Embarcadero\Studio\%BDSVER%\bin\rsvars.bat"
if not exist "%RSVARS%" (
  echo Delphi %VER% not found: "%RSVARS%"
  exit /b 2
)
call "%RSVARS%"

set "OUT=%ROOT%build\%VER%"
set "PLATFORMS=Win32 Win64"
if /i "%~2"=="all" set "PLATFORMS=Win32 Win64 Android64 iOSDevice64 OSXARM64"
set "DCLPLATFORMS=Win32"
if "%VER%"=="13" set "DCLPLATFORMS=Win32 Win64x"
set "MSB=msbuild /nologo /v:minimal /p:Config=Release /p:SkipResGeneration=true"
set "ERRORS=0"
if not exist "%OUT%" mkdir "%OUT%"
set "SUMMARY=%OUT%\summary.txt"
if exist "%SUMMARY%" del "%SUMMARY%"

echo.
echo === TFrameStand build, Delphi %VER% (BDS %BDSVER%), output: %OUT%

REM --- runtime package -------------------------------------------------------
for %%P in (%PLATFORMS%) do (
  set "PO=%OUT%\packages\%%P"
  echo.
  echo --- FrameStandPackage_%VER% [%%P]
  %MSB% "%ROOT%packages\FrameStandPackage_%VER%.dproj" /t:Build /p:Platform=%%P ^
    /p:DCC_BplOutput="!PO!" /p:DCC_DcpOutput="!PO!" /p:DCC_DcuOutput="!PO!\dcu" ^
    /p:DCC_HppOutput="!PO!\hpp" /p:DCC_ObjOutput="!PO!\hpp" /p:DCC_BpiOutput="!PO!\hpp"
  call :result !ERRORLEVEL! "runtime package %%P"
)

REM the iOS build writes its non-shared static library next to the project
if exist "%ROOT%packages\FrameStandPackage_%VER%_nonshared.a" (
  move /y "%ROOT%packages\FrameStandPackage_%VER%_nonshared.a" "%OUT%\packages\iOSDevice64\" >nul
)

REM --- design-time package (needs the runtime package of the same platform) --
for %%P in (%DCLPLATFORMS%) do (
  set "PO=%OUT%\packages\%%P"
  set "RT=!PO!"
  if /i "%%P"=="Win64x" set "RT=%OUT%\packages\Win64x-runtime"
  if /i "%%P"=="Win64x" (
    %MSB% "%ROOT%packages\FrameStandPackage_%VER%.dproj" /t:Build /p:Platform=Win64x ^
      /p:DCC_BplOutput="!RT!" /p:DCC_DcpOutput="!RT!" /p:DCC_DcuOutput="!RT!\dcu" ^
      /p:DCC_HppOutput="!RT!\hpp" /p:DCC_ObjOutput="!RT!\hpp" /p:DCC_BpiOutput="!RT!\hpp"
  )
  echo.
  echo --- dclFrameStandPackage_%VER% [%%P]
  %MSB% "%ROOT%packages\dclFrameStandPackage_%VER%.dproj" /t:Build /p:Platform=%%P ^
    /p:DCC_UnitSearchPath="!RT!" ^
    /p:DCC_BplOutput="!PO!" /p:DCC_DcpOutput="!PO!" /p:DCC_DcuOutput="!PO!\dcl-dcu" ^
    /p:DCC_HppOutput="!PO!\hpp" /p:DCC_ObjOutput="!PO!\hpp" /p:DCC_BpiOutput="!PO!\hpp"
  call :result !ERRORLEVEL! "design-time package %%P"
)

REM --- demos ---------------------------------------------------------------
echo.
echo --- demos [Win32]
%MSB% "%ROOT%demos\AllDemosProjectGroup.groupproj" /t:Build /p:Platform=Win32 ^
  /p:DCC_DcuOutput="%OUT%\demos\dcu" /p:DCC_ExeOutput="%OUT%\demos\bin"
call :result !ERRORLEVEL! "demos Win32"

REM --- tests ---------------------------------------------------------------
echo.
echo --- tests [Win32]
if not exist "%OUT%\tests" mkdir "%OUT%\tests"
pushd "%ROOT%tests"
dcc32 -Q -B -NSSystem;FMX;Winapi;System.Win;Data ^
  -U"%ROOT%source;%BDS%\source\DUnitX" -I"%BDS%\source\DUnitX" ^
  -N0"%OUT%\tests" -E"%OUT%\tests" TFrameStandTests.dpr
set "BUILT=%ERRORLEVEL%"
popd
if not "%BUILT%"=="0" (
  call :result %BUILT% "tests build"
) else (
  "%OUT%\tests\TFrameStandTests.exe"
  call :result !ERRORLEVEL! "tests run"
)

REM --- summary -------------------------------------------------------------
echo.
echo === Summary (Delphi %VER%)
type "%SUMMARY%"
if "%ERRORS%"=="0" (
  echo === ALL OK
) else (
  echo === %ERRORS% STEP^(S^) FAILED
)
exit /b %ERRORS%

:result
REM %1 = exit code of the step, %2 = description
if "%~1"=="0" (
  >>"%SUMMARY%" echo   ok      %~2
) else (
  set /a ERRORS+=1
  >>"%SUMMARY%" echo   FAILED  %~2 ^(exit code %~1^)
)
exit /b 0
