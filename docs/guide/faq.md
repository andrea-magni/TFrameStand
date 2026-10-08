# FAQ & Troubleshooting

### Do I need a TStyleBook?

No. Without a `StandBook`, or when the stand name is not found, the subject is placed in an empty `TLayout` aligned to the whole parent. You still get the lifecycle, the injection and the Common Actions, just no decoration.

### The frame appears but the stand decorations do not

Check that `StandBook` is assigned, that the stand's root element has exactly the `StyleName` you pass (or the one in `DefaultStandName`), and that you are not using the style book assigned to the form's `StyleBook` property for the stands. The component editor (double-click the component) lists the stands it finds and previews them.

### My OnShow animations do not run

Their `StyleName` (or `Name`, when `StyleName` is empty) must match `AnimationShow`, `OnShow*` by default. The match is case-insensitive and applies to any `TAnimation` anywhere in the stand's tree, the frame included (the frame is a child of the stand's container). Animations created after `Show` are not started.

### Hide is not animated / the frame disappears immediately

`Hide` waits for the longest `Delay + Duration` among the `OnHide*` animations. If none matches `AnimationHide`, the delay is zero. `Close` never animates: use `HideAndClose`.

### Clicking a control does nothing after I registered a Common Action

Common Actions are bound when the subject is created (`New`/`Use`). Register them before creating the frames, typically in the form's `OnCreate`, and remember they match the `StyleName` first, the `Name` only when `StyleName` is empty.

### My OnClick handler is not called anymore

A control matched by a Common Action gets its `OnClick` replaced. Use a name that does not match the pattern, or call your code from the Common Action.

### An access violation after Close

`Close` (and `HideAndClose`, when it completes) frees the info object, and the frame too when it is owned. Clear your references, and don't use the info in code that runs after closing. See [Lifecycle & Ownership](/guide/lifecycle#closing-close-and-hideandclose).

The info is also freed when its stand or its subject is destroyed by someone else (the parent or the form freed, an adopted frame freed by your code): see [When the parent or the subject is destroyed](/guide/lifecycle#when-the-parent-or-the-subject-is-destroyed). Use `FrameInfo(...)` / `GetFrameInfo<T>` instead of keeping references across such events.

### How do I show the same frame several times?

Call `New<T>` several times: each call creates a new frame and a new clone of the stand. To reuse one instance, keep the info and call `Show`/`Hide` on it, or retrieve it with `FrameInfo<T>` / `GetFrameInfo<T>`.

### Can I use a frame placed on the form at design time?

Yes, with `Use`: `FrameStand1.Use<TMyFrame>(MyFrame1, Layout1, 'card').Show`. The frame is not owned by the component and is only detached from the stand on close.

### Can I use TFrameStand on a frame instead of a form?

Yes. The default parent is the component's `Owner`, which can be a frame. Set `DefaultParent` or pass the parent explicitly when the owner is not a visual object (a data module, for example).

### Does it work with C++Builder?

The units are Delphi code and can be used from C++Builder projects through the packages, but the API relies heavily on Delphi generics (`New<T>`, `TFrameInfo<T>`) and attributes, which are not usable from C++. There is no C++-specific API at the moment.

### Is there a Delphi version requirement?

The current source needs Delphi 10.3 Rio or later. See [Installation](/guide/installation#supported-delphi-versions).
