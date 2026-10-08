# 3D Stands

A stand is any FMX style item, so it can contain a 3D scene: a `TViewport3D` with a `TLayer3D` inside shows a 2D frame on a plane in a 3D space, which you can rotate, move and animate like any 3D object. `demos\Stand3D` shows two such stands, `stand3D` and `new3D`.

```
TLayout 'new3D'                         Align = Contents
└── TViewport3D                         Align = Client
    └── TLayer3D 'layer3D'              Align = Client
        ├── TRectangle 'rectangle'
        │   └── TLayout 'container'     ← the frame goes on the 3D layer
        ├── TFloatAnimation             OnShow*: PropertyName = RotationAngle.X
        └── TFloatAnimation             OnHide*: PropertyName = RotationAngle.X
```

The other stand of the demo, `stand3D`, uses the `TLayer3D` itself as `container`, inside a `TDummy`, with its own `TCamera` named `camera` in a second `TDummy`.

The frame is placed, as usual, in the `container` element, which here is inside the `TLayer3D`: it keeps working as a normal 2D frame, with mouse and touch input.

A 3D object can also be the **parent** of an ordinary stand: `FrameStand1.New<TMyFrame>(Layer3D1)` puts the stand on the 2D surface of a `TLayer3D`, and a `TFrameStand` dropped on a `TForm3D` uses the form as default parent.

## Wiring the scene

Some 3D settings cannot be expressed in the style and must be applied to each clone. The `OnBeforeShow` event of the component is the place for them, for example to make the viewport use the camera of the stand:

```pascal
procedure TMainForm.FrameStand1BeforeShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
var
  LViewport: TViewport3D;
begin
  if ASubjectInfo.StandStyleName = 'stand3D' then
  begin
    LViewport := ASubjectInfo.Stand.Children[0] as TViewport3D;  // the root's first child
    LViewport.Camera := ASubjectInfo.Stand.FindStyleResource('camera') as TCamera;
    LViewport.UsingDesignCamera := False;
  end;
end;
```

The demo also realigns the `TLayer3D` when the form is resized, to work around an FMX issue with `TLayer3D` alignment ([RSP-18282](https://quality.embarcadero.com/browse/RSP-18282)).
