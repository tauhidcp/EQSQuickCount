unit utambahdapilprovinsi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ucekserial;

type

  { TFTambahDapilProvinsi }

  TFTambahDapilProvinsi = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBKab: TComboBox;
    CBDapil: TComboBox;
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
    procedure CBKabKeyPress(Sender: TObject; var Key: char);
    procedure CBDapilKeyPress(Sender: TObject; var Key: char);
    procedure EIDDapilKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  procedure setCB;
  function getIDDapil(nama:string):string;
  function getIDKab(nama:string):string;
  function noOtomatis(tambah:integer):string;
  procedure setCBSesuai(nama:string);
  function getIDProv(nama:string):string;
  procedure simpan;
  function getIdX(nama:string):string;
  end;

var
  FTambahDapilProvinsi: TFTambahDapilProvinsi;

const
  query = 'SELECT t_dapilprovinsi.id, t_dapil.nama_dapil, t_kabkota.nama_kota FROM ((t_dapilprovinsi INNER JOIN t_dapil ON t_dapil.id_dapil=t_dapilprovinsi.id_dapil) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_dapilprovinsi.kabkota) order by t_dapilprovinsi.id asc';

implementation

uses udatamodule, uutama;

{$R *.lfm}

{ TFTambahDapilProvinsi }

procedure TFTambahDapilProvinsi.CBDapilKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDapilProvinsi.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahDapilProvinsi.BSimpanClick(Sender: TObject);
begin
    if (EIDDapil.Text='') or (CBDapil.Text='-Pilih-') or (CBDapil.Text='')
    or (CBKab.Text='-Pilih-') or (CBKab.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_dapilprovinsi',5)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQDAPILProv do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_dapilprovinsi set kabkota="'+getIDKab(CBKab.Text)+'",id_dapil="'+getIDDapil(CBDapil.Text)+'" where id="'+EIDDapil.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data DAPIL Provinsi Berhasil Diperbarui!',mtInformation,[mbok],0);
          fdapilprov.HapusNode;
          fdapilprov.BuatNode;
     end;
  end;
end;

procedure TFTambahDapilProvinsi.CBDapilChange(Sender: TObject);
begin
CBKab.Items.Clear;
CBKab.Text:='-Pilih-';
setCBSesuai(CBDapil.Text);
end;

procedure TFTambahDapilProvinsi.CBKabKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDapilProvinsi.EIDDapilKeyPress(Sender: TObject; var Key: char);
begin
      if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahDapilProvinsi.hapus;
begin
  EIDDapil.Text:=noOtomatis(1);
  CBDapil.Text:='-Pilih-';
  CBKab.Text:='-Pilih-';
  BSimpan.Enabled:=True;
end;

procedure TFTambahDapilProvinsi.setCB;
var
  i,j : integer;
begin
  CBDapil.Items.Clear;
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapil where kategori="DPRD Provinsi"';
  Open;
  end;
  DM.ZQCari.First;
  for j:= 1 to DM.ZQCari.RecordCount do
  begin
  CBDapil.Items.Add(DM.ZQCari.FieldByName('nama_dapil').AsString);
  DM.ZQCari.Next;
  end;

  CBKab.Items.Clear;
  DM.ZQKabKota.First;
  for i:= 1 to DM.ZQKabKota.RecordCount do
  begin
  CBKab.Items.Add(DM.ZQKabKota.FieldByName('nama_kota').AsString);
  DM.ZQKabKota.Next;
  end;
end;

function TFTambahDapilProvinsi.getIDKab(nama: string): string;
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

function TFTambahDapilProvinsi.getIDDapil(nama: string): string;
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

function TFTambahDapilProvinsi.noOtomatis(tambah: integer): string;
begin
    Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapilprovinsi';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahDapilProvinsi.setCBSesuai(nama: string);
var
  i : integer;
begin
  CBKab.Items.Clear;
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_kabkota where id_provinsi="'+getIdProv(CBDapil.Text)+'"';
  Open;
  First;
  end;
  for i := 1 to DM.ZQCari.RecordCount do begin
  CBKab.Items.Add(DM.ZQCari.FieldByName('nama_kota').AsString);
  DM.ZQCari.Next;
  end;
end;

function TFTambahDapilProvinsi.getIDProv(nama: string): string;
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

procedure TFTambahDapilProvinsi.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapilprovinsi where id="'+EIDDapil.Text+'" or kabkota="'+getIdX(Trim(CBKab.Text))+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data DAPIL Provinsi dengan Id '+EIDDapil.Text+' Sudah Ada!',mtWarning,[mbok],0) else
begin
  with DM.ZQDAPILProv do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_dapilprovinsi (id,kabkota,id_dapil) values ("'+EIDDapil.Text+'","'+getIDKab(CBKab.Text)+'","'+getIDDapil(CBDapil.Text)+'")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
//  BSimpan.Enabled:=False;
  MessageDlg('Data DAPIL Provinsi Berhasil Disimpan!',mtInformation,[mbok],0);
  fdapilprov.HapusNode;
  fdapilprov.BuatNode;
end;
end;

function TFTambahDapilProvinsi.getIdX(nama: string): string;
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

end.

