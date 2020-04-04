unit utambahkabupatenkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ucekserial;

type

  { TFTambahKabupatenKota }

  TFTambahKabupatenKota = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBProv: TComboBox;
    EIDKota: TEdit;
    ENamaKota: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure EIDKotaKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
    procedure hapus;
    procedure SetCB;
    function getIdProvinsi(nama:string):string;
    function noOtomatis(tambah:integer):string;
    procedure simpan;
  end;

var
  FTambahKabupatenKota: TFTambahKabupatenKota;

const
  query = 'SELECT t_kabkota.id_kota, t_provinsi.nama_provinsi, t_kabkota.nama_kota FROM (t_kabkota INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) order by t_kabkota.id_kota asc';

implementation

uses udatamodule;

{$R *.lfm}

{ TFTambahKabupatenKota }

procedure TFTambahKabupatenKota.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahKabupatenKota.BSimpanClick(Sender: TObject);
begin
  if (EIDKota.Text='') or (ENamaKota.Text='') or (CBProv.Text='-Pilih-') or (CBProv.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

     if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_kabkota',10)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQKabKota do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_kabkota set nama_kota="'+ENamaKota.Text+'",id_provinsi="'+getIdProvinsi(CBProv.Text)+'" where id_kota="'+EIDKota.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data Kabupaten/Kota Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFTambahKabupatenKota.CBProvKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahKabupatenKota.EIDKotaKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahKabupatenKota.hapus;
begin
  EIDKota.Text:=noOtomatis(1);
  ENamaKota.Text:='';
  CBProv.Text:='-Pilih-';
  BSimpan.Enabled:=True;
end;

procedure TFTambahKabupatenKota.SetCB;
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
end;

function TFTambahKabupatenKota.getIdProvinsi(nama: string): string;
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

function TFTambahKabupatenKota.noOtomatis(tambah: integer): string;
begin
    Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_kabkota';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahKabupatenKota.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_kabkota where id_kota="'+EIDKota.Text+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data Kabupaten/Kota Dengan Id '+EIDKota.Text+' Sudah Ada!',mtWarning,[mbok],0) else
begin
  with DM.ZQKabKota do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_kabkota (id_kota,id_provinsi,nama_kota) values ("'+EIDKota.Text+'","'+getIdProvinsi(CBProv.Text)+'","'+ENamaKota.Text+'")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
//  BSimpan.Enabled:=False;
  MessageDlg('Data Kabupaten/Kota Berhasil Disimpan!',mtInformation,[mbok],0);
end;
end;

end.

