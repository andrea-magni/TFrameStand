unit Frames.EmployeeDetails;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components
  , FrameStand, FMX.ScrollBox, FMX.Memo, FMX.Memo.Types
  ;

type
  TEmployeeDetailsFrame = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    Switch1: TSwitch;
    LinkControlToField1: TLinkControlToField;
    Button1: TButton;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Memo1: TMemo;
    LinkControlToField2: TLinkControlToField;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    [FrameInfo] FInfo: TFrameInfo<TEmployeeDetailsFrame>;
  public
  end;

implementation

{$R *.fmx}

uses DataModules.Main;

procedure TEmployeeDetailsFrame.Button1Click(Sender: TObject);
begin
  FInfo.Hide();
end;

end.
