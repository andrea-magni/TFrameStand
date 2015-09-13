unit Frames.RatingDialog;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Ani
  , FrameStand, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components;

type
  TRatingDialogFrame = class(TFrame)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    GridPanelLayout1: TGridPanelLayout;
    RectangleRating1: TRectangle;
    OnShowRating1: TFloatAnimation;
    RectangleRating2: TRectangle;
    OnShowRating2: TFloatAnimation;
    RectangleRating3: TRectangle;
    OnShowRating3: TFloatAnimation;
    RectangleRating4: TRectangle;
    OnShowRating4: TFloatAnimation;
    RectangleRating5: TRectangle;
    OnShowRating5: TFloatAnimation;
    RatingLayout: TLayout;
    BottomLayout: TLayout;
    CancelButton: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldBitmap: TLinkPropertyToField;
    Label1: TLabel;
    Label7: TLabel;
    LinkPropertyToFieldText: TLinkPropertyToField;
    procedure RectangleRating1Click(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    FRating: Integer;
    FOnRatingChanged: TProc<Integer>;
    FOnCancel: TProc;
    procedure SetRating(const Value: Integer);
  protected
  public
    [BeforeShow] procedure BeforeShow;

    property Rating: Integer read FRating write SetRating;
    property OnRatingChanged: TProc<Integer> read FOnRatingChanged write FOnRatingChanged;
    property OnCancel: TProc read FOnCancel write FOnCancel;
  end;

implementation

{$R *.fmx}

uses DataModules.Main;

procedure TRatingDialogFrame.BeforeShow;
begin
  RectangleRating1.Scale.X := 0;
  RectangleRating2.Scale.X := 0;
  RectangleRating3.Scale.X := 0;
  RectangleRating4.Scale.X := 0;
  RectangleRating5.Scale.X := 0;
end;

procedure TRatingDialogFrame.CancelButtonClick(Sender: TObject);
begin
  if Assigned(OnCancel) then
    OnCancel();
end;

procedure TRatingDialogFrame.RectangleRating1Click(Sender: TObject);
begin
  Rating := (Sender as TRectangle).Tag;
end;

procedure TRatingDialogFrame.SetRating(const Value: Integer);
begin
  if FRating <> Value then
  begin
    FRating := Value;
    if Assigned(OnRatingChanged) then
      OnRatingChanged(FRating);
  end;
end;

end.
