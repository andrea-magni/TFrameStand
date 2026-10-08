# Units & Packages

## Runtime units (`source\`)

| Unit | Contents |
|---|---|
| `SubjectStand` | `TSubjectStand` and `TSubjectInfo`, the shared engine: stands, containers, animations, Common Actions, injection, lifecycle. Context and lifecycle attributes. `TDelayedAction`. |
| `FrameStand` | `TFrameStand`, `TFrameInfo<T>`, `[FrameStand]`, `[FrameInfo]`. |
| `FormStand` | `TFormStand`, `TFormInfo<T>`, `[FormStand]`, `[FormInfo]`, `[Align]`, `[ClipChildren]`. |
| `ResponsiveContainer` | `TBreakpoint`, `TBreakpoints`, `TResponsiveDefinition`, `TResponsiveContainer`. |
| `DeviceAndPlatformInfo` | `TDeviceAndPlatformInfo` record: platform, device class, device name, display metrics. |

## Design-time units

| Unit | Contents |
|---|---|
| `ComponentRegistration` | registers `TFrameStand` and `TFormStand` in the **TFrameStand - Andrea Magni** palette page. |
| `FrameStand.Editors`, `FormStand.Editors` | component editors (double-click). |
| `FrameStand.Editors.Forms.Test`, `FormStand.Editors.Forms.Test` | the test windows of the editors. |
| `Frames.Test`, `Forms.Test` | the sample subjects shown by the editors. |

The design-time units use the IDE's `DesignEditors` and `DesignIntf` units and must not be used in applications.

## Packages (`packages\`)

One folder for each supported Delphi version (`104Sydney`, `11Alexandria`, `12Athens`, `13Florence`), with the same files:

- `FrameStandPackage` — runtime package, `{$RUNONLY}`, requires `rtl` and `fmx`;
- `dclFrameStandPackage` — design-time package, requires the runtime package;
- `FrameStand.groupproj` — the group with both.

`tmsbuild.yaml`, in the root of the repository, describes the packages to [TMS Smart Setup](/guide/installation#tms-smart-setup).

See [Installation](/guide/installation#supported-delphi-versions) for the list of versions.

## Utility: TDelayedAction

```pascal
TDelayedAction.Execute(500, procedure begin ... end);

// cancellable
FPending := TDelayedAction.Schedule(500, procedure begin ... end);
...
FPending.Cancel;   // if it has not run yet
```

Runs a procedure in the main thread after a delay in milliseconds, using the FMX platform timer; with a delay of 0 the procedure runs immediately, in the calling thread. It can be called from any thread. `Schedule` returns an `IDelayedAction` with `Pending` and `Cancel` (to be called from the main thread). Actions still pending when the application terminates are dropped.

The components use it to wait for the hide animations, and cancel their pending actions when a subject is closed; the `Stand3D` demo uses it to open a frame half a second after the form is shown.
