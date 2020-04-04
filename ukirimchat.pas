unit ukirimchat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, udatamodule, ucekserial;

type

  { TFKirimChat }

  TFKirimChat = class(TForm)
    BKirim: TBitBtn;
    CbTujuan: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    MPesan: TMemo;
    Panel1: TPanel;
    PAtas: TPanel;
    PBawah: TPanel;
    procedure BKirimClick(Sender: TObject);
    procedure CbTujuanKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  function getChatId(status:string; idx:string):string;
  function getKelurahan(id:string):string;
  function getTPS(id:string):string;
  procedure simpan;
  end;

var
  FKirimChat: TFKirimChat;

implementation

{$R *.lfm}

{ TFKirimChat }

procedure TFKirimChat.CbTujuanKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFKirimChat.BKirimClick(Sender: TObject);
begin
   if (CbTujuan.Text='-Pilih-') or (MPesan.Text='') then
   MessageDlg('Jangan Kosongkan Form!',mtWarning,[mbok],0) else
     begin

     if (cekSerial()=True) then
     simpan else
     begin
     if (cekData('t_outboxchat',15)=True) then
         MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
         simpan;
     end;

     end;
end;

procedure TFKirimChat.hapus;
begin
  CbTujuan.Text:='-Pilih-';
  MPesan.Lines.Clear;
end;

function TFKirimChat.getChatId(status: string; idx: string): string;
begin
Result := '';
if (status='Saksi') then
 begin
 with DM.ZQCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select chat_id as id from t_saksi where id_telegram="'+idx+'" and chat_id<>0';
 Open;
 end;
 end else
if (status='Timses') then
 begin
 with DM.ZQCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select chat_id as id from t_timses where id_telegram="'+idx+'" and chat_id<>0';
 Open;
 end;
 end;
if (status='Dukung') then
 begin
 with DM.ZQCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select idchat as id from t_dukunganindie where idtelegram="'+idx+'" and idchat<>"-"';
 Open;
 end;
 end;
if (status='Polling') then
 begin
 with DM.ZQCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select idchat as id from t_polling where idtelegram="'+idx+'" and idchat<>"-"';
 Open;
 end;
 end;
if (status='Usul') then
 begin
 with DM.ZQCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select idchat as id from t_usulsaran where idtelegram="'+idx+'" and idchat<>"-"';
 Open;
 end;
 end;
if (status='DataKoorTPS') then
 begin
 with DM.ZQCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select idchat as id from t_usulantimses where idtelegram="'+idx+'" and idchat<>"-"';
 Open;
 end;
 end;
if DM.ZQCari.RecordCount>0 then
Result:= DM.ZQCari.FieldByName('id').AsString else Result:='-';
end;

function TFKirimChat.getKelurahan(id: string): string;
begin
Result := '';
with DM.ZQCari do
begin
Close;
SQL.Clear;
SQL.Text:='select nama_kelurahan as id from t_kelurahan where id_kelurahan="'+id+'"';
Open;
end;
Result:= DM.ZQCari.FieldByName('id').AsString;
end;

function TFKirimChat.getTPS(id: string): string;
begin
Result := '';
with DM.ZQCari do
begin
Close;
SQL.Clear;
SQL.Text:='select no_tps as id from t_tps where id_tps="'+id+'"';
Open;
end;
Result:= DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFKirimChat.simpan;
var
  i : integer;
  hasil,hasila,hasilx : string;
begin
  if (CbTujuan.Text='Saksi') then
       begin
       DM.ZQSaksi.First;
       for i := 1 to DM.ZQSaksi.RecordCount do
       begin
       if not (getChatId('Saksi',DM.ZQSaksi.FieldByName('id_telegram').AsString)='-') then
       begin
       // String Replace
       hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQSaksi.FieldByName('nama_saksi').AsString,[rfReplaceAll, rfIgnoreCase]);
       hasila := StringReplace(hasil,'<TPS>',DM.ZQSaksi.FieldByName('no_tps').AsString,[rfReplaceAll, rfIgnoreCase]);
       hasilx := StringReplace(hasila,'<ALAMAT>',DM.ZQSaksi.FieldByName('nama_kelurahan').AsString,[rfReplaceAll, rfIgnoreCase]);
       with DM.ZQKirimChat do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='insert into t_outboxchat (tanggal,jam,isipesan,id_chat,id_tujuan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+hasilx+'","'+getChatId('Saksi',DM.ZQSaksi.FieldByName('id_telegram').AsString)+'","'+DM.ZQSaksi.FieldByName('id_telegram').AsString+'","Pending")';
       ExecSQL;
       end;
       end;
       DM.ZQSaksi.Next;
       end;
       end;

       if (CbTujuan.Text='Relawan (TIMSES)') then
       begin
       DM.ZQTimses.First;
       for i := 1 to DM.ZQTimses.RecordCount do
       begin
       if not (getChatId('Timses',DM.ZQTimses.FieldByName('id_telegram').AsString)='-') then
       begin
       // String Replace
       hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQTimses.FieldByName('nama_timses').AsString,[rfReplaceAll, rfIgnoreCase]);
       hasilx := StringReplace(hasil,'<ALAMAT>',DM.ZQTimses.FieldByName('nama_kelurahan').AsString,[rfReplaceAll, rfIgnoreCase]);
       with DM.ZQKirimChat do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='insert into t_outboxchat (tanggal,jam,isipesan,id_chat,id_tujuan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+hasilx+'","'+getChatId('Timses',DM.ZQTimses.FieldByName('id_telegram').AsString)+'","'+DM.ZQTimses.FieldByName('id_telegram').AsString+'","Pending")';
       ExecSQL;
       end;
       end;
       DM.ZQTimses.Next;
       end;
       end;

       // Data Koor. TPS
       if (CbTujuan.Text='Data Koor. TPS') then
       begin
       with DM.ZQCari3 do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='select * from t_usulantimses where idchat<>"-"';
       Open;
       First;
       end;
       for i := 1 to DM.ZQCari3.RecordCount do begin
       if not (getChatId('Simpatisan',DM.ZQCari3.FieldByName('idtelegram').AsString)='-') then
       begin
       // String Replace
       hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQCari3.FieldByName('nama').AsString,[rfReplaceAll, rfIgnoreCase]);
       hasilx := StringReplace(hasil,'<ALAMAT>',getKelurahan(DM.ZQCari3.FieldByName('desa_kelurahan').AsString),[rfReplaceAll, rfIgnoreCase]);
       with DM.ZQKirimChat do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='insert into t_outboxchat (tanggal,jam,isipesan,id_chat,id_tujuan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+hasilx+'","'+getChatId('DataKoorTPS',DM.ZQCari3.FieldByName('idtelegram').AsString)+'","'+DM.ZQCari3.FieldByName('idtelegram').AsString+'","Pending")';
       ExecSQL;
       end;
       DM.ZQCari3.Next;
       end;
       end;
       end;

       if (CbTujuan.Text='Data Pendukung Independen') then
       begin
       with DM.ZQCari3 do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='select * from t_dukunganindie where idchat<>"-"';
       Open;
       First;
       end;
       for i := 1 to DM.ZQCari3.RecordCount do
       begin
       if not (getChatId('Dukung',DM.ZQCari3.FieldByName('idtelegram').AsString)='-') then
       begin
       // String Replace
       hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQCari3.FieldByName('nama').AsString,[rfReplaceAll, rfIgnoreCase]);
       hasilx := StringReplace(hasil,'<ALAMAT>',getKelurahan(DM.ZQCari3.FieldByName('desa_kelurahan').AsString),[rfReplaceAll, rfIgnoreCase]);
       with DM.ZQKirimChat do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='insert into t_outboxchat (tanggal,jam,isipesan,id_chat,id_tujuan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+hasilx+'","'+getChatId('Dukung',DM.ZQCari3.FieldByName('idtelegram').AsString)+'","'+DM.ZQCari3.FieldByName('idtelegram').AsString+'","Pending")';
       ExecSQL;
       end;
       DM.ZQCari3.Next;
       end;
       end;
       end;

       if (CbTujuan.Text='Data Polling') then
       begin
       with DM.ZQCari3 do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='select * from t_polling where idchat<>"-"';
       Open;
       First;
       end;
       for i := 1 to DM.ZQCari3.RecordCount do
       begin
       if not (getChatId('Polling',DM.ZQCari3.FieldByName('idtelegram').AsString)='-') then
       begin
       // String Replace
       hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQCari3.FieldByName('nama').AsString,[rfReplaceAll, rfIgnoreCase]);
       hasilx := StringReplace(hasil,'<ALAMAT>',getKelurahan(DM.ZQCari3.FieldByName('desa_kelurahan').AsString),[rfReplaceAll, rfIgnoreCase]);
       with DM.ZQKirimChat do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='insert into t_outboxchat (tanggal,jam,isipesan,id_chat,id_tujuan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+hasilx+'","'+getChatId('Polling',DM.ZQCari3.FieldByName('idtelegram').AsString)+'","'+DM.ZQCari3.FieldByName('idtelegram').AsString+'","Pending")';
       ExecSQL;
       end;
       DM.ZQCari3.Next;
       end;
       end;
       end;

       if (CbTujuan.Text='Data Usul Saran') then
       begin
       with DM.ZQCari3 do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='select * from t_usulsaran where idchat<>"-"';
       Open;
       First;
       end;
       for i := 1 to DM.ZQCari3.RecordCount do
       begin
       if not (getChatId('Usul',DM.ZQCari3.FieldByName('idtelegram').AsString)='-') then
       begin
       // String Replace
       hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQCari3.FieldByName('nama').AsString,[rfReplaceAll, rfIgnoreCase]);
       hasilx := StringReplace(hasil,'<ALAMAT>',getKelurahan(DM.ZQCari3.FieldByName('desa_kelurahan').AsString),[rfReplaceAll, rfIgnoreCase]);
       with DM.ZQKirimChat do
       begin
       Close;
       SQL.Clear;
       SQL.Text:='insert into t_outboxchat (tanggal,jam,isipesan,id_chat,id_tujuan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+hasilx+'","'+getChatId('Polling',DM.ZQCari3.FieldByName('idtelegram').AsString)+'","'+DM.ZQCari3.FieldByName('idtelegram').AsString+'","Pending")';
       ExecSQL;
       end;
       DM.ZQCari3.Next;
       end;
       end;
       end;

       MessageDlg('Pesan Dalam Antrian Pengiriman!',mtInformation,[mbok],0);
end;

end.

