unit utambahprov;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ucekserial;

type

  { TFTambahProv }

  TFTambahProv = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    ENamaProv: TEdit;
    EIDProv: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure EIDProvKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
    procedure hapus;
    function noOtomatis(tambah:integer):string;
    procedure simpan;
  end;

var
  FTambahProv: TFTambahProv;

  const
    query = 'select * from t_provinsi order by id_provinsi asc';

implementation

uses udatamodule;

{$R *.lfm}

{ TFTambahProv }

procedure TFTambahProv.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahProv.BSimpanClick(Sender: TObject);
begin
  if (EIDProv.Text='') or (ENamaProv.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
       simpan else
       begin
       if (cekData('t_provinsi',10)=True) then
           MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
           simpan;
       end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
          with DM.ZQProv do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_provinsi set nama_provinsi="'+ENamaProv.Text+'" where id_provinsi="'+EIDProv.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          MessageDlg('Data Provinsi Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFTambahProv.EIDProvKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahProv.hapus;
begin
  EIDProv.Text:=noOtomatis(1);
  ENamaProv.Text:='';
  BSimpan.Enabled:=True;
end;

function TFTambahProv.noOtomatis(tambah: integer): string;
begin
    Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_provinsi';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahProv.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_provinsi where id_provinsi="'+EIDProv.Text+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data Provinsi Dengan Id '+EIDProv.Text+' Sudah Ada!',mtWarning,[mbok],0) else
begin
  with DM.ZQProv do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_provinsi (id_provinsi,nama_provinsi) values ("'+EIDProv.Text+'","'+ENamaProv.Text+'")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
//  BSimpan.Enabled:=False;
  MessageDlg('Data Provinsi Berhasil Disimpan!',mtInformation,[mbok],0);
end;
end;

end.

