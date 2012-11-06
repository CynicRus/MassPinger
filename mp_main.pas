unit mp_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus, mp_loader,mp_types;

type

  { TForm1 }

  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PageControl1: TPageControl;
    GroupMenu: TPopupMenu;
    PCMenu: TPopupMenu;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TreeView1: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    { private declarations }
  public
    procedure LoadToTreeView();
    procedure LoadGroupToListView(aGroup: TNetworkItem);
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
var
//  tPing: TPingItem;
//  tNetwItem: TNetworkItem;
//  frm: TAddCpuDialog;
begin
  Storage:= TMPStorage.Create;
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
  Storage.LoadFromXmlFile('MP.xml');
  LoadToTreeView();
end;

procedure TForm1.TreeView1Click(Sender: TObject);
begin
    if not assigned(TreeView1.Selected) then exit;
    index:=TreeView1.Selected.Index;
    LoadGroupToListView(TNetworkItem(TreeView1.Selected.Data));
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
  Index:=0;
  LoadGroupToListView(TNetworkItem(Storage.Items[0]));
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
//end;

end.

