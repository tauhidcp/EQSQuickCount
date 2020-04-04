unit utambahkecamatan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ucekserial;

type

  { TFTambahKecamatan }

  TFTambahKecamatan = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBProv: TComboBox;
    CBKabKota: TComboBox;
    ENamaKecamatan: TEdit;
    EIDKecamatan: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure EIDKecamatanKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
  procedure hapus;
  procedure SetCB;
  function getIdKota(nama:string):string;
  function noOtomatis(tambah:integer):string;
  procedure setCBKabSesuai(nama:string);
  function getIdProv(nama:string):string;
  procedure simpan;
    { public declarations }
  end;

var
  FTambahKecamatan: TFTambahKecamatan;

  const
    query = 'SELECT t_kecamatan.id_kecamatan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM ((t_kecamatan INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) order by t_kecamatan.id_kecamatan asc';

implementation

uses udatamodule;

{$R *.lfm}

{ TFTambahKecamatan }

procedure TFTambahKecamatan.CBProvKeyPress(Sender: TObject; var Key: char);
begin
  Key:=#0;
end;

procedure TFTambahKecamatan.CBKabKotaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahKecamatan.EIDKecamatanKeyPress(Sender: TObject; var Key: char
  );
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahKecamatan.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahKecamatan.BSimpanClick(Sender: TObject);
begin
  if (EIDKecamatan.Text='') or (ENamaKecamatan.Text='') or (CBProv.Text='-Pilih-') or (CBProv.Text='')
  or (CBKabKota.Text='-Pilih-') or (CBKabKota.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
       simpan else
       begin
       if (cekData('t_kecamatan',10)=True) then
           MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
           simpan;
       end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQKec do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_kecamatan set nama_kecamatan="'+ENamaKecamatan.Text+'",id_kota="'+getIdKota(CBKabKota.Text)+'" where id_kecamatan="'+EIDKecamatan.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data Kecamatan Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFTambahKecamatan.CBProvChange(Sender: TObject);
begin
  setCBKabSesuai(CBProv.Text);
end;

procedure TFTambahKecamatan.hapus;
begin
  EIDKecamatan.Text:=noOtomatis(1);
  ENamaKecamatan.Text:='';
  CBProv.Text:='-Pilih-';
  CBKabKota.Text:='-Pilih-';
  BSimpan.Enabled:=True;
end;

procedure TFTambahKecamatan.SetCB;
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
end;

function TFTambahKecamatan.getIdKota(nama: string): string;
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

function TFTambahKecamatan.noOtomatis(tambah: integer): string;
begin
    Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_kecamatan';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahKecamatan.setCBKabSesuai(nama: string);
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

function TFTambahKecamatan.getIdProv(nama: string): string;
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

procedure TFTambahKecamatan.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_kecamatan where id_kecamatan="'+EIDKecamatan.Text+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('Data Kecamatan Dengan Id '+EIDKecamatan.Text+' Sudah Ada!',mtWarning,[mbok],0) else
  begin
    with DM.ZQKec do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_kecamatan (id_kecamatan,id_kota,nama_kecamatan) values ("'+EIDKecamatan.Text+'","'+getIdKota(CBKabKota.Text)+'","'+ENamaKecamatan.Text+'")';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
   // BSimpan.Enabled:=False;
    MessageDlg('Data Kecamatan Berhasil Disimpan!',mtInformation,[mbok],0);
  end;
end;

end.

