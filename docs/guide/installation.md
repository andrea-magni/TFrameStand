# Installation

## GetIt (recommended)

TFrameStand is available in **GetIt**, the Embarcadero package manager. In the IDE choose **Tools ▸ GetIt Package Manager**, search for `TFrameStand` and click **Install**. GetIt compiles the packages, installs the design-time package and sets the library path for you.

You can also browse it on the [GetIt website](https://getitnow.embarcadero.com/?q=TFrameStand).

::: tip
The GetIt version is the latest release. Installing from the repository gives you the latest commits, including fixes not released yet.
:::

## Manual installation

1. Clone or download the repository from [GitHub](https://github.com/andrea-magni/TFrameStand).
2. Open the package group for your Delphi version from the `packages` folder, for example `packages\FrameStand_13.groupproj` for Delphi 13 Florence.
3. Build both packages of the group: the runtime package `FrameStandPackage_XX` and the design-time package `dclFrameStandPackage_XX`.
4. Right-click the design-time package and choose **Install**. `TFrameStand` and `TFormStand` appear in the **Andrea Magni** page of the Tool Palette.
5. Add the `source` folder to the library path (**Tools ▸ Options ▸ Language ▸ Delphi ▸ Library**), for **each platform** you target (Windows 32/64, Android, iOS, macOS, Linux).

## Supported Delphi versions

| Delphi | Package group | Runtime package | Design-time package |
|---|---|---|---|
| 13 Florence | `FrameStand_13.groupproj` | `FrameStandPackage_13` | `dclFrameStandPackage_13` |
| 12 Athens | `FrameStand_12.groupproj` | `FrameStandPackage_12` | `dclFrameStandPackage_12` |
| 11.1+ Alexandria | `FrameStand_11_1.groupproj` | `FrameStandPackage_11_1` | `dclFrameStandPackage_11_1` |
| 11.0 Alexandria | `FrameStand_11.groupproj` | `FrameStandPackage_11` | `dclFrameStandPackage_11` |
| 10.4 Sydney | `FrameStand_10_4.groupproj` | `FrameStandPackage_10_4` | `dclFrameStandPackage_10_4` |

The packages use `{$LIBSUFFIX AUTO}`, so the BPL file name carries the IDE version (for example `dclFrameStandPackage_13370.bpl` for Delphi 13, whose package version is 370).

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
