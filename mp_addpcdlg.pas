unit mp_addpcdlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin,mp_types,mp_utils;

type

  { TdlgFrm }

  TdlgFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    edIP: TEdit;
    edMusic: TEdit;
    edPcName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    mDlg: TOpenDialog;
    PingTimeout: TSpinEdit;
    maxTime: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    PingItem: TPingItem;
    function Execute: boolean;
    { public declarations }
  end; 

var
  dlgFrm: TdlgFrm;

implementation

{$R *.lfm}

{ TdlgFrm }

procedure TdlgFrm.CheckBox1Click(Sender: TObject);
begin
  if not CheckBox1.Checked then
    begin
      edMusic.Enabled:=false;
      Button1.Enabled:=false;
    end
   else
   begin
      edMusic.Enabled:=true;
      Button1.Enabled:=true;
   end;
end;

procedure TdlgFrm.FormCreate(Sender: TObject);
begin
  CheckBox1Click(sender);
end;

function TdlgFrm.Execute: boolean;
begin

end;

procedure TdlgFrm.Button1Click(Sender: TObject);
begin
  if mDlg.Execute then edMusic.Text:=mDlg.FileName;
end;

procedure TdlgFrm.Button2Click(Sender: TObject);
var
  i: integer;
  ok: boolean;
begin
  PingItem:=TPingItem.Create(nil);
  ok:= true;
  for i:=0 to self.ComponentCount-1 do
  begin
    if eq(self.Components[i].ClassName,'TEdit')  then
      if (TEdit(self.Components[i]).Text = '') and (TEdit(self.Components[i]).Enabled)  then ok:=false;
  end;
  if Ok then
    begin
    PingItem.Name:=edPcName.Text;
    PingItem.IP:=edIp.Text;
    if CheckBox1.Checked then
      begin
        PingItem.PlaySound:=1;
        PingItem.Melody:=edMusic.Text;
       end
        else
        PingItem.PlaySound:=0;
      PingItem.CheckTimeout:=PingTimeout.Value;
      PingItem.AlarmTimeout:=maxTime.Value;
      self.Hide;
    end else ShowMessage('fill in all fields!');

end;

procedure TdlgFrm.Button3Click(Sender: TObject);
begin
  self.Destroy;
end;

end.

