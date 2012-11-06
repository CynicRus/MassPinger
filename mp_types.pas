unit mp_types;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 
type
  TStat = record
    ms,attempts,tAttempts,status,loses:integer;
  end;

  { TPingItem }
  TPingItem = class(TCollectionItem)
  public
    //stored
    IP: string;
    Name: string;
    Melody: string;
    PlaySound: integer;
    CheckTimeout: integer;
    AlarmTimeout: integer;
    //not stored
    CurrentStat: TStat;
      constructor Create(Col: TCollection); override;
      destructor Destroy; override;
    end;

  { TPingItemList }

  TPingItemList = class(TCollection)
    function GetItems(Index: Integer): TPingItem;
  public
    function AddItem: TPingItem;

    constructor Create;

    property Items[Index: Integer]: TPingItem read GetItems; default;
  end;

  { TNetworkItem }

  TNetworkItem = class(TCollectionItem)
    public
      Name: string;
      PCList: TPingItemList;
      constructor Create(Col: TCollection); override;
      destructor Destroy; override;
  end;

  TNetwork = class(TCollection)
    function GetItems(Index: Integer): TNetworkItem;
  public
    function AddItem: TNetworkItem;

    constructor Create;

    property Items[Index: Integer]: TNetworkItem read GetItems; default;
  end;


implementation

function TNetwork.GetItems(Index: Integer): TNetworkItem;
begin
  Result := TNetworkItem(inherited Items[Index]);
end;

function TNetwork.AddItem: TNetworkItem;
begin
  Result := TNetworkItem(inherited Add());
end;

constructor TNetwork.Create;
begin
  inherited Create(TNetworkItem);
end;

{ TNetworkItem }

constructor TNetworkItem.Create(Col: TCollection);
begin
  inherited Create(Col);
  PCList:=TPingItemList.Create;
end;

destructor TNetworkItem.Destroy;
begin
  inherited Destroy;
end;

constructor TPingItem.Create(Col: TCollection);
begin
  inherited Create(Col);
end;

destructor TPingItem.Destroy;
begin
  inherited Destroy;
end;

{ TPingItemList }

function TPingItemList.GetItems(Index: Integer): TPingItem;
begin
   Result := TPingItem(inherited Items[Index]);
end;

function TPingItemList.AddItem: TPingItem;
begin
   Result := TPingItem(inherited Add());
end;

constructor TPingItemList.Create;
begin
   inherited Create(TPingItem);
end;

end.

