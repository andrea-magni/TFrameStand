unit FormStand.Editors;

interface

uses
  Classes, SysUtils
  , DesignEditors
  , FormStand
  ;

type
  TFormStandEditor = class(TComponentEditor)
  private
    function CurrentObj: TFormStand;
  protected
  public
    procedure Edit; override;
  end;

procedure Register;

implementation

uses
  DesignIntf
  , Windows, FormStand.Editors.Forms.Test;

procedure Register;
begin
  RegisterComponentEditor(TFormStand, TFormStandEditor);
end;

{ TFormStandEditor }

function TFormStandEditor.CurrentObj: TFormStand;
begin
  Result := Component as TFormStand;
end;

procedure TFormStandEditor.Edit;
var
  LForm: TFormStandTestForm;
begin
  inherited;
  LForm := TFormStandTestForm.Create(nil);
  try
    LForm.FormStand := CurrentObj;
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

end.


