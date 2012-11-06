program MassPinger;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mp_main, mp_types, mp_loader, mp_threadpool, mp_utils,
  laz_synapse, mp_addpcdlg, mp_addpcdlgu;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdlgFrm, dlgFrm);
  Application.Run;
end.

