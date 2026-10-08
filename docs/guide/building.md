# Building & Testing

The repository has a build script and a test suite, used before every release and useful for contributions.

## build.cmd

From the repository root:

```bash
build.cmd
```

```bash
build.cmd 12 all
```

| Argument | Meaning |
|---|---|
| version (first) | Delphi version: `13` (default), `12`, `11` (11.1 or later), `10_4`; the packages are taken from `packages\13Florence`, `12Athens`, `11Alexandria`, `104Sydney` |
| `all` (second) | also build the runtime package for Android64, iOSDevice64 and OSXARM64 (the SDKs must be installed in the IDE) |

The script, with the `rsvars.bat` of the chosen Delphi:

1. builds the runtime package for Win32 and Win64 (and the mobile/macOS platforms with `all`);
2. builds the design-time package for Win32 (and Win64x, the 64-bit IDE, with Delphi 13);
3. builds all the demos of `demos\AllDemosProjectGroup.groupproj` for Win32;
4. builds and runs the test suite.

Everything is written under `build\<version>` (ignored by git): the `lib` folder and the `.res` files of the projects are not touched. At the end a summary lists each step; the exit code is 0 only if all of them succeeded, so the script can run in a CI job on a machine with Delphi.

## The setup

`setup\build-setup.cmd` builds the setup (Inno Setup 6) into `build\setup`:

```bash
setup\build-setup.cmd
```

It compiles a clean export of `HEAD` (`git archive`), so local changes and untracked files are never shipped: commit first. `ISCC.exe` is looked for in the `ISCC` environment variable, in `C:\Sviluppo\Inno Setup 6` (the maintainer's machine), in the `PATH` and in the default Inno Setup 6 folders. The version is the `LibraryVersion` define at the top of `setup\Setup.iss`.

`setup\Setup.iss` is based on the InnoSetupScripts library by Ethea (MIT license, derived from the Skia4Delphi setup), the same used by MARS-Curiosity: the shared code is in `setup\InnoSetupScripts`, the TFrameStand-specific parts (folders, library paths for all the platforms, demo folders) are in `Setup.iss`.

## The test suite

`tests\TFrameStandTests.dpr` is a DUnitX console application. FireMonkey runs headless enough on Windows for these tests: frames and forms are created, shown, hidden and closed without showing any window.

| Unit | Covers |
|---|---|
| `Tests.Responsive` | breakpoints, responsive lookup, breakpoint text format |
| `Tests.Lifecycle` | Show/Hide history (`VisibleFrames`, `VisibleForms`), streaming of the properties, delayed hide and close, `OnHide*` animations from a style book, `TDelayedAction`, memory over hide/close cycles |
| `Tests.Injection` | context injection on fields and lifecycle-method parameters, error messages, responsive substitution |
| `Tests.Teardown` | parents, forms, subjects and referenced components destroyed by someone else; 3D parents; owners that are not FMX objects |
| `Tests.CommonActions` | order and replacement of Common Actions |
| `Tests.Subjects` | the frames and forms used by the tests (resources in `tests\resources`) |

Run it alone after `build.cmd` with:

```bash
build\13\tests\TFrameStandTests.exe --pause
```

The results are also written as NUnit XML next to the executable. To work on the tests in the IDE, open `tests\TFrameStandTests.dpr` (the IDE creates the project file) and add `$(BDS)\source\DUnitX` and `..\source` to the search path.

::: tip Fixtures are registered explicitly
Each test unit registers its fixtures with `TDUnitX.RegisterTestFixture` in its `initialization` section: add the same line when you add a fixture.
:::
