unit utambahpartai;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ColorBox, ucekserial;

type

  { TFTambahPartai }

  TFTambahPartai = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBWarna: TColorBox;
    ENoUrut: TEdit;
    ENamaPartai: TEdit;
    ESingkatan: TEdit;
    ImageGambarPartai: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    LNamaImage: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    ShapeGambar: TShape;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure ENoUrutKeyPress(Sender: TObject; var Key: char);
    procedure ImageGambarPartaiClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure Hapus;
    function noOtomatis(tambah:integer):string;
    procedure simpan;
  end;

var
  FTambahPartai: TFTambahPartai;
const
  query = 'select * from t_partai order by no_urut asc';

implementation

uses udatamodule, upartai, uutama;

{$R *.lfm}

{ TFTambahPartai }

procedure TFTambahPartai.BBaruClick(Sender: TObject);
begin
  Hapus;
end;

procedure TFTambahPartai.BSimpanClick(Sender: TObject);
begin
  if (ENoUrut.Text='') or (ENamaPartai.Text='') or (ESingkatan.Text='') or (FUtama.OPD.FileName='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_partai',5)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
         if not (ExtractFileName(FUtama.OPD.FileName)=LNamaImage.Caption) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\partai\'+LNamaImage.Caption);
         CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\partai\'+ExtractFileName(FUtama.OPD.FileName));
         RenameFile(ExtractFilePath(Application.ExeName)+'img\partai\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\partai\'+ENoUrut.Text+ESingkatan.Text+ExtractFileExt(FUtama.OPD.FileName));
          with DM.ZQPartai do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_partai set nama_partai="'+ENamaPartai.Text+'",singkatan="'+ESingkatan.Text+'",gambar="'+ENoUrut.Text+ESingkatan.Text+ExtractFileExt(FUtama.OPD.FileName)+'",warna="'+CBWarna.Text+'" where no_urut="'+ENoUrut.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          LNamaImage.Caption:=ENoUrut.Text+ESingkatan.Text+ExtractFileExt(FUtama.OPD.FileName);
          FUtama.OPD.FileName:=LNamaImage.Caption;
          ImageGambarPartai.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\partai\'+LNamaImage.Caption);
          MessageDlg('Data Partai Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
   fpartai.AmbilGambar;
  end;
end;

procedure TFTambahPartai.ENoUrutKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahPartai.ImageGambarPartaiClick(Sender: TObject);
begin
  if FUtama.OPD.Execute then
  ImageGambarPartai.Picture.LoadFromFile(FUtama.OPD.FileName);
end;

procedure TFTambahPartai.Hapus;
begin
  ENoUrut.Text:=noOtomatis(1);
  ENamaPartai.Text:='';
  ESingkatan.Text:='';
  ImageGambarPartai.Picture.Clear;
  FUtama.OPD.FileName:='';
  BSimpan.Enabled:=True;
  CBWarna.Selected:=clBlack;
end;

function TFTambahPartai.noOtomatis(tambah: integer): string;
begin
    Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_partai';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahPartai.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_partai where no_urut="'+ENoUrut.Text+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data Partai Dengan Nomor Urut '+ENoUrut.Text+' Sudah Ada!',mtWarning,[mbok],0) else
begin
  // Copy File
  if FileExists(ExtractFilePath(Application.ExeName)+'img\partai\'+ExtractFileName(FUtama.OPD.FileName)) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\partai\'+ExtractFileName(FUtama.OPD.FileName));
  CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\partai\'+ExtractFileName(FUtama.OPD.FileName));
  RenameFile(ExtractFilePath(Application.ExeName)+'img\partai\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\partai\'+ENoUrut.Text+ESingkatan.Text+ExtractFileExt(FUtama.OPD.FileName));
  with DM.ZQPartai do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_partai (no_urut,nama_partai,singkatan,gambar,warna) values ("'+ENoUrut.Text+'","'+ENamaPartai.Text+'","'+ESingkatan.Text+'","'+ENoUrut.Text+ESingkatan.Text+ExtractFileExt(FUtama.OPD.FileName)+'","'+CBWarna.Text+'")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
 // BSimpan.Enabled:=False;
  MessageDlg('Data Partai Berhasil Disimpan!',mtInformation,[mbok],0);
end;
end;

end.

