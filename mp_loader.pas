unit mp_loader;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, Variants, DateUtils, XMLRead,XMLWrite,Dom,mp_types;
 type

 { TMPStorage }

 TMPStorage = class(TNetwork)
  public
    procedure LoadFromXmlFile(aFileName: string);
    procedure SaveToXmlFile(aFileName: string);
  end;
implementation

{ TMPStorage }

procedure TMPStorage.LoadFromXmlFile(aFileName: string);
  procedure DoLoadPC(aParentNode: TDOMNode; aNetworkItem: TNetworkItem);
    var
      I: Integer;
      oPingItem: TPingItem;
      oNode: TDOMNode;
    begin
      for I := 0 to aParentNode.ChildNodes.Count - 1 do
      begin
        oPingItem:=aNetworkItem.PCList.AddItem;

        oNode:=aParentNode.ChildNodes[i];
        oPingItem.Name:= VarToStr(oNode.Attributes.GetNamedItem('compname').NodeValue);
        oPingItem.ip  := VarToStr(oNode.Attributes.GetNamedItem('ip').NodeValue);
        oPingItem.melody   := VarToStr(oNode.Attributes.GetNamedItem('melody').NodeValue);
        oPingItem.AlarmTimeout   := StrToInt(VarToStr(oNode.Attributes.GetNamedItem('alarm').NodeValue));
        oPingItem.CheckTimeout:= StrToInt(VarToStr(oNode.Attributes.GetNamedItem('timeout').NodeValue));
        oPingItem.PlaySound:= StrToInt(VarToStr(oNode.Attributes.GetNamedItem('play').NodeValue));
         oPingItem.ashost:= StrTobool(VarToStr(oNode.Attributes.GetNamedItem('ashost').NodeValue));
      end;
    end;


    procedure DoLoadNetworks(aNode: TDOMNode);
    var
      I: Integer;
      oNode: TDOMNode;
      oNetworkItem: TNetworkItem;
    begin
      for I := 0 to aNode.ChildNodes.Count - 1 do
      begin
        oNetworkItem:=AddItem;

        oNode:=aNode.ChildNodes[i];
        oNetworkItem.Name:= oNode.Attributes.GetNamedItem('name').NodeValue;
       // oNetworkItem.Log:= oNode.Attributes.GetNamedItem('logfile').NodeValue;

        DoLoadPC(oNode, oNetworkItem);
      end;
    end;

  var
    oXmlDocument: TXmlDocument;
  begin
    oXMLDocument:=TXMLDocument.Create;
    ReadXMLFile(oXmlDocument,aFileName);

    DoLoadNetworks (oXmlDocument.DocumentElement);

    FreeAndNil(oXmlDocument);

  end;

procedure TMPStorage.SaveToXmlFile(aFileName: string);
  var
    oXmlDocument: TXmlDocument;
    vRoot,NetworkNode,PingItemNode: TDOMNode;
    i,d: integer;
    oPingItem: TPingItem;
  begin
    oXmlDocument:=TXmlDocument.Create;
    oXmlDocument.Encoding:='UTF-8';
    vRoot:=oXmlDocument.CreateElement('Document');
    oXmlDocument.AppendChild(vroot);
    vRoot:=oXMLDocument.DocumentElement;
    for i:=0 to count -1 do
       begin
         NetworkNode:=oXmlDocument.CreateElement('network');
         TDOMElement(NetworkNode).SetAttribute('name',Items[i].Name);
        // TDOMElement(NetworkNode).SetAttribute('logfile',Items[i].Log);
           for d:=0 to Items[i].PCList.Count - 1 do
              begin
                oPingItem:=Items[i].PCList.Items[d];
                PingItemNode:=oXMLDocument.CreateElement('workstation');
                TDOMElement(PingItemNode).SetAttribute('compname',oPingItem.Name);
                TDOMElement(PingItemNode).SetAttribute('ip',oPingItem.IP);
                TDOMElement(PingItemNode).SetAttribute('melody',oPingItem.Melody);
                TDOMElement(PingItemNode).SetAttribute('alarm',intToStr(oPingItem.AlarmTimeout));
                TDOMElement(PingItemNode).SetAttribute('play',IntToStr(oPingItem.PlaySound));
                TDOMElement(PingItemNode).SetAttribute('timeout',IntToStr(oPingItem.CheckTimeout));
                TDOMElement(PingItemNode).SetAttribute('ashost',BoolToStr(oPingItem.AsHost));
                NetworkNode.AppendChild(PingItemNode);
              end;
         vRoot.AppendChild(NetworkNode);
       end;
    WriteXMLFile (oXmlDocument,aFileName);
    FreeAndNil(oXmlDocument);
  end;

end.

