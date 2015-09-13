unit DataModules.Main;

interface

uses
  System.SysUtils, System.Classes, Data.Bind.GenData, Fmx.Bind.GenData,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  TMainDataModule = class(TDataModule)
    PrototypeBindSource1: TPrototypeBindSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainDataModule: TMainDataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
