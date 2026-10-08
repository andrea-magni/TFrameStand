unit Tests.Subjects;

// Frames and forms used by the tests, with helpers. Each class has its
// resource in tests\resources (text .fmx, linked below).

interface

uses
  System.SysUtils, System.Classes, System.Diagnostics
, FMX.Types, FMX.Forms, FMX.Controls, FMX.StdCtrls, FMX.Edit, FMX.Objects
, SubjectStand, FrameStand, FormStand
;

type
  TButtonFrame = class(TFrame)
    CloseButton: TButton;
  end;

  // counts its destructions in FramesDestroyed
  TCountFrame = class(TFrame)
  public
    destructor Destroy; override;
  end;

  // three controls; counts its destructions in FormsDestroyed
  TDataForm = class(TForm)
    Rect1: TRectangle;
    Rect2: TRectangle;
    Rect3: TRectangle;
  public
    Data: string;
    destructor Destroy; override;
  end;

  // no controls; counts its destructions in FormsDestroyed
  TEmptyForm = class(TForm)
  public
    destructor Destroy; override;
  end;

  TParamsFrame = class(TFrame)
  public
    GotInfo, GotStand, GotSubjectInfo, GotParent, GotContainer, GotStandControl: string;
    [BeforeShow]
    procedure BeforeShow([FrameInfo] AInfo: TFrameInfo<TParamsFrame>; [FrameStand] AStand: TFrameStand;
      [SubjectInfo] ASubjectInfo: TSubjectInfo; [Parent] AParent: TFmxObject;
      [Container] AContainer: TFmxObject; [Stand] AStandControl: TControl);
  end;

  TNoAttributeFrame = class(TFrame)
  public
    [BeforeShow]
    procedure BeforeShow(AParent: TFmxObject);
  end;

  TFieldsFrame = class(TFrame)
  public
    [FrameInfo] FI: TFrameInfo<TFieldsFrame>;
    [FrameStand] FS: TFrameStand;
    [SubjectInfo] SI: TSubjectInfo;
    [Parent] P: TFmxObject;
    [Container] C: TFmxObject;
    [Context] C2: TFmxObject;
    [Stand] ST: TControl;
  end;

  TEditFrame = class(TFrame)
  public
    [Parent] Edit: TEdit;
  end;

  TParamsForm = class(TForm)
  public
    GotInfo, GotStand: string;
    [BeforeShow]
    procedure BeforeShow([FormInfo] AInfo: TFormInfo<TParamsForm>; [FormStand] AStand: TFormStand);
  end;

  TBaseFrame = class(TFrame);

  // [FrameInfo] typed on itself: cannot receive the info of New<TBaseFrame>
  TDerivedFrame = class(TBaseFrame)
  public
    [FrameInfo] FI: TFrameInfo<TDerivedFrame>;
  end;

  // [FrameInfo] typed on the base class: works after substitution
  TDerived2Frame = class(TBaseFrame)
  public
    [FrameInfo] FI: TFrameInfo<TBaseFrame>;
    [SubjectInfo] SI: TSubjectInfo;
  end;

var
  FramesDestroyed: Integer = 0;
  FormsDestroyed: Integer = 0;

/// <summary>Runs the main-thread event loop (timers, queued procedures) for AMS milliseconds.</summary>
procedure Pump(const AMS: Integer);
/// <summary>Bytes currently allocated (FastMM state).</summary>
function AllocatedBytes: Int64;
/// <summary>Class name of AObject, or 'nil'.</summary>
function ClassNameOf(const AObject: TObject): string;

implementation

{$R 'resources\ButtonFrame.fmx'}
{$R 'resources\CountFrame.fmx'}
{$R 'resources\DataForm.fmx'}
{$R 'resources\EmptyForm.fmx'}
{$R 'resources\ParamsFrame.fmx'}
{$R 'resources\NoAttributeFrame.fmx'}
{$R 'resources\FieldsFrame.fmx'}
{$R 'resources\EditFrame.fmx'}
{$R 'resources\ParamsForm.fmx'}
{$R 'resources\BaseFrame.fmx'}
{$R 'resources\DerivedFrame.fmx'}
{$R 'resources\Derived2Frame.fmx'}

procedure Pump(const AMS: Integer);
var
  LStopwatch: TStopwatch;
begin
  LStopwatch := TStopwatch.StartNew;
  repeat
    Application.ProcessMessages;
    CheckSynchronize(5);
  until LStopwatch.ElapsedMilliseconds >= AMS;
end;

{$WARN SYMBOL_PLATFORM OFF} // GetMemoryManagerState
function AllocatedBytes: Int64;
var
  LState: TMemoryManagerState;
  LBlock: TSmallBlockTypeState;
begin
  GetMemoryManagerState(LState);
  Result := LState.TotalAllocatedMediumBlockSize + LState.TotalAllocatedLargeBlockSize;
  for LBlock in LState.SmallBlockTypeStates do
    Inc(Result, LBlock.UseableBlockSize * LBlock.AllocatedBlockCount);
end;

function ClassNameOf(const AObject: TObject): string;
begin
  if Assigned(AObject) then
    Result := AObject.ClassName
  else
    Result := 'nil';
end;

{ TCountFrame }

destructor TCountFrame.Destroy;
begin
  Inc(FramesDestroyed);
  inherited;
end;

{ TDataForm }

destructor TDataForm.Destroy;
begin
  Inc(FormsDestroyed);
  inherited;
end;

{ TEmptyForm }

destructor TEmptyForm.Destroy;
begin
  Inc(FormsDestroyed);
  inherited;
end;

{ TParamsFrame }

procedure TParamsFrame.BeforeShow(AInfo: TFrameInfo<TParamsFrame>; AStand: TFrameStand;
  ASubjectInfo: TSubjectInfo; AParent, AContainer: TFmxObject; AStandControl: TControl);
begin
  GotInfo := ClassNameOf(AInfo);
  GotStand := ClassNameOf(AStand);
  GotSubjectInfo := ClassNameOf(ASubjectInfo);
  GotParent := ClassNameOf(AParent);
  GotContainer := ClassNameOf(AContainer);
  GotStandControl := ClassNameOf(AStandControl);
end;

{ TNoAttributeFrame }

procedure TNoAttributeFrame.BeforeShow(AParent: TFmxObject);
begin
end;

{ TParamsForm }

procedure TParamsForm.BeforeShow(AInfo: TFormInfo<TParamsForm>; AStand: TFormStand);
begin
  GotInfo := ClassNameOf(AInfo);
  GotStand := ClassNameOf(AStand);
end;

end.
