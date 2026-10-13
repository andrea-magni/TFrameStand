# TFormStand

TFormStand shows the **content of forms** on stands: the form is created with `Owner = nil` and never shown as a window; its direct children are moved into a `TLayout` (the form container, `FormContainer`) placed in the stand's container, and moved back (adopted forms) or freed with the form (owned forms) on close. Use it to design pieces of UI with the form designer (Fire UI views, style preview).

```pascal
uses FormStand, SubjectStand, Forms.Second;

FormStand1.NewAndShow<TSecondForm>(ContentLayout, 'card');

type
  [Align(TAlignLayout.Left), ClipChildren(True)]   // optional, unit FormStand
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

| TFrameStand | TFormStand |
|---|---|
| `TFrameInfo<T>`, `Frame`, `FrameIsOwned` | `TFormInfo<T>`, `Form`, `FormIsOwned`, `FormContainer` |
| `New<T>`, `Use<T>`, `NewAndShow<T>`, `Push<T>`, `GetFrameInfo<T>` | `New<T>`, `Use<T>`, `NewAndShow<T>`, `Push<T>`, `GetFormInfo<T>` |
| `FrameInfo(...)`, `FrameInfos`, `VisibleFrames`, `LastShownFrame` | `FormInfo(...)`, `FormInfos`, `VisibleForms`, `LastShownForm` |
| `[FrameInfo]`, `[FrameStand]` | `[FormInfo]`, `[FormStand]` |

- `[Align]` (default `Client`) and `[ClipChildren]` (default False) on the form class control the form container; with an alignment other than Client the design size is kept.
- Window events (`OnShow`, `OnActivate`, `OnClose`, `OnResize`) do not fire: use `[BeforeShow]`/`[AfterShow]`/`[Hide]` methods. `OnCreate`/`OnDestroy` do.
- Non-generic `New(AClassName)` / `Use(AFrame)` exist only on TFrameStand.
- `ShowModal`, `ModalResult`, Back/Esc, `Push`/`Pop`, `ResponsiveMode` work the same as for frames.
