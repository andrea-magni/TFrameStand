# Core Concepts

TFrameStand and TFormStand share their whole engine, implemented in the `SubjectStand` unit. This page describes the moving parts; the names are the ones you find in the code.

## Subject

The **subject** is the object you want to show: a `TFrame` descendant for `TFrameStand`, a `TForm` descendant for `TFormStand`. In the shared code it is typed as `TSubject = TFmxObject`.

You give the component a subject in two ways:

| Method | Who creates the subject | Who frees it |
|---|---|---|
| `New<T>(AParent, AStandName)` | the component (`T.Create(nil)`, `Name` cleared) | the component, on `Close` |
| `Use<T>(AFrame, AParent, AStandName)` | you | you: on `Close` the frame is only removed from the stand |

The flag is exposed as `FrameIsOwned` / `FormIsOwned` (and `SubjectIsOwned`) on the info object, and you can change it.

## Stand

The **stand** is the visual layer between the subject and its parent. It is a style item, found by name in the `StandBook` (a `TStyleBook`) and **cloned** for each subject, so the same stand can host many subjects at the same time.

The stand name is resolved in this order:

1. the `AStandStyleName` argument of `New`/`Use`/`NewAndShow`, when not empty;
2. the `DefaultStandName` property of the component. Its default value is the class name without the `T`, lowercased: `framestand` for TFrameStand, `formstand` for TFormStand.

If no `StandBook` is assigned, or it contains no item with that name, TFrameStand creates an empty `TLayout` with `Align = Contents` and uses it as stand: the subject is shown as is, with no decoration. This is handy for embedding frames in a layout without any effect.

Whatever the style says, the stand is always aligned with `Align = Contents` (it covers its parent), and it is kept invisible until `Show`.

See [Designing Stands](/guide/stands) for how to build them.

## Container

The **container** is the element of the stand whose `StyleName` is `container`. The subject is added to it, so you decide with the container's `Align`, `Margins` and size where the frame lands inside the stand. If the stand has no `container` element, the stand itself is the container.

## Parent

The **parent** is the FMX object the stand is added to: any `TFmxObject`, typically a `TLayout`, the form, or a control you want to decorate (a `TEdit`, a `TListView`, a `TImage`...). It is resolved in this order:

1. the `AParent` argument, when assigned;
2. the `DefaultParent` property;
3. the `Owner` of the component (the form you dropped it on).

## Info

Every subject handled by the component has an **info** object: `TFrameInfo<T>` for frames, `TFormInfo<T>` for forms, both descending from `TSubjectInfo`. It is the handle you keep to drive the subject:

```pascal
var
  LInfo: TFrameInfo<TDetailsFrame>;
begin
  LInfo := FrameStand1.New<TDetailsFrame>(Layout1, 'sidepanel');
  LInfo.Frame.Customer := ACustomer;  // typed access to the frame
  LInfo.Show;
  // later...
  LInfo.HideAndClose;
end;
```

Its main members:

| Member | What it is |
|---|---|
| `Frame` / `Form` | the subject, typed as `T` |
| `Stand` | the clone of the stand (a `TControl`) |
| `Container` | the element the subject was added to |
| `Parent` | the object the stand was added to |
| `StandStyleName` | the name of the stand used |
| `Status` | `Initializing`, `Ready`, `Showing`, `Visible`, `Hiding`, `Hidden`, `Closing` |
| `IsVisible`, `Hiding` | shortcuts on the state |
| `Show`, `Hide`, `HideAndClose`, `Close` | see [Lifecycle & Ownership](/guide/lifecycle) |

The component keeps all the infos in `FrameInfos` (`FormInfos`), a dictionary keyed by subject, and you can look them up again later:

```pascal
FrameStand1.FrameInfo(MyFrame);                    // by instance
FrameStand1.FrameInfo<TDetailsFrame>;              // first info whose frame is a TDetailsFrame
FrameStand1.GetFrameInfo<TDetailsFrame>(True);     // the same, created with New<T> if missing
FrameStand1.LastShownFrame;                         // the frame shown most recently and still visible
```

## The component

`TFrameStand` and `TFormStand` are non-visual components (they descend from `TComponent` through `TSubjectStand`). You usually drop one on each form that shows frames, but nothing stops you from having more (one per style of stand, for instance) or from creating them in code.

Their published properties:

| Property | Default | Purpose |
|---|---|---|
| `StandBook` | | the `TStyleBook` with the stands |
| `DefaultStandName` | `framestand` / `formstand` | stand used when none is given |
| `DefaultParent` | | parent used when none is given (otherwise the owner) |
| `AnimationShow` | `OnShow*` | mask of the animations started on show |
| `AnimationHide` | `OnHide*` | mask of the animations started on hide |
| `CommonActionList` | | a `TActionList` for [Common Actions](/features/common-actions#binding-a-tactionlist) |
| `CommonActionPrefix` | `ca_` | prefix that binds a control to an action of `CommonActionList` |
| `DefaultHideAndCloseDeferTimeMS` | `100` | pause between hide and close in `HideAndClose` |

`StyleBook` and `DefaultStyleName` are older names of `StandBook` and `DefaultStandName`, kept for compatibility.

The full list of methods is in the [reference](/reference/components).
