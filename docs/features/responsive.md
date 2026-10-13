# Responsive Frames

The same piece of UI often needs a different layout on a phone and on a desktop. TFrameStand can **substitute** the frame class (and the stand, and the parent) when a frame is created, according to the width available in the parent, using breakpoints as CSS frameworks do.

## Breakpoints

A breakpoint is a name and a maximum width. The component starts with four:

| Name | Max width |
|---|---|
| `xs` | 400 |
| `sm` | 768 |
| `md` | 992 |
| `lg` | 1200 |

The current breakpoint for a width is the smallest one whose `MaxWidth` is greater than or equal to the width; widths beyond the largest breakpoint fall in the largest one.

Define your own:

```pascal
FrameStand1.Responsive.Breakpoints.Clear;
FrameStand1.Responsive.AddBreakpoint(240, 'xs');
FrameStand1.Responsive.AddBreakpoint(480, 'sm');
FrameStand1.Responsive.AddBreakpoint(720, 'md');
FrameStand1.Responsive.AddBreakpoint(1080, 'lg');
```

The list is kept sorted by width (`AddBreakpoint` and `SetBreakpoint`, which replaces a breakpoint by name, sort it), and the comparisons between breakpoints use their widths, so the order in which you add them does not matter.

`Responsive.CurrentBreakpoint(AWidth)` tells you the breakpoint for a width, and `Responsive.Breakpoints.ByName('md').MaxWidth` reads a threshold back.

## Definitions

A definition says: *when a subject of this class is requested and the breakpoint is this one or larger, use this other class instead*.

```pascal
// TOrdersFrame_xs is the base: a simple list for small screens
FrameStand1.Responsive.Define(TOrdersFrame_xs, TOrdersFrame_sm, 'sm');  // list + details from sm up
FrameStand1.Responsive.Define(TOrdersFrame_xs, TOrdersFrame_lg, 'lg');  // a full grid from lg up
```

```pascal
// always ask for the base class: the right one is created
FOrdersInfo := FrameStand1.New<TOrdersFrame_xs>(MainContent);
```

The substitute classes should descend from the base class requested, since `New<TOrdersFrame_xs>` returns a `TFrameInfo<TOrdersFrame_xs>` and you will access the frame as a `TOrdersFrame_xs`.

When several definitions match, the **last one** defined wins: define them from the smallest breakpoint to the largest, as above. On an `md` screen both the `sm` definition matches (`md` ≥ `sm`) and the `lg` one does not, so `TOrdersFrame_sm` is used.

The full form of `Define` works on `TResponsiveDefinition` records, which hold a class, a stand name and a parent; the source stand name can be a mask:

```pascal
FrameStand1.Responsive.Define(
  TResponsiveDefinition.Create(TDetailsFrame, 'lightbox'),     // when asked for this...
  TResponsiveDefinition.Create(nil, 'fullscreen'),             // ...use another stand, same class
  'xs');
```

In the target, an empty class, stand name or parent means "keep the requested one".

## When the substitution happens

The lookup runs in `New` (not in `Use`, which receives an already created frame), only when at least one definition exists, and uses the width of the parent **at that moment**:

- `Width` of controls and forms (`TForm`, `TForm3D`);
- the width in pixels of the 2D content of 3D layers (`TLayer3D`...: `Width * Resolution`, or `Width` with the `Screen` projection);
- any other `Width` property, read through RTTI.

Override `GetParentWidth` in a descendant of the component for other kinds of parents.

## Live: following the window

By default (`ResponsiveMode = rmOnCreate`) a frame already on screen is not replaced when the window is resized. Set `ResponsiveMode = rmLive` and it is: when the width of its parent moves to another breakpoint (the window is resized, the phone is rotated), the definitions are checked again and, if they now give another class, stand or parent, the subject is replaced.

```pascal
FrameStand1.ResponsiveMode := rmLive; // usually set at design time
FOrdersInfo := FrameStand1.New<TOrdersFrame_xs>(MainContent);
FOrdersInfo.Show;
// wider window: FOrdersInfo.Frame is now a TOrdersFrame_sm, then a TOrdersFrame_lg...
```

- **The info stays the same**: keep the info in your fields, not the frame. `FOrdersInfo` stays valid, as do its place in the [navigation stack](/features/navigation), a [dialog](/features/dialogs) in progress and its result procedure; `FOrdersInfo.Frame` returns the new frame.
- **Visible subjects** are replaced once the resize is over, and shown again with the show animations of their stand; **hidden** ones when they are shown again.
- Only subjects created with `New` or `Push` are replaced: `Use` receives a frame that already exists, with no class to look up.
- `OnGetSubjectClass` is called again too, so it can take part in the choice.

The new frame starts from scratch. To keep what the user did, copy it in `OnResponsiveChange`, which runs when the new frame is ready and the old one still exists (it is freed right after):

```pascal
procedure TMainForm.FrameStand1ResponsiveChange(const ASender: TSubjectStand;
  const AInfo: TSubjectInfo; const AOldSubject: TSubject);
begin
  if (AInfo.Subject is TOrdersFrame_xs) and (AOldSubject is TOrdersFrame_xs) then
  begin
    TOrdersFrame_xs(AInfo.Subject).DM := TOrdersFrame_xs(AOldSubject).DM;
    TOrdersFrame_xs(AInfo.Subject).SelectedOrder := TOrdersFrame_xs(AOldSubject).SelectedOrder;
  end;
end;
```

The `Responsive` demo uses `rmLive`.

## The OnGetSubjectClass event

After the responsive lookup, `New` fires `OnGetSubjectClass`, where you can change class, stand and parent with any logic you like (device type, user preferences, orientation...):

```pascal
procedure TMainForm.FrameStand1GetSubjectClass(const ASender: TFrameStand;
  var AParent: TFmxObject; var AStandStyleName: string; var AFrameClass: TFrameClass);
begin
  if (AFrameClass = TDetailsFrame) and ASender.DeviceAndPlatformInfo.IsPhone then
    AStandStyleName := 'fullscreen';
end;
```

`DeviceAndPlatformInfo` returns a record with the platform, the device class (phone, tablet, desktop...), the device name and the display metrics, with helpers like `IsPhone`, `IsTablet`, `IsDesktop`, `IsAndroid`, `IsiOS`.
