unit utambahdapil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule, ucekserial;

type

  { TFTambahDapil }

  TFTambahDapil = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBKat: TComboBox;
    CBKabKotaProv: TComboBox;
    EIDDapil: TEdit;
    ENamaDapil: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LKabKotaProv: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBKabKotaProvKeyPress(Sender: TObject; var Key: char);
    procedure CBKatChange(Sender: TObject);
    procedure CBKatKeyPress(Sender: TObject; var Key: char);
    procedure EIDDapilKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  function noOtomatis(tambah:integer):string;
  procedure setCBSesuai(nama:string);
  function getIdKabKotaProv(nama:string;kat:string):string;
  procedure simpan;
  end;

var
  FTambahDapil: TFTambahDapil;
  query : string;

  implementation

uses uutama;

// const
// query  = 'select * from t_dapil where kategori="'+FUtama.LKategori.Caption+'" order by id_dapil asc';



{$R *.lfm}

{ TFTambahDapil }

procedure TFTambahDapil.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahDapil.BSimpanClick(Sender: TObject);
begin
    if (EIDDapil.Text='') or (ENamaDapil.Text='') or (CBKat.Text='-Pilih-') or (CBKat.Text='')
    or (CBKabKotaProv.Text='-Pilih-') or (CBKabKotaProv.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_dapil',5)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQDapil do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_dapil set nama_dapil="'+ENamaDapil.Text+'",kategori="'+CBKat.Text+'",kabkotaprov="'+getIdKabKotaProv(CBKabKotaProv.Text,CBKat.Text)+'" where id_dapil="'+EIDDapil.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data DAPIL Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFTambahDapil.CBKabKotaProvKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDapil.CBKatChange(Sender: TObject);
begin
  CBKabKotaProv.Items.Clear;
  CBKabKotaProv.Text:='-Pilih-';
  setCBSesuai(CBKat.Text);
end;

procedure TFTambahDapil.CBKatKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDapil.EIDDapilKeyPress(Sender: TObject; var Key: char);
begin
if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahDapil.FormShow(Sender: TObject);
begin
  query  := 'select * from t_dapil where kategori="'+FUtama.LKategori.Caption+'" order by id_dapil asc';
end;

procedure TFTambahDapil.hapus;
begin
  EIDDapil.Text:=noOtomatis(1);
  ENamaDapil.Text:='';
  CBKat.Text:='-Pilih-';
  BSimpan.Enabled:=True;
  FTambahDapil.Height:=240;
  CBKabKotaProv.Text:='-Pilih-';
  CBKat.Items.Clear;
  CBKat.Items.Add(FUtama.LKategori.Caption);
end;

function TFTambahDapil.noOtomatis(tambah: integer): string;
begin
      Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapil';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahDapil.setCBSesuai(nama: string);
var
  i : integer;
begin
  CBKabKotaProv.Items.Clear;
  if (nama='DPR RI') then
  begin
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_provinsi';
  Open;
  First;
  end;
  for i := 1 to DM.ZQCari.RecordCount do begin
  CBKabKotaProv.Items.Add(DM.ZQCari.FieldByName('nama_provinsi').AsString);
  DM.ZQCari.Next;
  end;
  FTambahDapil.Height:=280;
  LKabKotaProv.Caption:='Provinsi';
  end else
  if (nama='DPRD Provinsi') then
  begin
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_provinsi';
  Open;
  First;
  end;
  for i := 1 to DM.ZQCari.RecordCount do begin
  CBKabKotaProv.Items.Add(DM.ZQCari.FieldByName('nama_provinsi').AsString);
  DM.ZQCari.Next;
  end;
  FTambahDapil.Height:=280;
  LKabKotaProv.Caption:='Provinsi';
  end else
  if (nama='DPRD Kabupaten/Kota') then
  begin
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_kabkota';
  Open;
  First;
  end;
  for i := 1 to DM.ZQCari.RecordCount do begin
  CBKabKotaProv.Items.Add(DM.ZQCari.FieldByName('nama_kota').AsString);
  DM.ZQCari.Next;
  end;
  FTambahDapil.Height:=280;
  LKabKotaProv.Caption:='Kabupaten/Kota';
  end;
end;

function TFTambahDapil.getIdKabKotaProv(nama: string;kat:string): string;
begin
  Result := '';
  if (kat='DPR RI') then
  begin
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select id_provinsi as id from t_provinsi where nama_provinsi="'+nama+'"';
  Open;
  First;
  end;
  Result := DM.ZQCari.FieldByName('id').AsString;
  end else
  if (kat='DPRD Provinsi') then
  begin
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select id_provinsi as id from t_provinsi where nama_provinsi="'+nama+'"';
  Open;
  First;
  end;
  Result := DM.ZQCari.FieldByName('id').AsString;
  end else
  if (kat='DPRD Kabupaten/Kota') then
  begin
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select id_kota as id from t_kabkota where nama_kota="'+nama+'"';
  Open;
  First;
  end;
  Result := DM.ZQCari.FieldByName('id').AsString;
  end;
end;

procedure TFTambahDapil.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapil where id_dapil="'+EIDDapil.Text+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data DAPIL dengan Id '+EIDDapil.Text+' Sudah Ada!',mtWarning,[mbok],0) else
begin
  with DM.ZQDapil do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_dapil (id_dapil,nama_dapil,kategori,kabkotaprov) values ("'+EIDDapil.Text+'","'+ENamaDapil.Text+'","'+CBKat.Text+'","'+getIdKabKotaProv(CBKabKotaProv.Text,CBKat.Text)+'")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
//   BSimpan.Enabled:=False;
  MessageDlg('Data DAPIL Berhasil Disimpan!',mtInformation,[mbok],0);
end;
end;

end.

