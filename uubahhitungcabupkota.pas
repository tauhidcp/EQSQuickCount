unit uubahhitungcabupkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule;

type

  { TFUbahHitungCabupKota }

  TFUbahHitungCabupKota = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBCabupKota: TComboBox;
    CBKabKota: TComboBox;
    CBKec: TComboBox;
    CBKel: TComboBox;
    CBTPS: TComboBox;
    EJumlahDPT: TEdit;
    EPerolehan: TEdit;
    ESuaraSah: TEdit;
    ESuaraTidakSah: TEdit;
    Label1: TLabel;
    Label10: TLabel;
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
    procedure CBCabupKotaChange(Sender: TObject);
    procedure CBCabupKotaKeyPress(Sender: TObject; var Key: char);
    procedure CBKabKotaChange(Sender: TObject);
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
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
  function getIdCabup(nama:string):string;
  function getIdKabKota(nama:string):string;
  function getIdDaerah(nama:string):string;
  function getIdKec(nama:string):string;
  function getIdKel(nama:string):string;
  function getIdTPS(nama:string;kel:string):string;
  procedure setCBKabKotaSesuai(nama:string);
  procedure setCBKecSesuai(nama:string);
  procedure setCBKelSesuai(nama:string);
  procedure setCBTPSSesuai(nama:string);
  end;

var
  FUbahHitungCabupKota: TFUbahHitungCabupKota;

implementation

uses uutama;

{$R *.lfm}

{ TFUbahHitungCabupKota }

procedure TFUbahHitungCabupKota.CBCabupKotaKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCabupKota.CBKabKotaChange(Sender: TObject);
begin
  setCBKecSesuai(CBKabKota.Text);
end;

procedure TFUbahHitungCabupKota.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFUbahHitungCabupKota.BSimpanClick(Sender: TObject);
begin
  if (CBCabupKota.Text='') or (CBCabupKota.Text='-Pilih-') or
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
          SQL.Text:='select * from t_hitungcabup where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and no_urut="'+getIdCabup(CBCabupKota.Text)+'"';
          Open;
        end;
        if DM.ZQCari.RecordCount >= 1 then
        begin
        // Update
        with DM.ZQHitungCabupKota do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='update t_hitungcabup set kabkota="'+getIdKabKota(CBKabKota.Text)+'",perolehan="'+EPerolehan.Text+'",suara_sah="'+ESuaraSah.Text+'",suara_tidaksah="'+ESuaraTidakSah.Text+'",dpt="'+EJumlahDPT.Text+'" where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and no_urut="'+getIdCabup(CBCabupKota.Text)+'"';
          ExecSQL;
        end;
        MessageDlg('Data Perhitungan CABUP/Kota Berhasil Diperbarui!',mtInformation,[mbok],0);
        end else
        begin
          // Simpan
          with DM.ZQHitungCabupKota do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='insert into t_hitungcabup (kabkota,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdKabKota(CBKabKota.Text)+'","'+getIdCabup(CBCabupKota.Text)+'","'+getIdTPS(CBTPS.Text,CBKel.Text)+'","'+EPerolehan.Text+'","'+ESuaraSah.Text+'","'+ESuaraTidakSah.Text+'","'+EJumlahDPT.Text+'")';
            ExecSQL;
          end;
          MessageDlg('Data Perhitungan CABUP/Kota Berhasil Diperbarui!',mtInformation,[mbok],0);
        end;
       fhcabup.BRefresh.Click;
     end;
end;

procedure TFUbahHitungCabupKota.CBCabupKotaChange(Sender: TObject);
begin
  setCBKabKotaSesuai(CBCabupKota.Text);
end;

procedure TFUbahHitungCabupKota.CBKabKotaKeyPress(Sender: TObject; var Key: char
  );
begin
  key:=#0;
end;

procedure TFUbahHitungCabupKota.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFUbahHitungCabupKota.CBKecKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCabupKota.CBKelChange(Sender: TObject);
begin
  setCBTPSSesuai(CBKel.Text);
end;

procedure TFUbahHitungCabupKota.CBKelKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCabupKota.CBTPSKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungCabupKota.EJumlahDPTKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungCabupKota.EPerolehanKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungCabupKota.ESuaraSahKeyPress(Sender: TObject; var Key: char
  );
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungCabupKota.ESuaraTidakSahKeyPress(Sender: TObject;
  var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungCabupKota.hapus;
begin
  CBCabupKota.Text:='-Pilih-';
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

function TFUbahHitungCabupKota.getIdKabKota(nama: string): string;
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

procedure TFUbahHitungCabupKota.setCB;
var
  i,j,k,l,m : integer;
begin
  CBCabupKota.Items.Clear;
  CBKabKota.Items.Clear;
  CBKec.Items.Clear;
  CBKel.Items.Clear;
  CBTPS.Items.Clear;

  DM.ZQCabupKota.First;
  for i:= 1 to DM.ZQCabupKota.RecordCount do
  begin
  CBCabupKota.Items.Add(DM.ZQCabupKota.FieldByName('nama_akronim').AsString);
  DM.ZQCabupKota.Next;
  end;

  DM.ZQKabKota.First;
  for j:= 1 to DM.ZQKabKota.RecordCount do
  begin
  CBKabKota.Items.Add(DM.ZQKabKota.FieldByName('nama_kota').AsString);
  DM.ZQKabKota.Next;
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

function TFUbahHitungCabupKota.getIdCabup(nama: string): string;
begin
  Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_urut as id from t_cabupkota where nama_akronim="'+nama+'"';
  Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFUbahHitungCabupKota.getIdDaerah(nama: string): string;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select daerah as id from t_cabupkota where nama_akronim="'+nama+'"';
   Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFUbahHitungCabupKota.getIdKec(nama: string): string;
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

function TFUbahHitungCabupKota.getIdKel(nama: string): string;
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

function TFUbahHitungCabupKota.getIdTPS(nama: string;kel:string): string;
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

procedure TFUbahHitungCabupKota.setCBKabKotaSesuai(nama: string);
var
  i : integer;
begin
  CBKabKota.Items.Clear;
  CBKabKota.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kota from t_kabkota where id_kota="'+getIdDaerah(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKabKota.Items.Add(DM.ZQCari.FieldByName('nama_kota').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFUbahHitungCabupKota.setCBKecSesuai(nama: string);
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

procedure TFUbahHitungCabupKota.setCBKelSesuai(nama: string);
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

procedure TFUbahHitungCabupKota.setCBTPSSesuai(nama: string);
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

