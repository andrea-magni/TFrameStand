# TFrameInfo / TFormInfo

```pascal
TSubjectInfo = class                              // unit SubjectStand
TFrameInfo<T: TFrame> = class(TSubjectInfo)       // unit FrameStand
TFormInfo<T: TForm>   = class(TSubjectInfo)       // unit FormStand
```

The info is the handle of one subject on its stand. It is created by `New`/`Use` and freed by `Close`.

## Properties

| Property | Type | Description |
|---|---|---|
| `Frame` | `T` | The frame (`TFrameInfo<T>`). |
| `FrameIsOwned` | `Boolean` | When `True`, `Close` frees the frame. `True` after `New`, `False` after `Use`. |
| `FrameStand` | `TFrameStand` | The component. |
| `Form`, `FormIsOwned`, `FormStand` | | The same for `TFormInfo<T>`. |
| `FormContainer` | `TLayout` | The layout holding the controls moved from the form (`TFormInfo<T>`). |
| `Subject` | `TSubject` (`TFmxObject`) | The subject, untyped. |
| `SubjectIsOwned` | `Boolean` | Untyped alias of `FrameIsOwned` / `FormIsOwned`. |
| `SubjectStand` | `TSubjectStand` | The component, untyped. |
| `Stand` | `TControl` | The clone of the stand. |
| `StandStyleName` | `string` | Name of the stand used. |
| `Container` | `TFmxObject` | Element of the stand holding the subject. |
| `Parent` | `TFmxObject` | Object holding the stand. |
| `Status` | `TSubjectStatus` | `Initializing`, `Ready`, `Showing`, `Visible`, `Hiding`, `Hidden`, `Closing`. |
| `IsVisible` | `Boolean` | `Stand.Visible`. |
| `Hiding` | `Boolean` | A `Hide` is in progress. |

## Methods

| Method | Description |
|---|---|
| `Show` | Shows the subject: `[BeforeShow]`, `OnBeforeShow`, `[Show]` or default show, show animations, `[AfterShow]`, `OnAfterShow`. |
| `Hide(ADelay = 0; AThen = nil): Boolean` | Starts the hide animations and hides after the longest of them (or after `ADelay` ms, if not 0); then calls `AThen` and `OnAfterHide`. Returns `False` if a hide is already in progress. |
| `HideAndClose(ADeferExecutionMS = 0; AThen = nil)` | `Hide`, then waits `DefaultHideAndCloseDeferTimeMS` (or `ADeferExecutionMS`), then `Close` and `AThen`. |
| `Close` | Removes the subject, without animations: frees the stand, frees or detaches the subject, frees the info. |
| `StopAnimations` | Stops all the show and hide animations of the stand. |
| `DefaultShow` / `DefaultHide` | The default show and hide, useful from your `[Show]` / `[Hide]` methods. |
| `Show(ABackgroundTask, AOnTaskComplete, AOnTaskCompleteSynchronized): ITask` | **Deprecated.** See [Background Work](/features/background-work). |

See [Lifecycle & Ownership](/guide/lifecycle) for the details and the timing.
