unit mp_addpcdlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin,Process, Sockets,mp_types,mp_utils,httpsend;

type

  { TdlgFrm }

  TdlgFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
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
    procedure FormActivate(Sender: TObject);
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
function GetHostIp(AHostName : string) : string;
var p : TProcess;
    sl : TStringList;
    i : integer;
begin
  // use nslookup to find IP address of a given host, it use google DNS server so it work regardless
  // of /etc/resolv.conf where 127.0.0.1 should be anyway
  result := '';
  // run nslookup foo.com 8.8.8.8
  p := TProcess.Create(nil);
  p.CommandLine := 'nslookup '+AHostName;
  p.Options := p.Options + [poWaitOnExit, poUsePipes];
  p.Execute;
  // parse its output, return first address found
  sl := TStringList.Create;
  sl.LoadFromStream(p.Output);
  for i := 0 to sl.Count-1 do
      if pos('Address: ',sl[i]) = 1 then
      begin
        if sl.Count>=5 then
         result := copy(sl[i+3],10,maxint) else
          result := copy(sl[i],10,maxint);
         break;
      end;
  // showmessage(sl.text);
  sl.Free;
  p.Free;
end;
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

procedure TdlgFrm.FormActivate(Sender: TObject);
begin
//  self.ShowModal;
  SetFocus;
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
    if CheckBox2.Checked then
        PingItem.IP:=GetHostIP(edIp.Text) else PingItem.IP:=edIp.Text;

    if CheckBox1.Checked then
      begin
        PingItem.PlaySound:=1;
        PingItem.Melody:=edMusic.Text;
       end
        else
        PingItem.PlaySound:=0;
      if not CheckBox2.Checked then
      PingItem.CheckTimeout:=PingTimeout.Value else PingItem.CheckTimeout:=5000;
      PingItem.AlarmTimeout:=maxTime.Value;
      {$IFDEF WINDOWS}self.Hide{$ELSE}self.Close{$ENDIF};
    end else ShowMessage('fill in all fields!');

end;

procedure TdlgFrm.Button3Click(Sender: TObject);
begin
  self.Hide;
end;

end.
