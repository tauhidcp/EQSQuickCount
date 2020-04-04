unit utambahdapilri;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ucekserial;

type

  { TFTambahDapilRI }

  TFTambahDapilRI = class(TForm)
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
  function noOtomatis(tambah:integer):string;
  function getIDKab(nama:string):string;
  function getIDDapil(nama:string):string;
  procedure setCB;
  procedure setCBSesuai(nama:string);
  function getIDProv(nama:string):string;
  procedure simpan;
  function getIdX(nama:string):string;
  end;

var
  FTambahDapilRI: TFTambahDapilRI;

  const
    query = 'SELECT t_dapilri.id, t_dapil.nama_dapil, t_kabkota.nama_kota FROM ((t_dapilri INNER JOIN t_dapil ON t_dapil.id_dapil=t_dapilri.id_dapil) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_dapilri.kabkota) order by t_dapilri.id asc';

implementation

uses udatamodule, uutama;

{$R *.lfm}

{ TFTambahDapilRI }

procedure TFTambahDapilRI.EIDDapilKeyPress(Sender: TObject; var Key: char);
begin
      if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahDapilRI.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahDapilRI.BSimpanClick(Sender: TObject);
begin
  if (EIDDapil.Text='') or (CBDapil.Text='') or (CBDapil.Text='-Pilih-') or (CBKab.Text='-Pilih-') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_dapilri',5)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQDAPILRI do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_dapilri set kabkota="'+getIDKab(CBKab.Text)+'",id_dapil="'+getIDDapil(CBDapil.Text)+'" where id="'+EIDDapil.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data DAPIL RI Berhasil Diperbarui!',mtInformation,[mbok],0);
          fdapilri.HapusNode;
          fdapilri.BuatNode;
     end;
  end;
end;

procedure TFTambahDapilRI.CBDapilChange(Sender: TObject);
begin
  CBKab.Items.Clear;
  CBKab.Text:='-Pilih-';
  setCBSesuai(CBDapil.Text);
end;

procedure TFTambahDapilRI.CBKabKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDapilRI.CBDapilKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDapilRI.hapus;
begin
  EIDDapil.Text:=noOtomatis(1);
  BSimpan.Enabled:=True;
  CBKab.Text:='-Pilih-';
  CBDapil.Text:='-Pilih-';
end;

function TFTambahDapilRI.noOtomatis(tambah: integer): string;
begin
    Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapilri';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

function TFTambahDapilRI.getIDKab(nama: string): string;
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

function TFTambahDapilRI.getIDProv(nama: string): string;
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

procedure TFTambahDapilRI.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_dapilri where id="'+EIDDapil.Text+'" or kabkota="'+getIdX(Trim(CBKab.Text))+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('Data DAPIL RI dengan Id '+EIDDapil.Text+' Sudah Ada!',mtWarning,[mbok],0) else
  begin
    with DM.ZQDAPILRI do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_dapilri (id,kabkota,id_dapil) values ("'+EIDDapil.Text+'","'+getIDKab(CBKab.Text)+'","'+getIDDapil(CBDapil.Text)+'")';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  //  BSimpan.Enabled:=False;
    MessageDlg('Data DAPIL RI Berhasil Disimpan!',mtInformation,[mbok],0);
    fdapilri.HapusNode;
    fdapilri.BuatNode;
  end;
end;

function TFTambahDapilRI.getIdX(nama: string): string;
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

function TFTambahDapilRI.getIDDapil(nama: string): string;
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

procedure TFTambahDapilRI.setCB;
var
  i,j : integer;
begin
  CBDapil.Items.Clear;
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapil where kategori="DPR RI"';
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

procedure TFTambahDapilRI.setCBSesuai(nama: string);
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

end.

