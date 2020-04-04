unit UUtama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, EditBtn, Buttons, ExtCtrls, ZConnection, ZDataset, CPort, ShellApi,
  Windows, MMSystem, ucekserial, encode_decode, strutils, dateutils;

type

  { TFModemEngine }

  TFModemEngine = class(TForm)
    BSimpan: TBitBtn;
    CkNotif: TCheckBox;
    CkPDU: TCheckBox;
    CBInbox: TComboBox;
    CBOutbox: TComboBox;
    ComPort1: TComPort;
    EBUSSD: TEditButton;
    EBaud: TEdit;
    EInterval: TEdit;
    ENamaModem: TEdit;
    EPort: TEdit;
    GroupBox: TGroupBox;
    GroupBox1: TGroupBox;
    GroupSetting: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LIDModem: TLabel;
    MATCommand: TMemo;
    MUSSD: TMemo;
    MemoLog: TMemo;
    PageControl: TPageControl;
    ProgressBar1: TProgressBar;
    SChatInfo: TStatusBar;
    ModemSetting: TTabSheet;
    CekPulsa: TTabSheet;
    TChatLog: TTabSheet;
    Koneksi: TZConnection;
    TimerSinyal: TTimer;
    TimerInbox: TTimer;
    TimerKirim: TTimer;
    TrayIcon1: TTrayIcon;
    ZQCari: TZQuery;
    ZQKirimSMS: TZQuery;
    ZQPengaturan: TZQuery;
    ZQStatus: TZQuery;
    ZQTambahan: TZQuery;
    ZQTerimaSMS: TZQuery;
    procedure BSimpanClick(Sender: TObject);
    procedure CBInboxKeyPress(Sender: TObject; var Key: char);
    procedure CBOutboxKeyPress(Sender: TObject; var Key: char);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure EBUSSDButtonClick(Sender: TObject);
    procedure EIntervalKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LIDModemClick(Sender: TObject);
    procedure MATCommandChange(Sender: TObject);
    procedure MemoLogKeyPress(Sender: TObject; var Key: char);
    procedure TimerInboxTimer(Sender: TObject);
    procedure TimerKirimTimer(Sender: TObject);
    procedure TimerSinyalTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure AmbilPesan;
  procedure KirimPesan;
  procedure Pengaturan;
  end;

var
  FModemEngine: TFModemEngine;
  nama,baud,port,inbox,outbox,tooltip,nomor,idx,pesan,indexpesan:string;
  incount, outcount : integer;
  Awal : Boolean;
  interval : integer;

implementation

{$R *.lfm}

//* Uses ShellAPI

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

  { TFModemEngine }

  procedure TFModemEngine.FormShow(Sender: TObject);
  begin
  FModemEngine.Left := (Screen.Width - FModemEngine.Width) - 15;
  FModemEngine.Top := (Screen.Height - FModemEngine.Height) - (TaskBarHeight+35);
  Pengaturan;
  end;

  procedure TFModemEngine.LIDModemClick(Sender: TObject);
  begin

  end;

  function IsNumber(N : String) : Boolean;
  var
  I : Integer;
  begin
  Result := True;
  if Trim(N) = '' then
   Exit(False);

  if (Length(Trim(N)) > 1) and (Trim(N)[1] = '0') then
  Exit(False);

  for I := 1 to Length(N) do
  begin
   if not (N[I] in ['0'..'9']) then
    begin
     Result := False;
     Break;
   end;
  end;
end;

procedure TFModemEngine.MATCommandChange(Sender: TObject);
var
  a,b,kar_awal,kar_akhir, cek :integer;
  s, after, idxl, statusx, pengirimx, tanggalx, waktux, pesanx, akhirx :string;
begin
// Cek Pulsa (Fix)
if (pos('+CUSD:',MATCommand.Text) <> 0) then
 begin
   if CkPDU.Checked=True then
   after := stringreplace(MATCommand.Text,'AT+CUSD=1,"'+GSMEncode7Bit(EBUSSD.Text)+'",15','',[rfReplaceAll, rfIgnoreCase]) else
   after := stringreplace(MATCommand.Text,'AT+CUSD=1,"'+EBUSSD.Text+'",15','',[rfReplaceAll, rfIgnoreCase]);
   a:=pos(',"',after);
   b:=pos('",',after);
   s:=copy(after,a+2,b-a-2);
   if CkPDU.Checked=True then
   MUSSD.Text:=GSMDecode7Bit(Trim(s)) else
   MUSSD.Text:=Trim(s);
  end;

 // Cek Apakah SMS Terkirim (Fix)
if (pos('+CMGS:',MATCommand.Text) <> 0) then
 begin
   after := stringreplace(MATCommand.Text,'AT+CMGS="'+nomor+'"','',[rfReplaceAll, rfIgnoreCase]);
   a:=pos('+CMGS:',after);
   b:=pos('OK',after);
   s:=copy(after,a+6,b-a-6);
   if (Trim(s)='') then s:=copy(after,a+5,b-a-5);
   if (Trim(s)='') then s:=copy(after,a+7,b-a-7);

   if (Trim(indexpesan) <> Trim(s)) and not (Trim(s)='') and not (Trim(s)=indexpesan) then
   begin
   // Pesan Terkirim
   if not (outbox='Off') then
   sndPlaySound(pchar(Utf8ToAnsi(ExtractFilePath(Application.ExeName)+'ringtone\'+outbox+'.wav')), snd_Async or snd_NoDefault);

   indexpesan:=Trim(s);
   outcount:=outcount+1;
   MemoLog.Lines.Add('['+FormatDateTime('dd-mm-yyyy',Now)+'|'+FormatDateTime('h:m:s',Now)+'] SMS Ke ['+IntToStr(outcount)+'] Terkirim');
   // Update data Outbox jadi terkirim
   with ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='update t_modem set outboxcount="'+IntToStr(outcount)+'" where id="'+LIDModem.Caption+'"';
   ExecSQL;
   SQL.Clear;
   SQL.Text:='update t_modem set indexpesan="'+indexpesan+'" where id="'+LIDModem.Caption+'"';
   ExecSQL;
   SQL.Clear;
   SQL.Text:='update t_outboxsms set status="Terkirim" where id="'+idx+'"';
   ExecSQL;
   end;
   end;
 end;

//Kekuatan Sinyal (Fix)
if (pos('+CSQ:',MATCommand.Text) <> 0) then
 begin
 a:=pos('+CSQ:',MATCommand.Text);
 b:=pos(',',MATCommand.Text);
 s:=copy(MATCommand.Text,a+6,b-a-6);
 if StrToIntDef(s,0) <= 30 then
 begin
   ProgressBar1.Position:=StrToIntDef(s,0);
 end else
   begin
   ProgressBar1.Position:=0;
   end;
 end;

// Pindahkan Kota Masuk ke Database
if (pos('+CMGL:',MATCommand.Text) <> 0) then
 begin

   after := stringreplace(MATCommand.Text,'AT+CMGL="ALL"','',[rfReplaceAll, rfIgnoreCase]);

   // ID
   kar_awal:=pos('+CMGL:',after);
   kar_akhir:=posex(',',after,kar_awal+1);
   idxl := copy(after,kar_awal+7,kar_akhir-kar_awal-7);

   // Status
   kar_awal:=posex('"',after,kar_akhir+1);
   kar_akhir:=posex('"',after,kar_awal+1);
   statusx:=copy(after,kar_awal+1,kar_akhir-kar_awal-1);

   // Pengirim
   kar_awal:=posex('"',after,kar_akhir+1);
   kar_akhir:=posex('"',after,kar_awal+1);
   pengirimx:=copy(after,kar_awal+1,kar_akhir-kar_awal-1);

   // Tanggal
   kar_awal:=posex('"',after,kar_akhir+1);
   kar_akhir:=posex(',',after,kar_awal+1);
   tanggalx:=copy(after,kar_awal+1,kar_akhir-kar_awal-1);

   // Waktu
   kar_awal:=kar_akhir;
   kar_akhir:=posex('"',after,kar_awal+1);
   waktux:=copy(after,kar_awal+1,kar_akhir-kar_awal-1);

   // Pesan Batasan CMGL
   kar_awal:=posex(#13#10,after,kar_akhir+1);
   kar_akhir:=posex('+CMGL:',after,kar_awal+1);
   pesanx := copy(after,kar_awal+1,kar_akhir-kar_awal-6);

   if (Trim(pesanx)='') then
   begin
   kar_awal:=posex(#13#10,after,kar_akhir+1);
   kar_akhir:=posex('+CMGL:',after,kar_awal+1);
   pesanx := copy(after,kar_awal+1,kar_akhir-kar_awal-6);
   end;

   // Pesan Batasan OK
   if (Trim(pesanx)='') then
   begin
   kar_awal:=posex(#13#10,after,kar_akhir+1);
   kar_akhir:=posex('OK',after,kar_awal+1);
   pesanx := copy(after,kar_awal+1,kar_akhir-kar_awal-2);
   end;

   if (Trim(pesanx)='') then
   begin
   kar_awal:=posex(#13#10,after,kar_akhir+1);
   kar_akhir:=posex('OK',after,kar_awal+1);
   pesanx := copy(after,kar_awal+1,kar_akhir-kar_awal-2);
   end;

   if not (Trim(idxl)='') and not (Trim(statusx)='') and not (Trim(pengirimx)='')
      and not (Trim(tanggalx)='') and not (Trim(waktux)='') and not (Trim(pesanx)='')
      and not (AnsiUpperCase((Trim(pesanx)[1]+Trim(pesanx)[2]+Trim(pesanx)[3]))='AT+')
      and not (AnsiUpperCase((Trim(pesanx)[1]+Trim(pesanx)[2]+Trim(pesanx)[3]))='+CM')
      and not (AnsiUpperCase((Trim(pesanx)[1]+Trim(pesanx)[2]+Trim(pesanx)[3]))='+CF')
      and not (AnsiUpperCase((Trim(pesanx)[1]+Trim(pesanx)[2]+Trim(pesanx)[3]))='+CN')
      and not (AnsiUpperCase((Trim(pesanx)[1]+Trim(pesanx)[2]+Trim(pesanx)[3]))='+CS')
      and not (AnsiUpperCase((Trim(pesanx)[1]+Trim(pesanx)[2]+Trim(pesanx)[3]))='+CU')
      and not (AnsiUpperCase((Trim(pesanx)[1]+Trim(pesanx)[2]+Trim(pesanx)[3]+Trim(pesanx)[4]+Trim(pesanx)[5]))='ERROR')
      then
       begin

           if not (inbox='Off') then
           sndPlaySound(pchar(Utf8ToAnsi(ExtractFilePath(Application.ExeName)+'ringtone\'+inbox+'.wav')), snd_Async or snd_NoDefault);

           if not (tooltip='No') then
           begin
           TrayIcon1.BalloonTitle:='SMS Masuk';
           TrayIcon1.BalloonHint :='SMS Masuk Dari ('+pengirimx+')';
           TrayIcon1.ShowBalloonHint;
           end;
           incount:=incount+1;
           MemoLog.Lines.Add('['+FormatDateTime('dd-mm-yyyy',Now)+'|'+FormatDateTime('h:m:s',Now)+'] SMS Ke ['+IntToStr(incount)+'] Diterima');
           with ZQTerimaSMS do
           begin
           Close;
           SQL.Clear;
           SQL.Text:='update t_modem set inboxcount="'+IntToStr(incount)+'" where id="'+LIDModem.Caption+'"';
           ExecSQL;
           end;

           try
           with ZQTerimaSMS do
           begin
           Close;
           SQL.Clear;
           SQL.Text:='insert into t_inboxsms (tanggal,jam,id_modem,no_pengirim,isi_pesan,processed) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+LIDModem.Caption+'","'+Trim(pengirimx)+'","'+Trim(pesanx)+'","False")';
           ExecSQL;
           end;
           ComPort1.WriteStr('AT+CMGD='+Trim(idxl)+#13#10);
           MATCommand.Lines.Clear;
           except
             ComPort1.WriteStr('AT+CMGD='+Trim(idxl)+#13#10);
             MATCommand.Lines.Clear;
             exit;
           end;
       end;
 end;

  //Memory Full (Fix)
  if (pos('^SMMEMFULL',MATCommand.Text) <> 0) then
   begin
   MemoLog.Lines.Add('Tidak Bisa Menerima SMS karena Memory SIM Full');
   ComPort1.WriteStr('AT+CMGL="ALL"'+#13#10); // Baca Inbox
   end;
end;

procedure TFModemEngine.CBInboxKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFModemEngine.BSimpanClick(Sender: TObject);
var
  tipx : string;
begin
  if (ENamaModem.Text='') or (EBaud.Text='') or (EInterval.Text='') or (EPort.Text='') or (CBInbox.Text='-Pilih-') or (CBOutbox.Text='-Pilih-') then
     exit else
     begin
       if CkNotif.Checked=True then tipx:='Yes' else tipx:='No';
       with ZQPengaturan do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='update t_modem set nama_modem="'+ENamaModem.Text+'",port="'+EPort.Text+'",baud="'+EBaud.Text+'",inboxnotif="'+CBInbox.Text+'",outboxnotif="'+CBOutbox.Text+'",tooltip="'+tipx+'",intervalx="'+EInterval.Text+'" where id="'+LIDModem.Caption+'"';
       ExecSQL;
       SQL.Clear;
       SQL.Text:='select * from t_modem where id="'+LIDModem.Caption+'"';
       Open;
       First;
       end;
       TimerKirim.Enabled:=False;
       interval:= StrToInt(EInterval.Text);
       EInterval.Text:=IntToStr(interval);
       TimerKirim.Interval:=interval;
       TimerKirim.Enabled:=True;
       Caption:=ENamaModem.Text;
       inbox:=CBInbox.Text;
       outbox:=CBOutbox.Text;
       tooltip:=tipx;
       baud:=EBaud.Text;
       port:=EPort.Text;
     end;
end;

procedure TFModemEngine.CBOutboxKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFModemEngine.ComPort1RxChar(Sender: TObject; Count: Integer);
var
str : String;
begin
 ComPort1.ReadStr(str, Count);
 MATCommand.Text := MATCommand.Text + str;
end;

procedure TFModemEngine.EBUSSDButtonClick(Sender: TObject);
begin
  if (ComPort1.Connected=True) then
  begin
    MemoLog.Lines.Clear;
  if (CkPDU.Checked=True) then
   ComPort1.WriteStr('AT+CUSD=1,"'+GSMEncode7Bit(EBUSSD.Text)+'",15'+#13#10) else
   ComPort1.WriteStr('AT+CUSD=1,"'+EBUSSD.Text+'",15'+#13#10);
  end;
end;

procedure TFModemEngine.EIntervalKeyPress(Sender: TObject; var Key: char);
begin
   if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFModemEngine.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  with ZQStatus do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='update t_modem set status="Off" where id="'+LIDModem.Caption+'"';
  ExecSQL;
  end;
  ComPort1.Close;
  Application.Terminate;
end;

procedure TFModemEngine.FormCreate(Sender: TObject);
begin
  with ZQPengaturan do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_modem where id="'+LIDModem.Caption+'"';
  Open;
  First;
  nama       := FieldByName('nama_modem').AsString;
  port       := FieldByName('port').AsString;
  baud       := FieldByName('baud').AsString;
  inbox      := FieldByName('inboxnotif').AsString;
  outbox     := FieldByName('outboxnotif').AsString;
  tooltip    := FieldByName('tooltip').AsString;
  indexpesan := FieldByName('indexpesan').AsString;
  interval   := FieldByName('intervalx').AsInteger;
  end;
  TimerKirim.Interval:=interval;
  Caption  := nama;
  Awal := False;
end;

procedure TFModemEngine.MemoLogKeyPress(Sender: TObject; var Key: char);
begin
  Key:=#0;
end;

procedure TFModemEngine.TimerInboxTimer(Sender: TObject);
begin
  if (ComPort1.Connected=True) then
  begin
  if cekSerial()=False then
  begin
  if cekData('t_inboxsms',15)=False then
  AmbilPesan else MemoLog.Lines.Add('Software Belum Diregister Sehingga SMS Yang Dapat Diproses Terbatas!');
  end else AmbilPesan;
  end;
end;

procedure TFModemEngine.TimerKirimTimer(Sender: TObject);
begin
  if (ComPort1.Connected=True) then
      begin
      if cekSerial()=False then
      begin
      if cekData('t_outboxsms',15)=False then
      KirimPesan else MemoLog.Lines.Add('Software Belum Diregister Sehingga SMS Yang Dapat Diproses Terbatas!');
      end else KirimPesan;
      end;
end;

procedure TFModemEngine.TimerSinyalTimer(Sender: TObject);
begin
    with ZQPengaturan do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_modem where id="'+LIDModem.Caption+'"';
    Open;
    end;
    SChatInfo.Panels[0].Text := ' Inbox ['+ZQPengaturan.FieldByName('inboxcount').AsString+']';
    SChatInfo.Panels[1].Text := ' Outbox ['+ZQPengaturan.FieldByName('outboxcount').AsString+']';
    incount                  := ZQPengaturan.FieldByName('inboxcount').AsInteger;
    outcount                 := ZQPengaturan.FieldByName('outboxcount').AsInteger;
  if (ComPort1.Connected=True) then
    begin
    if (Awal=False) then
    begin
    ComPort1.WriteStr('AT+CFUN=1'+#13#10); // Full Function Modem Wavecom
    ComPort1.WriteStr('ATE0'+#13#10); // Kembali ke Titik 0 :D
    ComPort1.WriteStr('AT+CSDH=1'+#13#10); // Untuk Modem Wavecom
    ComPort1.WriteStr('AT+CMGF=1'+#13#10); // Teks Mode
    ComPort1.WriteStr('AT+CSCS="GSM"'+#13#10); // Mode GSM
    ComPort1.WriteStr('AT+CNMI=2,1,0,0,0'+#13#10); // Nyalakan Indikator Penerimaan Pesan agar dapat diproses langsung
    ComPort1.WriteStr('AT^CURC=0'); // Matikan Signal RSSI
    ComPort1.WriteStr('AT+CMGD=1,4'+#13#10); // Kosongkan Inbox
    Awal := True;
    end;
    with ZQStatus do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='update t_modem set status="On" where id="'+LIDModem.Caption+'"';
    ExecSQL;
    end;
    end else
    begin
    try
      ComPort1.Port:=port;
      ComPort1.BaudRate:=StrToBaudRate(baud);
      ComPort1.Open;
    except
     Exit;
    end;
    with ZQStatus do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='update t_modem set status="Off" where id="'+LIDModem.Caption+'"';
    ExecSQL;
    end;
    end;
  // Cek Sinyal
  if (ComPort1.Connected=True) then
     begin
     MATCommand.Lines.Clear;
     ComPort1.WriteStr('AT+CSQ'+#13#10);
     end;
end;

procedure TFModemEngine.AmbilPesan;
begin
   MATCommand.Lines.Clear;
   ComPort1.WriteStr('AT+CMGL="ALL"'+#13#10);
end;

procedure TFModemEngine.KirimPesan;
var
cekno : string;
begin
  with ZQKirimSMS do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_outboxsms where status="Pending" and id_modem="'+LIDModem.Caption+'" order by id asc limit 1';
  Open;
  end;
  if (ZQKirimSMS.RecordCount>0) then
  begin
   idx   := ZQKirimSMS.FieldByName('id').AsString;
   nomor := ZQKirimSMS.FieldByName('no_tujuan').AsString;
   pesan := ZQKirimSMS.FieldByName('isi_pesan').AsString;
   cekno := nomor[1]+nomor[2]+nomor[3];
   if (cekno='+62') or (IsNumber(nomor)=True) then
   begin
   MATCommand.Lines.Clear;
   ComPort1.WriteStr('AT+CMGS="'+nomor+'"'+#13#10);
   ComPort1.WriteStr(pesan);
   ComPort1.WriteStr(#26+#13#10);
   end else
   begin
   // Update data Outbox jadi terkirim
   outcount:=outcount+1;
   with ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='update t_modem set outboxcount="'+IntToStr(outcount)+'" where id="'+LIDModem.Caption+'"';
   ExecSQL;
   SQL.Clear;
   SQL.Text:='update t_outboxsms set status="Terkirim" where id="'+idx+'"';
   ExecSQL;
   end;
   end;
  end;
end;

procedure TFModemEngine.Pengaturan;
begin
  Caption:='';
  SChatInfo.Panels[0].Width:=FModemEngine.Width div 2;
  SChatInfo.Panels[1].Width:=FModemEngine.Width div 2;
  MemoLog.Lines.Clear;
  ENamaModem.Text:='';
  EBaud.Text:='';
  EBUSSD.Text:='';
  EPort.Text:='';
  CBOutbox.Text:='-Pilih-';
  CBInbox.Text:='-Pilih-';
  ZQPengaturan.First;
  SChatInfo.Panels[0].Text := ' Inbox ['+ZQPengaturan.FieldByName('inboxcount').AsString+']';
  SChatInfo.Panels[1].Text := ' Outbox ['+ZQPengaturan.FieldByName('outboxcount').AsString+']';
  Caption:=ZQPengaturan.FieldByName('nama_modem').AsString;
  ENamaModem.Text:=ZQPengaturan.FieldByName('nama_modem').AsString;
  EBaud.Text:=ZQPengaturan.FieldByName('baud').AsString;
  EPort.Text:=ZQPengaturan.FieldByName('port').AsString;
  if (ZQPengaturan.FieldByName('tooltip').AsString='Yes') then
  CkNotif.Checked:=True else CkNotif.Checked:=False;
  CBOutbox.Text:=ZQPengaturan.FieldByName('outboxnotif').AsString;
  CBInbox.Text:=ZQPengaturan.FieldByName('inboxnotif').AsString;
  incount:=ZQPengaturan.FieldByName('inboxcount').AsInteger;
  outcount:=ZQPengaturan.FieldByName('outboxcount').AsInteger;
  TimerKirim.Enabled:=False;
  interval:= ZQPengaturan.FieldByName('intervalx').AsInteger;
  EInterval.Text:=IntToStr(interval);
  TimerKirim.Interval:=interval;
  TimerKirim.Enabled:=True;
end;

end.

