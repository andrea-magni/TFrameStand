unit Frames.Third;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts;

type
  TFrame3 = class(TFrame)
    Label1: TLabel;
    Edit1: TEdit;
    FinishButton: TButton;
    Layout1: TLayout;
    procedure FinishButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  FrameStand
, Data.Main
;

procedure TFrame3.FinishButtonClick(Sender: TObject);
begin
  TDelayedAction.Execute(50
    , procedure
      begin
        MainData.Finish;
      end
  );
end;

end.
