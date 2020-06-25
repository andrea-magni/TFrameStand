unit Form.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, SubjectStand,
  FrameStand, FMX.Viewport3D, System.Math.Vectors, FMX.Controls3D, FMX.Layers3D,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani, FMX.Objects, Frame.First,
  FMX.Layouts;

type
  TMainForm = class(TForm)
    FrameStand1: TFrameStand;
    Stands: TStyleBook;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ContentLayout: TLayout;
    OpenButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure FrameStand1BeforeShow(const ASender: TSubjectStand;
      const ASubjectInfo: TSubjectInfo);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
  private
    { Private declarations }
    FInfo: TFrameInfo<TFirstFrame>;
    procedure RealignLayer3D;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.RealignLayer3D;
var
  LLayer3D: TLayer3D;
begin
  if not Assigned(FInfo) then Exit;

  // workaround for https://quality.embarcadero.com/browse/RSP-18282
  LLayer3D := FInfo.Stand.FindStyleResource('layer3D') as TLayer3D;
  if Assigned(LLayer3D) then
  begin
    LLayer3D.Align := TAlignLayout.None;
    LLayer3D.Align := TAlignLayout.Client;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FrameStand1.CommonActions.Add('HideAndClose*'
    , procedure (Info: TSubjectInfo)
      begin
        Info.HideAndClose();
      end
  );
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  if Assigned(FInfo) then
    RealignLayer3D;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  TDelayedAction.Execute(500
  , procedure
    begin
      OpenButtonClick(OpenButton);
    end
  );

end;

procedure TMainForm.FrameStand1BeforeShow(const ASender: TSubjectStand;
  const ASubjectInfo: TSubjectInfo);
var
  LCamera: TCamera;
  LViewPort: TViewport3D;
begin
  if ASubjectInfo.StandStyleName = 'stand3D' then
  begin
    LCamera := ASubjectInfo.Stand.FindStyleResource('camera') as TCamera;
    LViewPort := ASubjectInfo.Stand.FindStyleResource('viewport3d') as TViewPort3D;
    LViewPort.Camera := LCamera;
    LViewPort.UsingDesignCamera := False;

  end;

  if ASubjectInfo.StandStyleName = 'new3D' then
    RealignLayer3D;

end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
begin
  FInfo := FrameStand1.GetFrameInfo<TFirstFrame>(True, nil, 'new3D');
  FInfo.Show();
end;

end.
