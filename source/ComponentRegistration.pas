unit ComponentRegistration;

interface

uses
  Classes, SysUtils
;

procedure Register;

implementation

uses
  FrameStand, FormStand;

procedure Register;
begin
  RegisterComponents('Andrea Magni', [TFrameStand, TFormStand]);
end;


end.
