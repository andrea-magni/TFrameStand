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
| `ComponentRegistration` | registers `TFrameStand` and `TFormStand` in the **Andrea Magni** palette page. |
| `FrameStand.Editors`, `FormStand.Editors` | component editors (double-click). |
| `FrameStand.Editors.Forms.Test`, `FormStand.Editors.Forms.Test` | the test windows of the editors. |
| `Frames.Test`, `Forms.Test` | the sample subjects shown by the editors. |

The design-time units use the IDE's `DesignEditors` and `DesignIntf` units and must not be used in applications.

## Packages (`packages\`)

For each supported Delphi version:

- `FrameStandPackage_XX` — runtime package, `{$RUNONLY}`, requires `rtl` and `fmx`;
- `dclFrameStandPackage_XX` — design-time package, requires the runtime package;
- `FrameStand_XX.groupproj` — the group with both.

See [Installation](/guide/installation#supported-delphi-versions) for the list of versions.

## Utility: TDelayedAction

```pascal
TDelayedAction.Execute(500, procedure begin ... end);
```

Runs a procedure in the main thread after a delay in milliseconds (immediately, when the delay is 0). The components use it to wait for the hide animations; the `Stand3D` demo uses it to open a frame half a second after the form is shown.
