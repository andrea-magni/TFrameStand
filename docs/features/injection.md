# Context Injection

A frame shown by TFrameStand often needs its context: the info to close itself, the parent it decorates, the stand to tweak an element. Instead of passing references around, the frame **declares** what it needs with attributes, and the component injects it.

## Field injection

Mark a field of the frame with a context attribute. Fields are injected by `New`/`Use`, after the frame has been placed in the stand and before `Show`.

```pascal
uses FMX.Forms, FMX.Edit, FrameStand, SubjectStand;

type
  THelperFrame = class(TFrame)
    PlusButton: TButton;
    procedure PlusButtonClick(Sender: TObject);
  private
    [FrameInfo] FInfo: TFrameInfo<THelperFrame>;   // my own info
    [Parent]    FEdit: TEdit;                      // the control I decorate
  end;

procedure THelperFrame.PlusButtonClick(Sender: TObject);
begin
  FEdit.Text := (StrToIntDef(FEdit.Text, 0) + 1).ToString;
end;
```

```pascal
// in the form: decorate Edit1 with the helper frame
FrameStand1.New<THelperFrame>(Edit1).Show;
```

| Attribute | Field type | Injected value |
|---|---|---|
| `[FrameInfo]` | `TFrameInfo<T>` | the info of this frame (TFrameStand) |
| `[FrameStand]` | `TFrameStand` | the component (TFrameStand) |
| `[FormInfo]` | `TFormInfo<T>` | the info of this form (TFormStand) |
| `[FormStand]` | `TFormStand` | the component (TFormStand) |
| `[SubjectInfo]` | `TSubjectInfo` | the info, untyped (both components) |
| `[SubjectStand]` | `TSubjectStand` | the component, untyped |
| `[Parent]` | any `TFmxObject` descendant | the parent the stand was added to |
| `[Stand]` | any `TControl` descendant | the clone of the stand |
| `[Container]` | any `TFmxObject` descendant | the stand element holding the frame |

For `[Parent]`, `[Stand]` and `[Container]` you can declare the field with the type you expect, as `TEdit` above: the frame must then always be shown on that kind of object, otherwise the injection fails with an invalid cast. `TFmxObject` is always safe.

The attributes are declared in `SubjectStand` (generic ones), `FrameStand` and `FormStand` (specific ones): add those units to the `uses` of the frame. In the `FormStand` demos the long form `[FormInfoAttribute]` is used; it is equivalent to `[FormInfo]`.

::: tip
Injected fields are not available in the frame's constructor: they are set after it. Use them from event handlers or from the lifecycle methods below.
:::

## Lifecycle methods

Mark **public** methods of the frame with a lifecycle attribute to have them called at the corresponding moment:

| Attribute | Called | Notes |
|---|---|---|
| `[BeforeShow]` | at the start of `Show`, before `OnBeforeShow` | prepare data, reset the UI |
| `[Show]` | instead of the default show | you must make `Stand` visible yourself |
| `[AfterShow]` | at the end of `Show`, before `OnAfterShow` | animations have just been started |
| `[Hide]` | instead of the default hide, after the hide delay | you must make `Stand` invisible yourself |

```pascal
type
  TCodeRageXFrame = class(TFrame)
    Image1: TImage;
  private
    [FrameInfo] FInfo: TFrameInfo<TCodeRageXFrame>;
  public
    [BeforeShow] procedure MyBeforeShow;
  end;

procedure TCodeRageXFrame.MyBeforeShow;
begin
  Image1.RotationAngle := 30;
end;
```

The methods must be visible to extended RTTI (public or published; this is the default for public methods). Several methods can carry the same attribute.

### Parameters

Lifecycle methods can take parameters, if every parameter is an object marked with a context attribute: the same attributes, with the same rules, as for the fields.

```pascal
type
  TButtonSetFrame = class(TFrame)
  public
    [BeforeShow]
    procedure BeforeShow([Parent] AParentObj: TFmxObject);
  end;

  TDetailsFrame = class(TFrame)
  public
    [AfterShow]
    procedure AfterShow([FrameInfo] AInfo: TFrameInfo<TDetailsFrame>; [Stand] AStand: TControl);
  end;
```

## Errors

Problems are reported when the subject is created (`New`, `Use`), with an `ESubjectStandError` that names the class, the field or parameter and the reason:

- a lifecycle method with a parameter that is not an object, has no context attribute, or has one that does not apply to its type:
  `TMyFrame.BeforeShow: cannot inject parameter AParent. Parameters of [BeforeShow], [Show], [AfterShow] and [Hide] methods must be objects marked with a context attribute...`
- a value that does not fit the declared type, e.g. `[Parent] FEdit: TEdit` on a frame shown on a `TLayout`:
  `TEditFrame: cannot inject [Parent] into field FEdit: the value is a TLayout, the declared type is TEdit`

On **fields**, a context attribute that does not apply to the type of the field (say `[Stand]` on a `string`) is ignored, as it has always been.

::: tip Responsive substitution and typed infos
Generic types are unrelated in Delphi: `TFrameInfo<TBase>` is not a `TFrameInfo<TDerived>`. When `New<TBase>` creates a `TDerived` frame through [responsive substitution](/features/responsive), its info is a `TFrameInfo<TBase>`: declare the `[FrameInfo]` field (or parameter) of `TDerived` as `TFrameInfo<TBase>`, or as `TSubjectInfo`. The error message suggests the right type.
:::

## Form-level attributes (TFormStand)

TFormStand adds two attributes for the **class** of the form, read when its content is moved into the stand. See [TFormStand](/features/formstand#layout-attributes).
