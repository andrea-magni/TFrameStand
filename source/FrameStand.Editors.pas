unit FrameStand.Editors;

interface

uses
  Classes, SysUtils
  , DesignEditors
  , FrameStand
  ;

type
  TSubjectStandEditor = class(TComponentEditor)
  private
    function CurrentObj: TSubjectStand;
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
  RegisterComponentEditor(TSubjectStand, TSubjectStandEditor);
end;

{ TSubjectStandEditor }

function TSubjectStandEditor.CurrentObj: TSubjectStand;
begin
  Result := Component as TSubjectStand;
end;

procedure TSubjectStandEditor.Edit;
var
  LForm: TTestForm;
begin
  inherited;
  LForm := TTestForm.Create(nil);
  try
    LForm.SubjectStand := CurrentObj;
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

end.


