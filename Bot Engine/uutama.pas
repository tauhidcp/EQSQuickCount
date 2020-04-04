unit UUtama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, EditBtn, Buttons, ExtCtrls, ZConnection, ZDataset,
  Windows, fphttpclient, ssl_openssl, fpjson, jsonparser, dateutils, WinInet,
  AmbilPesan;

type

  { TFBotEngine }

  TFBotEngine = class(TForm)
    BSimpan: TBitBtn;
    CkNotif: TCheckBox;
    CBInbox: TComboBox;
    CBOutbox: TComboBox;
    ENamaBot: TEdit;
    EToken: TEdit;
    GroupBox: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MemoLog: TMemo;
    PageControl: TPageControl;
    PBLoading: TProgressBar;
    SChatInfo: TStatusBar;
    TChatLog: TTabSheet;
    TBotSetting: TTabSheet;
    TimerCekInternet: TTimer;
    TrayIcon1: TTrayIcon;
    ZKoneksi: TZConnection;
    ZQPengaturan: TZQuery;
    ZQTerimaChat: TZQuery;
    ZQKirimChat: TZQuery;
    ZQCari: TZQuery;
    ZQStatus: TZQuery;
    ZQTambahan: TZQuery;
    procedure BSimpanClick(Sender: TObject);
    procedure CBInboxKeyPress(Sender: TObject; var Key: char);
    procedure CBOutboxKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MemoLogKeyPress(Sender: TObject; var Key: char);
    procedure TimerCekInternetTimer(Sender: TObject);
  private
  AmbilPesan : TAmbilPesan;   // Thread
  { private declarations }
  public
    { public declarations }
  procedure Pengaturan;
  end;

var
  FBotEngine: TFBotEngine;
  offset: Int64;
  token,inbox,outbox,tooltip : string;
  http        : TFPHTTPClient;
  jsonDoc     : TJSONObject;
  Flags: Windows.DWORD;

implementation

{$R *.lfm}

function TaskBarHeight: integer;
var
  hTB: HWND; // taskbar handle
  TBRect: TRect; // taskbar rectangle
begin
  hTB:= FindWindow('Shell_TrayWnd', '');
  if hTB = 0 then
    Result := 0
  else begin
    GetWindowRect(hTB, TBRect);
    Result := TBRect.Bottom - TBRect.Top;
  end;
end;

{ TFBotEngine }

procedure TFBotEngine.FormShow(Sender: TObject);
begin
  FBotEngine.Left := (Screen.Width - FBotEngine.Width) - 15;
  FBotEngine.Top := (Screen.Height - FBotEngine.Height) - (TaskBarHeight+35);
  Pengaturan;
end;

procedure TFBotEngine.CBInboxKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFBotEngine.BSimpanClick(Sender: TObject);
var
  tipx : string;
begin
  if (ENamaBot.Text='') or (EToken.Text='') or (CBInbox.Text='-Pilih-') or (CBOutbox.Text='-Pilih-') then
     exit else
     begin
       if CkNotif.Checked=True then tipx:='Yes' else tipx:='No';
       with ZQPengaturan do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='update t_telegrambot set nama_bot="'+ENamaBot.Text+'",token="'+EToken.Text+'",inboxnotif="'+CBInbox.Text+'",outboxnotif="'+CBOutbox.Text+'",tooltip="'+tipx+'" where id="1"';
       ExecSQL;
       SQL.Clear;
       SQL.Text:='select * from t_telegrambot';
       Open;
       First;
       end;
       Caption:=ENamaBot.Text;
       inbox:=CBInbox.Text;
       outbox:=CBOutbox.Text;
       tooltip:=tipx;
       token:=EToken.Text;
     end;
end;

procedure TFBotEngine.CBOutboxKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFBotEngine.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  with ZQStatus do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='update t_telegrambot set status="Off" where id="1"';
  ExecSQL;
  end;
  Application.Terminate;
end;


procedure TFBotEngine.FormDestroy(Sender: TObject);
begin
  AmbilPesan.Destroy;
  AmbilPesan.Terminate;
  inherited;
end;

procedure TFBotEngine.MemoLogKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFBotEngine.TimerCekInternetTimer(Sender: TObject);
begin
  with ZQPengaturan do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_telegrambot';
  Open;
  First;
  end;
  SChatInfo.Panels[0].Text := ' Inbox ['+ZQPengaturan.FieldByName('inboxcount').AsString+']';
  SChatInfo.Panels[1].Text := ' Outbox ['+ZQPengaturan.FieldByName('outboxcount').AsString+']';
  Flags := 0;
  if (WinInet.InternetGetConnectedState(@Flags, 0)) then
      begin
      PBLoading.Position:=100;
      with ZQStatus do
      begin
      Close;
      SQL.Clear;
      SQL.Text:='update t_telegrambot set status="On" where id="1"';
      ExecSQL;
      end;
      end else
      begin
      PBLoading.Position:=0;
      with ZQStatus do
      begin
      Close;
      SQL.Clear;
      SQL.Text:='update t_telegrambot set status="Off" where id="1"';
      ExecSQL;
      end;
      end;
end;

procedure TFBotEngine.Pengaturan;
begin
  with ZQPengaturan do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_telegrambot';
  Open;
  First;
  end;
  Caption:='';
  SChatInfo.Panels[0].Width:=FBotEngine.Width div 2;
  SChatInfo.Panels[1].Width:=FBotEngine.Width div 2;
  MemoLog.Lines.Clear;
  ENamaBot.Text:='';
  EToken.Text:='';
  CBOutbox.Text:='-Pilih-';
  CBInbox.Text:='-Pilih-';
  ZQPengaturan.First;
  SChatInfo.Panels[0].Text := ' Inbox ['+ZQPengaturan.FieldByName('inboxcount').AsString+']';
  SChatInfo.Panels[1].Text := ' Outbox ['+ZQPengaturan.FieldByName('outboxcount').AsString+']';
  Caption:=ZQPengaturan.FieldByName('nama_bot').AsString;
  ENamaBot.Text:=ZQPengaturan.FieldByName('nama_bot').AsString;
  EToken.Text:=ZQPengaturan.FieldByName('token').AsString;
  if (ZQPengaturan.FieldByName('tooltip').AsString='Yes') then
  CkNotif.Checked:=True else CkNotif.Checked:=False;
  CBOutbox.Text:=ZQPengaturan.FieldByName('outboxnotif').AsString;
  CBInbox.Text:=ZQPengaturan.FieldByName('inboxnotif').AsString;
  with ZQPengaturan do
  begin
  offset   := FieldByName('offset').AsInteger;
  token    := FieldByName('token').AsString;
  inbox    := FieldByName('inboxnotif').AsString;
  outbox   := FieldByName('outboxnotif').AsString;
  tooltip  := FieldByName('tooltip').AsString;
  end;
  http := TFPHTTPClient.Create(nil);
  AmbilPesan := TAmbilPesan.Create(True);
  AmbilPesan.Start;
end;


end.

