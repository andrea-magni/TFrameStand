---
layout: home

hero:
  name: "TFrameStand"
  text: "Frames and forms, on a stand"
  tagline: Show any TFrame or TForm in your FireMonkey app through reusable, animated stands. Consistent UI, modern transitions, almost no code.
  image:
    src: /logo.png
    alt: TFrameStand
  actions:
    - theme: brand
      text: Get Started
      link: /guide/introduction
    - theme: alt
      text: Your First Stand
      link: /guide/getting-started
    - theme: alt
      text: Demos
      link: /demos/
    - theme: alt
      text: View on GitHub
      link: https://github.com/andrea-magni/TFrameStand

features:
  - icon: 🖼️
    title: Stands
    details: 'Design the visual layer between your frame and its parent once, in a TStyleBook, and reuse it everywhere. Lightbox, dialog, bottom sheet, toast, side panel.'
    link: /guide/stands
    linkText: Designing stands
  - icon: ✨
    title: Animations & effects
    details: 'Any TAnimation in the stand whose name matches OnShow* or OnHide* runs on show and hide. Hide waits for the animations to finish, automatically.'
    link: /features/animations
    linkText: Animations
  - icon: 🎯
    title: Common Actions
    details: 'Bind behaviour (close, cancel, confirm...) to controls by name pattern, across every frame shown by the stand. Works with TActionList too.'
    link: /features/common-actions
    linkText: Common Actions
  - icon: 💉
    title: Context injection
    details: 'Mark fields and methods with attributes like [FrameInfo], [Parent], [BeforeShow]: the frame gets its context without coupling to the caller.'
    link: /features/injection
    linkText: Injection
  - icon: 🧩
    title: TFormStand
    details: 'The same model with TForm descendants. Design with Fire UI views and the style preview, then show the form''s content inside any control.'
    link: /features/formstand
    linkText: TFormStand
  - icon: 📐
    title: Responsive
    details: 'Define breakpoints and swap the frame class, the stand or the parent according to the available width. Same code, phone to desktop.'
    link: /features/responsive
    linkText: Responsive frames
---

<div class="vp-doc" style="max-width: 960px; margin: 48px auto 0; padding: 0 24px;">

## What is TFrameStand?

**TFrameStand** and **TFormStand** are two non-visual components for [Embarcadero Delphi](https://www.embarcadero.com/products/delphi) FireMonkey (FMX) applications. They put a `TFrame` (or the content of a `TForm`) on screen through a **stand**: a visual layer, designed in a `TStyleBook`, that sits between the frame and its parent control and carries backgrounds, shadows, effects and animations.

```pascal
uses FrameStand, SubjectStand, Frames.Details;

procedure TMainForm.ShowDetailsButtonClick(Sender: TObject);
begin
  // create a TDetailsFrame inside a 'lightbox' stand and show it,
  // running every OnShow* animation found in the stand
  FrameStand1.NewAndShow<TDetailsFrame>(nil, 'lightbox');
end;
```

The frame knows nothing about the stand, the stand knows nothing about the frame: you can show the same frame as a dialog on a phone and as a side panel on a desktop, or give every dialog of the application the same look with one style item.

<img class="demo-gif" src="/gifs/demos_viewsdialogs.gif" alt="Views and dialogs demo" />

## Where to go next

- New here? Read the [introduction](/guide/introduction), then build [your first stand](/guide/getting-started).
- Want to see it? The [demos](/demos/) cover lightboxes, wait screens, dialogs, bottom sheets, wizards and responsive layouts.
- Looking for a method or an attribute? See the [reference](/reference/components).

</div>
