unit Frames.Button;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Ani;

type
  TButtonFrame = class(TFrame)
    Image: TImage;
    TextLabel: TLabel;
    OnShowSlideIn: TFloatAnimation;
    procedure ImageClick(Sender: TObject);
    procedure TextLabelClick(Sender: TObject);
  private
    FOnButtonClick: TProc<TObject>;
    FRightToLeft: Boolean;
    function GetButtonText: string;
    procedure SetButtonText(const Value: string);
    function GetButtonImage: TBitmap;
    procedure SetButtonImage(const Value: TBitmap);
    procedure SetRightToLeft(const Value: Boolean);
  public
    property ButtonImage: TBitmap read GetButtonImage write SetButtonImage;
    property ButtonText: string read GetButtonText write SetButtonText;
    property OnButtonClick: TProc<TObject> read FOnButtonClick write FOnButtonClick;

    property RightToLeft: Boolean read FRightToLeft write SetRightToLeft;
  end;

implementation

{$R *.fmx}

{ TButtonFrame }

procedure TButtonFrame.ImageClick(Sender: TObject);
begin
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Sender);
end;

function TButtonFrame.GetButtonImage: TBitmap;
begin
  Result := Image.Bitmap;
end;

function TButtonFrame.GetButtonText: string;
begin
  Result := TextLabel.Text;
end;

procedure TButtonFrame.SetButtonImage(const Value: TBitmap);
begin
  Image.Bitmap.Assign(Value);
end;

procedure TButtonFrame.SetButtonText(const Value: string);
begin
  TextLabel.Text := Value;
end;

procedure TButtonFrame.SetRightToLeft(const Value: Boolean);
begin
  if FRightToLeft <> Value then
  begin
    FRightToLeft := Value;
    if FRightToLeft then
    begin
      Image.Align := TAlignLayout.Right;
      TextLabel.TextAlign := TTextAlign.Trailing;
    end
    else
    begin
      Image.Align := TAlignLayout.Left;
      TextLabel.TextAlign := TTextAlign.Leading;
    end;
  end;
end;

procedure TButtonFrame.TextLabelClick(Sender: TObject);
begin
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Sender);
end;

end.
