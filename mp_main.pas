unit mp_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus, ExtCtrls, mp_loader,mp_types,mp_pingthread,PingSend;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    pingList: TImageList;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PageControl1: TPageControl;
    PCMenu: TPopupMenu;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PingTimer: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItem4Click(Sender: TObject);
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

var
  Form1: TForm1;
  index: integer = 0;
  Storage: TMPStorage;

implementation
uses mp_addpcdlgu;
{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
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
  if fileexists('MP.xml') then
    begin
      Storage.LoadFromXmlFile('MP.xml');
      LoadToTreeView();
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  AddCategory(Sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if not assigned(TreeView1.Selected) then exit;
  RemoveCategory(Sender);
end;

procedure TForm1.ListView1Click(Sender: TObject);
begin

end;

procedure TForm1.ListView1MouseDown(Sender: TObject; Button: TMouseButton;
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

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  //AddPC(sender);
end;

procedure TForm1.PingTimerTimer(Sender: TObject);
var
  i,j: integer;
  Ping: TPingSend;
  tPing: TPingItem;
  t: integer;
begin
  Ping:=TPingSend.Create;
  for i:=0 to Storage.Count-1 do
   for j:=0 to Storage.Items[i].PCList.Count-1 do
  begin
  tPing:=Storage.Items[i].PCList[j];
  ping.Timeout:=tPing.CheckTimeout;
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
  PingUpdateListView(Storage.Items[i]);
  end;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
var
  i: integer;
begin
  ToolButton1.Enabled:=false;
  ToolButton2.Enabled:=true;
  ToolButton3.Enabled:=true;
  PingTimer.Enabled:=true;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  ToolButton1.Enabled:=true;
  ToolButton2.Enabled:=false;
  ToolButton3.Enabled:=true;
  pingTimer.Enabled:=false;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  ToolButton1.Enabled:=true;
  ToolButton2.Enabled:=false;
  ToolButton3.Enabled:=false;
  pingTimer.Enabled:=false;
end;

procedure TForm1.TreeView1Click(Sender: TObject);
begin
  if assigned(TreeView1.Selected) then
       begin
        index:=TreeView1.Selected.Index;
        LoadGroupToListView(TNetworkItem(TreeView1.Selected.Data));
       end;
end;


procedure TForm1.LoadToTreeView();
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

procedure TForm1.LoadGroupToListView(aGroup: TNetworkItem);
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

procedure TForm1.PingUpdateListView(aGroup: TNetworkItem);
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
    oListItem.SubItems.Add('Offline')
  end;
  end;

procedure TForm1.AddPC(Sender: TObject);
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

procedure TForm1.RemovePC(Sender: TObject);
begin
  if storage.Count > 0 then exit;
  storage.Items[index].PCList.Delete(ListView1.Selected.Index);
  Storage.SaveToXmlFile('MP.xml');
  LoadToTreeView();
end;

procedure TForm1.AddCategory(Sender: TObject);
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

procedure TForm1.RemoveCategory(Sender: TObject);
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

