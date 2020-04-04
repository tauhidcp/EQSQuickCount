unit utambahsaksi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ucekserial;

type

  { TFTambahSaksi }

  TFTambahSaksi = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBProv: TComboBox;
    CBKabKota: TComboBox;
    CBKec: TComboBox;
    CBKelDesa: TComboBox;
    CBTPS: TComboBox;
    ENoHP: TEdit;
    EIDTelegram: TEdit;
    EID: TEdit;
    ENama: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBKabKotaChange(Sender: TObject);
    procedure CBKecChange(Sender: TObject);
    procedure CBKelDesaChange(Sender: TObject);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure CBKecKeyPress(Sender: TObject; var Key: char);
    procedure CBKelDesaKeyPress(Sender: TObject; var Key: char);
    procedure CBTPSKeyPress(Sender: TObject; var Key: char);
    procedure EIDKeyPress(Sender: TObject; var Key: char);
    procedure ENoHPKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }

  function noOtomatis(tambah:integer):string;
  procedure hapus;
  procedure setCB;
  function getIdProv(nama:string):string;
  function getIdKota(nama:string):string;
  function getIdKec(nama:string):string;
  function getIdKelurahan(nama:string):string;
  function getIdTPS(no:string;kel:string):string;
  procedure setCBKabSesuai(nama:string);
  procedure setCBKecSesuai(nama:string);
  procedure setCBKelSesuai(nama:string);
  procedure setCBSesuai(nama:string);
  procedure simpan;
  end;

var
  FTambahSaksi: TFTambahSaksi;

  const
    query = 'SELECT t_saksi.id_saksi, t_saksi.nama_saksi, t_kelurahan.nama_kelurahan, t_tps.no_tps, t_saksi.nohp, t_saksi.id_telegram FROM ((t_saksi INNER JOIN t_kelurahan ON t_saksi.desa_kelurahan=t_kelurahan.id_kelurahan) INNER JOIN t_tps ON t_tps.id_tps=t_saksi.tps) order by t_saksi.id_saksi asc';

implementation

uses udatamodule;

{$R *.lfm}

{ TFTambahSaksi }

procedure TFTambahSaksi.CBProvKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahSaksi.CBProvChange(Sender: TObject);
begin
  setCBKabSesuai(CBProv.Text);
end;

procedure TFTambahSaksi.BBaruClick(Sender: TObject);
begin
  hapus;
end;

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

procedure TFTambahSaksi.BSimpanClick(Sender: TObject);
begin
  if (EID.Text='') or (EIDTelegram.Text='') or (ENama.Text='') or (ENoHP.Text='') or (CBKelDesa.Text='-Pilih-') or (CBKelDesa.Text='')
  or (CBKec.Text='-Pilih-') or (CBKec.Text='') or (CBKabKota.Text='-Pilih-') or (CBKabKota.Text='')
  or (CBProv.Text='-Pilih-') or (CBProv.Text='')
  or (CBTPS.Text='-Pilih-') or (CBTPS.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_saksi',10)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQSaksi do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_saksi set nama_saksi="'+ENama.Text+'",desa_kelurahan="'+getIdKelurahan(CBKelDesa.Text)+'",tps="'+getIdTPS(CBTPS.Text,CBKelDesa.Text)+'",nohp="'+ReplaceNol(ENoHP.Text)+'",id_telegram="'+EIDTelegram.Text+'" where id_saksi="'+EID.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data Saksi Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFTambahSaksi.CBKabKotaChange(Sender: TObject);
begin
  setCBKecSesuai(CBKabKota.Text);
end;

procedure TFTambahSaksi.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFTambahSaksi.CBKelDesaChange(Sender: TObject);
begin
  setCBSesuai(CBKelDesa.Text);
end;

procedure TFTambahSaksi.CBKabKotaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahSaksi.CBKecKeyPress(Sender: TObject; var Key: char);
begin
    key:=#0;
end;

procedure TFTambahSaksi.CBKelDesaKeyPress(Sender: TObject; var Key: char);
begin
    key:=#0;
end;

procedure TFTambahSaksi.CBTPSKeyPress(Sender: TObject; var Key: char);
begin
    key:=#0;
end;

procedure TFTambahSaksi.EIDKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahSaksi.ENoHPKeyPress(Sender: TObject; var Key: char);
begin
if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

function TFTambahSaksi.noOtomatis(tambah: integer): string;
begin
      Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_saksi';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahSaksi.hapus;
begin
EID.Text:=noOtomatis(1);
ENama.Text:='';
ENoHP.Text:='';
EIDTelegram.Text:='';
CBProv.Text:='-Pilih-';
CBKabKota.Text:='-Pilih-';
CBKelDesa.Text:='-Pilih-';
CBKec.Text:='-Pilih-';
CBTPS.Text:='-Pilih-';
BSimpan.Enabled:=True;
end;

procedure TFTambahSaksi.setCB;
var
  i,j : integer;
begin
  CBProv.Items.Clear;
  DM.ZQProv.First;
  for i:= 1 to DM.ZQProv.RecordCount do
  begin
  CBProv.Items.Add(DM.ZQProv.FieldByName('nama_provinsi').AsString);
  DM.ZQProv.Next;
  end;
  CBKabKota.Items.Clear;
  DM.ZQKabKota.First;
  for i:= 1 to DM.ZQKabKota.RecordCount do
  begin
  CBKabKota.Items.Add(DM.ZQKabKota.FieldByName('nama_kota').AsString);
  DM.ZQKabKota.Next;
  end;
  CBKec.Items.Clear;
  DM.ZQKec.First;
  for i:= 1 to DM.ZQKec.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQKec.FieldByName('nama_kecamatan').AsString);
  DM.ZQKec.Next;
  end;
  CBKelDesa.Items.Clear;
  DM.ZQKelDesa.First;
  for i:= 1 to DM.ZQKelDesa.RecordCount do
  begin
  CBKelDesa.Items.Add(DM.ZQKelDesa.FieldByName('nama_kelurahan').AsString);
  DM.ZQKelDesa.Next;
  end;
  CBTPS.Items.Clear;
  DM.ZQTPS.First;
  for j := 1 to DM.ZQTPS.RecordCount do
  begin
  CBTPS.Items.Add(DM.ZQTPS.FieldByName('no_tps').AsString);
  DM.ZQTPS.Next;
  end;
end;

function TFTambahSaksi.getIdProv(nama: string): string;
begin
  Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_provinsi as id from t_provinsi where nama_provinsi="'+nama+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFTambahSaksi.getIdKota(nama: string): string;
begin
Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_kota as id from t_kabkota where nama_kota="'+nama+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFTambahSaksi.getIdKec(nama: string): string;
begin
 Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_kecamatan as id from t_kecamatan where nama_kecamatan="'+nama+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFTambahSaksi.getIdKelurahan(nama: string): string;
begin
Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_kelurahan as id from t_kelurahan where nama_kelurahan="'+nama+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFTambahSaksi.getIdTPS(no: string;kel:string): string;
begin
Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_tps as id from t_tps where no_tps="'+no+'" and id_kelurahan="'+getIdKelurahan(kel)+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFTambahSaksi.setCBKabSesuai(nama: string);
var
  i : integer;
begin
  CBKabKota.Items.Clear;
  CBKabKota.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kota from t_kabkota where id_provinsi="'+getIdProv(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKabKota.Items.Add(DM.ZQCari.FieldByName('nama_kota').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFTambahSaksi.setCBKecSesuai(nama: string);
var
  i : integer;
begin
  CBKec.Items.Clear;
  CBKec.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kecamatan from t_kecamatan where id_kota="'+getIdKota(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQCari.FieldByName('nama_kecamatan').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFTambahSaksi.setCBKelSesuai(nama: string);
var
  i : integer;
begin
  CBKelDesa.Items.Clear;
  CBKelDesa.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kelurahan from t_kelurahan where id_kecamatan="'+getIdKec(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKelDesa.Items.Add(DM.ZQCari.FieldByName('nama_kelurahan').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFTambahSaksi.setCBSesuai(nama: string);
var
  i : integer;
begin
  CBTPS.Items.Clear;
  CBTPS.Text:='-Pilih-';
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_tps from t_tps where id_kelurahan="'+getIdKelurahan(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBTPS.Items.Add(DM.ZQCari.FieldByName('no_tps').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFTambahSaksi.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_saksi where desa_kelurahan="'+getIdKelurahan(CBKelDesa.Text)+'" and tps="'+getIdTPS(CBTPS.Text,CBKelDesa.Text)+'" or nohp="'+ReplaceNol(ENoHP.Text)+'" or id_saksi="'+EID.Text+'" or id_telegram="'+EIDTelegram.Text+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data Saksi, Nomor Handphone atau ID Telegram Sudah digunakan!',mtWarning,[mbok],0) else
begin
  with DM.ZQSaksi do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_saksi (id_saksi,nama_saksi,desa_kelurahan,tps,nohp,id_telegram) values ("'+EID.Text+'","'+ENama.Text+'","'+getIdKelurahan(CBKelDesa.Text)+'","'+getIdTPS(CBTPS.Text,CBKelDesa.Text)+'","'+ReplaceNol(ENoHP.Text)+'","'+EIDTelegram.Text+'")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
//  BSimpan.Enabled:=False;
  MessageDlg('Data Saksi Berhasil Disimpan!',mtInformation,[mbok],0);
end;
end;

end.

