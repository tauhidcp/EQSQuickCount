unit uubahhitungdprdkabkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule;

type

  { TFUbahHitungDPRDKab }

  TFUbahHitungDPRDKab = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBCaleg: TComboBox;
    CBKec: TComboBox;
    CBKel: TComboBox;
    CBTPS: TComboBox;
    EJumlahDPT: TEdit;
    EPerolehan: TEdit;
    ESuaraSah: TEdit;
    ESuaraTidakSah: TEdit;
    Label1: TLabel;
    Label10: TLabel;
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
    procedure CBCalegChange(Sender: TObject);
    procedure CBCalegKeyPress(Sender: TObject; var Key: char);
    procedure CBKecChange(Sender: TObject);
    procedure CBKecKeyPress(Sender: TObject; var Key: char);
    procedure CBKelChange(Sender: TObject);
    procedure CBKelKeyPress(Sender: TObject; var Key: char);
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
  function getIdDapil(nama:string):string;
  function getIdCaleg(nama:string):string;
  function getIdKabKota(nama:string):string;
  function getIdDaerah(nama:string):string;
  function getIdKec(nama:string):string;
  function getIdKel(nama:string):string;
  function getIdTPS(nama:string;kel:string):string;
  procedure setCBKecSesuai(nama:string);
  procedure setCBKelSesuai(nama:string);
  procedure setCBTPSSesuai(nama:string);
  end;

var
  FUbahHitungDPRDKab: TFUbahHitungDPRDKab;

implementation

uses uutama;

{$R *.lfm}

{ TFUbahHitungDPRDKab }

procedure TFUbahHitungDPRDKab.CBCalegKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungDPRDKab.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFUbahHitungDPRDKab.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFUbahHitungDPRDKab.BSimpanClick(Sender: TObject);
begin
     if (CBCaleg.Text='') or (CBCaleg.Text='-Pilih-') or
     (CBKec.Text='') or (CBKec.Text='-Pilih-') or
     (CBKel.Text='') or (CBKel.Text='-Pilih-') or (CBTPS.Text='') or (CBTPS.Text='-Pilih-') or
     (EPerolehan.Text='') or (ESuaraSah.Text='') or (ESuaraTidakSah.Text='') or (EJumlahDPT.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
        // Cek Apakah Data Sudah ada
        with DM.ZQCari do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='select * from t_hitungdprdkab where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and id_caleg="'+getIdCaleg(CBCaleg.Text)+'"';
          Open;
        end;
        if DM.ZQCari.RecordCount >= 1 then
        begin
        // Update
        with DM.ZQHitungDPRDKab do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='update t_hitungdprdkab set dapil="'+getIdDapil(CBCaleg.Text)+'",perolehan="'+EPerolehan.Text+'",suara_sah="'+ESuaraSah.Text+'",suara_tidaksah="'+ESuaraTidakSah.Text+'",dpt="'+EJumlahDPT.Text+'" where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and id_caleg="'+getIdCaleg(CBCaleg.Text)+'"';
          ExecSQL;
        end;
        MessageDlg('Data Perhitungan CALEG DPRD Kabupaten/Kota Berhasil Diperbarui!',mtInformation,[mbok],0);
        end else
        begin
          // Simpan
          with DM.ZQHitungDPRDKab do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='insert into t_hitungdprdkab (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(CBCaleg.Text)+'","'+getIdCaleg(CBCaleg.Text)+'","'+getIdTPS(CBTPS.Text,CBKel.Text)+'","'+EPerolehan.Text+'","'+ESuaraSah.Text+'","'+ESuaraTidakSah.Text+'","'+EJumlahDPT.Text+'")';
            ExecSQL;
          end;
          MessageDlg('Data Perhitungan CALEG DPRD Kabupaten/Kota Berhasil Diperbarui!',mtInformation,[mbok],0);
        end;
        fhdprdkab.BRefresh.Click;
     end;
end;

procedure TFUbahHitungDPRDKab.CBCalegChange(Sender: TObject);
begin
  setCBKecSesuai(CBCaleg.Text);
end;

procedure TFUbahHitungDPRDKab.CBKecKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungDPRDKab.CBKelChange(Sender: TObject);
begin
  setCBTPSSesuai(CBKel.Text);
end;

procedure TFUbahHitungDPRDKab.CBKelKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungDPRDKab.CBTPSKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungDPRDKab.EJumlahDPTKeyPress(Sender: TObject; var Key: char
  );
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungDPRDKab.EPerolehanKeyPress(Sender: TObject; var Key: char
  );
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungDPRDKab.ESuaraSahKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungDPRDKab.ESuaraTidakSahKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungDPRDKab.hapus;
begin
  CBCaleg.Text:='-Pilih-';
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

procedure TFUbahHitungDPRDKab.setCB;
var
  i,k,l,m : integer;
begin
  CBCaleg.Items.Clear;
  CBKec.Items.Clear;
  CBKel.Items.Clear;
  CBTPS.Items.Clear;

  DM.ZQDPRDKab.First;
  for i:= 1 to DM.ZQDPRDKab.RecordCount do
  begin
  CBCaleg.Items.Add(DM.ZQDPRDKab.FieldByName('nama_caleg').AsString);
  DM.ZQDPRDKab.Next;
  end;

  DM.ZQKec.First;
  for k:= 1 to DM.ZQKec.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQKec.FieldByName('nama_kecamatan').AsString);
  DM.ZQKec.Next;
  end;

  DM.ZQKelDesa.First;
  for l:= 1 to DM.ZQKelDesa.RecordCount do
  begin
  CBKel.Items.Add(DM.ZQKelDesa.FieldByName('nama_kelurahan').AsString);
  DM.ZQKelDesa.Next;
  end;

  DM.ZQTPS.First;
  for m:= 1 to DM.ZQKelDesa.RecordCount do
  begin
  CBTPS.Items.Add(DM.ZQTPS.FieldByName('no_tps').AsString);
  DM.ZQTPS.Next;
  end;

end;

function TFUbahHitungDPRDKab.getIdDapil(nama: string): string;
begin
 Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select dapil as id from t_calegdprdkabkota where nama_caleg="'+nama+'"';
  Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFUbahHitungDPRDKab.getIdCaleg(nama: string): string;
begin
  Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select id as id from t_calegdprdkabkota where nama_caleg="'+nama+'"';
  Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFUbahHitungDPRDKab.getIdKabKota(nama: string): string;
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

function TFUbahHitungDPRDKab.getIdDaerah(nama: string): string;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select dapil as id from t_calegdprdkabkota where nama_caleg="'+nama+'"';
   Open;
  end;
  with DM.ZQCari2 do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_dapil as id from t_dapil where id_dapil="'+DM.ZQCari.FieldByName('id').AsString+'"';
   Open;
  end;
  if DM.ZQCari2.RecordCount>=1 then
  Result:=DM.ZQCari2.FieldByName('id').AsString;
end;

function TFUbahHitungDPRDKab.getIdKec(nama: string): string;
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

function TFUbahHitungDPRDKab.getIdKel(nama: string): string;
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

function TFUbahHitungDPRDKab.getIdTPS(nama: string;kel:string): string;
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

procedure TFUbahHitungDPRDKab.setCBKecSesuai(nama: string);
var
  i : integer;
begin
  CBKec.Items.Clear;
  CBKec.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='SELECT t_kecamatan.nama_kecamatan FROM (t_kecamatan INNER JOIN t_dapilkabkota ON t_dapilkabkota.kecamatan=t_kecamatan.id_kecamatan) where t_dapilkabkota.id_dapil="'+getIdDaerah(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQCari.FieldByName('nama_kecamatan').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFUbahHitungDPRDKab.setCBKelSesuai(nama: string);
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

procedure TFUbahHitungDPRDKab.setCBTPSSesuai(nama: string);
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

