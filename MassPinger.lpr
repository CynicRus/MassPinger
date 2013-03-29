program MassPinger;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mp_main, mp_types, mp_loader, mp_utils, mp_addpcdlg, mp_addpcdlgu,
  httpsend;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPingerFrm, PingerFrm);
  Application.CreateForm(TdlgFrm, dlgFrm);
  Application.Run;
end.
