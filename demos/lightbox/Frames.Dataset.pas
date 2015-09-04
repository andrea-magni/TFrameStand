unit Frames.Dataset;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView, Data.Bind.Components, Data.Bind.DBScope
  , Data.DB, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt;

type
  TDatasetFrame = class(TFrame)
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
  private
    { Private declarations }
    function GetDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet);
    function GetItemTextField: string;
    procedure SetItemTextField(const Value: string);
    function GetDetailField: string;
    procedure SetDetailField(const Value: string);
  public
    { Public declarations }
    property DataSet: TDataSet read GetDataSet write SetDataSet;
    property ItemTextField: string read GetItemTextField write SetItemTextField;
    property DetailField: string read GetDetailField write SetDetailField;
  end;

implementation

{$R *.fmx}

{ TDatasetFrame }

function TDatasetFrame.GetDataSet: TDataSet;
begin
  Result := BindSourceDB1.DataSet;
end;

function TDatasetFrame.GetDetailField: string;
begin
  Result := LinkListControlToField1.FillExpressions[0].SourceMemberName;
end;

function TDatasetFrame.GetItemTextField: string;
begin
  Result := LinkListControlToField1.FieldName;
end;

procedure TDatasetFrame.SetDataSet(const Value: TDataSet);
begin
  BindSourceDB1.DataSet := Value;
end;

procedure TDatasetFrame.SetDetailField(const Value: string);
begin
  LinkListControlToField1.FillExpressions[0].SourceMemberName := Value;
end;

procedure TDatasetFrame.SetItemTextField(const Value: string);
begin
  LinkListControlToField1.FieldName := Value;
end;

end.
