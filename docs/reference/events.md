# Events

All the events are published on both components and receive the component as `ASender`.

## Show and hide

```pascal
TOnBeforeShowEvent = procedure(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo) of object;
```

The same signature is used by `OnAfterShow`, `OnBeforeHide` and `OnAfterHide`.

| Event | Fired |
|---|---|
| `OnBeforeShow` | in `Show`, after the subject's `[BeforeShow]` methods, before the stand becomes visible |
| `OnAfterShow` | in `Show`, after the show animations have been started and the `[AfterShow]` methods |
| `OnBeforeHide` | in `Hide`, before the hide animations start |
| `OnAfterHide` | when the hide delay has elapsed and the stand is invisible, after the `AThen` callback of `Hide` |

Use `ASubjectInfo.StandStyleName` or `ASubjectInfo.Subject is TMyFrame` to react only to some subjects.

## OnBeforeStartAnimation

```pascal
TOnBeforeStartAnimationEvent = procedure(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo; const AAnimation: TAnimation) of object;
```

Fired for each show or hide animation, just before it is started. Change its properties to adapt the animation. See [Animations](/features/animations#changing-animations-at-runtime).

## OnBindCommonActionList

```pascal
TOnBindCommonActionList = procedure(ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo;
  const AObject: TFmxObject; var ACommonActionName: string) of object;
```

Fired for every object of the stand and subject while binding the `CommonActionList`. `ACommonActionName` holds the name derived from the prefix (empty if the object does not start with it): change it to bind a different action, or set it to bind objects without the prefix. See [Common Actions](/features/common-actions#binding-a-tactionlist).

## OnGetSubjectClass

```pascal
// TFrameStand
TOnGetFrameClassEvent = procedure(const ASender: TFrameStand; var AParent: TFmxObject;
  var AStandStyleName: string; var AFrameClass: TFrameClass) of object;
// TFormStand
TOnGetFormClassEvent = procedure(const ASender: TFormStand; var AParent: TFmxObject;
  var AStandStyleName: string; var AFormClass: TFormClass) of object;
```

Fired by `New`, after the responsive lookup, before the subject is created: change class, stand or parent. See [Responsive Frames](/features/responsive#the-ongetsubjectclass-event).
