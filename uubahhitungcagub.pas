unit uubahhitungcagub;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule;

type

  { TFUbahHitungCagub }

  TFUbahHitungCagub = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBCagub: TComboBox;
    CBKabKota: TComboBox;
    CBKec: TComboBox;
    CBKel: TComboBox;
    CBProv: TComboBox;
    CBTPS: TComboBox;
    EJumlahDPT: TEdit;
    EPerolehan: TEdit;
    ESuaraSah: TEdit;
    ESuaraTidakSah: TEdit;
    Label1: TLabel;
    Label10: TLabel;
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
    procedure CBCagubChange(Sender: TObject);
    procedure CBCagubKeyPress(Sender: TObject; var Key: char);
    procedure CBKabKotaChange(Sender: TObject);
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure CBKecChange(Sender: TObject);
    procedure CBKecKeyPress(Sender: TObject; var Key: char);
    procedure CBKelChange(Sender: TObject);
    procedure CBKelKeyPress(Sender: TObject; var Key: char);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure CBTPSKeyPress(Sender: TObject; var Key: char);
    procedure EJumlahDPTKeyPress(Sender: TObject; var Key: char);
    procedure EPerolehanKeyPress(Sender: TObject; var Key: char);
    procedure ESuaraSahKeyPress(Sender: TObject; var Key: char);
    procedure ESuaraTidakSahKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  procedure setCB;
  function getIdCagub(nama:string):string;
  function getIdDaerah(nama:string):string;
  function getIdProv(nama:string):string;
  function getIdKabkota(nama:string):string;
  function getIdKec(nama:string):string;
  function getIdKel(nama:string):string;
  function getIdTPS(nama:string;kel:string):string;
  procedure setCBProvSesuai(nama:string);

  procedure setCBKabKotaSesuai(nama:string);
  procedure setCBKecSesuai(nama:string);
  procedure setCBKelSesuai(nama:string);

  procedure setCBTPSSesuai(nama:string);
  end;

var
  FUbahHitungCagub: TFUbahHitungCagub;

implementation

uses uutama;

{$R *.lfm}

{ TFUbahHitungCagub }

procedure TFUbahHitungCagub.CBCagubKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCagub.CBCagubChange(Sender: TObject);
begin
  setCBProvSesuai(CBCagub.Text);
end;

procedure TFUbahHitungCagub.BSimpanClick(Sender: TObject);
begin
  if (CBCagub.Text='') or (CBCagub.Text='-Pilih-') or (CBProv.Text='') or (CBProv.Text='-Pilih-') or
     (CBKabKota.Text='') or (CBKabKota.Text='-Pilih-') or (CBKec.Text='') or (CBKec.Text='-Pilih-') or
     (CBKel.Text='') or (CBKel.Text='-Pilih-') or (CBTPS.Text='') or (CBTPS.Text='-Pilih-') or
     (EPerolehan.Text='') or (ESuaraSah.Text='') or (ESuaraTidakSah.Text='') or (EJumlahDPT.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
        // Cek Apakah Data Sudah ada
        with DM.ZQCari do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='select * from t_hitungcagub where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and no_urut="'+getIdCagub(CBCagub.Text)+'"';
          Open;
        end;
        if DM.ZQCari.RecordCount >= 1 then
        begin
        // Update
        with DM.ZQHitungCagub do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='update t_hitungcagub set provinsi="'+getIdProv(CBProv.Text)+'",perolehan="'+EPerolehan.Text+'",suara_sah="'+ESuaraSah.Text+'",suara_tidaksah="'+ESuaraTidakSah.Text+'",dpt="'+EJumlahDPT.Text+'" where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and no_urut="'+getIdCagub(CBCagub.Text)+'"';
          ExecSQL;
        end;
        MessageDlg('Data Perhitungan CAGUB Berhasil Diperbarui!',mtInformation,[mbok],0);
        end else
        begin
          // Simpan
          with DM.ZQHitungCagub do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='insert into t_hitungcagub (provinsi,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdProv(CBProv.Text)+'","'+getIdCagub(CBCagub.Text)+'","'+getIdTPS(CBTPS.Text,CBKel.Text)+'","'+EPerolehan.Text+'","'+ESuaraSah.Text+'","'+ESuaraTidakSah.Text+'","'+EJumlahDPT.Text+'")';
            ExecSQL;
          end;
          MessageDlg('Data Perhitungan CAGUB Berhasil Diperbarui!',mtInformation,[mbok],0);
        end;
        fhcagub.BRefresh.Click;
     end;
end;

procedure TFUbahHitungCagub.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFUbahHitungCagub.CBKabKotaChange(Sender: TObject);
begin
  setCBKecSesuai(CBKabKota.Text);
end;

procedure TFUbahHitungCagub.CBKabKotaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCagub.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFUbahHitungCagub.CBKecKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCagub.CBKelChange(Sender: TObject);
begin
  setCBTPSSesuai(CBKel.Text);
end;

procedure TFUbahHitungCagub.CBKelKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCagub.CBProvChange(Sender: TObject);
begin
  setCBKabKotaSesuai(CBProv.Text);
end;

procedure TFUbahHitungCagub.CBProvKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCagub.CBTPSKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCagub.EJumlahDPTKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungCagub.EPerolehanKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungCagub.ESuaraSahKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungCagub.ESuaraTidakSahKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungCagub.hapus;
begin
  CBCagub.Text:='-Pilih-';
  CBProv.Text:='-Pilih-';
  CBKabKota.Text:='-Pilih-';
  CBKec.Text:='-Pilih-';
  CBKel.Text:='-Pilih-';
  CBTPS.Text:='-Pilih-';
  EPerolehan.Text:='';
  ESuaraSah.Text:='';
  ESuaraTidakSah.Text:='';
  EJumlahDPT.Text:='';
  setCB;
  BSimpan.Enabled:=True;
end;

function TFUbahHitungCagub.getIdProv(nama: string): string;
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

procedure TFUbahHitungCagub.setCB;
var
  i,j,k,l,m,n : integer;
begin
  CBCagub.Items.Clear;
  CBProv.Items.Clear;
  CBKabKota.Items.Clear;
  CBKec.Items.Clear;
  CBKel.Items.Clear;
  CBTPS.Items.Clear;

  DM.ZQCagub.First;
  for i:= 1 to DM.ZQCagub.RecordCount do
  begin
  CBCagub.Items.Add(DM.ZQCagub.FieldByName('nama_akronim').AsString);
  DM.ZQCagub.Next;
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

function TFUbahHitungCagub.getIdCagub(nama: string): string;
begin
  Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_urut as id from t_cagub where nama_akronim="'+nama+'"';
  Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFUbahHitungCagub.getIdDaerah(nama: string): string;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select daerah as id from t_cagub where nama_akronim="'+nama+'"';
   Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFUbahHitungCagub.getIdKabkota(nama: string): string;
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

function TFUbahHitungCagub.getIdKec(nama: string): string;
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

function TFUbahHitungCagub.getIdKel(nama: string): string;
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

function TFUbahHitungCagub.getIdTPS(nama: string;kel:string): string;
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

procedure TFUbahHitungCagub.setCBProvSesuai(nama: string);
var
  i : integer;
begin
  CBProv.Items.Clear;
  CBProv.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_provinsi from t_provinsi where id_provinsi="'+getIdDaerah(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBProv.Items.Add(DM.ZQCari.FieldByName('nama_provinsi').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFUbahHitungCagub.setCBKabKotaSesuai(nama: string);
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

procedure TFUbahHitungCagub.setCBKecSesuai(nama: string);
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

procedure TFUbahHitungCagub.setCBKelSesuai(nama: string);
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

procedure TFUbahHitungCagub.setCBTPSSesuai(nama: string);
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

end.

