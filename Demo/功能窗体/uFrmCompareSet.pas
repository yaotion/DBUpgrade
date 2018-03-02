unit uFrmCompareSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,uDataDefine, DB, ADODB, ComCtrls;

type
  TfrmCompareSet = class(TForm)
    btnCancel: TSpeedButton;
    btnOK: TSpeedButton;
    OpenDialog1: TOpenDialog;
    ADOConnection: TADOConnection;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    btnFindSource: TSpeedButton;
    edtSourceFile: TEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    btnTest: TSpeedButton;
    edtDestIP: TEdit;
    edtDestUser: TEdit;
    edtDestPassword: TEdit;
    edtDestDBName: TEdit;
    procedure btnFindSourceClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //源数据库结构文件
    SourceFile : string;
    //目标数据库连接
    DestDBConn : RDBConnection;
  end;

var
  frmCompareSet: TfrmCompareSet;

implementation

{$R *.dfm}

procedure TfrmCompareSet.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmCompareSet.btnFindSourceClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edtSourceFile.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmCompareSet.btnOKClick(Sender: TObject);
begin
  DestDBConn.strIp := edtDestIP.Text;
  DestDBConn.strUser := edtDestUser.Text;
  DestDBConn.strPassword := edtDestPassword.Text;
  DestDBConn.strDBName := edtDestDBName.Text;
  SourceFile := edtSourceFile.Text;
  if not FileExists(SourceFile) then
  begin
    Application.MessageBox('提示','源数据库文件不存在',MB_OK + MB_ICONERROR);
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TfrmCompareSet.btnTestClick(Sender: TObject);
var
  connString : string;
begin
  connString :=  'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=%s;Password=%s;Initial Catalog=%s;Data Source=%s';
  connString := Format(connString,[edtDestUser.Text,
    edtDestPassword.Text,edtDestDBName.Text,edtDestIP.Text]);
  ADOConnection.ConnectionString := connString;
  try
    try
      ADOConnection.Open;
      Application.MessageBox('数据库连接成功','提示',MB_OK + MB_ICONINFORMATION);
    except on e: Exception do
      Application.MessageBox(PChar(Format('数据库连接错误：%s',[e.Message])),'提示',MB_OK + MB_ICONERROR);
    end;
  finally
    ADOConnection.Close;
  end;
end;

end.
