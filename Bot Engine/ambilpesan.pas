unit AmbilPesan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, EditBtn, Buttons, ExtCtrls, ZConnection, ZDataset, ShellApi,
  Windows, fphttpclient, ssl_openssl, fpjson, jsonparser, dateutils, WinInet,
  MMSystem, chash, encode_decode;

Type

    { TAmbilPesan }

    TAmbilPesan = class(TThread)
    private
    ZKoneksi: TZConnection;
    ZQPengaturan: TZQuery;
    ZQCari: TZQuery;
    ZQKirimChat: TZQuery;
    ZQTambahan: TZQuery;
    ZQStatus: TZQuery;
    protected
      procedure Execute; override;
      procedure Ambil_Pesan;
      procedure Kirim_Pesan;
    public
      function cekSerial():Boolean;
      function cekData(nama_tabel:string;jml_data:integer):Boolean;
      property Terminated;
      Constructor Create(CreateSuspended : boolean);
    end;

const
  telegram_url='https://api.telegram.org';

implementation

uses uutama;

{ TAmbilKirim }

procedure TAmbilPesan.Execute;
begin
  while not Terminated do
  begin
    Flags := 0;
    // Ambil dan Kirim Pesan
    if (WinInet.InternetGetConnectedState(@Flags, 0)) and not (token='') then
    begin
      if cekSerial()=False then
      begin
      if cekData('t_inboxchat',15)=False then
      begin
      // Aksi
      Ambil_Pesan;
      end else begin FBotEngine.MemoLog.Lines.Add('Software Belum Diregister Sehingga Pesan Yang Dapat Diproses Terbatas!'); end;
      end else begin
      // Aksi
      Ambil_Pesan;
      end;
      Sleep(100);
      // Kirim
      if cekSerial()=False then
      begin
      if cekData('t_outboxchat',15)=False then
      begin
      // Aksi
      Kirim_Pesan;
      end else begin FBotEngine.MemoLog.Lines.Add('Software Belum Diregister Sehingga Pesan Yang Dapat Diproses Terbatas!'); end;
      end else begin
      // Aksi
      Kirim_Pesan;
      end;
      Sleep(100);
    end;
  end;
end;

procedure TAmbilPesan.Ambil_Pesan;
var
s, pesan, idchat, idpengirim, username : string;
i           : integer;
JsonParser  : TJSONParser;
begin
  try

     s := http.Get(telegram_url+'/'+token+'/getUpdates?offset='+IntToStr(offset+1));

     JsonParser := TJSONParser.Create(s);
     JsonDoc    := TJSONObject(JsonParser.Parse);

     if  jsonDoc.findpath('ok').AsBoolean then
     begin

       if (jsonDoc.findpath('result').Count <> 0) then
       begin

         if not (inbox='Off') then
         sndPlaySound(pchar(Utf8ToAnsi(ExtractFilePath(Application.ExeName)+'ringtone\'+inbox+'.wav')), snd_Async or snd_NoDefault);

         if (jsonDoc.findpath('result').Items[0].FindPath('message').FindPath('chat').FindPath('username') <> nil) then
         username := jsonDoc.findpath('result').Items[0].FindPath('message').FindPath('chat').FindPath('username').AsString
         else
         begin
         if (jsonDoc.findpath('result').Items[0].FindPath('message').FindPath('chat').FindPath('first_name') <> nil) then
         username := jsonDoc.findpath('result').Items[0].FindPath('message').FindPath('chat').FindPath('first_name').AsString
         else
         username := 'Anonim';
         end;

         if not (tooltip='No') then
         begin
         FBotEngine.TrayIcon1.BalloonTitle:='Pesan Baru';
         FBotEngine.TrayIcon1.BalloonHint :='Pesan Telegram Dari ('+username+')';
         FBotEngine.TrayIcon1.ShowBalloonHint;
         end;

         for i := 0 to jsonDoc.findpath('result').Count-1 do
         begin

            if (jsonDoc.findpath('result').Items[i].FindPath('message').FindPath('text') <> nil) then
            pesan := jsonDoc.findpath('result').Items[i].FindPath('message').FindPath('text').AsString
            else pesan := 'Bukan Pesan Teks';

            idchat     := jsonDoc.findpath('result').Items[i].FindPath('message').FindPath('chat').FindPath('id').AsString;

            if (jsonDoc.findpath('result').Items[i].FindPath('message').FindPath('chat').FindPath('username') <> nil) then
            idpengirim := jsonDoc.findpath('result').Items[i].FindPath('message').FindPath('chat').FindPath('username').AsString
            else
            begin
            if (jsonDoc.findpath('result').Items[i].FindPath('message').FindPath('chat').FindPath('first_name') <> nil) then
            idpengirim := jsonDoc.findpath('result').Items[i].FindPath('message').FindPath('chat').FindPath('first_name').AsString
            else
            idpengirim := 'Anonim';
            end;

            FBotEngine.MemoLog.Lines.add('['+FormatDateTime('dd-mm-yyyy',Now)+'|'+FormatDateTime('h:m:s',Now)+'] Pesan Ke ['+IntToStr(ZQPengaturan.FieldByName('inboxcount').AsInteger+1)+'] Diterima');

            // Update Saksi dan TIMSES
            with ZQCari do
            begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_saksi set chat_id="'+idchat+'" where id_telegram="'+idpengirim+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:='update t_timses set chat_id="'+idchat+'" where id_telegram="'+idpengirim+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:='update t_usulantimses set idchat="'+idchat+'" where idtelegram="'+idpengirim+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:='update t_dukunganindie set idchat="'+idchat+'" where idtelegram="'+idpengirim+'"';
            ExecSQL;

            // Update Offset
            offset := jsonDoc.findpath('result').Items[jsonDoc.findpath('result').Count-1].FindPath('update_id').AsInt64;
            SQL.Clear;
            SQL.Text:='insert into t_inboxchat (tanggal,jam,id_chat,id_pengirim,isi_pesan,processed) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+idchat+'","'+idpengirim+'","'+pesan+'","False")';
            ExecSQL;
            SQL.Clear;
            SQL.Text:='update t_telegrambot set inboxcount=inboxcount+1 where id="1"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:='update t_telegrambot set offset="'+IntToStr(offset)+'" where id="1"';
            ExecSQL;
            end;
            with ZQPengaturan do
            begin
            Close;
            SQL.Clear;
            SQL.Text:='select * from t_telegrambot';
            Open;
            First;
            end;
       end;

       end;
     end;

  except
    exit;
  end;
end;

procedure TAmbilPesan.Kirim_Pesan;
var
sx, idx, chat, pesan : string;
JsonParserx  : TJSONParser;
begin
  with ZQKirimChat do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_outboxchat where status="Pending" order by id asc limit 1';
  Open;
  First;
  end;
  if (ZQKirimChat.RecordCount>0) then
 begin
 idx    := ZQKirimChat.FieldByName('id').AsString;
 chat   := ZQKirimChat.FieldByName('id_chat').AsString;
 pesan  := stringreplace(ZQKirimChat.FieldByName('isipesan').AsString,#13#10,'%0A',[rfReplaceAll, rfIgnoreCase]);
   try
     sx := http.Get(telegram_url+'/'+token+'/sendMessage?chat_id='+chat+'&text='+pesan);
     JsonParserx := TJSONParser.Create(sx);
     jsonDoc    := TJSONObject(JsonParserx.Parse);
     if  jsonDoc.findpath('ok').AsBoolean then
     begin

       if not (outbox='Off') then sndPlaySound(pchar(Utf8ToAnsi(ExtractFilePath(Application.ExeName)+'ringtone\'+outbox+'.wav')), snd_Async or snd_NoDefault);
       FBotEngine.MemoLog.Lines.add('['+FormatDateTime('dd-mm-yyyy',Now)+'|'+FormatDateTime('h:m:s',Now)+'] Pesan Ke ['+IntToStr(ZQPengaturan.FieldByName('outboxcount').AsInteger+1)+'] Terkirim');

       with ZQCari do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='update t_outboxchat set status="Terkirim" where id="'+idx+'"';
       ExecSQL;
       SQL.Clear;
       SQL.Text:='update t_telegrambot set outboxcount=outboxcount+1 where id="1"';
       ExecSQL;
       end;
       with ZQPengaturan do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='select * from t_telegrambot';
       Open;
       First;
       end;
   end;
   except
     exit;
   end;

  end;
end;

function TAmbilPesan.cekSerial: Boolean;
var
  ikey,akey : string;
begin
  Result:=False;
  with ZQStatus do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_instalationkey';
  Open;
  First;
  end;
  with ZQTambahan do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_activationkey';
  Open;
  First;
  end;
  ikey := GSMEncode7Bit(SHA1DigestToHex(CalcSHA1(MD5DigestToHex(CalcMD5(GSMDecode7Bit(ZQStatus.FieldByName('kunci1').AsString)+'-'+GSMDecode7Bit(ZQStatus.FieldByName('kunci2').AsString)+'-'+GSMDecode7Bit(ZQStatus.FieldByName('kunci3').AsString)+'-'+GSMDecode7Bit(ZQStatus.FieldByName('kunci4').AsString))))));
  akey :=  ZQTambahan.FieldByName('kunci').AsString;
  if (ikey=akey) then Result:=True else Result:=False;
end;

function TAmbilPesan.cekData(nama_tabel: string; jml_data: integer): Boolean;
begin
  Result := False;
  with ZQStatus do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from '+nama_tabel;
  Open;
  end;
  if ZQStatus.RecordCount>=jml_data then Result:=True else Result:=False;
end;

constructor TAmbilPesan.Create(CreateSuspended : boolean);
begin
  ZKoneksi := TZConnection.Create(nil);
  ZQPengaturan := TZQuery.Create(nil);
  ZQCari := TZQuery.Create(nil);
  ZQKirimChat := TZQuery.Create(nil);
  ZQTambahan := TZQuery.Create(nil);
  ZQStatus := TZQuery.Create(nil);
  with ZKoneksi do
  begin
   HostName := 'localhost';
   Port := 3310;
   Database := 'eqsquickcount';
   User := 'root';
   Password := 'eqs!123Ab';
   Protocol := 'mysql-5';
   LibraryLocation := 'C:\EQSQuickCount\libmysql.dll';
   Connected := True;
  end;
  ZQPengaturan.Connection:=ZKoneksi;
  ZQCari.Connection:=ZKoneksi;
  ZQKirimChat.Connection:=ZKoneksi;
  ZQTambahan.Connection:=ZKoneksi;
  ZQStatus.Connection:=ZKoneksi;
  with ZQPengaturan do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_telegrambot';
  Open;
  First;
  end;
  FreeOnTerminate := False;
  inherited Create(CreateSuspended);
end;

end.

