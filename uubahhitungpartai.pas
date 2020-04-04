unit uubahhitungpartai;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule;

type

  { TFUbahHitungPartai }

  TFUbahHitungPartai = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBPartai: TComboBox;
    CBKabKota: TComboBox;
    CBKec: TComboBox;
    CBKel: TComboBox;
    CBProv: TComboBox;
    CBTPS: TComboBox;
    ESuaraSah: TEdit;
    ESuaraTidakSah: TEdit;
    EJumlahDPT: TEdit;
    ETotalSuara: TEdit;
    ESuaraDPRRI: TEdit;
    ESuaraDPRDProv: TEdit;
    ESuaraDPRDKab: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
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
    procedure CBKelChange(Sender: TObject);
    procedure CBKelKeyPress(Sender: TObject; var Key: char);
    procedure CBPartaiKeyPress(Sender: TObject; var Key: char);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure CBTPSKeyPress(Sender: TObject; var Key: char);
    procedure EJumlahDPTKeyPress(Sender: TObject; var Key: char);
    procedure ESuaraDPRDKabKeyPress(Sender: TObject; var Key: char);
    procedure ESuaraDPRDProvKeyPress(Sender: TObject; var Key: char);
    procedure ESuaraDPRRIKeyPress(Sender: TObject; var Key: char);
    procedure ESuaraSahKeyPress(Sender: TObject; var Key: char);
    procedure ESuaraTidakSahKeyPress(Sender: TObject; var Key: char);
    procedure ETotalSuaraKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  procedure setCB;
  function getIdProv(nama:string):string;
  function getIdPartai(nama:string):string;
  function getIdKabkota(nama:string):string;
  function getIdKec(nama:string):string;
  function getIdKel(nama:string):string;
  function getIdTPS(nama:string;kel:string):string;
  procedure setCBKabKotaSesuai(nama:string);
  procedure setCBKecSesuai(nama:string);
  procedure setCBKelSesuai(nama:string);
  procedure setCBTPSSesuai(nama:string);
  procedure setTotal;
  end;

var
  FUbahHitungPartai: TFUbahHitungPartai;

implementation

uses uutama;

{$R *.lfm}

{ TFUbahHitungPartai }

procedure TFUbahHitungPartai.CBPartaiKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungPartai.CBProvChange(Sender: TObject);
begin
  setCBKabKotaSesuai(CBProv.Text);
end;

procedure TFUbahHitungPartai.CBKabKotaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungPartai.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFUbahHitungPartai.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFUbahHitungPartai.BSimpanClick(Sender: TObject);
var
  suara : string;
begin

    setTotal;

  if (CBPartai.Text='') or (CBPartai.Text='-Pilih-') or (CBProv.Text='') or (CBProv.Text='-Pilih-') or
     (CBKabKota.Text='') or (CBKabKota.Text='-Pilih-') or (CBKec.Text='') or (CBKec.Text='-Pilih-') or
     (CBKel.Text='') or (CBKel.Text='-Pilih-') or (CBTPS.Text='') or (CBTPS.Text='-Pilih-') or
     (ESuaraSah.Text='') or (ESuaraTidakSah.Text='') or (EJumlahDPT.Text='') or
     (ESuaraDPRRI.Text='') or (ESuaraDPRDProv.Text='') or (ESuaraDPRDKab.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
        // Cek Apakah Data Sudah ada
        with DM.ZQCari do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='select * from t_hitungpartai where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and no_urut="'+getIdPartai(CBPartai.Text)+'"';
          Open;
        end;
        if DM.ZQCari.RecordCount >= 1 then
        begin
        // Update
        with DM.ZQHitungPartai do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='update t_hitungpartai set suara_dprdkab="'+ESuaraDPRDKab.Text+'",suara_dprdprov="'+ESuaraDPRDProv.Text+'",suara_dprri="'+ESuaraDPRRI.Text+'",suara_sah="'+ESuaraSah.Text+'",suara_tidaksah="'+ESuaraTidakSah.Text+'",dpt="'+EJumlahDPT.Text+'" where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and no_urut="'+getIdPartai(CBPartai.Text)+'"';
          ExecSQL;
        end;
        MessageDlg('Data Perhitungan Partai Berhasil Diperbarui!',mtInformation,[mbok],0);
        end else
        begin
          // Simpan
          with DM.ZQHitungPartai do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='insert into t_hitungpartai (no_urut,tps,suara_dprdkab,suara_dprdprov,suara_dprri,suara_sah,suara_tidaksah,dpt) values ("'+getIdPartai(CBPartai.Text)+'","'+getIdTPS(CBTPS.Text,CBKel.Text)+'","'+ESuaraDPRDKab.Text+'","'+ESuaraDPRDProv.Text+'","'+ESuaraDPRRI.Text+'","'+ESuaraSah.Text+'","'+ESuaraTidakSah.Text+'","'+EJumlahDPT.Text+'")';
            ExecSQL;
          end;
          MessageDlg('Data Perhitungan Partai Berhasil Diperbarui!',mtInformation,[mbok],0);
        end;
        fhpartai.BRefresh.Click;
     end;
end;

procedure TFUbahHitungPartai.CBKabKotaChange(Sender: TObject);
begin
  setCBKecSesuai(CBKabKota.Text);
end;

procedure TFUbahHitungPartai.CBKecKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungPartai.CBKelChange(Sender: TObject);
begin
  setCBTPSSesuai(CBKel.Text);
end;

procedure TFUbahHitungPartai.CBKelKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungPartai.CBProvKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungPartai.CBTPSKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungPartai.EJumlahDPTKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungPartai.ESuaraDPRDKabKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungPartai.ESuaraDPRDProvKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungPartai.ESuaraDPRRIKeyPress(Sender: TObject; var Key: char
  );
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungPartai.ESuaraSahKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungPartai.ESuaraTidakSahKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungPartai.ETotalSuaraKeyPress(Sender: TObject; var Key: char
  );
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungPartai.hapus;
begin
  CBPartai.Text:='-Pilih-';
  CBProv.Text:='-Pilih-';
  CBKabKota.Text:='-Pilih-';
  CBKec.Text:='-Pilih-';
  CBKel.Text:='-Pilih-';
  CBTPS.Text:='-Pilih-';
  ESuaraDPRRI.Text:='';
  ESuaraDPRDProv.Text:='';
  ESuaraDPRDKab.Text:='';
  ETotalSuara.Text:='';
  ESuaraSah.Text:='';
  ESuaraTidakSah.Text:='';
  EJumlahDPT.Text:='';
  setCB;
  BSimpan.Enabled:=True;
  if (FUtama.LKategori.Caption='DPR RI') then begin
  Label10.Visible:=False;
  Label7.Visible:=True;
  Label7.Caption:='Perolehan';
  Label8.Visible:=False;
  Label9.Visible:=False;
  ESuaraDPRDKab.Visible:=False;
  ESuaraDPRDProv.Visible:=False;
  ETotalSuara.Visible:=False;
  ESuaraDPRRI.Visible:=True;
  end;
  if (FUtama.LKategori.Caption='DPRD Provinsi') then begin
  Label10.Visible:=False;
  Label7.Visible:=False;
  Label8.Visible:=True;
  Label8.Caption:='Perolehan';
  Label9.Visible:=False;
  ESuaraDPRDKab.Visible:=False;
  ESuaraDPRDProv.Visible:=True;
  ETotalSuara.Visible:=False;
  ESuaraDPRRI.Visible:=False;
  end;
  if (FUtama.LKategori.Caption='DPRD Kabupaten/Kota') then begin
  Label10.Visible:=False;
  Label7.Visible:=False;
  Label8.Visible:=False;
  Label9.Visible:=True;
  Label9.Caption:='Perolehan';
  ESuaraDPRDKab.Visible:=True;
  ESuaraDPRDProv.Visible:=False;
  ETotalSuara.Visible:=False;
  ESuaraDPRRI.Visible:=False;
  end;
end;

procedure TFUbahHitungPartai.setCB;
var
  i,j,k,l,m,n : integer;
begin
  CBPartai.Items.Clear;
  CBProv.Items.Clear;
  CBKabKota.Items.Clear;
  CBKec.Items.Clear;
  CBKel.Items.Clear;
  CBTPS.Items.Clear;

  DM.ZQPartai.First;
  for i:= 1 to DM.ZQPartai.RecordCount do
  begin
  CBPartai.Items.Add(DM.ZQPartai.FieldByName('singkatan').AsString);
  DM.ZQPartai.Next;
  end;

  DM.ZQProv.First;
  for j:= 1 to DM.ZQProv.RecordCount do
  begin
  CBProv.Items.Add(DM.ZQProv.FieldByName('nama_provinsi').AsString);
  DM.ZQProv.Next;
  end;

  DM.ZQKabKota.First;
  for k:= 1 to DM.ZQKabKota.RecordCount do
  begin
  CBKabKota.Items.Add(DM.ZQKabKota.FieldByName('nama_kota').AsString);
  DM.ZQKabKota.Next;
  end;

  DM.ZQKec.First;
  for l:= 1 to DM.ZQKec.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQKec.FieldByName('nama_kecamatan').AsString);
  DM.ZQKec.Next;
  end;

  DM.ZQKelDesa.First;
  for m:= 1 to DM.ZQKelDesa.RecordCount do
  begin
  CBKel.Items.Add(DM.ZQKelDesa.FieldByName('nama_kelurahan').AsString);
  DM.ZQKelDesa.Next;
  end;

  DM.ZQTPS.First;
  for n:= 1 to DM.ZQKelDesa.RecordCount do
  begin
  CBTPS.Items.Add(DM.ZQTPS.FieldByName('no_tps').AsString);
  DM.ZQTPS.Next;
  end;

end;

function TFUbahHitungPartai.getIdProv(nama: string): string;
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

function TFUbahHitungPartai.getIdPartai(nama: string): string;
begin
  Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_urut as id from t_partai where singkatan="'+nama+'"';
  Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFUbahHitungPartai.getIdKabkota(nama: string): string;
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

function TFUbahHitungPartai.getIdKec(nama: string): string;
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

function TFUbahHitungPartai.getIdKel(nama: string): string;
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

function TFUbahHitungPartai.getIdTPS(nama: string;kel:string): string;
begin
  Result:='';
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select id_tps as id from t_tps where no_tps="'+nama+'" and id_kelurahan="'+getIdKel(kel)+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFUbahHitungPartai.setCBKabKotaSesuai(nama: string);
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

procedure TFUbahHitungPartai.setCBKecSesuai(nama: string);
var
  i : integer;
begin
  CBKec.Items.Clear;
  CBKec.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kecamatan from t_kecamatan where id_kota="'+getIdKabkota(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQCari.FieldByName('nama_kecamatan').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFUbahHitungPartai.setCBKelSesuai(nama: string);
var
  i : integer;
begin
  CBKel.Items.Clear;
  CBKel.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kelurahan from t_kelurahan where id_kecamatan="'+getIdKec(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKel.Items.Add(DM.ZQCari.FieldByName('nama_kelurahan').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFUbahHitungPartai.setCBTPSSesuai(nama: string);
var
  i : integer;
begin
  CBTPS.Items.Clear;
  CBTPS.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_tps from t_tps where id_kelurahan="'+getIdKel(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBTPS.Items.Add(DM.ZQCari.FieldByName('no_tps').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFUbahHitungPartai.setTotal;
begin
  if (FUtama.LKategori.Caption='DPR RI') then begin
  ETotalSuara.Text:=ESuaraDPRRI.Text;
  ESuaraDPRDProv.Text:='0';
  ESuaraDPRDKab.Text:='0';
  end;
  if (FUtama.LKategori.Caption='DPRD Provinsi') then begin
  ETotalSuara.Text:=ESuaraDPRDProv.Text;
  ESuaraDPRRI.Text:='0';
  ESuaraDPRDKab.Text:='0';
  end;
  if (FUtama.LKategori.Caption='DPRD Kabupaten/Kota') then begin
  ETotalSuara.Text:=ESuaraDPRDKab.Text;
  ESuaraDPRDProv.Text:='0';
  ESuaraDPRRI.Text:='0';
  end;
end;

end.

