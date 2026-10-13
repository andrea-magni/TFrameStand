unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.StdCtrls, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, SubjectStand, FrameStand;

type
  TMainForm = class(TForm)
    Background: TRectangle;
    Header: TRectangle;
    TitleLabel: TLabel;
    DarkLabel: TLabel;
    DarkSwitch: TSwitch;
    Content: TLayout;
    Buttons: TVertScrollBox;
    DialogButton: TButton;
    LightboxButton: TButton;
    BottomSheetButton: TButton;
    DrawerButton: TButton;
    SnackbarButton: TButton;
    PageButton: TButton;
    Stands: TStyleBook;
    FrameStand1: TFrameStand;
    procedure FormCreate(Sender: TObject);
    procedure DarkSwitchSwitch(Sender: TObject);
    procedure DialogButtonClick(Sender: TObject);
    procedure LightboxButtonClick(Sender: TObject);
    procedure BottomSheetButtonClick(Sender: TObject);
    procedure DrawerButtonClick(Sender: TObject);
    procedure SnackbarButtonClick(Sender: TObject);
    procedure PageButtonClick(Sender: TObject);
    procedure FrameStand1BeforeShow(const ASender: TSubjectStand;
      const ASubjectInfo: TSubjectInfo);
  private
    FDark: Boolean;
    procedure LoadStands;
    procedure ShowSnackbar(const AText: string);
    procedure ColorTexts(const AObject: TFmxObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  Frames.Message, Frames.Photo, Frames.Choice, Frames.Toast, Frames.Page;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // the Cancel buttons of the frames and the background of the stands
  // ('background_cancel') cancel the dialogs
  FrameStand1.CommonActions.Add('*_cancel',
    procedure (AInfo: TSubjectInfo)
    begin
      AInfo.ModalResult := mrCancel;
    end);
  LoadStands;
end;

procedure TMainForm.LoadStands;
var
  LStream: TResourceStream;
begin
  // the two files of the gallery have the same stands: switching the theme
  // is loading the other one (the subjects already shown keep their stand)
  if FDark then
    LStream := TResourceStream.Create(HInstance, 'STANDS_DARK', RT_RCDATA)
  else
    LStream := TResourceStream.Create(HInstance, 'STANDS_LIGHT', RT_RCDATA);
  try
    Stands.LoadFromStream(LStream);
  finally
    LStream.Free;
  end;
  if FDark then
  begin
    Background.Fill.Color := $FF121214;
    Header.Fill.Color := $FF1F1F24;
  end
  else
  begin
    Background.Fill.Color := $FFF2F2F5;
    Header.Fill.Color := $FF3F51B5;
  end;
end;

procedure TMainForm.DarkSwitchSwitch(Sender: TObject);
begin
  FDark := DarkSwitch.IsChecked;
  LoadStands;
end;

procedure TMainForm.ColorTexts(const AObject: TFmxObject);
var
  LChild: TFmxObject;
begin
  // the labels of the frames follow the theme of the stands
  if AObject is TLabel then
  begin
    TLabel(AObject).StyledSettings := TLabel(AObject).StyledSettings - [TStyledSetting.FontColor];
    if FDark then
      TLabel(AObject).TextSettings.FontColor := TAlphaColorRec.White
    else
      TLabel(AObject).TextSettings.FontColor := $FF202020;
  end;
  if Assigned(AObject.Children) then
    for LChild in AObject.Children do
      ColorTexts(LChild);
end;

procedure TMainForm.FrameStand1BeforeShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
begin
  ColorTexts(ASubjectInfo.Subject);
end;

procedure TMainForm.ShowSnackbar(const AText: string);
var
  LInfo: TFrameInfo<TToastFrame>;
begin
  LInfo := FrameStand1.New<TToastFrame>(nil, 'snackbar');
  LInfo.Frame.Text := AText;
  LInfo.Show;
  LInfo.HideAndCloseAfter(2500); // nothing happens if it is closed before
end;

procedure TMainForm.DialogButtonClick(Sender: TObject);
var
  LInfo: TFrameInfo<TMessageFrame>;
begin
  LInfo := FrameStand1.New<TMessageFrame>(nil, 'dialog');
  LInfo.Frame.Title := 'Delete the photo?';
  LInfo.Frame.Text := 'It will be removed from all your albums.';
  LInfo.ShowModal(
    procedure (AResult: TModalResult)
    begin
      if AResult = mrOk then
        ShowSnackbar('Photo deleted')
      else
        ShowSnackbar('Cancelled');
    end);
end;

procedure TMainForm.LightboxButtonClick(Sender: TObject);
begin
  // closed by its Close button, by the background, by Back and Esc
  FrameStand1.New<TPhotoFrame>(nil, 'lightbox').ShowModal(
    procedure (AResult: TModalResult)
    begin
    end);
end;

procedure TMainForm.BottomSheetButtonClick(Sender: TObject);
var
  LInfo: TFrameInfo<TChoiceFrame>;
begin
  LInfo := FrameStand1.New<TChoiceFrame>(nil, 'bottomsheet');
  LInfo.Frame.Title := 'Share with';
  LInfo.Frame.Choices := ['Mail', 'Messages', 'Copy link'];
  LInfo.ShowModal(
    procedure (AFrame: TChoiceFrame; AResult: TModalResult)
    begin
      if AResult = mrOk then
        ShowSnackbar('Shared with ' + AFrame.Chosen);
    end);
end;

procedure TMainForm.DrawerButtonClick(Sender: TObject);
var
  LInfo: TFrameInfo<TChoiceFrame>;
begin
  LInfo := FrameStand1.New<TChoiceFrame>(nil, 'drawer');
  LInfo.Frame.Title := 'Menu';
  LInfo.Frame.Choices := ['Home', 'Albums', 'Favourites', 'Settings'];
  LInfo.ShowModal(
    procedure (AFrame: TChoiceFrame; AResult: TModalResult)
    begin
      if AResult = mrOk then
        ShowSnackbar(AFrame.Chosen);
    end);
end;

procedure TMainForm.SnackbarButtonClick(Sender: TObject);
begin
  ShowSnackbar('Hello from a snackbar');
end;

procedure TMainForm.PageButtonClick(Sender: TObject);
var
  LInfo: TFrameInfo<TPageFrame>;
begin
  if FrameStand1.StackCount > 0 then
    Exit;
  LInfo := FrameStand1.Push<TPageFrame>(nil, 'page',
    procedure (AFrame: TPageFrame)
    begin
      AFrame.Number := 1;
    end);
  // the first page is the root of the stack: Back and Esc close it
  LInfo.BackKeyAction := baHideAndClose;
end;

end.
