unit usms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, udatamodule, ucekserial;

type

  { TFSMS }

  TFSMS = class(TForm)
    BKirim: TBitBtn;
    CbGroup: TComboBox;
    CbKirim: TComboBox;
    CbModem: TComboBox;
    ENomor: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LLimitChar: TLabel;
    MPesan: TMemo;
    Panel1: TPanel;
    PAtas: TPanel;
    PBawah: TPanel;
    procedure BKirimClick(Sender: TObject);
    procedure CbGroupKeyPress(Sender: TObject; var Key: char);
    procedure CbKirimChange(Sender: TObject);
    procedure CbKirimKeyPress(Sender: TObject; var Key: char);
    procedure CbModemKeyPress(Sender: TObject; var Key: char);
    procedure ENomorKeyPress(Sender: TObject; var Key: char);
    procedure MPesanKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  procedure setCB;
  function getIdModem(nama:string):string;
  function getKelurahan(id:string):string;
  function getTPS(id:string):string;
  procedure simpan;
  end;

var
  FSMS: TFSMS;

implementation

{$R *.lfm}

{ TFSMS }

function ReplaceNol(n:string): string;
var
i : integer;
hasil : string;
begin
Result:='';
if (Length(Trim(n))>=10) and (Trim(n)[1]='0') then
   begin
    hasil := '+62';
    for i := 2 to Length(n) do hasil := hasil + n[i];
    Result:=hasil;
   end else
   if (copy(Trim(n),1,3)='+62') and (Length(Trim(n))>=10)
   then Result:=n;
end;

procedure TFSMS.BKirimClick(Sender: TObject);
begin
    if (CbKirim.Text='') or (MPesan.Text='') or (CBModem.Text='-Pilih-') then
    MessageDlg('Jangan Kosongkan Form!',mtWarning,[mbok],0) else
      begin

       if (cekSerial()=True) then
       simpan else
       begin
       if (cekData('t_outboxsms',15)=True) then
           MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
           simpan;
       end;

      end;
end;

procedure TFSMS.CbGroupKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFSMS.CbKirimChange(Sender: TObject);
begin
  if CbKirim.Text='Single' then
  begin
  CbGroup.Visible:=False;
  ENomor.Visible:=True;
  end else
  if CbKirim.Text='Broadcast' then
  begin
  ENomor.Visible:=False;
  CbGroup.Visible:=True;
  end;
end;

procedure TFSMS.CbKirimKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFSMS.CbModemKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFSMS.ENomorKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFSMS.MPesanKeyPress(Sender: TObject; var Key: char);
begin
  with Sender as TMemo do
  begin
  if (Key=#22) or (Key=#3) then Key:=#0 else begin
  if (MPesan.Text<>'') then LLimitChar.Caption:='0 karakter';
   LLimitChar.Caption:=IntToStr(Length(MPesan.Text)+1)+' karakter';
   if (Length(MPesan.Text)+1) = 160 then
       if not (key in[#8]) then Key := #0;
  end;
  end;
end;

procedure TFSMS.hapus;
begin
  CbKirim.Text:='-Pilih-';
  CbGroup.Text:='-Pilih-';
  ENomor.Text:='';
  CbModem.Text:='-Pilih-';
  MPesan.Lines.Clear;
  LLimitChar.Caption:='0 karakter';
  ENomor.Visible:=False;
  CbGroup.Visible:=False;
end;

procedure TFSMS.setCB;
var
  i : integer;
begin
  CBModem.Items.Clear;
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_modem from t_modem where status="On"';
  Open;
  end;
  DM.ZQCari2.First;
  for i := 1 to DM.ZQCari2.RecordCount do begin
  CBModem.Items.Add(DM.ZQCari2.FieldByName('nama_modem').AsString);
  DM.ZQCari2.Next;
  end;
end;

function TFSMS.getIdModem(nama: string): string;
begin
    Result := '';
   with DM.ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id as id from t_modem where nama_modem="'+nama+'"';
   Open;
   end;
  Result:= DM.ZQCari.FieldByName('id').AsString;
end;

function TFSMS.getKelurahan(id: string): string;
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

function TFSMS.getTPS(id: string): string;
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

procedure TFSMS.simpan;
var
  i : integer;
  hasil,hasila,hasilx : string;
begin
    if (CbKirim.Text='Single') then
    begin
        if not (ENomor.Text='') then
        begin
         with DM.ZQKirimSMS do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+getIdModem(CBModem.Text)+'","'+ReplaceNol(ENomor.Text)+'","'+MPesan.Text+'","Pending")';
         ExecSQL;
         end;
         MessageDlg('Pesan Dalam Antrian Pengiriman!',mtInformation,[mbok],0);
        end;
    end else
    if (CbKirim.Text='Broadcast') then
    begin
        if not (CbGroup.Text='-Pilih-') then
        begin
         // Peta Suara
         if (CbGroup.Text='Peta Suara') then
         begin
         with DM.ZQCari3 do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='select * from t_petasuara';
         Open;
         First;
         end;
         for i := 1 to DM.ZQCari3.RecordCount do begin
         // String Replace
         hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQCari3.FieldByName('nama').AsString,[rfReplaceAll, rfIgnoreCase]);
         hasilx := StringReplace(hasil,'<ALAMAT>',getKelurahan(DM.ZQCari3.FieldByName('alamat').AsString),[rfReplaceAll, rfIgnoreCase]);
         with DM.ZQKirimSMS do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+getIdModem(CBModem.Text)+'","'+DM.ZQCari3.FieldByName('nohp').AsString+'","'+hasilx+'","Pending")';
         ExecSQL;
         end;
         DM.ZQCari3.Next;
         end;
         end;
         // Saksi
         if (CbGroup.Text='Saksi') then
         begin
         DM.ZQSaksi.First;
         for i := 1 to DM.ZQSaksi.RecordCount do begin
         if not (Trim(DM.ZQSaksi.FieldByName('nohp').AsString)='') then
         begin
         // String Replace
         hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQSaksi.FieldByName('nama_saksi').AsString,[rfReplaceAll, rfIgnoreCase]);
         hasila := StringReplace(hasil,'<TPS>',DM.ZQSaksi.FieldByName('no_tps').AsString,[rfReplaceAll, rfIgnoreCase]);
         hasilx := StringReplace(hasila,'<ALAMAT>',DM.ZQSaksi.FieldByName('nama_kelurahan').AsString,[rfReplaceAll, rfIgnoreCase]);
         with DM.ZQKirimSMS do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+getIdModem(CBModem.Text)+'","'+DM.ZQSaksi.FieldByName('nohp').AsString+'","'+hasilx+'","Pending")';
         ExecSQL;
         end;
         end;
         DM.ZQSaksi.Next;
         end;
         end;
         // TIMSES
         if (CbGroup.Text='Relawan (TIMSES)') then
         begin
         DM.ZQTimses.First;
         for i := 1 to DM.ZQTimses.RecordCount do begin
         if not (Trim(DM.ZQTimses.FieldByName('nohp').AsString)='') then
         begin
         // String Replace
         hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQTimses.FieldByName('nama_timses').AsString,[rfReplaceAll, rfIgnoreCase]);
         hasilx := StringReplace(hasil,'<ALAMAT>',DM.ZQTimses.FieldByName('nama_kelurahan').AsString,[rfReplaceAll, rfIgnoreCase]);
         with DM.ZQKirimSMS do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+getIdModem(CBModem.Text)+'","'+DM.ZQTimses.FieldByName('nohp').AsString+'","'+hasilx+'","Pending")';
         ExecSQL;
         end;
         end;
         DM.ZQTimses.Next;
         end;
         end;
         // Data Koor. TPS
         if (CbGroup.Text='Data Koor. TPS') then
         begin
         with DM.ZQCari3 do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='select * from t_usulantimses where nohp<>"-"';
         Open;
         First;
         end;
         for i := 1 to DM.ZQCari3.RecordCount do begin
         // String Replace
         hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQCari3.FieldByName('nama').AsString,[rfReplaceAll, rfIgnoreCase]);
         hasilx := StringReplace(hasil,'<ALAMAT>',getKelurahan(DM.ZQCari3.FieldByName('desa_kelurahan').AsString),[rfReplaceAll, rfIgnoreCase]);
         with DM.ZQKirimSMS do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+getIdModem(CBModem.Text)+'","'+DM.ZQCari3.FieldByName('nohp').AsString+'","'+hasilx+'","Pending")';
         ExecSQL;
         end;
         DM.ZQCari3.Next;
         end;
         end;
         // Data Dukungan Independen
         if (CbGroup.Text='Data Pendukung Independen') then
         begin
         with DM.ZQCari3 do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='select * from t_dukunganindie where nohp<>"-"';
         Open;
         First;
         end;
         for i := 1 to DM.ZQCari3.RecordCount do begin
         // String Replace
         hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQCari3.FieldByName('nama').AsString,[rfReplaceAll, rfIgnoreCase]);
         hasilx := StringReplace(hasil,'<ALAMAT>',getKelurahan(DM.ZQCari3.FieldByName('desa_kelurahan').AsString),[rfReplaceAll, rfIgnoreCase]);
         with DM.ZQKirimSMS do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+getIdModem(CBModem.Text)+'","'+DM.ZQCari3.FieldByName('nohp').AsString+'","'+hasilx+'","Pending")';
         ExecSQL;
         end;
         DM.ZQCari3.Next;
         end;
         end;
         // Data Polling
         if (CbGroup.Text='Data Polling') then
         begin
         with DM.ZQCari3 do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='select * from t_polling where nohp<>"-"';
         Open;
         First;
         end;
         for i := 1 to DM.ZQCari3.RecordCount do begin
         // String Replace
         hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQCari3.FieldByName('nama').AsString,[rfReplaceAll, rfIgnoreCase]);
         hasilx := StringReplace(hasil,'<ALAMAT>',getKelurahan(DM.ZQCari3.FieldByName('desa_kelurahan').AsString),[rfReplaceAll, rfIgnoreCase]);
         with DM.ZQKirimSMS do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+getIdModem(CBModem.Text)+'","'+DM.ZQCari3.FieldByName('nohp').AsString+'","'+hasilx+'","Pending")';
         ExecSQL;
         end;
         DM.ZQCari3.Next;
         end;
         end;
         // Data Usul Saran
         if (CbGroup.Text='Data Usul Saran') then
         begin
         with DM.ZQCari3 do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='select * from t_usulsaran where nohp<>"-"';
         Open;
         First;
         end;
         for i := 1 to DM.ZQCari3.RecordCount do begin
         // String Replace
         hasil  := StringReplace(MPesan.Text,'<NAMA>',DM.ZQCari3.FieldByName('nama').AsString,[rfReplaceAll, rfIgnoreCase]);
         hasilx := StringReplace(hasil,'<ALAMAT>',getKelurahan(DM.ZQCari3.FieldByName('desa_kelurahan').AsString),[rfReplaceAll, rfIgnoreCase]);
         with DM.ZQKirimSMS do
         begin
         Close;
         SQL.Clear;
         SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+getIdModem(CBModem.Text)+'","'+DM.ZQCari3.FieldByName('nohp').AsString+'","'+hasilx+'","Pending")';
         ExecSQL;
         end;
         DM.ZQCari3.Next;
         end;
         end;
         MessageDlg('Pesan Dalam Antrian Pengiriman!',mtInformation,[mbok],0);
        end;
    end;
end;

end.

