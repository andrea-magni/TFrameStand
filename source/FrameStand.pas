unit FrameStand;

interface

uses
  Classes, SysUtils
, FMX.Types, FMX.Controls, FMX.Forms
, SubjectStand
;

type
  TFrameInfo<T: TFrame> = class(TSubjectInfo)
  private
  protected
  public
  end;

  TFrameStand = class(TSubjectStand)
  private
  protected
  public
    function Use<T: TFrame>(const AFrame: T; const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFrameInfo<T>; overload;

    function New<T: TFrame>(const AParent: TFmxObject = nil;
      const AStandStyleName: string = ''): TFrameInfo<T>; overload;
  end;

implementation

{ TFrameStand }

function TFrameStand.New<T>(const AParent: TFmxObject;
  const AStandStyleName: string): TFrameInfo<T>;
begin
  Result := New(TSubjectClass(TFrame(T).ClassType), AParent, AStandStyleName) as TFrameInfo<T>;
end;

function TFrameStand.Use<T>(const AFrame: T; const AParent: TFmxObject;
  const AStandStyleName: string): TFrameInfo<T>;
begin

end;


end.
