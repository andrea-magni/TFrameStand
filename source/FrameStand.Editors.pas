unit FrameStand.Editors;

interface

uses
  Classes, SysUtils
  , DesignEditors
  , FrameStand
  ;

type
  TFrameStandEditor = class(TComponentEditor)
  private
    function CurrentObj: TFrameStand;
  protected
  public
    procedure Edit; override;
  end;

procedure Register;

implementation

uses
  DesignIntf
  , Windows, FrameStand.Editors.Forms.Test;

procedure Register;
begin
  RegisterComponentEditor(TFrameStand, TFrameStandEditor);
end;

{ TFrameStandEditor }

function TFrameStandEditor.CurrentObj: TFrameStand;
begin
  Result := Component as TFrameStand;
end;

procedure TFrameStandEditor.Edit;
var
  LForm: TTestForm;
begin
  inherited;
  LForm := TTestForm.Create(nil);
  try
    LForm.FrameStand := CurrentObj;
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

end.


