# Installation

## GetIt (recommended)

TFrameStand is available in **GetIt**, the Embarcadero package manager. In the IDE choose **Tools ▸ GetIt Package Manager**, search for `TFrameStand` and click **Install**. GetIt compiles the packages, installs the design-time package and sets the library path for you.

You can also browse it on the [GetIt website](https://getitnow.embarcadero.com/?q=TFrameStand).

::: tip
The GetIt version is the latest release. Installing from the repository gives you the latest commits, including fixes not released yet.
:::

## Setup

Each [GitHub release](https://github.com/andrea-magni/TFrameStand/releases/latest) has a setup, `TFrameStand_<version>_Setup.exe`, that installs the library in one or more RAD Studio versions found on the computer (10.4 Sydney to 13 Florence). Close RAD Studio, run the setup, choose the folder and the RAD Studio versions. The setup:

- copies the library (sources, packages, demos, tests, documentation sources) to the folder you choose, by default `Documents\TFrameStand`;
- builds the runtime and design-time packages with the compiler of each selected RAD Studio version, and installs the design-time package (the components appear in the **TFrameStand - Andrea Magni** page of the Tool Palette);
- defines the IDE environment variable `TFRAMESTANDDIR` and adds `$(TFRAMESTANDDIR)\source` to the library path of **every platform** configured in the IDE: Windows (Win32, Win64, Win64x, WinArm64EC), Android, iOS, macOS and Linux;
- uninstalls a previous version installed by the setup, and tries to remove a TFrameStand installed with GetIt in the same RAD Studio versions (if GetIt still lists it afterwards, uninstall it from GetIt: two copies of the components cannot be installed together).

Uninstall it from **Settings ▸ Apps** (or with `unins000.exe` in the installation folder): packages, environment variable and library paths are removed; folders you created in `demos` are left in place.

The setup can also run unattended:

```bash
TFrameStand_2.2_Setup.exe /DIR="C:\Dev\TFrameStand" /SILENT /RADStudioVersions=all
```

`/RADStudioVersions` takes `all` or a comma-separated list of product versions (`37.0` for Delphi 13, `23.0` for 12, `22.0` for 11, `21.0` for 10.4); by default the newest version found is used.

## TMS Smart Setup

[TMS Smart Setup](https://doc.tmssoftware.com/smartsetup/) is a free, open-source command-line tool that downloads, builds and registers Delphi libraries. TFrameStand ships a `tmsbuild.yaml`, so Smart Setup can build it from sources for every supported Delphi version installed on your machine (**10.4 Sydney** and newer), for all the FMX platforms installed in the IDE (Linux excluded, since it needs FMXLinux).

1. [Download and install Smart Setup](https://doc.tmssoftware.com/smartsetup/download/) (version 3.5 or later).
2. The community server, where open-source libraries are listed, is disabled by default. Enable it once:

   ```bash
   tms server-enable community true
   ```

3. Install TFrameStand:

   ```bash
   tms install andreamagni.tframestand
   ```

Smart Setup clones the repository, compiles the runtime and design-time packages (Debug and Release), installs the design-time package in the IDE and adds the compiled units to the library path. Later on, `tms update andreamagni.tframestand` gets the latest version and rebuilds it, and `tms uninstall andreamagni.tframestand` removes it.

::: info Listing in progress
TFrameStand is being added to the Smart Setup community server: until `tms install andreamagni.tframestand` finds it, use the setup or the manual installation.
:::

## Manual installation

1. Clone or download the repository from [GitHub](https://github.com/andrea-magni/TFrameStand).
2. Open the package group for your Delphi version from the `packages` folder, for example `packages\13Florence\FrameStand.groupproj` for Delphi 13 Florence.
3. Build both packages of the group: the runtime package `FrameStandPackage` and the design-time package `dclFrameStandPackage`.
4. Right-click the design-time package and choose **Install**. `TFrameStand` and `TFormStand` appear in the **TFrameStand - Andrea Magni** page of the Tool Palette.
5. Add the `source` folder to the library path (**Tools ▸ Options ▸ Language ▸ Delphi ▸ Library**), for **each platform** you target (Windows 32/64, Android, iOS, macOS, Linux).

## Supported Delphi versions

| Delphi | Package group |
|---|---|
| 13 Florence | `packages\13Florence\FrameStand.groupproj` |
| 12 Athens | `packages\12Athens\FrameStand.groupproj` |
| 11 Alexandria (11.1 or later) | `packages\11Alexandria\FrameStand.groupproj` |
| 10.4 Sydney | `packages\104Sydney\FrameStand.groupproj` |

Each group has the runtime package `FrameStandPackage` and the design-time package `dclFrameStandPackage`. The packages use `{$LIBSUFFIX AUTO}`, so the BPL file name carries the IDE version (for example `dclFrameStandPackage370.bpl` for Delphi 13, whose package version is 370). The compiled units go to `lib\<folder>\dcu\<platform>\<config>` (for example `lib\13Florence\dcu\Win32\Release`), BPL and DCP files to the default folders of the IDE (`Bpl` and `Dcp` under `Public Documents\Embarcadero\Studio\<version>`, with a subfolder for each platform but Win32), so the packages of different Delphi versions and platforms do not overwrite each other.

::: tip Upgrading from v.2.1 or earlier
Up to v.2.1 the package names carried the Delphi version (`FrameStandPackage_13`, `dclFrameStandPackage_13`, ...). Before installing the new packages, remove the old design-time package in **Component ▸ Install Packages**. Projects built with runtime packages must list `FrameStandPackage` instead of `FrameStandPackage_XX`.
:::

::: warning Older versions
Delphi 10.4 Sydney is the minimum: the units stop the compilation with a clear message on older compilers. For Delphi 10.3 Rio use [v.2.0.1](https://github.com/andrea-magni/TFrameStand/releases/tag/v.2.0.1), for XE8 to 10.2 Tokyo use [v.1.8](https://github.com/andrea-magni/TFrameStand/releases/tag/v.1.8).
:::

## Without packages

The components can be used at runtime only, without installing anything: add the `source` folder to the search path of the project and create the component in code.

```pascal
uses FrameStand, SubjectStand;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FFrameStand := TFrameStand.Create(Self);
  FFrameStand.StandBook := StyleBook1;
  FFrameStand.DefaultStandName := 'lightbox';
end;
```

## Units to use

| You use | Add to `uses` |
|---|---|
| `TFrameStand`, `TFrameInfo<T>`, `[FrameInfo]`, `[FrameStand]` | `FrameStand` |
| `TFormStand`, `TFormInfo<T>`, `[FormInfo]`, `[Align]`, `[ClipChildren]` | `FormStand` |
| `TSubjectInfo`, `TSubjectStand`, `[BeforeShow]`, `[Parent]`, `[Stand]`... | `SubjectStand` |
| `TBreakpoint`, `TResponsiveDefinition` | `ResponsiveContainer` |

Most applications need both `FrameStand` (or `FormStand`) and `SubjectStand`: Common Actions receive a `TSubjectInfo`, and the lifecycle attributes are declared in `SubjectStand`.
