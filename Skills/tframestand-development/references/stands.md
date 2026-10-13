# Stands, gallery, animations

## Anatomy of a stand

```
TLayout            StyleName = '<stand name>'   root, found by name, always aligned Contents at runtime
├── TRectangle     StyleName = 'background_cancel'   decorations (a dimmed background...)
├── TRectangle     StyleName = 'card'
│   └── TLayout    StyleName = 'container'          the subject goes here (any depth); none: the root
└── TFloatAnimation StyleName = 'OnShowFade' / 'OnHideFade'  started by Show / Hide (any depth)
```

Design stands in a `TStyleBook` (style designer) and assign it to `StandBook`; one style book holds many stands; each `New`/`Use` clones the stand. Customize a clone in `OnBeforeShow` (`ASubjectInfo.Stand.FindStyleResource('card') as TControl`).

## The stand gallery

`stands\Stands.Light.style` and `stands\Stands.Dark.style` (same stand names; switch theme by loading the other file in the same style book):

| Stand | Description | Elements |
|---|---|---|
| `dialog` | centered card (320×240) over a dimmed background | `card`, `background_cancel` |
| `lightbox` | subject almost full screen over a dark background | `container` (24 px margins), `background_cancel` |
| `bottomsheet` | sheet sliding up (height 360) with a handle | `sheet`, `background_cancel` |
| `drawer` | side menu sliding from the left (width 300) | `panel`, `background_cancel` |
| `snackbar` | bar at the bottom (height 56), no background, UI stays usable | `bar` |
| `page` | full page, slides in from the right; back from the left on `Pop` | |

Load at design time (style designer > Load) or at runtime:

```pascal
Stands.LoadFromFile('Stands.Light.style');   // or a TResourceStream with an RCDATA resource
FrameStand1.StandBook := Stands;
FrameStand1.CommonActions.Add('*_cancel', procedure (AInfo: TSubjectInfo) begin AInfo.ModalResult := mrCancel; end);
FrameStand1.New<TChoiceFrame>(nil, 'bottomsheet').ShowModal(...);
```

For mobile, embed the files as RCDATA (`<RcItem Include="..\stands\Stands.Light.style"><ResourceType>RCDATA</ResourceType><ResourceId>STANDS_LIGHT</ResourceId></RcItem>` in the .dproj, `{$R *.dres}` in the .dpr) or load them in the style book at design time. Frames keep the application style's colors: on dark stands set label font colors or use a dark app style.

## Animations

- `AnimationShow` / `AnimationHide` masks (default `OnShow*` / `OnHide*`) select the animations by `StyleName` (or `Name`).
- `Hide` waits for the longest `Delay + Duration` of the hide animations before hiding.
- `OnBeforeStartAnimation(ASender, ASubjectInfo, AAnimation)` adapts values per subject/device.
- Slide without squeezing the content: animate `Margins.Left` and `Margins.Right` together on an `Align = Client` element (the `page` stand does), or `Margins.Bottom` of an `Align = Bottom` element.

### Values from the size of the stand

Put a `TStyleTag` inside a `TFloatAnimation` (animations do not store `TagString` in a style):

```
object TFloatAnimation
  StyleName = 'OnShowSlide'
  PropertyName = 'Margins.Bottom'
  StopValue = 0
  object TStyleTag
    TagString = 'StartValue=-ParentHeight'
  end
end
```

Keys: `StartValue`, `StopValue`, `PopStartValue`, `PopStopValue` (used while the navigation stack pops). Values: `Width`/`Height` (the stand = its parent), `ParentWidth`/`ParentHeight` (the element the animation belongs to), numbers; optionally negative. Separated by `;`. Applied just before `OnBeforeStartAnimation`. Animations created in code can use their own `TagString`.
