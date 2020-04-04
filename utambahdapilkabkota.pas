unit utambahdapilkabkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ucekserial;

type

  { TFTambahDapilKabKota }

  TFTambahDapilKabKota = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBDapil: TComboBox;
    CBKec: TComboBox;
    EIDDapil: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBDapilChange(Sender: TObject);
    procedure CBDapilKeyPress(Sender: TObject; var Key: char);
    procedure CBKecKeyPress(Sender: TObject; var Key: char);
    procedure EIDDapilKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  procedure setCB;
  function getIDDapil(nama:string):string;
  function getIDKec(nama:string):string;
  function noOtomatis(tambah:integer):string;
  procedure setCBSesuai(nama:string);
  function getIDKabKota(nama:string):string;
  procedure simpan;
  end;

var
  FTambahDapilKabKota: TFTambahDapilKabKota;

const
  query = 'SELECT t_dapilkabkota.id, t_dapil.nama_dapil, t_kecamatan.nama_kecamatan FROM ((t_dapilkabkota INNER JOIN t_dapil ON t_dapil.id_dapil=t_dapilkabkota.id_dapil) INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_dapilkabkota.kecamatan) order by t_dapilkabkota.id asc';

implementation

uses udatamodule, uutama;

{$R *.lfm}

{ TFTambahDapilKabKota }

procedure TFTambahDapilKabKota.CBDapilKeyPress(Sender: TObject; var Key: char
  );
begin
  key:=#0;
end;

procedure TFTambahDapilKabKota.CBKecKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDapilKabKota.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahDapilKabKota.BSimpanClick(Sender: TObject);
begin
  if (EIDDapil.Text='') or (CBDapil.Text='-Pilih-') or (CBDapil.Text='')
  or (CBKec.Text='-Pilih-') or (CBKec.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_dapilkabkota',5)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQDAPILKabKota do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_dapilkabkota set kecamatan="'+getIDKec(CBKec.Text)+'",id_dapil="'+getIDDapil(CBDapil.Text)+'" where id="'+EIDDapil.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data DAPIL Kabupaten/Kota Berhasil Diperbarui!',mtInformation,[mbok],0);
          fdapilkabkota.HapusNode;
          fdapilkabkota.BuatNode;
     end;
  end;
end;

procedure TFTambahDapilKabKota.CBDapilChange(Sender: TObject);
begin
  CBKec.Items.Clear;
  CBKec.Text:='-Pilih-';
  setCBSesuai(CBDapil.Text);
end;

procedure TFTambahDapilKabKota.EIDDapilKeyPress(Sender: TObject; var Key: char);
begin
      if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahDapilKabKota.hapus;
begin
  EIDDapil.Text:=noOtomatis(1);
  CBDapil.Text:='-Pilih-';
  CBKec.Text:='-Pilih-';
  BSimpan.Enabled:=True;
end;

procedure TFTambahDapilKabKota.setCB;
var
  i,j : integer;
begin
  CBDapil.Items.Clear;

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapil where kategori="DPRD Kabupaten/Kota"';
  Open;
  end;
  DM.ZQCari.First;
  for j:= 1 to DM.ZQCari.RecordCount do
  begin
  CBDapil.Items.Add(DM.ZQCari.FieldByName('nama_dapil').AsString);
  DM.ZQCari.Next;
  end;

  CBKec.Items.Clear;
  DM.ZQKec.First;
  for i:= 1 to DM.ZQKec.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQKec.FieldByName('nama_kecamatan').AsString);
  DM.ZQKec.Next;
  end;
end;

function TFTambahDapilKabKota.getIDKec(nama: string): string;
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

function TFTambahDapilKabKota.getIDDapil(nama: string): string;
begin
    Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_dapil as id from t_dapil where nama_dapil="'+nama+'"';
   Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFTambahDapilKabKota.noOtomatis(tambah: integer): string;
begin
    Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapilkabkota';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahDapilKabKota.setCBSesuai(nama: string);
var
  i : integer;
begin
  CBKec.Items.Clear;
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_kecamatan where id_kota="'+getIDKabKota(CBDapil.Text)+'"';
  Open;
  First;
  end;
  for i := 1 to DM.ZQCari.RecordCount do begin
  CBKec.Items.Add(DM.ZQCari.FieldByName('nama_kecamatan').AsString);
  DM.ZQCari.Next;
  end;
end;

function TFTambahDapilKabKota.getIDKabKota(nama: string): string;
begin
Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select kabkotaprov as id from t_dapil where nama_dapil="'+nama+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFTambahDapilKabKota.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapilkabkota where id="'+EIDDapil.Text+'" or kecamatan="'+getIDKec(Trim(CBKec.Text))+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data DAPIL Kabupaten/Kota dengan Id '+EIDDapil.Text+' Sudah Ada!',mtWarning,[mbok],0) else
begin
  with DM.ZQDAPILKabKota do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_dapilkabkota (id,kecamatan,id_dapil) values ("'+EIDDapil.Text+'","'+getIDKec(CBKec.Text)+'","'+getIDDapil(CBDapil.Text)+'")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
//  BSimpan.Enabled:=False;
  MessageDlg('Data DAPIL Kabupaten/Kota Berhasil Disimpan!',mtInformation,[mbok],0);
  fdapilkabkota.HapusNode;
  fdapilkabkota.BuatNode;
end;
end;

end.

