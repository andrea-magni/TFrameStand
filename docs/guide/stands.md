# Designing Stands

A stand is an ordinary FireMonkey style item. You design it in the **style designer** of a `TStyleBook` (double-click the style book), exactly like a custom style for a control, and assign that style book to the `StandBook` property of the component.

## Anatomy

```
TLayout                      StyleName = '<stand name>'   ← root: looked up by name
├── ... decorations           backgrounds, shadows, effects, images
├── TLayout                  StyleName = 'container'     ← the subject goes here
└── TFloatAnimation ...      StyleName = 'OnShow...' / 'OnHide...'
```

The rules are few:

- the **root** element is found by its `StyleName`: that is the stand name. Any `TControl` works (`TLayout`, `TRectangle`, `TPanel`...). It is always aligned with `Align = Contents` at runtime;
- the element with `StyleName = 'container'` receives the subject. It can be anywhere in the tree, at any depth. Without it, the subject goes in the root;
- animations named `OnShow*` / `OnHide*` (the masks are the `AnimationShow` / `AnimationHide` properties) run on show and hide, wherever they are in the tree. See [Animations](/features/animations);
- any element can carry a name matched by a [Common Action](/features/common-actions), for example a dimmed background that closes the stand when clicked.

One style book can hold any number of stands. Every call to `New` or `Use` clones the stand, so the same stand can be on screen several times at once.

## Recipes

### Lightbox

A centred panel over a dimmed background (see `demos\lightbox` and [Your First Stand](/guide/getting-started)).

```
TLayout       'lightbox'
├── TRectangle  'close_background'  Align = Contents, Fill = Black, Opacity = 0
│   ├── TFloatAnimation 'OnShowFade'  Opacity → 0.6
│   └── TFloatAnimation 'OnHideFade'  Opacity → 0
└── TRectangle  'panel'  Align = Center, with a TShadowEffect
    └── TLayout 'container'  Align = Client
```

### Sliding panel

A panel that slides in from the bottom, animating its margin (from `demos\MaterialButton\styles.style`):

```
TLayout 'slide_down_up'   Align = Contents
└── TLayout 'slider'      Align = Bottom, Height = 100
    ├── TLayout 'container'  Align = HorzCenter
    ├── TFloatAnimation 'OnShowSlideIn'   PropertyName = Margins.Bottom, -100 → 10, Interpolation = Bounce
    └── TFloatAnimation 'OnHideSlideOut'  PropertyName = Margins.Bottom, current → -100
```

Change `Align = Bottom` to `Right` and animate `Margins.Right` and you get a side panel; the demo has both, plus a centred variant, and lets you switch stand at runtime.

### Bottom sheet

`demos\BottomSheet` shows a frame in a `bottomsheetstand` docked at the bottom of a content layout. The form handles the pan gesture on the stand's `peek` element and animates the height of its `bottomsheet` element, both reached with `Info.Stand.FindStyleResource`: a good example of driving stand elements from code.

### No decoration

When the stand name is not found in the `StandBook` (or no style book is assigned), the subject is placed in an empty `TLayout`. Use it to embed a frame in a layout, with all the other features (injection, Common Actions, lifecycle) and no visual effect.

## Choosing the stand at runtime

The stand is a parameter of `New`, `Use`, `NewAndShow` and `GetFrameInfo`:

```pascal
// the same frame, two presentations
if IsPhone then
  FrameStand1.NewAndShow<TDetailsFrame>(nil, 'fullscreen')
else
  FrameStand1.NewAndShow<TDetailsFrame>(nil, 'lightbox');
```

For width-based choices, [Responsive Frames](/features/responsive) does it declaratively, and the `OnGetSubjectClass` event lets you change class, stand and parent in a single place.

## Customizing the stand before it shows

The clone of the stand is available as `Info.Stand` right after `New`, before `Show`: find its elements with `FindStyleResource` and adjust them.

```pascal
LInfo := FrameStand1.New<TDetailsFrame>(nil, 'lightbox');
(LInfo.Stand.FindStyleResource('panel') as TRectangle).Fill.Color := TAlphaColors.Lightyellow;
LInfo.Show;
```

The `OnBeforeShow` event, called for every subject, is the place for adjustments that apply to all the subjects of a stand (the `Stand3D` demo wires a camera to its viewport there).

## Keeping stands in a separate file

A style book can load its content from a `.style` file, so the stands of a whole application can live in one file shared by many forms:

```pascal
StyleBook1.LoadFromFile('stands.style');
FrameStand1.StandBook := StyleBook1;
```

`demos\MaterialButton\styles.style` is a readable example of such a file.

::: tip
Use a style book dedicated to the stands, not the one assigned to the form's `StyleBook` property: stand names could clash with the style names of the controls, and the stands would be loaded as styles of the form.
:::
