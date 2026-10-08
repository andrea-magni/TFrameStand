# Your First Stand

In this walkthrough you build a **lightbox**: a frame shown at the centre of the form over a dimmed background, fading in and out, closed by a click on the background or on a button of the frame. It is the classic TFrameStand example, and it is all in the `demos\lightbox` project if you prefer to read the finished code.

## 1. Drop the components

Create a new **Multi-Device Application** and drop on the main form:

- a `TStyleBook` (`StyleBook1`): it will hold the stands. Leave the form's own `StyleBook` property empty, this style book is only for the stands;
- a `TFrameStand` (`FrameStand1`) and set:
  - `StandBook` = `StyleBook1`
  - `DefaultStandName` = `lightbox`

## 2. Design the stand

Double-click `StyleBook1` to open the style designer, and build this tree (the names that matter are in the `StyleName` property):

```
TLayout              StyleName = 'lightbox'     Align = Contents
├── TRectangle       StyleName = 'close_background'   Align = Contents, Fill = Black, Opacity = 0
│   └── TFloatAnimation  StyleName = 'OnShowFadeIn'   PropertyName = Opacity, StopValue = 0.6, Duration = 0.3
│   └── TFloatAnimation  StyleName = 'OnHideFadeOut'  PropertyName = Opacity, StopValue = 0,   Duration = 0.3
└── TRectangle       StyleName = 'panel'        Align = Center, Width = 400, Height = 300, Fill = White
    └── TLayout      StyleName = 'container'    Align = Client, Margins = 8
```

- `lightbox` is the **stand name**: it is what you pass to `New`/`NewAndShow` (or set in `DefaultStandName`).
- `container` is where your frame goes.
- Animations whose name matches `OnShow*` run when the frame is shown, the `OnHide*` ones when it is hidden. Hiding waits for them to finish before making the stand invisible.

Apply and close the style designer.

::: tip
The visibility of the stand's root element in the style book does not matter: TFrameStand clones it, keeps the clone invisible until `Show`, then makes it visible. The visibility of the children, instead, is used as it is.
:::

## 3. Create the frame

Add a new FireMonkey frame (**File ▸ New ▸ Multi-Device Frame**), name it `TDetailsFrame`, save it as `Frames.Details.pas`, and put on it a `TLabel` and a `TButton` named `CloseButton`. Design it for the size of the panel (400 × 300); at runtime the frame is aligned inside the container.

## 4. Show it

```pascal
uses
  FrameStand, SubjectStand, Frames.Details;

procedure TMainForm.ShowButtonClick(Sender: TObject);
var
  LInfo: TFrameInfo<TDetailsFrame>;
begin
  LInfo := FrameStand1.New<TDetailsFrame>();   // parent: the form; stand: DefaultStandName
  LInfo.Frame.Label1.Text := 'Hello, TFrameStand!';
  LInfo.Show();
end;
```

`New<T>` creates the frame, clones the stand, puts the frame in the container and the stand in the parent, still invisible. `Show` makes it visible and starts the `OnShow*` animations.

The same in one call, configuring the frame with an anonymous method:

```pascal
FrameStand1.NewAndShow<TDetailsFrame>(nil, 'lightbox',
  procedure (AFrame: TDetailsFrame)
  begin
    AFrame.Label1.Text := 'Hello, TFrameStand!';
  end);
```

## 5. Close it with a Common Action

Instead of writing an `OnClick` handler in every frame, register a **Common Action** once: every control whose `StyleName` (or `Name`) matches the pattern gets it as `OnClick`, in every frame shown by `FrameStand1`, stand elements included.

```pascal
procedure TMainForm.FormCreate(Sender: TObject);
begin
  FrameStand1.CommonActions.Add('Close*',
    procedure (AInfo: TSubjectInfo)
    begin
      AInfo.HideAndClose;
    end);
end;
```

The pattern is matched case-insensitively against the `StyleName` of each control (or its `Name`, when `StyleName` is empty), so `Close*` matches both `CloseButton` on the frame and the `close_background` rectangle of the stand: a click outside the panel closes the lightbox too.

`HideAndClose` runs the `OnHide*` animations, waits for them, then frees the stand and the frame (the frame was created by `New`, so it is owned by the stand).

Run the application: the frame fades in over the dimmed form, and a click on the button or on the background fades it out.

## What's next

- Understand what happened in [Core Concepts](/guide/core-concepts) and [Lifecycle & Ownership](/guide/lifecycle).
- Make more stands: see [Designing Stands](/guide/stands).
- Let the frame reach its own info, parent and stand with [Context Injection](/features/injection).
