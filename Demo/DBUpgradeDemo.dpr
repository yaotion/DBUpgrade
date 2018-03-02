program DBUpgradeDemo;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uFrmSourceDB in '功能窗体\uFrmSourceDB.pas' {frmSetSourceDB},
  uFrmCompareSet in '功能窗体\uFrmCompareSet.pas' {frmCompareSet},
  uFrmConfigAdd in '功能窗体\uFrmConfigAdd.pas' {frmConfigAdd};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown  := DebugHook <> 0;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmConfigAdd, frmConfigAdd);
  Application.Run;
end.
