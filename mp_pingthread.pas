unit mp_pingthread; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,PingSend,mp_types;

type

{ TPingThread }

TPingThread = class(TThread)
   protected
     procedure Execute; override;
   private
   public
     fPing: TPingItem;
     constructor Create(CreateSuspended: boolean; aPing: TPingItem);
     end;
implementation

{ TPingThread }




procedure TPingThread.Execute;


begin
  //inherited Execute;
end;

constructor TPingThread.Create(CreateSuspended: boolean; aPing: TPingItem);
begin
    fPing:=aPing;
    inherited Create(CreateSuspended);
end;

end.

