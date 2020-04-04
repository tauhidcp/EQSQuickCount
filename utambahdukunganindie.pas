unit utambahdukunganindie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ucekserial;

type

  { TFTambahDukunganIndependen }

  TFTambahDukunganIndependen = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBKabKota: TComboBox;
    CBKec: TComboBox;
    CBKelDesa: TComboBox;
    CBProv: TComboBox;
    ENoKTP: TEdit;
    EID: TEdit;
    EIDTelegram: TEdit;
    ENama: TEdit;
    ENoHP: TEdit;
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
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure CBKecChange(Sender: TObject);
    procedure CBKecKeyPress(Sender: TObject; var Key: char);
    procedure CBKelDesaKeyPress(Sender: TObject; var Key: char);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure EIDKeyPress(Sender: TObject; var Key: char);
    procedure ENoHPKeyPress(Sender: TObject; var Key: char);
    procedure ENoKTPKeyPress(Sender: TObject; var Key: char);
  private

  public

  function getIdKelurahan(nama:String):string;
  function noOtomatis(tambah:integer):string;
  procedure hapus;
  procedure setCB;
  function getIdProv(nama:string):string;
  function getIdKota(nama:string):string;
  function getIdKec(nama:string):string;
  procedure setCBKabSesuai(nama:string);
  procedure setCBKecSesuai(nama:string);
  procedure setCBKelSesuai(nama:string);
  procedure simpan;
  end;

var
  FTambahDukunganIndependen: TFTambahDukunganIndependen;

const
  query = 'SELECT t_dukunganindie.id_dukung, t_dukunganindie.noktp, t_dukunganindie.nama, t_kelurahan.nama_kelurahan, t_dukunganindie.nohp, t_dukunganindie.idtelegram, t_dukunganindie.idchat FROM (t_dukunganindie INNER JOIN t_kelurahan ON t_dukunganindie.desa_kelurahan=t_kelurahan.id_kelurahan) order by t_dukunganindie.id_dukung asc';
  queryc = 'SELECT t_dpt.id, t_dpt.ktp, t_dpt.nama, t_tps.no_tps, t_kelurahan.nama_kelurahan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM (((((t_dpt INNER JOIN t_tps ON t_tps.id_tps=t_dpt.tps) INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';

implementation

uses udatamodule;

{$R *.lfm}

{ TFTambahDukunganIndependen }

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

procedure TFTambahDukunganIndependen.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahDukunganIndependen.BSimpanClick(Sender: TObject);
begin
if (EID.Text='') or (ENoKTP.Text='') or (EIDTelegram.Text='') or (ENama.Text='') or (ENoHP.Text='') or (CBKelDesa.Text='-Pilih-') or (CBKelDesa.Text='')
  or (CBKec.Text='-Pilih-') or (CBKec.Text='') or (CBKabKota.Text='-Pilih-') or (CBKabKota.Text='')
  or (CBProv.Text='-Pilih-') or (CBProv.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
        simpan else
        begin
        if (cekData('t_dukunganindie',10)=True) then
            MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
            simpan;
        end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQDukIndie do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_dukunganindie set noktp="'+ENoKTP.Text+'",nama="'+ENama.Text+'",desa_kelurahan="'+getIdKelurahan(CBKelDesa.Text)+'",nohp="'+ReplaceNol(ENoHP.Text)+'",idtelegram="'+EIDTelegram.Text+'" where id_dukung="'+EID.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data Dukungan Independen Berhasil Diperbarui',mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFTambahDukunganIndependen.CBKabKotaChange(Sender: TObject);
begin
  setCBKecSesuai(CBKabKota.Text);
end;

procedure TFTambahDukunganIndependen.CBKabKotaKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDukunganIndependen.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFTambahDukunganIndependen.CBKecKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDukunganIndependen.CBKelDesaKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDukunganIndependen.CBProvChange(Sender: TObject);
begin
  setCBKabSesuai(CBProv.Text);
end;

procedure TFTambahDukunganIndependen.CBProvKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDukunganIndependen.EIDKeyPress(Sender: TObject; var Key: char
  );
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahDukunganIndependen.ENoHPKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahDukunganIndependen.ENoKTPKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end else
 begin
 if not (ENoKTP.Text='') or (key=#13) then
   begin
      with DM.ZQCari do
      begin
      Close;
      SQL.Clear;
      SQL.Text:=queryc+' where t_dpt.ktp like "%'+ENoKTP.Text+'%" or t_dpt.ktp="'+ENoKTP.Text+'"';
      Open;
      end;
      if DM.ZQCari.RecordCount>0 then
      begin
      DM.ZQCari.First;
      ENama.Text:=DM.ZQCari.FieldByName('nama').AsString;
      CBProv.Text:=DM.ZQCari.FieldByName('nama_provinsi').AsString;
      CBKabKota.Text:=DM.ZQCari.FieldByName('nama_kota').AsString;
      CBKec.Text:=DM.ZQCari.FieldByName('nama_kecamatan').AsString;
      CBKelDesa.Text:=DM.ZQCari.FieldByName('nama_kelurahan').AsString;
      end else
      begin
      ENama.Text:='';
      CBProv.Text:='-Pilih-';
      CBKabKota.Text:='-Pilih-';
      CBKec.Text:='-Pilih-';
      CBKelDesa.Text:='-Pilih-';
      end;
   end else
   begin
   ENama.Text:='';
   CBProv.Text:='-Pilih-';
   CBKabKota.Text:='-Pilih-';
   CBKec.Text:='-Pilih-';
   CBKelDesa.Text:='-Pilih-';
   end;
 end;
end;

function TFTambahDukunganIndependen.getIdKelurahan(nama: String): string;
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

function TFTambahDukunganIndependen.noOtomatis(tambah: integer): string;
begin
Result := '';
with DM.ZQCari do
begin
Close;
SQL.Clear;
SQL.Text:='select * from t_dukunganindie';
Open;
end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahDukunganIndependen.hapus;
begin
EID.Text:=noOtomatis(1);
ENoHP.Text:='';
ENama.Text:='';
ENoKTP.Text:='';
CBProv.Text:='-Pilih-';
CBKabKota.Text:='-Pilih-';
CBKelDesa.Text:='-Pilih-';
CBKec.Text:='-Pilih-';
EIDTelegram.Text:='';
BSimpan.Enabled:=True;
end;

procedure TFTambahDukunganIndependen.setCB;
var
  i : integer;
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
end;

function TFTambahDukunganIndependen.getIdProv(nama: string): string;
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

function TFTambahDukunganIndependen.getIdKota(nama: string): string;
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

function TFTambahDukunganIndependen.getIdKec(nama: string): string;
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

procedure TFTambahDukunganIndependen.setCBKabSesuai(nama: string);
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

procedure TFTambahDukunganIndependen.setCBKecSesuai(nama: string);
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

procedure TFTambahDukunganIndependen.setCBKelSesuai(nama: string);
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

procedure TFTambahDukunganIndependen.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dukunganindie where id_dukung="'+EID.Text+'" or noktp="'+ENoKTP.Text+'" or nohp="'+ENoHP.Text+'" or idtelegram="'+EIDTelegram.Text+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data Dukungan Independen dengan Id '+EID.Text+',Nomor HP '+ENoHP.Text+',ID Telegram '+EIDTelegram.Text+' atau Nomor KTP '+ENoKTP.Text+' Sudah Ada!',mtWarning,[mbok],0) else
begin
  with DM.ZQDukIndie do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_dukunganindie (id_dukung,noktp,nama,desa_kelurahan,nohp,idtelegram,idchat) values ("'+EID.Text+'","'+ENoKTP.Text+'","'+ENama.Text+'","'+getIdKelurahan(CBKelDesa.Text)+'","'+ReplaceNol(ENoHP.Text)+'","'+EIDTelegram.Text+'","-")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
 // BSimpan.Enabled:=False;
  MessageDlg('Data Dukungan Independen Berhasil Disimpan!',mtInformation,[mbok],0);
end;
end;

end.

