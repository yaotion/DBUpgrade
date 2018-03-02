unit uFrmSourceDB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uDataDefine, ExtCtrls, Buttons, DB, ADODB, ComCtrls;

type
  TfrmSetSourceDB = class(TForm)
    btnOK: TSpeedButton;
    btnCancel: TSpeedButton;
    ADOConnection: TADOConnection;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label9: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    btnTest: TSpeedButton;
    edtSourceIP: TEdit;
    edtSourceUser: TEdit;
    edtSourcePassword: TEdit;
    edtSourceDBName: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //源数据库连接
    SourceDBConn : RDBConnection;
  end;

var
  frmSetSourceDB: TfrmSetSourceDB;

implementation

{$R *.dfm}

procedure TfrmSetSourceDB.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSetSourceDB.btnOKClick(Sender: TObject);
begin
  SourceDBConn.strIp := edtSourceIP.Text;
  SourceDBConn.strUser := edtSourceUser.Text;
  SourceDBConn.strPassword := edtSourcePassword.Text;
  SourceDBConn.strDBName := edtSourceDBName.Text;
  ModalResult := mrOk;
end;

procedure TfrmSetSourceDB.btnTestClick(Sender: TObject);
var
  connString : string;
begin
  connString :=  'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=%s;Password=%s;Initial Catalog=%s;Data Source=%s';
  connString := Format(connString,[edtSourceUser.Text,
    edtSourcePassword.Text,edtSourceDBName.Text,edtSourceIP.Text]);
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
