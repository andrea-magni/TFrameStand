---
name: tframestand-development
description: Develop FireMonkey (FMX) user interfaces with TFrameStand and TFormStand (Delphi components by Andrea Magni) - showing frames and forms on "stands" (styles with animations), dialogs that return a result (ShowModal, ModalResult), Back/Esc handling, navigation stacks (Push/Pop), the stand gallery (dialog, lightbox, bottom sheet, drawer, snackbar, page), Common Actions, context injection ([FrameInfo], [BeforeShow]...), responsive frames (breakpoints, rmLive) and lifecycle (New, Use, Show, Hide, HideAndClose, Close). Use this skill whenever the user works in a Delphi FMX project that uses TFrameStand or TFormStand (units FrameStand, FormStand, SubjectStand; TFrameInfo<T>, TFormInfo<T>), asks how to show a frame as a dialog, a side menu, a bottom sheet or a page, how to get a result back from a frame, how to handle the Android Back button, how to animate frames, or how to adapt frames to the screen size - even if they don't name TFrameStand but the code clearly uses it.
---

# Developing with TFrameStand / TFormStand

TFrameStand (https://github.com/andrea-magni/TFrameStand, docs https://andrea-magni.github.io/TFrameStand/) shows FMX frames (TFrameStand) or the content of forms (TFormStand) on a **stand**: a style item (from a `TStyleBook`) that wraps the subject with decorations and `OnShow*`/`OnHide*` animations. Minimum Delphi version: 10.4. All the calls run in the main thread.

## Mental model

- **Component**: `TFrameStand` / `TFormStand` on a form or data module. Key properties: `StandBook` (the `TStyleBook` with the stands), `DefaultStandName` (`framestand` / `formstand`), `DefaultParent`, `AnimationShow`/`AnimationHide` masks (`OnShow*`/`OnHide*`), `CatchBackKey`, `PushMode`, `ResponsiveMode`.
- **Subject**: the frame or form shown. **Stand**: a clone of the style item named like the stand; the subject goes in its element with `StyleName = 'container'`. A missing stand name gives a plain layout (no decoration).
- **Info**: `TFrameInfo<T>` / `TFormInfo<T>` (base `TSubjectInfo`), the handle of one subject on its stand: `Frame`/`Form`, `Stand`, `Container`, `Show`, `Hide`, `HideAndClose`, `Close`, `ShowModal`, `ModalResult`. **Keep the info, not the frame** (the frame can be replaced by `ResponsiveMode = rmLive`).

```pascal
uses FrameStand, SubjectStand;

LInfo := FrameStand1.New<TDetailsFrame>(ContentLayout, 'lightbox'); // created and owned, not shown
LInfo.Frame.Customer := LCustomer;
LInfo.Show;
...
LInfo.HideAndClose; // hide animations, then free stand, frame and info
```

## Choosing the API

| The user wants | Use |
|---|---|
| show a frame on a stand | `New<T>(AParent, AStandName)` + `Show`, or `NewAndShow<T>` |
| show a frame already on the form | `Use<T>(AFrame, AParent, AStandName)` (not owned) |
| a dialog that returns a result | `ShowModal(procedure (AFrame: T; AResult: TModalResult) ...)`; the frame sets `FInfo.ModalResult := mrOk` |
| close/cancel from many places | a Common Action: `CommonActions.Add('*_cancel', procedure (AInfo: TSubjectInfo) begin AInfo.ModalResult := mrCancel end)` |
| Android Back / Esc | `CatchBackKey := True`; non-dialog subjects opt in with `BackKeyAction` |
| pages, wizards, master/detail | `Push<T>`, `Pop`, `PopToRoot`, `PushMode` |
| ready-made dialog, lightbox, bottom sheet, drawer, snackbar, page | load `stands\Stands.Light.style` / `Stands.Dark.style` in the `StandBook` |
| toast / snackbar that goes away | `Show` then `HideAndCloseAfter(2500)` |
| different frame per screen width | `Responsive.Define(TBase, TWide, 'md')`, `ResponsiveMode := rmLive` to follow resizes |

## Rules that avoid the common bugs

- **Dismiss with `HideAndClose`, not `Close`, from inside the subject's own event handlers.** `Close` frees the frame (and the control being clicked) at once; `HideAndClose` and `ModalResult` close after `DefaultHideAndCloseDeferTimeMS`.
- **After `Close` / `HideAndClose` the info is freed**: set fields that reference it to nil (or use `ShowModal` with `AClose = True` and keep no reference).
- **Register Common Actions before `New`/`Use`**: they are bound when the subject is created. A matching control's `OnClick` is replaced.
- **`ModalResult` only dismisses subjects shown with `ShowModal`**; the FMX `TButton.ModalResult` property does not apply (it sets the host form's result): set `FInfo.ModalResult` in `OnClick` or in a Common Action.
- **Injection**: `[FrameInfo] FInfo: TFrameInfo<TMyFrame>` must use the frame's own class or a base class it descends from; with responsive substitution, type it on the base class requested to `New`.
- **Responsive substitutes must descend from the base class** passed to `New<T>`.
- **Do not cache `Info.Frame` with `ResponsiveMode = rmLive`**; copy state to the new frame in `OnResponsiveChange`.
- **`Use` frames are not owned**: closing detaches them; if their parent is destroyed while shown, FMX destroys them too.
- **Animations**: names must match `AnimationShow`/`AnimationHide` (`OnShow*`/`OnHide*`); `Hide` waits for the longest `OnHide*` animation. In a style, put size-dependent values in a `TStyleTag` child (`TagString = 'StartValue=-ParentHeight'`), not in the animation's `TagString` (not stored in styles).
- **Background work**: run tasks with `TTask.Run` and touch the components only through `TThread.Synchronize`/`TThread.Queue`; the `Show(ABackgroundTask...)` overload is deprecated. `StyleBook`/`DefaultStyleName` are deprecated names of `StandBook`/`DefaultStandName`.
- Follow the style of the existing code (frames vs forms, Common Actions vs `OnClick`, stands in the form's style book or in a separate file).

## References

Read the reference matching the task:

- `references/api.md` — exact declarations (types, enums, units, signatures, events) and behaviors the declarations don't tell: read it before writing code against an API you are not sure about.
- `references/lifecycle.md` — New/Use/Show/Hide/HideAndClose/Close, ownership, timing, events, lifecycle methods (`[BeforeShow]`...), context injection, Common Actions.
- `references/stands.md` — designing stands, the stand gallery, animations, values from the stand size (`TStyleTag`).
- `references/dialogs-and-navigation.md` — `ShowModal`/`ModalResult`, Back/Esc (`CatchBackKey`, `BackKeyAction`), navigation stack (`Push`/`Pop`, `PushMode`, `StackOperation`).
- `references/responsive.md` — breakpoints, definitions, `OnGetSubjectClass`, `ResponsiveMode = rmLive`, `OnResponsiveChange`.
- `references/formstand.md` — TFormStand: forms as subjects, `[Align]`/`[ClipChildren]`, differences from frames.
