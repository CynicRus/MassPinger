unit mp_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus, ExtCtrls, mp_loader,mp_types,mp_pingthread,PingSend;

  { TPingerFrm }
 type
  TPingerFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Memo1: TMemo;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    pingList: TImageList;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PageControl1: TPageControl;
    PCMenu: TPopupMenu;
    HideMenu: TPopupMenu;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PingTimer: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ti: TTrayIcon;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure PingTimerTimer(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    { private declarations }
  public
    procedure LoadToTreeView();
    procedure LoadGroupToListView(aGroup: TNetworkItem);
    procedure PingUpdateListView(aGroup: TNetworkItem);
    procedure AddPC(Sender: TObject);
    procedure RemovePC(Sender: TObject);
    procedure AddCategory(Sender: TObject);
    procedure RemoveCategory(Sender: TObject);
    { public declarations }
  end; 
type

{ TPingThread }

TPingThread = class(TThread)
  protected
    procedure Execute; override;
  public
    tPing: TPingItem;
    Constructor Create(CreateSuspended : boolean;iPing: TPingItem);
  end;

var
  PingerFrm: TPingerFrm;
  index: integer = 0;
  Storage: TMPStorage;
  Check: boolean = false;
  Minimized: boolean = false;
  Pings: Array of TPingThread;

implementation
uses mp_addpcdlgu;

{ TPingThread }

procedure TPingThread.Execute;
var
  Ping: TPingSend;
  t: integer;
begin
 // inherited Execute();
   Ping:=TPingSend.Create;
   ping.Timeout:=tPing.CheckTimeout;
  while check do
  begin
   sleep(tPing.CheckTimeout);
  if Ping.Ping(tPing.IP) then begin
      if Ping.ReplyError = IE_NoError then
       begin
         t:=Ping.PingTime;
         tPing.CurrentStat.Attempts:=tPing.CurrentStat.Attempts+1;
         tPing.CurrentStat.status:=1;
      end
      else
      begin
        tPing.CurrentStat.loses:=tPing.CurrentStat.loses+1;
        tPing.CurrentStat.status:=0;
      end;
      tPing.CurrentStat.tAttempts:=tPing.CurrentStat.Attempts+tPing.CurrentStat.loses;
       tPing.CurrentStat.ms := Round(100.0*(tPing.CurrentStat.ms - tPing.CurrentStat.ms/tping.CurrentStat.tAttempts + 1.0*t/tping.CurrentStat.tAttempts));
      tPing.CurrentStat.ms := tPing.CurrentStat.ms / 100.0;
  end;
  end;
end;

constructor TPingThread.Create(CreateSuspended: boolean; iPing: TPingItem);
begin
  FreeOnTerminate := True;
    inherited Create(CreateSuspended);
    tPing:=TPingItem.Create(nil);
    tPing:=iPing;
end;

{$R *.lfm}

{ TPingerFrm }

procedure TPingerFrm.FormCreate(Sender: TObject);
//  tPing: TPingItem;
//  tNetwItem: TNetworkItem;
//  frm: TAddCpuDialog;
begin
  Storage:= TMPStorage.Create;
  ToolButton2.Enabled:=false;
  ToolButton3.Enabled:=false;
{  tNetwItem:=Storage.AddItem ;
  tNetwItem.Name:='DC';
 // Storage.LoadFromXmlFile('MP.xml');
//  LoadToTreeView();
  tPing:=tNetwItem.PCList.AddItem;
  frm:=TAddCpuDialog.Create(self);
  if frm.Execute then
   begin
   tPing.Name:=frm.MainForm.PingItem.Name;
   tPing.IP:=frm.MainForm.PingItem.IP;
   tPing.Melody:=frm.MainForm.PingItem.Melody;
   tPing.PlaySound:=frm.MainForm.PingItem.PlaySound;
   tPing.CheckTimeout:=frm.MainForm.PingItem.CheckTimeout;
   tPing.AlarmTimeout:=frm.MainForm.PingItem.AlarmTimeout;
   end;
  Storage.SaveToXmlFile('MP.xml');}
  self.Caption:='Mass Pinger v 1.0 by Cynic'+#32+{$IFDEF WINDOWS}'[WIN]' {$ELSE}'[LIN]'{$ENDIF};
  if fileexists('MP.xml') then
    begin
      Storage.LoadFromXmlFile('MP.xml');
      LoadToTreeView();
    end;
  SetLength(Pings,1);
end;

procedure TPingerFrm.FormDestroy(Sender: TObject);
begin
   Check:=false;
   sleep(500);
   pings:=nil;
//  FreeAndNil(Pings);
end;

procedure TPingerFrm.Button1Click(Sender: TObject);
begin
  AddCategory(Sender);
end;

procedure TPingerFrm.Button2Click(Sender: TObject);
begin
if not assigned(TreeView1.Selected) then exit;
  RemoveCategory(Sender);
end;

procedure TPingerFrm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Minimized:=true;
  CloseAction := caNone;
  Application.Minimize;
  ti.show;
end;

procedure TPingerFrm.ListView1Click(Sender: TObject);
begin

end;

procedure TPingerFrm.ListView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (button=mbRight)  then
   begin
     if not assigned(ListView1.Selected) then
      begin
         PCMenu.Items[0].Caption:='Add new PC';
         PCMenu.Items[0].OnClick:=@AddPC;
        end
     else
      begin
         PCMenu.Items[0].Caption:='Remove PC';
         PCMenu.Items[0].OnClick:=@RemovePC;
      end;
      PCMenu.PopUp;
    end;
end;

procedure TPingerFrm.MenuItem2Click(Sender: TObject);
begin
  Minimized:=true;
  Application.Minimize;
  ti.show;
end;

procedure TPingerFrm.MenuItem3Click(Sender: TObject);
begin
  HideMenu.Items[0].Click;
end;

procedure TPingerFrm.MenuItem4Click(Sender: TObject);
begin
  //AddPC(sender);
end;

procedure TPingerFrm.MenuItem5Click(Sender: TObject);
begin
  self.Destroy;
  Application.Terminate;
end;

procedure TPingerFrm.MenuItem6Click(Sender: TObject);
begin
  Minimized:=false;
  Application.Restore;
//  Self.Show;
  ti.Hide;
end;

procedure TPingerFrm.PingTimerTimer(Sender: TObject);
  begin
  PingUpdateListView(Storage.Items[index]);
  end;

procedure TPingerFrm.ToolButton1Click(Sender: TObject);
var
  i,j,k: integer;
  mPing: TPingThread;
begin
  ToolButton1.Enabled:=false;
  ToolButton2.Enabled:=true;
  ToolButton3.Enabled:=true;
  PingTimer.Enabled:=true;
  if not Check then
   begin
  Check:=true;
  for i:=0 to Storage.Count-1 do
   for j:=0 to Storage.Items[i].PCList.Count - 1 do
    begin
    PingTimer.Enabled:=true;
      mPing:=TPingThread.Create(false,Storage.Items[i].PCList[j]);
      pings[Length(pings)-1]:=mPing;
      SetLength(Pings,Length(pings));
    end;

   end else
   begin
    For k:=0 to Length(pings)-1 do
   begin
    TPingThread(Pings[k]).Suspended:=false;
   end;
   end;
end;

procedure TPingerFrm.ToolButton2Click(Sender: TObject);
var
 i: integer;
begin
  ToolButton1.Enabled:=true;
  ToolButton2.Enabled:=false;
  ToolButton3.Enabled:=true;
  For i:=0 to Length(pings)-1 do
   begin
    TPingThread(Pings[i]).Suspended:=true;
   end;
  PingTimer.Enabled:=false;
end;

procedure TPingerFrm.ToolButton3Click(Sender: TObject);
var
 i: integer;
begin
  PingTimer.Enabled:=true;
  ToolButton1.Enabled:=true;
  ToolButton2.Enabled:=false;
  ToolButton3.Enabled:=false;
 // pingTimer.Enabled:=false;
  check:=false;
 // for i:= 0 to Length(pings)-1 do
 //  begin
 //   Pings[i].Suspended:=true;
 //   Pings[i].Free;
 //  end;

end;

procedure TPingerFrm.TreeView1Click(Sender: TObject);
begin
  if assigned(TreeView1.Selected) then
       begin
        index:=TreeView1.Selected.Index;
        LoadGroupToListView(TNetworkItem(TreeView1.Selected.Data));
       end;
end;


procedure TPingerFrm.LoadToTreeView();
var
  I: Integer;
  TempNode: TTreeNode;
begin
  TreeView1.Items.Clear;
  for I := 0 to Storage.Count - 1 do
  begin
     TempNode:=TreeView1.Items.Add(nil,Storage.Items[i].Name);
     TempNode.Data:=Storage.Items[i];
  end;
  LoadGroupToListView(TNetworkItem(Storage.Items[index]));
end;

procedure TPingerFrm.LoadGroupToListView(aGroup: TNetworkItem);
var
  I: Integer;
  oListItem: TListItem;
  oPingItem: TPingItem;
begin
  ListView1.Items.Clear;
  for I := 0 to aGroup.PCList.Count - 1 do
  begin
    oListItem:= ListView1.Items.Add;
    oListItem.Data:=aGroup.PCList[i];
    oPingItem:=aGroup.PCList[i];
    oListItem.Caption:=aGroup.PCList[i].Name;
    oListItem.SubItems.Add(oPingItem.IP);
   // oListItem.SubItems.Add(oPingItem.CurrentStat.attempts+'/'+aGroup.PCList[i].CurrentStat.tAttempts);
   // oListItem.SubItems.Add(oPingItem.CurrentStat.ms);
   // oListItem.SubItems.Add(oPingItem.CurrentStat.loses);
  //  if oPingItem.CurrentStat.status > 0 then
  //  oListItem.SubItems.Add('Online')
  //  else
  //  oListItem.SubItems.Add('Offline')
  end;
  end;

procedure TPingerFrm.PingUpdateListView(aGroup: TNetworkItem);
var
  I: Integer;
  oListItem: TListItem;
  oPingItem: TPingItem;
begin
  ListView1.Items.Clear;
  for I := 0 to aGroup.PCList.Count - 1 do
  begin
    oListItem:= ListView1.Items.Add;
    oListItem.Data:=aGroup.PCList[i];
    oPingItem:=aGroup.PCList[i];
    oListItem.Caption:=aGroup.PCList[i].Name;
    oListItem.SubItems.Add(oPingItem.IP);
    oListItem.SubItems.Add(IntToStr(oPingItem.CurrentStat.attempts)+'/'+IntToStr(aGroup.PCList[i].CurrentStat.tAttempts));
    oListItem.SubItems.Add(FloattoStr(oPingItem.CurrentStat.ms));
    oListItem.SubItems.Add(IntToStr(oPingItem.CurrentStat.loses));
    if oPingItem.CurrentStat.status > 0 then
    oListItem.SubItems.Add('Online')
    else
     begin
    oListItem.SubItems.Add('Offline') ;
    if Minimized and Check then
    begin
     ti.BalloonHint:=oPingItem.name + #32 +'is offline now! Please check that!';
     ti.ShowBalloonHint;
     end;
  end;
  end;

end;

procedure TPingerFrm.AddPC(Sender: TObject);
var
  frm: TAddCpuDialog;
  tPing: TPingItem;
begin
  if not storage.Count > 0 then exit;
  tPing:=Storage.Items[index].PCList.AddItem;
  frm:=TAddCpuDialog.Create(self);
  if frm.Execute then
   begin
   tPing.Name:=frm.MainForm.PingItem.Name;
   tPing.IP:=frm.MainForm.PingItem.IP;
   tPing.Melody:=frm.MainForm.PingItem.Melody;
   tPing.PlaySound:=frm.MainForm.PingItem.PlaySound;
   tPing.CheckTimeout:=frm.MainForm.PingItem.CheckTimeout;
   tPing.AlarmTimeout:=frm.MainForm.PingItem.AlarmTimeout;
   end;
  frm.Free;
  self.Show;
  Storage.SaveToXmlFile('MP.xml');
  LoadToTreeView();
end;

procedure TPingerFrm.RemovePC(Sender: TObject);
begin
  if storage.Count > 0 then exit;
  storage.Items[index].PCList.Delete(ListView1.Selected.Index);
  Storage.SaveToXmlFile('MP.xml');
  LoadToTreeView();
end;

procedure TPingerFrm.AddCategory(Sender: TObject);
var
  Net: TNetworkItem;
  UserString: string;
begin
  Net:=Storage.AddItem;
 if InputQuery('Add new group:', 'Type in new group name', false, UserString)
  then Net.Name:=UserString;
   Storage.SaveToXmlFile('MP.xml');
  LoadToTreeView();
end;

procedure TPingerFrm.RemoveCategory(Sender: TObject);
begin
  Storage.Delete(TreeView1.Selected.Index);
  if storage.Count > 0 then
   begin
    Storage.SaveToXmlFile('MP.xml');
   index:=0;
   LoadToTreeView();
   end
  else
  begin
    DeleteFile('MP.xml');
    TreeView1.Items.Clear;
    ListView1.Items.Clear;
  end;
end;

//end;

end.

