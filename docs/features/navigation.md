# Navigation Stack

Wizards, settings pages, master/detail flows: pages that open one on top of the other and close in the reverse order. `Push` and `Pop` keep that stack for you, with the transitions of the stands.

::: info Since v.2.3
The navigation stack is available since v.2.3.
:::

## Push and Pop

```pascal
uses FrameStand, SubjectStand;

procedure TMainForm.NextButtonClick(Sender: TObject);
begin
  case FrameStand1.StackCount of
    0: FrameStand1.Push<TStep1Frame>;
    1: FrameStand1.Push<TStep2Frame>;
    2: FrameStand1.Push<TStep3Frame>;
  end;
end;

procedure TMainForm.BackButtonClick(Sender: TObject);
begin
  FrameStand1.Pop;
end;
```

`Push<T>(AParent, AStandStyleName, AConfigProc)` creates a page like `New` (same parent and stand rules, responsive substitution included), puts it on top of the stack and shows it. The page below is hidden and kept.

`Pop` closes the top page, with its hide animation, and shows the page below again, as it was: what the user typed is still there. It returns `False`, and does nothing, when the stack has one page or none: the first page, the root, is never popped. `PopToRoot` goes back to the first page in one step: the pages in between are closed at once, without animations.

| Member | Description |
|---|---|
| `Push<T>(AParent = nil; AStandStyleName = ''; AConfigProc = nil)` | creates, pushes and shows a page; returns its info |
| `Pop: Boolean` | back to the page below |
| `PopToRoot: Boolean` | back to the first page |
| `StackCount` | pages in the stack |
| `StackTop` | the info of the top page (nil when the stack is empty) |
| `StackOperation` | `soPush` or `soPop` while `Push` and `Pop` show and hide pages, `soNone` otherwise |
| `PushMode` | what `Push` does to the page below (published) |

`TFormStand` has the same members, for forms.

## The page below: PushMode

| `PushMode` | On `Push` | On `Pop` |
|---|---|---|
| `pmHide` (default) | hidden, with its hide animation, and kept | shown again, as it was |
| `pmKeepVisible` | left visible under the new page | already there: nothing to do |
| `pmClose` | closed (frees the frame) | created again with `AConfigProc`: nothing is kept |

`pmKeepVisible` suits stands that do not cover the whole page below (a sheet over a list); `pmClose` saves memory with many heavy pages. With `pmClose`, configure the page in `AConfigProc`, which `Pop` runs again on the new frame:

```pascal
FrameStand1.Push<TOrderFrame>(nil, '',
  procedure (AFrame: TOrderFrame)
  begin
    AFrame.OrderID := FCurrentOrder;
  end);
```

## Transitions forward and back

The stands animate the pages as usual (`OnShow*` when a page appears, `OnHide*` when it goes away). To slide the pages one way on `Push` and the other way on `Pop`, read `StackOperation` in `OnBeforeStartAnimation`, which runs while `Push` and `Pop` start the animations:

```pascal
procedure TMainForm.FrameStand1BeforeStartAnimation(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo; const AAnimation: TAnimation);
begin
  if AAnimation.StyleName = 'OnShow_SlideIn' then
    // forward: in from the right; back: in from the left
    if ASender.StackOperation = soPop then
      TFloatAnimation(AAnimation).PropertyName := 'Margins.Right'
    else
      TFloatAnimation(AAnimation).PropertyName := 'Margins.Left';
end;
```

On `Pop` the page leaving stays in front of the page coming back, until its hide animation ends.

## Back and Esc

With `CatchBackKey` (see [Back and Esc](/features/dialogs#back-and-esc)) the Back button of Android and the Esc key pop the stack: `Push` gives the pages above the root `BackKeyAction = baPop`. A dialog shown over a page is cancelled first; on the root page the key goes on to the form, so Android closes the app as usual.

## Closing pages in other ways

- When the top page is closed by something other than `Pop` (its `HideAndClose`, a `Close*` [Common Action](/features/common-actions)), it leaves the stack and the page below is shown again.
- A page in the middle closed by someone else just leaves the stack.
- `CloseAll` and `HideAndCloseAll` empty the stack at once: no page is shown again.

::: tip One stack per component
Each `TFrameStand` (and each `TFormStand`) has its own stack. For two independent flows on the same form, use two components.
:::

The [Wizard demo](/demos/#wizard-simple) is a three-step wizard built on `Push` and `Pop`, with a Back button, `CatchBackKey` and slide animations that change direction on `Pop`.
