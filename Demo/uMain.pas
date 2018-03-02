unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ADODB,DB,uDBUpgradeConst,uDBUpgrade, ComCtrls, ImgList, StdCtrls,
  ExtCtrls, PngImageList, RzPanel, RzSplit, AdvSplitter, Buttons, RzShellDialogs,
  Menus, RzTabs, XPMan, ToolWin, PngCustomButton, PngSpeedButton;


type
  //配置信息
  RUpgradeConfig = record
    //配置名称
    ConfigName : string;
    //创建时间
    CreateTime : string;
    //反射的数据库配置
    ReverseDBADD : string;
    ReverseDBUID : string;
    ReverseDBPWD : string;
    ReverseDBName : string;
    //比对的源XML路径
    SourceXML : string;
    //比对的目标数据库
    DestDBADD : string;
    DestDBUID : string;
    DestDBPWD : string;
    DestDBName : string;
  end;
  TUpgradeConfig = array of RUpgradeConfig;
  TfrmMain = class(TForm)
    ADOConnSource: TADOConnection;
    PngImageList1: TPngImageList;
    OpenDialog1: TOpenDialog;
    ADOConnDest: TADOConnection;
    DBLoader1: TDBLoader;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    miReverse: TMenuItem;
    miCompare: TMenuItem;
    N4: TMenuItem;
    E1: TMenuItem;
    N2: TMenuItem;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    RzPageControl1: TRzPageControl;
    TabSheet10: TRzTabSheet;
    AdvSplitter1: TAdvSplitter;
    lvTable: TListView;
    lvColumn: TListView;
    TabSheet11: TRzTabSheet;
    AdvSplitter2: TAdvSplitter;
    lvView: TListView;
    memoViewContent: TMemo;
    TabSheet12: TRzTabSheet;
    AdvSplitter3: TAdvSplitter;
    lvTrigger: TListView;
    memoTriggerContent: TMemo;
    TabSheet13: TRzTabSheet;
    AdvSplitter4: TAdvSplitter;
    lvProcedure: TListView;
    memoProcedureContent: TMemo;
    TabSheet14: TRzTabSheet;
    AdvSplitter5: TAdvSplitter;
    lvFunction: TListView;
    memoFunctionContent: TMemo;
    TabSheet15: TRzTabSheet;
    lvForeignkey: TListView;
    TabSheet1: TRzTabSheet;
    AdvSplitter6: TAdvSplitter;
    lvIndexColumn: TListView;
    lvIndex: TListView;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Button2: TButton;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Memo1: TMemo;
    Panel7: TPanel;
    Panel9: TPanel;
    tvCompare: TTreeView;
    ImgLstTree: TPngImageList;
    treeConfigHistory: TTreeView;
    PopupMenu1: TPopupMenu;
    miConfigAdd: TMenuItem;
    miConfigEdit: TMenuItem;
    miConfigDelete: TMenuItem;
    RzPanel1: TRzPanel;
    BtnConfigAdd: TPngSpeedButton;
    BtnConfigEdit: TPngSpeedButton;
    BtnConfigDelete: TPngSpeedButton;
    btnReverse: TPngSpeedButton;
    btnCompare: TPngSpeedButton;
    N3: TMenuItem;
    nConfigAdd: TMenuItem;
    nConfigEdit: TMenuItem;
    nConfigDelete: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvTableClick(Sender: TObject);
    procedure lvViewClick(Sender: TObject);
    procedure lvTriggerClick(Sender: TObject);
    procedure lvProcedureClick(Sender: TObject);
    procedure lvFunctionClick(Sender: TObject);
    procedure lvTableChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure miReverseClick(Sender: TObject);
    procedure miCompareClick(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure lvIndexClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DBLoader1CreateSourceDB(Sender: TObject; Succeed: Boolean;
      errorMsg: string);
    procedure DBLoader1DeleteDestDB(Sender: TObject; Succeed: Boolean;
      errorMsg: string);
    procedure btnReverseClick(Sender: TObject);
    procedure btnCompareClick(Sender: TObject);
    procedure treeConfigHistoryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miConfigDeleteClick(Sender: TObject);
    procedure miConfigAddClick(Sender: TObject);
    procedure miConfigEditClick(Sender: TObject);
    procedure BtnConfigAddClick(Sender: TObject);
    procedure BtnConfigEditClick(Sender: TObject);
    procedure BtnConfigDeleteClick(Sender: TObject);
    procedure nConfigDeleteClick(Sender: TObject);
    procedure nConfigEditClick(Sender: TObject);
    procedure nConfigAddClick(Sender: TObject);
  private
    { Private declarations }
    //反射回来的数据
    m_ReflexDB : TSQLDatabase;
    //从文件加载回来的数据
    m_FileDB   : TSQLDatabase;
    //待更新的目标数据库的数据
    m_UpdateDb : TSQLDatabase;
    //配置信息
    m_ConfigArray : TUpgradeConfig;
  private
    //比对两个数据库并生成比对结果的显示树
    procedure InitCompareTree(SourceDB,DestDB : TSQLDatabase);
    //加载参数配置
    procedure LoadConfig;
    //保存参数配置
    procedure SaveConfig;
    //刷新参数配置显示
    procedure RefreshTree;
  public
    { Public declarations }

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}
uses
  uFrmSourceDB,uFrmCompareSet,uDataDefine,IniFiles, uFrmConfigAdd;
{ TForm1 }


procedure TfrmMain.btnCompareClick(Sender: TObject);
begin
  miCompareClick(sender);
end;

procedure TfrmMain.BtnConfigAddClick(Sender: TObject);
begin
  miConfigAddClick(Sender);
end;

procedure TfrmMain.BtnConfigDeleteClick(Sender: TObject);
begin
  miConfigDeleteClick(Sender);
end;

procedure TfrmMain.BtnConfigEditClick(Sender: TObject);
begin
  miConfigEditClick(Sender);
end;

procedure TfrmMain.btnReverseClick(Sender: TObject);
begin
  miReverseClick(Sender);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  OpenDialog1.FileName := '';
  if treeConfigHistory.Selected <> nil then
  begin
    OpenDialog1.FileName := m_ConfigArray[treeConfigHistory.Selected.Index].SourceXML;
  end;
  if OpenDialog1.Execute then
  begin
    try
      m_ReflexDB.SaveToXml(OpenDialog1.FileName,Self);
      Application.MessageBox('保存成功','提示',MB_OK + MB_ICONINFORMATION);
    except on  e : Exception do
       Application.MessageBox(PChar(Format('保存失败%s',[e.Message])),'提示',MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  try
    Memo1.Lines.Clear;
    Memo1.Lines.Add('开始更新...');
    DBLoader1.UpdateDB(m_FileDB,m_UpdateDb,ADOConnDest);
    Memo1.Lines.Add('开始完成...');    
    ShowMessage('更新完毕');
  except on e : Exception do
    begin
      Memo1.Lines.Add('更新失败：' + e.Message);
      ShowMessage('更新失败：' + e.Message);
    end;
  end;
end;

procedure TfrmMain.DBLoader1CreateSourceDB(Sender: TObject; Succeed: Boolean;
  errorMsg: string);
var
  strTypeName,strObjectName : string;
  strSucceed : string;
begin
  {$region '翻译对象名'}
  if Sender is TSQLTable then
  begin
    strTypeName := '表';
    strObjectName := TSQLTable(Sender).TableName;
  end;
  if Sender is TSQLIndex then
  begin
     strTypeName := '索引\键';
     strObjectName := TSQLIndex(Sender).IndexName;
  end;
  if Sender is TSQLForeignkey then
  begin
    strTypeName := '外键';
    strObjectName := TSQLForeignkey(Sender).ForeignkeyName;
  end;
  if Sender is TSQLTrigger then
  begin
    strTypeName := '触发器';
    strObjectName := TSQLTrigger(Sender).TriggerName;
  end;

  if Sender is TSQLView then
  begin
    strTypeName := '视图';
    strObjectName := TSQLView(Sender).ViewName;
  end;
  if Sender is TSQLProcedure then
  begin
    strTypeName := '存储过程';
    strObjectName := TSQLProcedure(Sender).ProcedureName;
  end;
  if Sender is TSQLFunction then
  begin
    strTypeName := '函数';
    strObjectName := TSQLFunction(Sender).FunctionName;
  end;
  {$endregion '翻译对象名'}
  strSucceed := '失败';
  if Succeed then
    strSucceed := '成功';
  Memo1.Lines.Add(Format('创建%s[%s]%s:%s',[strTypeName,strObjectName,strSucceed,errorMsg]));
end;

procedure TfrmMain.DBLoader1DeleteDestDB(Sender: TObject; Succeed: Boolean;
  errorMsg: string);
var
  strTypeName,strObjectName : string;
  strSucceed : string;  
begin
 {$region '翻译对象名'}
  if Sender is TSQLTable then
  begin
    strTypeName := '主键';
    strObjectName := TSQLTable(Sender).TableName;
  end;
  if Sender is TSQLForeignkey then
  begin
    strTypeName := '外键';
    strObjectName := TSQLForeignkey(Sender).ForeignkeyName;
  end;
  if Sender is TSQLTrigger then
  begin
    strTypeName := '触发器';
    strObjectName := TSQLTrigger(Sender).TriggerName;
  end;
  if Sender is TSQLIndex then
  begin
     strTypeName := '唯一约束';
     strObjectName := TSQLIndex(Sender).IndexName;
  end;
  if Sender is TSQLView then
  begin
    strTypeName := '视图';
    strObjectName := TSQLView(Sender).ViewName;
  end;
  if Sender is TSQLProcedure then
  begin
    strTypeName := '存储过程';
    strObjectName := TSQLProcedure(Sender).ProcedureName;
  end;
  if Sender is TSQLFunction then
  begin
    strTypeName := '函数';
    strObjectName := TSQLFunction(Sender).FunctionName;
  end;
  {$endregion '翻译对象名'}
  strSucceed := '失败';
  if Succeed then
    strSucceed := '成功';
  Memo1.Lines.Add(Format('删除%s[%s]%s:%s',[strTypeName,strObjectName,strSucceed,errorMsg]));
end;

procedure TfrmMain.E1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  m_ReflexDB := TSQLDatabase.Create;
  m_FileDB   := TSQLDatabase.Create;
  m_UpdateDb := TSQLDatabase.Create;
  LoadConfig;
  RefreshTree;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  lvTable.OnChange := nil;
  m_ReflexDB.Free;
  m_FileDB.Free;
  m_UpdateDb.Free;
end;

procedure TfrmMain.InitCompareTree(SourceDB, DestDB: TSQLDatabase);
var
  i : integer;
  tab : TSQLTable;
  col : TSQLColumn;
  item,subItem : TTreeNode;
  j: Integer;
begin
  tvCompare.Items.Clear;
  for i := 0 to SourceDB.TableList.Count - 1 do
  begin
    tab := SourceDB.TableList[i];
    item := tvCompare.Items.AddChild(nil,'');
    item.Text := tab.TableName;
    case tab.UpdateType of
      utNone:
        begin
          item.ImageIndex := 0;
          item.SelectedIndex := 0;
          for j := 0 to tab.ColumnList.Count - 1 do
          begin
            col := tab.ColumnList.Items[j];
            subItem := tvCompare.Items.AddChild(item,'');
            subItem.Text := col.ColumnName;
            subItem.ImageIndex := 0;
            subItem.SelectedIndex := 0;
          end;
        end;
      utAdd:
      begin
        item.ImageIndex := 1;
        item.SelectedIndex := 1;
        for j := 0 to tab.ColumnList.Count - 1 do
        begin
          col := tab.ColumnList.Items[j];
          subItem := tvCompare.Items.AddChild(item,'');
          subItem.Text := col.ColumnName;
          subItem.ImageIndex := 1;
          subItem.SelectedIndex := 1;
        end;
      end;
      utUpdate:
      begin
        item.ImageIndex := 2;
        item.SelectedIndex := 2;
        for j := 0 to tab.ColumnList.Count - 1 do
        begin
          col := tab.ColumnList.Items[j];
          subItem := tvCompare.Items.AddChild(item,'');          
          subItem.Text := col.ColumnName;
          case col.UpdateType of
            utNone: begin
              subItem.ImageIndex := 0;
              subItem.SelectedIndex := 0;
            end;
            utAdd: begin
              subItem.ImageIndex := 1;
              subItem.SelectedIndex := 1;
            end;
            utUpdate: begin
              subItem.ImageIndex := 2;
              subItem.SelectedIndex := 2;
            end;
          end;
        end;
        tab := DestDB.FindTable(tab.TableName);
        for j := 0 to tab.ColumnList.Count - 1 do
        begin

          
          col := tab.ColumnList.Items[j];
          if col.UpdateType <> utDelete then continue;
          subItem := tvCompare.Items.AddChild(item,'');          
          subItem.Text := col.ColumnName;
          case col.UpdateType of
            utDelete: begin
              subItem.ImageIndex := 3;
              subItem.SelectedIndex := 3;
            end;
          end;
        end;
      end;
    end;
  end;

  for i := 0 to DestDB.TableList.Count - 1 do
  begin
    tab := DestDB.TableList[i];
    if tab.UpdateType <> utDelete then continue;
    
    item := tvCompare.Items.AddChild(nil,'');
    item.Text := tab.TableName;
    case tab.UpdateType of
      utDelete:
      begin
        item.ImageIndex := 3;
        item.SelectedIndex := 3;
        for j := 0 to tab.ColumnList.Count - 1 do
        begin
          col := tab.ColumnList.Items[j];
          subItem := tvCompare.Items.AddChild(item,'');
          subItem.Text := col.ColumnName;
          subItem.ImageIndex := 3;
          subItem.SelectedIndex := 3;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.LoadConfig;
var
  ini : TIniFile;
  sections : TStrings;
  i: Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  try
    sections := TStringList.Create;
    try
      ini.ReadSections(sections);
      setlength(m_ConfigArray,sections.Count);
      for i := 0 to sections.Count-1 do
      begin
        m_ConfigArray[i].ConfigName := ini.ReadString(sections[i],'ConfigName','');
        m_ConfigArray[i].CreateTime := ini.ReadString(sections[i],'CreateTime','');
        m_ConfigArray[i].ReverseDBADD := ini.ReadString(sections[i],'ReverseDBADD','');
        m_ConfigArray[i].ReverseDBUID := ini.ReadString(sections[i],'ReverseDBUID','');
        m_ConfigArray[i].ReverseDBPWD := ini.ReadString(sections[i],'ReverseDBPWD','');
        m_ConfigArray[i].ReverseDBName := ini.ReadString(sections[i],'ReverseDBName','');
        m_ConfigArray[i].SourceXML := ini.ReadString(sections[i],'SourceXML','');
        m_ConfigArray[i].DestDBADD := ini.ReadString(sections[i],'DestDBADD','');
        m_ConfigArray[i].DestDBUID := ini.ReadString(sections[i],'DestDBUID','');
        m_ConfigArray[i].DestDBPWD := ini.ReadString(sections[i],'DestDBPWD','');
        m_ConfigArray[i].DestDBName := ini.ReadString(sections[i],'DestDBName','');
      end;
    finally
      sections.Free;
    end;
  finally
    ini.Free;
  end;
end;

procedure TfrmMain.lvFunctionClick(Sender: TObject);
var
  funcName : string;
  func : TSQLFunction;
  i : integer;
begin
  if lvFunction.Selected = nil then exit;
  funcName := lvFunction.Selected.Caption;
  for i := 0 to m_ReflexDB.FunctionList.Count - 1 do
  begin
    func := m_ReflexDB.FunctionList[i];
    if func.FunctionName = lvFunction.Selected.Caption then
    begin
      memoFunctionContent.Text := func.FunctionContent;
    end;
  end;
end;

procedure TfrmMain.lvIndexClick(Sender: TObject);
var
  indexName : string;
  i,j,k: Integer;
  ind : TSQLIndex;
  tab : TSQLTable;
  indexcol : TSQLIndexColumn;
  item : TListItem;
  strTemp : string;
begin
  if lvIndex.Selected = nil then exit;
  lvIndexColumn.Items.Clear;
  indexName := lvIndex.Selected.Caption;
  for i := 0 to m_ReflexDB.TableList.Count - 1 do
  begin
    tab := m_ReflexDB.TableList[i];
    if tab.TableName = lvIndex.Selected.SubItems[0] then
    begin
      for j := 0 to tab.IndexList.Count - 1 do
      begin
        ind := tab.IndexList[j];
        if ind.IndexName = indexName then
        begin
          for k := 0 to ind.ColumnList.Count - 1 do
          begin
            indexcol := ind.ColumnList[k];
            item := lvIndexColumn.Items.Add;
            item.Caption :=  indexcol.ColumnName;
            strTemp := '升序';
            if indexcol.Order = coDesc then
              strTemp := '降序';
            item.SubItems.Add(strTemp);
          end;
          exit;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.lvProcedureClick(Sender: TObject);
var
  procedureName : string;
  proc : TSQLProcedure;
  i : integer;
begin
  if lvProcedure.Selected = nil then exit;
  procedureName := lvProcedure.Selected.Caption;
  for i := 0 to m_ReflexDB.ProcedureList.Count - 1 do
  begin
    proc := m_ReflexDB.ProcedureList[i];
    if proc.ProcedureName = lvProcedure.Selected.Caption then
    begin
      memoProcedureContent.Text := proc.ProcedureContent;
    end;
  end;
end;

procedure TfrmMain.lvTableChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  tabName : string;
  tab : TSQLTable;
  i: Integer;
begin
  tabName := Item.Caption;
  for i := 0 to m_ReflexDB.TableList.Count - 1 do
  begin
    tab := m_ReflexDB.TableList[i];
    if tab.TableName = tabName then
    begin
      tab.UpdateData := Item.Checked;
    end;
  end;
end;

procedure TfrmMain.lvTableClick(Sender: TObject);
var
  tabName : string;
  i,j: Integer;
  tab : TSQLTable;
  col : TSQLColumn;
  item : TListItem;
  strTemp : string;
begin
  if lvTable.Selected = nil then exit;
  lvColumn.Items.Clear;
  tabName := lvTable.Selected.Caption;
  for i := 0 to m_ReflexDB.TableList.Count - 1 do
  begin
    tab := m_ReflexDB.TableList[i];
    if tab.TableName = tabName then
    begin
      for j := 0 to tab.ColumnList.Count - 1 do
      begin
        col := tab.ColumnList[j];
        item := lvColumn.Items.Add;
        item.Caption :=  col.ColumnName;
        item.SubItems.Add(col.GetDataTypeName);
        item.SubItems.Add(IntToStr(col.DataLength));
        strTemp := '';
        if col.AllowNull then
          strTemp := '√';
        item.SubItems.Add(strTemp);
        item.SubItems.Add(col.DefaultValue);
        strTemp := '';
        if col.Primary then
          strTemp := '√';
        item.SubItems.Add(strTemp);
        strTemp := '';
        if col.Identity then
          strTemp := '√';
        item.SubItems.Add(strTemp);
        item.SubItems.Add(col.ColumnDescription);
      end;
      exit;
    end;
  end;
end;

procedure TfrmMain.lvTriggerClick(Sender: TObject);
var
  TriggerName : string;
  Trigger : TSQLTrigger;
  i : integer;
begin
  if lvTrigger.Selected = nil then exit;
  TriggerName := lvTrigger.Selected.Caption;
  for i := 0 to m_ReflexDB.TriggerList.Count - 1 do
  begin
    Trigger := m_ReflexDB.TriggerList[i];
    if Trigger.TriggerName = lvTrigger.Selected.Caption then
    begin
      memoTriggerContent.Text := Trigger.TriggerContent;
    end;
  end;
end;

procedure TfrmMain.lvViewClick(Sender: TObject);
var
  viewName : string;
  view : TSQLView;
  i : integer;
begin
  if lvView.Selected = nil then exit;
  viewName := lvView.Selected.Caption;
  for i := 0 to m_ReflexDB.ViewList.Count - 1 do
  begin
    view := m_ReflexDB.ViewList[i];
    if view.ViewName = lvView.Selected.Caption then
    begin
      memoViewContent.Text := view.ViewContent;
    end;
  end;
end;


procedure TfrmMain.miCompareClick(Sender: TObject);
var
  connString,sourceFile : string;
  destDBConn : RDBConnection;
  is2000,is2005 : boolean;
  destDBVersion : string;
begin
  frmCompareSet := TfrmCompareSet.Create(nil);
  try
    if treeConfigHistory.Selected <> nil then
    begin
      frmCompareSet.edtSourceFile.Text :=  m_ConfigArray[treeConfigHistory.Selected.Index].SourceXML;
      frmCompareSet.edtDestIP.Text := m_ConfigArray[treeConfigHistory.Selected.Index].DestDBADD;
      frmCompareSet.edtDestUser.Text := m_ConfigArray[treeConfigHistory.Selected.Index].DestDBUID;
      frmCompareSet.edtDestPassword.Text := m_ConfigArray[treeConfigHistory.Selected.Index].DestDBPWD;
      frmCompareSet.edtDestDBName.Text := m_ConfigArray[treeConfigHistory.Selected.Index].DestDBName;

    end;
    if frmCompareSet.ShowModal = mrOk then
    begin
      destDBConn := frmCompareSet.DestDBConn;
      sourceFile := frmCompareSet.edtSourceFile.Text;
    end else begin
      exit;
    end;
  finally
    frmCompareSet.Free;
  end;

  connString :=  'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=%s;' +
    'Password=%s;Initial Catalog=%s;Data Source=%s';
  connString := Format(connString,[destDBConn.strUser,
    destDBConn.strPassword,destDBConn.strDBName,destDBConn.strIp]);
  try
    if ADOConnDest.Connected  then
    begin
      ADOConnDest.Close;
    end;
    ADOConnDest.ConnectionString := connString;
    ADOConnDest.Connected := true
  except
    on e : Exception  do
    begin
      ADOConnDest.Close;
      ShowMessage(Format('目标数据库打开失败:%s！',[e.Message]));
      exit;
    end;
  end;

  m_FileDB.Clear;
  m_UpdateDb.Clear;
  m_FileDB.LoadFromXml(sourceFile,self);
  if not DBLoader1.GetDBVersion(ADOConnDest,destDBVersion)  then
  begin
    if not Application.MessageBox('目标数据库无版本信息，您还要继续执行吗？',
      '警告',MB_OKCANCEL + MB_ICONWARNING) = mrcancel then Exit; 

  end;
  if m_FileDB.DatabaseVersion = destDBVersion then
  begin
     if Application.MessageBox('源数据库与目标数据库的版本一致，您还要继续执行吗？',
      '警告',MB_OKCANCEL + MB_ICONWARNING) = mrcancel then Exit; 
  end;
  
  is2000 := DBLoader1.IsSql2000(ADOConnDest);
  is2005 := DBLoader1.IsSql2005(ADOConnDest);
  if not (is2000 or is2005) then
  begin
    Application.MessageBox('未知的数据库版本','提示',MB_OK + MB_ICONERROR) ;
    exit;
  end;  
  if is2000 then
    DBLoader1.Sqls := DBLoader1.GetSql2000Sqls;
  if is2005 then
    DBLoader1.Sqls := DBLoader1.GetSql2005Sqls;
  DBLoader1.LoadSchema(m_UpdateDb,ADOConnDest);
  m_FileDB.Compare(m_UpdateDb);
  InitCompareTree(m_FileDB,m_UpdateDb);
  PageControl1.ActivePageIndex := 1;
end;

procedure TfrmMain.miConfigAddClick(Sender: TObject);
var
  tempConfig:  RUpgradeConfig;
  i: Integer;
begin
  frmConfigAdd := tfrmConfigAdd.Create(nil);
  try
    if frmConfigAdd.ShowModal = mrcancel then
    begin
      exit;
    end;

    tempConfig.ConfigName := Trim(frmConfigAdd.edtConfigName.Text);
    tempConfig.CreateTime := FormatDateTime('yyyy-MM-dd HH:nn:ss',Now);
    tempConfig.ReverseDBADD := frmConfigAdd.edtSourceIP.Text;
    tempConfig.ReverseDBUID := frmConfigAdd.edtSourceUser.Text;
    tempConfig.ReverseDBPWD := frmConfigAdd.edtSourcePassword.Text;
    tempConfig.ReverseDBName := frmConfigAdd.edtSourceDBName.Text;
    tempConfig.SourceXML := frmConfigAdd.edtSourceFile.Text;
    tempConfig.DestDBADD := frmConfigAdd.edtDestIP.Text;
    tempConfig.DestDBUID := frmConfigAdd.edtDestUser.Text;
    tempConfig.DestDBPWD := frmConfigAdd.edtDestPassword.Text;
    tempConfig.DestDBName := frmConfigAdd.edtDestDBName.Text;

    setLength(m_ConfigArray,length(m_ConfigArray) + 1);
    for i := length(m_ConfigArray) - 2 downto 0 do
    begin
      m_ConfigArray[i+1] := m_ConfigArray[i];
    end;
    m_ConfigArray[0] := tempConfig;
    SaveConfig;
    RefreshTree;
    treeConfigHistory.Selected := treeConfigHistory.Items[0];
  finally
    frmConfigAdd.Free;
  end;
end;

procedure TfrmMain.miConfigDeleteClick(Sender: TObject);
var
  i,tempIndex: Integer;
begin
  if (treeConfigHistory.Selected = nil) then
  begin
    exit;
  end;
  if Application.MessageBox('您确定要删除此配置信息吗？','提示',MB_OKCANCEL) = mrCancel then exit;
  tempIndex := treeConfigHistory.Selected.Index;
  for i := treeConfigHistory.Selected.Index  to length(m_ConfigArray) - 2 do
  begin
    m_ConfigArray[i] := m_ConfigArray[i + 1];
  end;
  SetLength(m_ConfigArray,length(m_ConfigArray) - 1);
  SaveConfig;
  RefreshTree;
  if treeConfigHistory.Items.Count > 0 then
  begin
    if treeConfigHistory.Items.Count  > tempIndex then
      treeConfigHistory.Selected := treeConfigHistory.Items[tempIndex]
    else
      treeConfigHistory.Selected := treeConfigHistory.Items[treeConfigHistory.Items.Count - 1];
  end;
end;

procedure TfrmMain.miConfigEditClick(Sender: TObject);
var
  tempConfig:  RUpgradeConfig;
  tempIndex : integer;
begin
  if (treeConfigHistory.Selected = nil) then
  begin
    Application.MessageBox('请选择配置信息','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  tempIndex := treeConfigHistory.Selected.Index;
  frmConfigAdd := TfrmConfigAdd.Create(nil);
  try
    with m_ConfigArray[treeConfigHistory.Selected.Index] do
    begin
      frmConfigAdd.edtConfigName.Text := ConfigName;
      frmConfigAdd.edtSourceIP.Text := ReverseDBADD;
      frmConfigAdd.edtSourceUser.Text := ReverseDBUID;
      frmConfigAdd.edtSourcePassword.Text := ReverseDBPWD;
      frmConfigAdd.edtSourceDBName.Text := ReverseDBName;
      frmConfigAdd.edtSourceFile.Text := SourceXML;
      frmConfigAdd.edtDestIP.Text := DestDBADD;
      frmConfigAdd.edtDestUser.Text := DestDBUID;
      frmConfigAdd.edtDestPassword.Text := DestDBPWD;
      frmConfigAdd.edtDestDBName.Text := DestDBName;
    end;
    if frmConfigAdd.ShowModal = mrcancel then exit;
    tempConfig.ConfigName := Trim(frmConfigAdd.edtConfigName.Text);
    tempConfig.CreateTime := FormatDateTime('yyyy-MM-dd HH:nn:ss',Now);
    tempConfig.ReverseDBADD := frmConfigAdd.edtSourceIP.Text;
    tempConfig.ReverseDBUID := frmConfigAdd.edtSourceUser.Text;
    tempConfig.ReverseDBPWD := frmConfigAdd.edtSourcePassword.Text;
    tempConfig.ReverseDBName := frmConfigAdd.edtSourceDBName.Text;
    tempConfig.SourceXML := frmConfigAdd.edtSourceFile.Text;
    tempConfig.DestDBADD := frmConfigAdd.edtDestIP.Text;
    tempConfig.DestDBUID := frmConfigAdd.edtDestUser.Text;
    tempConfig.DestDBPWD := frmConfigAdd.edtDestPassword.Text;
    tempConfig.DestDBName := frmConfigAdd.edtDestDBName.Text;
    m_ConfigArray[treeConfigHistory.Selected.Index] := tempConfig;
    treeConfigHistory.Selected.Text := tempConfig.ConfigName;
    SaveConfig;
    RefreshTree;
    treeConfigHistory.Selected := treeConfigHistory.Items[tempIndex];       
  finally
    frmConfigAdd.Free;
  end;
end;

procedure TfrmMain.miReverseClick(Sender: TObject);
var
  i,j : integer;
  item : TListItem;
  tickCount : integer;
  connString,strTemp : string;
  dbConn : RDBConnection;
  is2000,is2005 : boolean;
begin
  frmSetSourceDB := TFrmSetSourceDB.Create(nil);
  try
    if treeConfigHistory.Selected <> nil then
    begin
      frmSetSourceDB.edtSourceIP.Text := m_ConfigArray[treeConfigHistory.Selected.Index].ReverseDBADD;
      frmSetSourceDB.edtSourceUser.Text := m_ConfigArray[treeConfigHistory.Selected.Index].ReverseDBUID;
      frmSetSourceDB.edtSourcePassword.Text :=  m_ConfigArray[treeConfigHistory.Selected.Index].ReverseDBPWD;
      frmSetSourceDB.edtSourceDBName.Text :=  m_ConfigArray[treeConfigHistory.Selected.Index].ReverseDBName;
    end;
    if frmSetSourceDB.ShowModal = mrOk then
    begin
      dbConn := frmSetSourceDB.SourceDBConn;
    end else begin
      exit;
    end;
  finally
    frmSetSourceDB.Free;
  end;
    
  tickCount := GetTickCount;
  {$region '创建连接'}
  connString :=  'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=%s; ' +
     ' Password=%s;Initial Catalog=%s;Data Source=%s';
  connString := Format(connString,[dbConn.strUser,
    dbConn.strPassword,dbConn.strDBName,dbConn.strIp]);
  try
    if ADOConnSource.Connected then
    begin
      ADOConnSource.Close;
    end;
    ADOConnSource.ConnectionString := connString;
    ADOConnSource.Connected := true;
  except
    on e : Exception  do
    begin
      ADOConnSource.Close;
      ShowMessage(Format('目标数据库打开失败:%s！',[e.Message]));
      exit;
    end;
  end;
  {$endregion '创建连接'}
  m_ReflexDB.Clear;
  is2000 := DBLoader1.IsSql2000(ADOConnSource);
  is2005 := DBLoader1.IsSql2005(ADOConnSource);
  if not (is2000 or is2005) then
  begin
    Application.MessageBox('未知的数据库版本','提示',MB_OK + MB_ICONERROR) ;
    exit;
  end;  
  if is2000 then
    DBLoader1.Sqls := DBLoader1.GetSql2000Sqls;
  if is2005 then
    DBLoader1.Sqls := DBLoader1.GetSql2005Sqls;
  DBLoader1.LoadSchema(m_ReflexDB,ADOConnSource);

  {$region '预览数据库框架'}
  lvTable.Items.Clear;
  lvView.Items.Clear;
  lvProcedure.Items.Clear;
  lvFunction.Items.Clear;
  lvForeignkey.Items.Clear;
  lvIndex.Items.Clear;
  for i := 0 to m_ReflexDB.TableList.Count - 1 do
  begin
    item := lvTable.Items.Add;
    item.ImageIndex := 0;
    item.Checked := m_ReflexDB.TableList[i].UpdateData;
    item.Caption := m_ReflexDB.TableList[i].TableName;
    item.SubItems.Add(m_ReflexDB.TableList[i].TableDescription);
    for j := 0 to m_ReflexDB.TableList[i].IndexList.Count - 1 do
    begin
      item := lvIndex.Items.Add;
      item.ImageIndex := 0;
      item.Caption := m_ReflexDB.TableList[i].IndexList[j].IndexName;
      item.SubItems.Add(m_ReflexDB.TableList[i].IndexList[j].TableName);
      strTemp := '';
      if m_ReflexDB.TableList[i].IndexList[j].Clustered then
        strTemp := '√';
      item.SubItems.Add(strTemp);    
      strTemp := '';
      if m_ReflexDB.TableList[i].IndexList[j].Unique then
        strTemp := '√';
      item.SubItems.Add(strTemp);
      strTemp := '';
      if m_ReflexDB.TableList[i].IndexList[j].IsPrimary then
        strTemp := '√';
      item.SubItems.Add(strTemp);
      strTemp := '';
      if m_ReflexDB.TableList[i].IndexList[j].IsConstraint then
        strTemp := '√';
      item.SubItems.Add(strTemp);
    end;
    TRzTabSheet(lvIndex.Parent).Caption := Format('索引(%d)',[lvIndex.Items.Count]);
  end;
  TRzTabSheet(lvTable.Parent).Caption := Format('表(%d)',[lvTable.Items.Count]);

  for i := 0 to m_ReflexDB.ViewList.Count - 1 do
  begin
    item := lvView.Items.Add;
    item.ImageIndex := 1;
    item.Caption := m_ReflexDB.ViewList[i].ViewName;
    item.SubItems.Add(m_ReflexDB.ViewList[i].ViewDescription);
  end;
  TRzTabSheet(lvView.Parent).Caption := Format('视图(%d)',[lvView.Items.Count]);
  
  for i := 0 to m_ReflexDB.TriggerList.Count - 1 do
  begin
    item := lvTrigger.Items.Add;
    item.ImageIndex := 2;
    item.Caption := m_ReflexDB.TriggerList[i].TriggerName;
    item.SubItems.Add(m_ReflexDB.TriggerList[i].TriggerDescription);
  end;
  TRzTabSheet(lvTrigger.Parent).Caption := Format('触发器(%d)',[lvTrigger.Items.Count]);

  for i := 0 to m_ReflexDB.ProcedureList.Count - 1 do
  begin
    item := lvProcedure.Items.Add;
    item.ImageIndex := 3;
    item.Caption := m_ReflexDB.ProcedureList[i].ProcedureName;
    item.SubItems.Add(m_ReflexDB.ProcedureList[i].ProcedureDescription)
  end;
  TRzTabSheet(lvProcedure.Parent).Caption := Format('存储过程(%d)',[lvProcedure.Items.Count]);
  
  for i := 0 to m_ReflexDB.FunctionList.Count - 1 do
  begin
    item := lvFunction.Items.Add;
    item.ImageIndex := 4;
    item.Caption := m_ReflexDB.FunctionList[i].FunctionName;
    item.SubItems.Add(m_ReflexDB.FunctionList[i].FunctionDescription);
  end;
  TRzTabSheet(lvFunction.Parent).Caption := Format('函数(%d)',[lvFunction.Items.Count]);
  
  for i := 0 to m_ReflexDB.ForeignkeyList.Count - 1 do
  begin
    item := lvForeignkey.Items.Add;
    item.ImageIndex := 5;
    item.Caption := m_ReflexDB.ForeignkeyList[i].KeyTableName;
    item.SubItems.Add(m_ReflexDB.ForeignkeyList[i].KeyColumnName);
    item.SubItems.Add(m_ReflexDB.ForeignkeyList[i].RKeyTableName);
    item.SubItems.Add(m_ReflexDB.ForeignkeyList[i].RKeyColumnName);
  end;
  TRzTabSheet(lvForeignkey.Parent).Caption := Format('外键(%d)',[lvForeignkey.Items.Count]);


 
  {$endregion '预览数据库框架'}
  caption := Format('数据库自动升级：%0.2f秒',[(GetTickCount - tickCount)/1000]);
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmMain.nConfigAddClick(Sender: TObject);
begin
  miConfigAddClick(Sender);
end;

procedure TfrmMain.nConfigDeleteClick(Sender: TObject);
begin
  miConfigDeleteClick(Sender);
end;

procedure TfrmMain.nConfigEditClick(Sender: TObject);
begin
  miConfigEditClick(Sender);
end;

procedure TfrmMain.RefreshTree;
var
  i : integer;
  node: TTreeNode;
begin
  treeConfigHistory.Items.Clear;
  for i := 0 to length(m_ConfigArray) - 1 do
  begin
    node := treeConfigHistory.Items.Add(nil,'');
    node.Text := m_ConfigArray[i].ConfigName;
  end;
end;

procedure TfrmMain.SaveConfig;
var
  ini : TIniFile;
  i: Integer;
  sections : TStrings;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  try
    sections := TStringList.Create;
    try
      ini.ReadSections(sections);
      for i := 0 to sections.Count - 1 do
      begin
        ini.EraseSection(sections[i]);
      end;
    finally
      sections.Free;
    end;
    for i := 0 to length(m_ConfigArray) - 1 do
    begin
      ini.WriteString(m_ConfigArray[i].ConfigName,'ConfigName',m_ConfigArray[i].ConfigName);
      ini.WriteString(m_ConfigArray[i].ConfigName,'CreateTime',m_ConfigArray[i].CreateTime);
      ini.WriteString(m_ConfigArray[i].ConfigName,'ReverseDBADD',m_ConfigArray[i].ReverseDBADD);
      ini.WriteString(m_ConfigArray[i].ConfigName,'ReverseDBUID',m_ConfigArray[i].ReverseDBUID);
      ini.WriteString(m_ConfigArray[i].ConfigName,'ReverseDBPWD',m_ConfigArray[i].ReverseDBPWD);
      ini.WriteString(m_ConfigArray[i].ConfigName,'ReverseDBName',m_ConfigArray[i].ReverseDBName);
      ini.WriteString(m_ConfigArray[i].ConfigName,'SourceXML',m_ConfigArray[i].SourceXML);
      ini.WriteString(m_ConfigArray[i].ConfigName,'DestDBADD',m_ConfigArray[i].DestDBADD);
      ini.WriteString(m_ConfigArray[i].ConfigName,'DestDBUID',m_ConfigArray[i].DestDBUID);
      ini.WriteString(m_ConfigArray[i].ConfigName,'DestDBPWD',m_ConfigArray[i].DestDBPWD);
      ini.WriteString(m_ConfigArray[i].ConfigName,'DestDBName',m_ConfigArray[i].DestDBName);
    end;
  finally
    ini.Free;
  end;
end;

procedure TfrmMain.treeConfigHistoryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 46 then
  begin
    miConfigDeleteClick(sender);
  end;
end;

end.
