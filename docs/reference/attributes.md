# Attributes

All the attributes can be written with or without the `Attribute` suffix (`[FrameInfo]` = `[FrameInfoAttribute]`).

## Context attributes

Used on **fields** of the subject (injected by `New`/`Use`) and, where noted, on **parameters** of the lifecycle methods. See [Context Injection](/features/injection).

| Attribute | Unit | Value | Fields | Parameters |
|---|---|---|---|---|
| `[SubjectStand]` | `SubjectStand` | the component (`TSubjectStand`) | ✓ | ✓ |
| `[SubjectInfo]` | `SubjectStand` | the info (`TSubjectInfo`) | ✓ | ✓ |
| `[Stand]` | `SubjectStand` | the stand clone (`TControl`) | ✓ | ✓ |
| `[Container]` | `SubjectStand` | the stand element holding the subject (`TFmxObject`) | ✓ | ✓ |
| `[Parent]` | `SubjectStand` | the parent of the stand (`TFmxObject`) | ✓ | ✓ |
| `[FrameStand]` | `FrameStand` | the component (`TFrameStand`) | ✓ | |
| `[FrameInfo]` | `FrameStand` | the info (`TFrameInfo<T>`) | ✓ | |
| `[FormStand]` | `FormStand` | the component (`TFormStand`) | ✓ | |
| `[FormInfo]` | `FormStand` | the info (`TFormInfo<T>`) | ✓ | |

## Lifecycle attributes

Used on **public methods** of the subject. Unit `SubjectStand`. See [Lifecycle methods](/features/injection#lifecycle-methods).

| Attribute | Called |
|---|---|
| `[BeforeShow]` | at the start of `Show`, before the `OnBeforeShow` event |
| `[Show]` | in place of the default show (making the stand visible) |
| `[AfterShow]` | at the end of `Show`, before the `OnAfterShow` event |
| `[Hide]` | in place of the default hide (making the stand invisible), after the hide delay |

## Form class attributes

Used on the **class** of a form shown by TFormStand. Unit `FormStand`. See [TFormStand](/features/formstand#layout-attributes).

| Attribute | Default | Effect |
|---|---|---|
| `[Align(TAlignLayout)]` | `TAlignLayout.Client` | alignment of the form container |
| `[ClipChildren(Boolean)]` | `False` | clipping of the form container |
