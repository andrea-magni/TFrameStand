# Introduction

**TFrameStand** and **TFormStand** are two non-visual components for Delphi FireMonkey (FMX) that show a `TFrame` (or the content of a `TForm`) inside your application through a **stand**: a reusable visual layer that sits between the frame and the control hosting it.

They solve a problem every FMX application meets sooner or later: you split the UI into frames to keep it manageable, and then you write the same plumbing over and over to create them, parent them, fade them in, dim the background, close them on a click outside, free them at the right time. With TFrameStand that plumbing is declared once, in a style, and every frame of the application can use it.

## The idea in one picture

```
  Parent control (a TLayout, the form, a TListView, a TEdit...)
  └── Stand        ← designed in a TStyleBook: background, shadow, effects, animations
      └── container   ← the stand's style element named 'container'
          └── Your TFrame  (or the controls of your TForm, with TFormStand)
```

- The **subject** is what you want to show: a `TFrame` descendant for TFrameStand, a `TForm` descendant for TFormStand.
- The **stand** is a style item (a `TLayout`, `TRectangle`... with children) looked up by name in the component's `StandBook` (a `TStyleBook`). Each time you show a subject, a clone of the stand is created.
- The **container** is the element of the stand, with `StyleName = 'container'`, that receives the subject. If the stand has no container, the subject goes directly into the stand.
- The **parent** is the FMX object the stand is added to: the one you pass, or `DefaultParent`, or the component's owner (usually the form).

Each subject shown gets an **info** object (`TFrameInfo<T>` / `TFormInfo<T>`) that you use to show, hide and close it, and to reach the frame, the stand and the container.

## What you get

- **Visual consistency**: one stand for all dialogs, one for all side panels, one for all toasts. Change the style, change the whole app.
- **Animations and effects for free**: every `TAnimation` in the stand named `OnShow*` runs on show, every `OnHide*` on hide; hiding waits for the animations to complete. See [Animations](/features/animations).
- **Common Actions**: bind a behaviour to controls by name pattern (`Close*`, `*_cancel`...) across all the frames shown by a stand, or bind them to a `TActionList`. See [Common Actions](/features/common-actions).
- **Context injection**: frames declare what they need with attributes (`[FrameInfo]`, `[Parent]`, `[BeforeShow]`...) and get it injected. See [Context Injection](/features/injection).
- **Responsive substitution**: choose the frame class, stand or parent according to the available width. See [Responsive Frames](/features/responsive).
- **TFormStand**: the same with `TForm` descendants, so you can design subjects with Fire UI views and the style preview of the form designer. See [TFormStand](/features/formstand).

## Requirements

- Delphi with FireMonkey. Packages are provided for each Delphi version from 10.3 Rio to Delphi 13 Florence (older package files for XE8–10.2 are still in the repository, see [Installation](/guide/installation#supported-delphi-versions)).
- Any FMX platform: Windows, macOS, iOS, Android, Linux (FMXLinux).

## Learn more

- [Your first stand](/guide/getting-started): a lightbox in ten minutes.
- [Core concepts](/guide/core-concepts): subjects, stands, containers, parents and infos in detail.
- The [CodeRage X session](https://www.youtube.com/watch?v=Z6_ZvnCmFCw) (50 minutes, covers the basics), the [blog posts](https://blog.andreamagni.eu/tag/tframestand/) and a full chapter of the book [Delphi GUI Programming with FireMonkey](https://www.packtpub.com/product/delphi-gui-programming-with-firemonkey/9781788624176).
