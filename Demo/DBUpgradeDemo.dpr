program DBUpgradeDemo;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uFrmSourceDB in '���ܴ���\uFrmSourceDB.pas' {frmSetSourceDB},
  uFrmCompareSet in '���ܴ���\uFrmCompareSet.pas' {frmCompareSet},
  uFrmConfigAdd in '���ܴ���\uFrmConfigAdd.pas' {frmConfigAdd};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown  := DebugHook <> 0;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmConfigAdd, frmConfigAdd);
  Application.Run;
end.
