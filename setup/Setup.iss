[Code]
{************************************************************************}
{                                                                        }
{ TFrameStand setup, based on the Ethea InnoSetup Tools Library          }
{ (InnoSetupScripts, MIT license; original code by the Skia4Delphi       }
{ Project), the same library used by the MARS-Curiosity setup.           }
{                                                                        }
{************************************************************************}
{                                                                        }
{                          Custom Parameters                             }
{                                                                        }
{ /RADStudioVersions=                                                    }
{   Values allowed: 21.0 to 37.0 separed by comma or all keyword         }
{   Default: (latest version found in computer)                          }
{   Description: The version used is the product version in registry,    }
{     i.e. RAD Studio 12 Athens is "23.0", RAD Studio 13 Florence is     }
{     "37.0". Ex: /RADStudioVersions=37.0,23.0 installs only in RAD      }
{     Studio 13 Florence and 12 Athens; /RADStudioVersions=all installs  }
{     in all the RAD Studio versions found. Run by GetIt, use            }
{     /RADStudioVersions=$(ProductVersion)                               }
{                                                                        }
{ /CreateUninstallRegKey=                                                }
{   Values allowed: no|yes or false|true or 0|1                          }
{   Default: yes                                                         }
{   Description: When true the uninstall shortcut in applications panel  }
{     is created and, before the setup starts, the uninstall of other    }
{     versions is called                                                 }
{                                                                        }
{************************************************************************}
{                                                                        }
{ Install in silent mode:                                                }
{   cmd /C ""TFrameStand_Setup.exe" /DIR="C:\Dev\TFrameStand"            }
{     /SILENT /RADStudioVersions=all"                                    }
{                                                                        }
{ Uninstall in silent mode:                                              }
{   cmd /C ""C:\Dev\TFrameStand\unins000.exe" /VERYSILENT                }
{     /RADStudioVersions=all"                                            }
{                                                                        }
{ Build: setup\build-setup.cmd (from a clean export of the repository)   }
{                                                                        }
{************************************************************************}

#define LibraryName "TFrameStand"
#define SetupName "TFrameStand"
#define LibraryVersion "2.1"
#define LibraryPublisher "Andrea Magni"
#define LibraryCopyright "Copyright (c) Andrea Magni"
#define LibraryURL "https://github.com/andrea-magni/TFrameStand"
#define LibrarySamplesFolder "demos"
#define LibraryPackagesFolder "packages"
#define LibrarySourceFolder "source"
#define LibraryDCUFolder "lib"
#define LibraryDocumentationURL "https://andrea-magni.github.io/TFrameStand/"
#define LibrarySupportURL "https://github.com/andrea-magni/TFrameStand/issues/"
#define LibraryUpdatesURL "https://github.com/andrea-magni/TFrameStand/releases/"
#define LibraryLicenseFileName "..\LICENSE"
#define BannerImagesFileName "WizTFrameStandImage.bmp"
#define SmallImagesFileName "WizTFrameStandSmallImage.bmp"
#define SetupFolder "setup"
#define FilesEmbedded

// the demo folders shipped with the setup ("|lightbox|wait|...|"): the uninstaller deletes only
// these, any other folder in demos (a project of the user) is left alone
#define DemoFolders "|"
#define DemoFindHandle 0
#define DemoFindResult 0
#define DemoName ""
#sub ReadDemoName
  #define public DemoName FindGetFileName(DemoFindHandle)
  #if DemoName == "." || DemoName == ".." || !DirExists(AddBackslash(SourcePath) + "..\demos\" + DemoName)
    #define public DemoName ""
  #endif
#endsub
#sub AddDemoFolder
  #expr ReadDemoName
  #if DemoName != ""
    #define public DemoFolders DemoFolders + DemoName + "|"
  #endif
#endsub
#for {DemoFindHandle = DemoFindResult = FindFirst(AddBackslash(SourcePath) + "..\demos\*", faDirectory); DemoFindResult; DemoFindResult = FindNext(DemoFindHandle)} AddDemoFolder
#if DemoFindHandle
  #expr FindClose(DemoFindHandle)
#endif
#if DemoFolders == "|"
  #error No demo folder found in ..\demos
#endif
//you can choose your preferred Style contained in folder: InnoSetupScripts\Style
#define VclStyle "RubyGraphite.vsf"

[Setup]
WizardSizePercent=120
AllowCancelDuringInstall=yes
AppCopyright={#LibraryCopyright}
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
AppId={{A9D73FEF-F3C4-4645-B540-EEA26A25F946}
AppName={#LibraryName}
AppPublisher={#LibraryPublisher}
AppPublisherURL={#LibraryURL}
AppSupportURL={#LibrarySupportURL}
AppUpdatesURL={#LibraryUpdatesURL}
AppVersion={#LibraryVersion}
CloseApplications=no
Compression=lzma2/ultra64
CreateUninstallRegKey=NeedsUninstallRegKey
DefaultDirName={code:GetDefaultDirName}
DefaultGroupName={#LibraryName}
DirExistsWarning=no
DisableDirPage=no
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableStartupPrompt=yes
DisableWelcomePage=no
InternalCompressLevel=ultra64
LicenseFile={#LibraryLicenseFileName}
LZMANumBlockThreads=6
LZMAUseSeparateProcess=yes
MissingMessagesWarning=yes
NotRecognizedMessagesWarning=yes
PrivilegesRequired=lowest
SetupLogging=yes
ShowLanguageDialog=no
SolidCompression=yes
UsePreviousAppDir=no
WizardImageFile={#BannerImagesFileName}
WizardSmallImageFile={#SmallImagesFileName}
OutputBaseFilename={#SetupName}_{#LibraryVersion}_Setup
OutputDir=.\Output\
Uninstallable=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl,.\InnoSetupScripts\Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl,.\InnoSetupScripts\Languages\Catalan.isl"
Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl,.\InnoSetupScripts\Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl,.\InnoSetupScripts\Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl,.\InnoSetupScripts\Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl,.\InnoSetupScripts\Languages\Spanish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl,.\InnoSetupScripts\Languages\Default.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl,.\InnoSetupScripts\Languages\Default.isl"

#define CommonRADStudioFilesExcludes "*.exe,*.dll,*.bpl,*.bpi,*.dcp,*.so,*.apk,*.drc,*.map,*.dres,*.rsm,*.tds,*.dcu,*.lib,*.jdbg,*.plist,*.cfg,*Resource.rc,*.local,*.identcache,*.projdata,*.tvsconfig,*.skincfg,*.cbk,*.dsk,__history\*,__recovery\*,*.~*,*.stat,modules\*,.github\*,*.a,*.dex,*.o,*.vrc,*.res,*.log,*.deployproj,*.bak,unins0*.dat,*.nupkg"
; Don't change the order of the files. This could affect the performance when extract temp files
[Files]
#ifdef VclStyle
  Source: ".\InnoSetupScripts\Style\*"; DestDir: "{app}\{#SetupFolder}\Style"; Flags: ignoreversion
#endif
; packages: one folder per Delphi version (10.4 to 13), each with FrameStand.groupproj
Source: "..\{#LibraryPackagesFolder}\*"; Excludes: "{#CommonRADStudioFilesExcludes}"; DestDir: "{app}\{#LibraryPackagesFolder}"; Flags: recursesubdirs ignoreversion
Source: "..\*"; Excludes: "{#CommonRADStudioFilesExcludes},*.gitattributes,*.gitignore,\.git\*,\.github\*,\.claude\*,\{#LibraryDCUFolder}\*,\{#SetupFolder}\*,\{#LibraryPackagesFolder}\*,\build\*,\docs\node_modules\*,\docs\.vitepress\cache\*,\docs\.vitepress\dist\*,\docs\public\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{group}\Uninstall"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#LibrarySamplesFolder}"; Description: "{cm:SetupOpenSamplesFolder}"; Flags: shellexec runasoriginaluser postinstall;
Filename: "{#LibraryDocumentationURL}"; Description: "{cm:SetupViewOnlineDocumentation}"; Flags: shellexec runasoriginaluser postinstall;

[UninstallDelete]
; demos: only the demo folders shipped with the setup (see DemoFolders), not the projects of the user
Type: files; Name: "{app}\demos\*";
#sub EmitDemoUninstallDelete
  #expr ReadDemoName
  #if DemoName != ""
Type: filesandordirs; Name: "{app}\demos\{#DemoName}";
  #endif
#endsub
#for {DemoFindHandle = DemoFindResult = FindFirst(AddBackslash(SourcePath) + "..\demos\*", faDirectory); DemoFindResult; DemoFindResult = FindNext(DemoFindHandle)} EmitDemoUninstallDelete
#if DemoFindHandle
  #expr FindClose(DemoFindHandle)
#endif
Type: filesandordirs; Name: "{app}\docs\*";
Type: filesandordirs; Name: "{app}\gifs\*";
Type: filesandordirs; Name: "{app}\lib\*";
Type: filesandordirs; Name: "{app}\media\*";
Type: filesandordirs; Name: "{app}\packages\*";
Type: filesandordirs; Name: "{app}\source\*";
Type: filesandordirs; Name: "{app}\tests\*";
Type: filesandordirs; Name: "{app}\{#SetupFolder}\*";
Type: filesandordirs; Name: "{app}\build.cmd";
Type: filesandordirs; Name: "{app}\Build.Logs.txt";
Type: filesandordirs; Name: "{app}\LICENSE";
Type: filesandordirs; Name: "{app}\README.md";
Type: dirifempty; Name: "{app}\demos";
Type: dirifempty; Name: "{app}\docs";
Type: dirifempty; Name: "{app}\gifs";
Type: dirifempty; Name: "{app}\lib";
Type: dirifempty; Name: "{app}\media";
Type: dirifempty; Name: "{app}\packages";
Type: dirifempty; Name: "{app}\source";
Type: dirifempty; Name: "{app}\tests";
Type: dirifempty; Name: "{app}\{#SetupFolder}";
Type: dirifempty; Name: "{app}";

// Include
#include ".\InnoSetupScripts\Source\Setup.Main.inc"

[code]
const
  // IDE environment variable with the installation folder: the library paths use $(TFRAMESTANDDIR)
  LibraryDirVariable = 'TFRAMESTANDDIR';
  LibraryDirDefine = '$(' + LibraryDirVariable + ')';

/// <summary> Make custom changes before the installation </summary>
function _OnTryPrepareProjectInstallation(var AProjectItem: TRADStudioGroupProjectItem; const AInfo: TRADStudioInfo): Boolean; forward;
/// <summary> Make custom changes before the uninstallation </summary>
function _OnTryPrepareProjectUninstallation(var AProjectItem: TRADStudioGroupProjectItem; const AInfo: TRADStudioInfo): Boolean; forward;

/// <summary> TFrameStand is a FireMonkey library for every FMX platform. The setup builds the
/// packages for Win32 and Win64 (the IDE and the runtime packages need them), and Setup.Main.inc
/// sets the library path of those two platforms. Applications for the other platforms (Win64x,
/// WinArm64EC, Android, iOS, macOS, Linux) compile the units from source: the source folder must
/// be in their library path too. The platforms are read from the registry of the IDE, so new
/// ones (WinArm64EC in Delphi 13, the next ones) are covered without changing the setup. </summary>
procedure _UpdateSourcePathsOfOtherPlatforms(const AProject: TRADStudioProject; const AInfo: TRADStudioInfo; const AAdd: Boolean);
var
  LLibraryKey, LPlatformKey, LValue: string;
  LPlatformNames, LPaths: TArrayOfString;
  I, J: Integer;
begin
  if AProject.IsDesignOnly or (GetArrayLength(AProject.SourcePaths) = 0) then
    Exit;
  LLibraryKey := GetRADStudioRegKey(AInfo.Version) + '\Library';
  if not RegGetSubkeyNames(HKEY_CURRENT_USER, LLibraryKey, LPlatformNames) then
    Exit;
  for I := 0 to GetArrayLength(LPlatformNames) - 1 do
  begin
    if SameText(LPlatformNames[I], GetProjectPlatformName(pfWin32))
      or SameText(LPlatformNames[I], GetProjectPlatformName(pfWin64)) then
      Continue;
    LPlatformKey := LLibraryKey + '\' + LPlatformNames[I];
    if not RegQueryStringValue(HKEY_CURRENT_USER, LPlatformKey, 'Search Path', LValue) then
      LValue := '';
    LPaths := SplitString(LValue, ';');
    // drop our paths first (also when adding: no duplicates, and they move to the top)
    for J := 0 to GetArrayLength(AProject.SourcePaths) - 1 do
    begin
      LPaths := RemoveString(LPaths, AProject.SourcePaths[J], False);
      LPaths := RemoveString(LPaths, AProject.SourcePaths[J] + '\', False);
    end;
    if AAdd then
      for J := GetArrayLength(AProject.SourcePaths) - 1 downto 0 do
        LPaths := InsertString(0, LPaths, AProject.SourcePaths[J], False);
    if RegWriteStringValue(HKEY_CURRENT_USER, LPlatformKey, 'Search Path', JoinStrings(LPaths, ';', False)) then
      Log(Format('_UpdateSourcePathsOfOtherPlatforms: %s, %s', [LPlatformNames[I], JoinStrings(AProject.SourcePaths, ';', False)]))
    else
      Log(Format('_UpdateSourcePathsOfOtherPlatforms: could not update the library path of %s', [LPlatformNames[I]]));
  end;
end;

/// <summary> Library paths relative to $(TFRAMESTANDDIR) instead of absolute </summary>
procedure _UseLibraryDirVariable(var AProjectItem: TRADStudioGroupProjectItem);
var
  I: Integer;
  LAppPath: string;
begin
  LAppPath := ExpandConstant('{app}');
  for I := 0 to GetArrayLength(AProjectItem.Project.SourcePaths) - 1 do
    StringChangeEx(AProjectItem.Project.SourcePaths[I], LAppPath, LibraryDirDefine, True);
  StringChangeEx(AProjectItem.Project.DCUOutputPath, LAppPath, LibraryDirDefine, True);
end;

function _OnTryPrepareProjectInstallation(var AProjectItem: TRADStudioGroupProjectItem; const AInfo: TRADStudioInfo): Boolean;
begin
  Log(Format('_OnTryPrepareProjectInstallation: Preparing package "%s" before install...', [AProjectItem.Project.FileName]));
  _UseLibraryDirVariable(AProjectItem);
  Result := TryAddRADStudioEnvVariable(AInfo.Version, LibraryDirVariable, ExpandConstant('{app}'));
  if Result then
    _UpdateSourcePathsOfOtherPlatforms(AProjectItem.Project, AInfo, True);
end;

function _OnTryPrepareProjectUninstallation(var AProjectItem: TRADStudioGroupProjectItem; const AInfo: TRADStudioInfo): Boolean;
begin
  Log(Format('_OnTryPrepareProjectUninstallation: Preparing package "%s" to uninstall...', [AProjectItem.Project.FileName]));
  _UseLibraryDirVariable(AProjectItem);
  _UpdateSourcePathsOfOtherPlatforms(AProjectItem.Project, AInfo, False);
  Result := TryRemoveRADStudioEnvVariable(AInfo.Version, LibraryDirVariable);
  if not Result then
    Log(Format('_OnTryPrepareProjectUninstallation: Failed to prepare the project "%s"', [AProjectItem.Project.FileName]));
end;

function _IsShippedDemoFolder(const AName: string): Boolean;
begin
  Result := Pos('|' + Lowercase(AName) + '|', Lowercase('{#DemoFolders}')) > 0;
end;

/// <summary> Folders of ADemosDir that are not demos shipped with TFrameStand: projects of the user </summary>
function _GetUserFolders(const ADemosDir: string): TArrayOfString;
var
  LFindRec: TFindRec;
begin
  SetArrayLength(Result, 0);
  if FindFirst(AddBackslash(ADemosDir) + '*', LFindRec) then
  try
    repeat
      if ((LFindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY) <> 0)
        and (LFindRec.Name <> '.') and (LFindRec.Name <> '..')
        and not _IsShippedDemoFolder(LFindRec.Name)
      then
        Result := AppendString(Result, LFindRec.Name, False);
    until not FindNext(LFindRec);
  finally
    FindClose(LFindRec);
  end;
end;

<event('CurUninstallStepChanged')>
procedure _CurUninstallStepChangedReportUserFolders(ACurUninstallStep: TUninstallStep);
var
  LFolders: TArrayOfString;
  LMessage: string;
  I: Integer;
begin
  if ACurUninstallStep <> usPostUninstall then
    Exit;
  LFolders := _GetUserFolders(ExpandConstant('{app}\demos'));
  if GetArrayLength(LFolders) = 0 then
    Exit;
  LMessage := '';
  for I := 0 to GetArrayLength(LFolders) - 1 do
    LMessage := LMessage + #13#10 + '  ' + ExpandConstant('{app}\demos\') + LFolders[I];
  Log('Folders not shipped with {#LibraryName} left in demos:' + LMessage);
  if not UninstallSilent then
    MsgBox('These folders are not part of {#LibraryName} and were not deleted:' + LMessage, mbInformation, MB_OK);
end;

<event('InitializeSetup')>
function _InitializeSetup: Boolean;
begin
  FOnTryPrepareProjectInstallation := @_OnTryPrepareProjectInstallation;
  FOnTryPrepareProjectUninstallation := @_OnTryPrepareProjectUninstallation;
  Result := True;
end;

<event('InitializeUninstall')>
function _InitializeUninstall: Boolean;
begin
  FOnTryPrepareProjectUninstallation := @_OnTryPrepareProjectUninstallation;
  Result := True;
end;
