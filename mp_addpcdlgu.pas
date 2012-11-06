unit mp_addpcdlgu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,mp_addpcdlg;
type

  { TAddCpuDialog }

  TAddCpuDialog = class(TComponent)

  public
    MainForm: TDlgFrm;
    constructor Create(AnOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: boolean;
  published
  end;

implementation

{ TAddCpuDialog }

constructor TAddCpuDialog.Create(AnOwner: TComponent);
begin
  inherited Create(AnOwner);
  MainForm:=TDlgFrm.Create(self);
end;

destructor TAddCpuDialog.Destroy;
begin
  MainForm.Free;
  inherited Destroy;
//  MainForm.Free;
end;

function TAddCpuDialog.Execute: boolean;
begin
  MainForm.ShowModal;
  if assigned(MainForm.PingItem) then
   result:=true else result :=false;

end;

end.

