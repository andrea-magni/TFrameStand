# TFormStand

<img src="/formstand-logo.png" alt="TFormStand" width="96" style="float: right; margin: 0 0 16px 16px;" />

**TFormStand** is the twin of TFrameStand that uses `TForm` descendants as subjects. Everything described for frames (stands, animations, Common Actions, injection, lifecycle, responsive) works the same way; only the type names change.

Why forms? The form designer has features frames lack: **Fire UI** views (a different layout per device: phone, tablet, Android, iOS...), the **style preview** of the selected platform, a `TStyleBook` per form. With TFormStand you design a piece of UI as a form, with all those tools, and then show its content inside any control of another form, with a stand.

## How it works

The form is created (with `Owner = nil`) but **never shown as a window**. When it is put on a stand, TFormStand:

1. creates a `TLayout`, the **form container**, as large as the form's client area;
2. moves all the direct children of the form into it;
3. adds the form container to the stand's container.

When the subject is closed, the children are moved back to the form (when the form is not owned) or the form is freed (when it is owned, as with `New`).

Since the form object stays alive, its fields, its methods and the event handlers of its controls keep working: you write the form as usual.

```pascal
uses FormStand, SubjectStand, Forms.Second;

procedure TMainForm.ShowSecondButtonClick(Sender: TObject);
begin
  FormStand1.NewAndShow<TSecondForm>(ContentLayout, 'card');
end;

procedure TMainForm.CloseSecondButtonClick(Sender: TObject);
begin
  FormStand1.HideAndCloseAll([TSecondForm]);
end;
```

```pascal
type
  TSecondForm = class(TForm)
    CloseButton: TButton;
    procedure CloseButtonClick(Sender: TObject);
  private
    [FormInfo] FI: TFormInfo<TSecondForm>;
  end;

procedure TSecondForm.CloseButtonClick(Sender: TObject);
begin
  FI.HideAndClose;
end;
```

## Layout attributes

Two attributes on the form **class** control the form container:

| Attribute | Default | Effect |
|---|---|---|
| `[Align(TAlignLayout.xxx)]` | `TAlignLayout.Client` | `Align` of the form container inside the stand's container |
| `[ClipChildren(True)]` | `False` | `ClipChildren` of the form container |

```pascal
type
  [Align(TAlignLayout.Left), ClipChildren(True)]
  TMenuForm = class(TForm)
    ...
  end;
```

With an alignment other than `Client` the form's design size is kept: a form designed 300 pixels wide and aligned `Left` becomes a 300-pixel side panel.

## API

`TFormStand` mirrors `TFrameStand`:

| TFrameStand | TFormStand |
|---|---|
| `TFrameInfo<T>`, `Frame`, `FrameIsOwned` | `TFormInfo<T>`, `Form`, `FormIsOwned`, plus `FormContainer` |
| `New<T>`, `Use<T>`, `NewAndShow<T>`, `GetFrameInfo<T>` | `New<T>`, `Use<T>`, `NewAndShow<T>`, `GetFormInfo<T>` |
| `FrameInfo(...)`, `FrameInfos`, `VisibleFrames`, `LastShownFrame` | `FormInfo(...)`, `FormInfos`, `VisibleForms`, `LastShownForm` |
| `[FrameInfo]`, `[FrameStand]` | `[FormInfo]`, `[FormStand]` |

The non-generic overloads `New(AClassName)` and `Use(AFrame)` exist only on TFrameStand.

## Things to keep in mind

- Form-level events tied to the window (`OnShow`, `OnActivate`, `OnClose`, `OnResize`...) do not fire, because the form is never shown. `OnCreate` and `OnDestroy` do. Use the [lifecycle methods](/features/injection#lifecycle-methods) instead.
- Properties of the form itself (`Fill`, its `StyleBook`, `Caption`...) are not carried over: only its children are moved. Put a `TRectangle` aligned to the client as the first child if you need a background.
- Non-visual components (data modules, action lists, bindings) stay on the form and keep working.
- While a form adopted with `Use` is shown, its controls are children of the stand: if the parent of the stand is destroyed, they are destroyed with it (the form itself survives, empty). Close the subject first if you want to show the form again.
- The `TFormStand_HelloWorld`, `TFormStand_ActionList` and `TFormStand_LiveBindings` demos show Fire UI views, actions and LiveBindings working inside a form shown on a stand.
