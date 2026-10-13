# Responsive frames

## Breakpoints

Default: `xs` 400, `sm` 768, `md` 992, `lg` 1200 (max widths). The breakpoint of a width is the smallest one with `MaxWidth >= width`; wider falls in the largest.

```pascal
FrameStand1.Responsive.Breakpoints.Clear;
FrameStand1.Responsive.AddBreakpoint(480, 'sm');
FrameStand1.Responsive.AddBreakpoint(1080, 'lg');
FrameStand1.Responsive.CurrentBreakpoint(MainContent.Width);
```

## Definitions

```pascal
// always request the base class; substitutes must descend from it
FrameStand1.Responsive.Define(TOrdersFrame_xs, TOrdersFrame_sm, 'sm');
FrameStand1.Responsive.Define(TOrdersFrame_xs, TOrdersFrame_lg, 'lg');
LInfo := FrameStand1.New<TOrdersFrame_xs>(MainContent);

// stand (and parent) substitution: TResponsiveDefinition (class, stand name, parent); empty = keep
FrameStand1.Responsive.Define(
  TResponsiveDefinition.Create(TDetailsFrame, 'lightbox'),
  TResponsiveDefinition.Create(nil, 'fullscreen'), 'xs');
```

- Applied by `New` (and `Push`), not `Use`, using the width of the parent at that moment (`GetParentWidth`: controls, forms, 3D layers in pixels; override for other parents).
- Several matches: the **last defined** wins; define from the smallest breakpoint up.
- `OnGetSubjectClass(ASender, var AParent, var AStandStyleName, var AFrameClass)` runs after the lookup for custom logic (`ASender.DeviceAndPlatformInfo.IsPhone`...).
- `[FrameInfo]` fields of substitutes: type them on the base class (`TFrameInfo<TOrdersFrame_xs>`).

## Live: ResponsiveMode = rmLive

```pascal
FrameStand1.ResponsiveMode := rmLive; // published, default rmOnCreate

procedure TMainForm.FrameStand1ResponsiveChange(const ASender: TSubjectStand;
  const AInfo: TSubjectInfo; const AOldSubject: TSubject);
begin
  // the new subject is ready, the old one still exists (freed right after)
  TOrdersFrame_xs(AInfo.Subject).DM := TOrdersFrame_xs(AOldSubject).DM;
end;
```

- When the parent's width moves to another breakpoint (resize, rotation), subjects created with `New`/`Push` are re-checked and, if class/stand/parent change, replaced **in the same info**: references to the info, stack position, `ShowModal` and its result procedure keep working; `Info.Frame` returns the new frame.
- Visible subjects: replaced once the resize is over, shown again with the show animations. Hidden ones: when shown again.
- Never keep the frame itself in a field; copy user state in `OnResponsiveChange`.
