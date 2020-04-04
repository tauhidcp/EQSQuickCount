unit utambahusulantimses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ucekserial;

type

  { TFTambahUsulanTimses }

  TFTambahUsulanTimses = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBProv: TComboBox;
    CBKabKota: TComboBox;
    CBKec: TComboBox;
    CBKelDesa: TComboBox;
    EIDTelegram: TEdit;
    ENama: TEdit;
    ENoHP: TEdit;
    EID: TEdit;
    Label1: TLabel;
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
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure CBKecKeyPress(Sender: TObject; var Key: char);
    procedure CBKelDesaKeyPress(Sender: TObject; var Key: char);
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
  procedure setCBKabSesuai(nama:string);
  procedure setCBKecSesuai(nama:string);
  procedure setCBKelSesuai(nama:string);
  procedure simpan;
  end;

var
  FTambahUsulanTimses: TFTambahUsulanTimses;

const
  query = 'SELECT t_usulantimses.id_usulan, t_usulantimses.nama, t_kelurahan.nama_kelurahan, t_usulantimses.nohp, t_usulantimses.idchat, t_usulantimses.idtelegram FROM (t_usulantimses INNER JOIN t_kelurahan ON t_usulantimses.desa_kelurahan=t_kelurahan.id_kelurahan) order by t_usulantimses.id_usulan asc';

implementation

uses udatamodule;

{$R *.lfm}

{ TFTambahUsulanTimses }

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

procedure TFTambahUsulanTimses.CBProvKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFTambahUsulanTimses.CBKabKotaKeyPress(Sender: TObject; var Key: char
  );
begin
    key:=#0;
end;

procedure TFTambahUsulanTimses.CBKecKeyPress(Sender: TObject; var Key: char
  );
begin
    key:=#0;
end;

procedure TFTambahUsulanTimses.CBKelDesaKeyPress(Sender: TObject; var Key: char
  );
begin
    key:=#0;
end;

procedure TFTambahUsulanTimses.EIDKeyPress(Sender: TObject; var Key: char);
begin
if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahUsulanTimses.ENoHPKeyPress(Sender: TObject; var Key: char);
begin
        if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahUsulanTimses.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahUsulanTimses.BSimpanClick(Sender: TObject);
begin
if (EID.Text='') or (EIDTelegram.Text='') or (ENama.Text='') or (ENoHP.Text='') or (CBKelDesa.Text='-Pilih-') or (CBKelDesa.Text='')
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
        if (cekData('t_usulantimses',10)=True) then
            MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
            simpan;
        end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQUsulTimses do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_usulantimses set nama="'+ENama.Text+'",desa_kelurahan="'+getIdKelurahan(CBKelDesa.Text)+'",nohp="'+ReplaceNol(ENoHP.Text)+'",idtelegram="'+EIDTelegram.Text+'" where id_usulan="'+EID.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data Koordinator TPS Berhasil Diperbarui',mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFTambahUsulanTimses.CBKabKotaChange(Sender: TObject);
begin
  setCBKecSesuai(CBKabKota.Text);
end;

procedure TFTambahUsulanTimses.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFTambahUsulanTimses.CBProvChange(Sender: TObject);
begin
  setCBKabSesuai(CBProv.Text);
end;

function TFTambahUsulanTimses.noOtomatis(tambah: integer): string;
begin
  Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_usulantimses';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahUsulanTimses.hapus;
begin
EID.Text:=noOtomatis(1);
ENoHP.Text:='';
ENama.Text:='';
CBProv.Text:='-Pilih-';
CBKabKota.Text:='-Pilih-';
CBKelDesa.Text:='-Pilih-';
CBKec.Text:='-Pilih-';
EIDTelegram.Text:='';
BSimpan.Enabled:=True;
end;

procedure TFTambahUsulanTimses.setCB;
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

function TFTambahUsulanTimses.getIdProv(nama: string): string;
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

function TFTambahUsulanTimses.getIdKota(nama: string): string;
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

function TFTambahUsulanTimses.getIdKec(nama: string): string;
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

function TFTambahUsulanTimses.getIdKelurahan(nama: string): string;
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

procedure TFTambahUsulanTimses.setCBKabSesuai(nama: string);
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

procedure TFTambahUsulanTimses.setCBKecSesuai(nama: string);
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

procedure TFTambahUsulanTimses.setCBKelSesuai(nama: string);
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

procedure TFTambahUsulanTimses.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_usulantimses where id_usulan="'+EID.Text+'" or nohp="'+ENoHP.Text+'" or idtelegram="'+EIDTelegram.Text+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data Simpatisan dengan Id '+EID.Text+',Nomor HP '+ENoHP.Text+' atau ID Telegram '+EIDTelegram.Text+' Sudah Ada!',mtWarning,[mbok],0) else
begin
  with DM.ZQUsulTimses do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_usulantimses (id_usulan,nama,desa_kelurahan,nohp,idchat,idtelegram) values ("'+EID.Text+'","'+ENama.Text+'","'+getIdKelurahan(CBKelDesa.Text)+'","'+ReplaceNol(ENoHP.Text)+'","-","'+EIDTelegram.Text+'")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
 // BSimpan.Enabled:=False;
  MessageDlg('Data Koordinator TPS Berhasil Disimpan!',mtInformation,[mbok],0);
end;
end;

end.

