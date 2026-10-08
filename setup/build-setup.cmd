@echo off
REM ==========================================================================
REM  TFrameStand - build the setup (Inno Setup 6)
REM
REM  The setup is built from a clean export of HEAD (committed files only):
REM  local changes and untracked files are not included.
REM  Output: build\setup\TFrameStand_<version>_Setup.exe
REM
REM  ISCC.exe is looked for in %ISCC%, in the PATH and in the default
REM  Inno Setup 6 folders.
REM ==========================================================================
setlocal

set "ROOT=%~dp0.."
for %%I in ("%ROOT%") do set "ROOT=%%~fI"
set "OUT=%ROOT%\build\setup"
set "EXPORT=%OUT%\source"

if not defined ISCC (
  for %%P in (ISCC.exe) do if not "%%~$PATH:P"=="" set "ISCC=%%~$PATH:P"
)
if not defined ISCC if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" set "ISCC=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if not defined ISCC if exist "%ProgramFiles%\Inno Setup 6\ISCC.exe" set "ISCC=%ProgramFiles%\Inno Setup 6\ISCC.exe"
if not defined ISCC if exist "%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe" set "ISCC=%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe"
if not defined ISCC (
  echo ISCC.exe not found: install Inno Setup 6 or set ISCC=^<path of ISCC.exe^>
  exit /b 2
)

echo === Exporting HEAD to %EXPORT%
if exist "%EXPORT%" rmdir /s /q "%EXPORT%"
mkdir "%EXPORT%"
git -C "%ROOT%" archive --format=zip -o "%OUT%\source.zip" HEAD || exit /b 1
"%SystemRoot%\System32\tar.exe" -xf "%OUT%\source.zip" -C "%EXPORT%" || exit /b 1
del "%OUT%\source.zip"

echo === Compiling the setup with "%ISCC%"
"%ISCC%" /Q /O"%OUT%" "%EXPORT%\setup\Setup.iss"
if errorlevel 1 (
  echo === SETUP BUILD FAILED
  exit /b 1
)
echo === Setup written to %OUT%
dir /b "%OUT%\*.exe"
exit /b 0
