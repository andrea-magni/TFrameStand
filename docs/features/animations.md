# Animations

TFrameStand drives FireMonkey animations by **name**: no code, no events to wire. Put a `TAnimation` descendant (`TFloatAnimation`, `TColorAnimation`, `TRectAnimation`, `TBitmapListAnimation`...) in the stand and name it so that it matches one of two masks:

| Property | Default | Animations started |
|---|---|---|
| `AnimationShow` | `OnShow*` | by `Show`, right after the stand becomes visible |
| `AnimationHide` | `OnHide*` | by `Hide` (and `HideAndClose`) |

The mask is matched, case-insensitively, against the animation's `StyleName`, or its `Name` when `StyleName` is empty. Animations are searched in the whole tree of the stand clone, **frame included**: since the frame sits inside the stand's container, a frame can carry its own `OnShow*` / `OnHide*` animations (for example to animate one of its controls) and they are started together with the stand's.

## Hide waits for the animations

When you call `Hide`, every matching hide animation is started and the stand stays visible for the time of the longest one, computed as `Delay + Duration`. Only then the stand is made invisible and `OnAfterHide` fires. You can override the computed delay:

```pascal
LInfo.Hide(500);                 // hide after 500 ms, whatever the animations say
LInfo.Hide(0, procedure begin    // computed delay, then a callback
  ShowMessage('Gone');
end);
```

Before the stand is made invisible (and before it is freed by `Close`) all the show and hide animations are stopped: FireMonkey does not like objects freed while their animations are running.

## Typical animations

| Effect | Animation | Property | Values |
|---|---|---|---|
| Fade in | `TFloatAnimation` 'OnShowFade' on the root or a background | `Opacity` | 0 → 1 |
| Fade out | `TFloatAnimation` 'OnHideFade' | `Opacity` | current → 0 (`StartFromCurrent = True`) |
| Slide from bottom | `TFloatAnimation` 'OnShowSlide' on an aligned layout | `Margins.Bottom` | -Height → 0 |
| Zoom in | two `TFloatAnimation` 'OnShowZoomX' / 'OnShowZoomY' | `Scale.X`, `Scale.Y` | 0.8 → 1 |
| Dim background | `TFloatAnimation` 'OnShowDim' on a black `TRectangle` | `Opacity` | 0 → 0.6 |
| Blur the parent | `TGaussianBlurEffect` with a `TFloatAnimation` 'OnShowBlur' | `BlurAmount` | 0 → 0.5 |

Use `StartFromCurrent = True` on the hide animations: if the user closes the stand while it is still appearing, the hide starts from where the show animation arrived.

## Changing animations at runtime

The `OnBeforeStartAnimation` event is called for each animation that is about to start, with the info and the animation: use it to adapt durations, values or interpolation to the subject or to the device.

```pascal
procedure TMainForm.FrameStand1BeforeStartAnimation(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo; const AAnimation: TAnimation);
begin
  // faster transitions on phones
  if ASender.DeviceAndPlatformInfo.IsPhone then
    AAnimation.Duration := AAnimation.Duration / 2;
end;
```

You can also use different masks per component (`AnimationShow := 'Enter*'`), or start animations yourself from a `[Show]` method (see [Context Injection](/features/injection#lifecycle-methods)).

## Effects

Any FMX effect (`TShadowEffect`, `TGlowEffect`, `TGaussianBlurEffect`...) placed in the stand is applied to its element as usual.

Effects on what is **behind** the stand belong to the form: the `lightbox` demo blurs the form's content with a `TGaussianBlurEffect` that it enables in `OnBeforeShow` and disables in `OnAfterHide`, checking `ASubjectInfo.StandStyleName = 'lightbox'`.
