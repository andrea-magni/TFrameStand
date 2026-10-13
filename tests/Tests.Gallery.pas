unit Tests.Gallery;

// The stand gallery (stands\Stands.Light.style, stands\Stands.Dark.style),
// animation values from TagString, HideAndCloseAfter.

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.IOUtils, DUnitX.TestFramework
, FMX.Types, FMX.Forms, FMX.Controls, FMX.Objects, FMX.Ani
, SubjectStand, FrameStand
, Tests.Subjects
;

type
  [TestFixture]
  TGalleryFixture = class
  private
    FMain: TForm;
    FRoot: TRectangle;
    FFrameStand: TFrameStand;
    FStarts: TStringList;
    procedure LoadGallery(const ATheme: string);
    procedure RecordAnimation(const ASender: TSubjectStand; const ASubjectInfo: TSubjectInfo;
      const AAnimation: TAnimation);
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;

    [Test]
    [TestCase('Light', 'Light')]
    [TestCase('Dark', 'Dark')]
    procedure EveryStandShowsAndHides(const ATheme: string);
    [Test] procedure BackgroundCancelsADialog;
    [Test] procedure ValuesFromTheSizeOfTheStand;
    [Test] procedure PopValuesGoingBack;
    [Test] procedure NumbersInTagString;
    [Test] procedure HideAndCloseAfterADelay;
    [Test] procedure HideAndCloseAfterOnAClosedSubject;
  end;

implementation

const
  STANDS: array[0..5] of string = ('dialog', 'lightbox', 'bottomsheet', 'drawer', 'snackbar', 'page');

function GalleryFile(const ATheme: string): string;
var
  LDir: string;
begin
  // the tests run from build\<version>\tests: look for the repository root
  LDir := ExtractFilePath(ParamStr(0));
  while LDir <> '' do
  begin
    Result := System.IOUtils.TPath.Combine(LDir, 'stands' + PathDelim + 'Stands.' + ATheme + '.style');
    if FileExists(Result) then
      Exit;
    if ExtractFileDir(ExcludeTrailingPathDelimiter(LDir)) = ExcludeTrailingPathDelimiter(LDir) then
      Break;
    LDir := ExtractFilePath(ExcludeTrailingPathDelimiter(LDir));
  end;
  raise Exception.Create('stands\Stands.' + ATheme + '.style not found');
end;

{ TGalleryFixture }

procedure TGalleryFixture.Setup;
begin
  FStarts := TStringList.Create;
  FMain := TForm.CreateNew(nil);
  FMain.ClientWidth := 400;
  FMain.ClientHeight := 700;
  FRoot := TRectangle.Create(FMain);
  FRoot.Parent := FMain;
  FRoot.Align := TAlignLayout.Client;
  FFrameStand := TFrameStand.Create(FMain);
end;

procedure TGalleryFixture.TearDown;
begin
  FreeAndNil(FMain);
  FreeAndNil(FStarts);
end;

procedure TGalleryFixture.LoadGallery(const ATheme: string);
var
  LBook: TStyleBook;
begin
  LBook := TStyleBook.Create(FMain);
  LBook.LoadFromFile(GalleryFile(ATheme));
  FFrameStand.StandBook := LBook;
end;

procedure TGalleryFixture.RecordAnimation(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo; const AAnimation: TAnimation);
begin
  if AAnimation is TFloatAnimation then
    FStarts.Values[AAnimation.StyleName] := Format('%d..%d',
      [Round(TFloatAnimation(AAnimation).StartValue), Round(TFloatAnimation(AAnimation).StopValue)]);
end;

procedure TGalleryFixture.EveryStandShowsAndHides(const ATheme: string);
var
  LName: string;
  LInfo: TFrameInfo<TFrame>;
begin
  LoadGallery(ATheme);
  for LName in STANDS do
  begin
    LInfo := FFrameStand.New<TFrame>(FRoot, LName);
    Assert.AreEqual(LName, LInfo.StandStyleName, LName + ': the stand of the gallery');
    Assert.IsTrue(LInfo.Stand.ChildrenCount > 0, LName + ': found in the style book');
    Assert.IsTrue(LInfo.Container <> LInfo.Stand, LName + ': has a container');
    LInfo.Show;
    Pump(500);
    Assert.IsTrue(LInfo.IsVisible, LName + ': shown');
    LInfo.HideAndClose;
    Pump(600);
  end;
  Assert.AreEqual(0, FFrameStand.Count, 'all closed after their hide animations');
end;

procedure TGalleryFixture.BackgroundCancelsADialog;
var
  LInfo: TFrameInfo<TFrame>;
  LBackground: TFmxObject;
  LResult: TModalResult;
begin
  LoadGallery('Light');
  FFrameStand.CommonActions.Add('*_cancel',
    procedure (AInfo: TSubjectInfo)
    begin
      AInfo.ModalResult := mrCancel;
    end);
  LResult := mrNone;
  LInfo := FFrameStand.New<TFrame>(FRoot, 'dialog');
  LInfo.ShowModal(
    procedure (AResult: TModalResult)
    begin
      LResult := AResult;
    end);
  LBackground := LInfo.Stand.FindStyleResource('background_cancel');
  Assert.IsTrue(LBackground is TControl, 'background_cancel');
  TControl(LBackground).OnClick(LBackground);
  Pump(600);
  Assert.AreEqual(mrCancel, LResult);
  Assert.AreEqual(0, FFrameStand.Count);
end;

procedure TGalleryFixture.ValuesFromTheSizeOfTheStand;
var
  LInfo: TFrameInfo<TFrame>;
  LSheet: TControl;
begin
  LoadGallery('Light');
  FFrameStand.OnBeforeStartAnimation := RecordAnimation;
  LInfo := FFrameStand.New<TFrame>(FRoot, 'bottomsheet');
  LSheet := LInfo.Stand.FindStyleResource('sheet') as TControl;
  LInfo.Show;
  // 'StartValue=-ParentHeight': from below the bottom edge
  Assert.AreEqual(Format('%d..0', [-Round(LSheet.Height)]), FStarts.Values['OnShowSlide']);
  LInfo.Hide;
  Assert.AreEqual(Format('%d', [-Round(LSheet.Height)]), FStarts.Values['OnHideSlide'].Split(['..'])[1]);
  Pump(600);
end;

procedure TGalleryFixture.PopValuesGoingBack;
begin
  LoadGallery('Light');
  FFrameStand.OnBeforeStartAnimation := RecordAnimation;
  FFrameStand.Push<TFrame>(FRoot, 'page');
  FFrameStand.Push<TFrame>(FRoot, 'page');
  // forward: the new page in from the right, the old one out to the left
  Assert.AreEqual('400..0', FStarts.Values['OnShowSlideL']);
  Assert.AreEqual('0..-400', FStarts.Values['OnHideSlideL']);
  Pump(600);
  FFrameStand.Pop;
  // back: the page below in from the left, the top one out to the right
  Assert.AreEqual('-400..0', FStarts.Values['OnShowSlideL']);
  Assert.AreEqual('400..0', FStarts.Values['OnShowSlideR']);
  Assert.AreEqual('0..400', FStarts.Values['OnHideSlideL']);
  Pump(600);
end;

procedure TGalleryFixture.NumbersInTagString;
var
  LBook: TStyleBook;
  LStream: TStringStream;
begin
  LBook := TStyleBook.Create(FMain);
  LStream := TStringStream.Create(
    'object TStyleContainer'#13#10 +
    '  object TLayout'#13#10 +
    '    StyleName = ''tagged'''#13#10 +
    '    object TFloatAnimation'#13#10 +
    '      StyleName = ''OnShowMove'''#13#10 +
    '      Duration = 0.100000000000000000'#13#10 +
    '      PropertyName = ''Opacity'''#13#10 +
    '      object TStyleTag'#13#10 +
    '        TagString = ''StartValue=0.25; StopValue = -Width ; Unknown=Height'''#13#10 +
    '      end'#13#10 +
    '    end'#13#10 +
    '  end'#13#10 +
    'end');
  try
    LBook.LoadFromStream(LStream);
  finally
    LStream.Free;
  end;
  FFrameStand.StandBook := LBook;
  FFrameStand.OnBeforeStartAnimation := RecordAnimation;
  FFrameStand.New<TFrame>(FRoot, 'tagged').Show;
  Assert.AreEqual('0..-400', FStarts.Values['OnShowMove'], 'a number, -Width, spaces, unknown keys ignored');
  Pump(300);
end;

procedure TGalleryFixture.HideAndCloseAfterADelay;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FRoot);
  LInfo.Show;
  LInfo.HideAndCloseAfter(200);
  Pump(100);
  Assert.AreEqual(1, FFrameStand.Count, 'not yet');
  Pump(400);
  Assert.AreEqual(0, FFrameStand.Count, 'closed');
end;

procedure TGalleryFixture.HideAndCloseAfterOnAClosedSubject;
var
  LInfo: TFrameInfo<TFrame>;
begin
  LInfo := FFrameStand.New<TFrame>(FRoot);
  LInfo.Show;
  LInfo.HideAndCloseAfter(200);
  LInfo.Close; // closed before: the delayed hide is cancelled
  Pump(400);
  Assert.AreEqual(0, FFrameStand.Count);
end;

initialization
  TDUnitX.RegisterTestFixture(TGalleryFixture);

end.
