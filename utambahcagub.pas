unit utambahcagub;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ColorBox, ucekserial;

type

  { TFTambahCagub }

  TFTambahCagub = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBDaerah: TComboBox;
    CBWarna: TColorBox;
    ENamaAkronim: TEdit;
    ENamaCagub: TEdit;
    ENamaCawagub: TEdit;
    ENoUrut: TEdit;
    ImageFoto: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LNamaImage: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    ShapeGambar: TShape;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBDaerahKeyPress(Sender: TObject; var Key: char);
    procedure ENoUrutKeyPress(Sender: TObject; var Key: char);
    procedure ImageFotoClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  procedure setCB;
  function getDaerah(NamaDaerah:String):String;
  function noOtomatis(tambah:integer):string;
  procedure simpan;
  end;

var
  FTambahCagub: TFTambahCagub;

const
  query = 'SELECT t_cagub.no_urut, t_cagub.nama_cagub, t_cagub.nama_cawagub, t_cagub.nama_akronim, t_provinsi.nama_provinsi, t_cagub.foto, t_cagub.warna FROM (t_cagub INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_cagub.daerah) order by t_cagub.no_urut asc';

implementation

uses udatamodule, ucagub, uutama;

{$R *.lfm}

{ TFTambahCagub }

procedure TFTambahCagub.CBDaerahKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCagub.ENoUrutKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahCagub.ImageFotoClick(Sender: TObject);
begin
    if FUtama.OPD.Execute then
  ImageFoto.Picture.LoadFromFile(FUtama.OPD.FileName);
end;

procedure TFTambahCagub.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahCagub.BSimpanClick(Sender: TObject);
begin
  if (ENoUrut.Text='') or (ENamaCagub.Text='') or (ENamaCawagub.Text='') or (ENamaAkronim.Text='') or (CBDaerah.Text='') or (CBDaerah.Text='-Pilih-') or (FUtama.OPD.FileName='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_cagub',3)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
         if not (ExtractFileName(FUtama.OPD.FileName)=LNamaImage.Caption) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\cagub\'+LNamaImage.Caption);
         CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\cagub\'+ExtractFileName(FUtama.OPD.FileName));
         RenameFile(ExtractFilePath(Application.ExeName)+'img\cagub\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\cagub\'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName));
          with DM.ZQCagub do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_cagub set nama_cagub="'+ENamaCagub.Text+'",nama_cawagub="'+ENamaCawagub.Text+'",nama_akronim="'+ENamaAkronim.Text+'",daerah="'+getDaerah(CBDaerah.Text)+'",foto="'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName)+'",warna="'+CBWarna.Text+'" where no_urut="'+ENoUrut.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          LNamaImage.Caption:=ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName);
          FUtama.OPD.FileName:=LNamaImage.Caption;
          ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\cagub\'+LNamaImage.Caption);
          MessageDlg('Data CAGUB Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
    fcagub.AmbilGambar;
  end;
end;

procedure TFTambahCagub.hapus;
begin
  ENoUrut.Text:=noOtomatis(1);
  ENamaCagub.Text:='';
  ENamaCawagub.Text:='';
  ENamaAkronim.Text:='';
  FUtama.OPD.FileName:='';
  CBDaerah.Text:='-Pilih-';
  ImageFoto.Picture.Clear;
  BSimpan.Enabled:=True;
  ENoUrut.Enabled:=True;
  CBWarna.Selected:=clBlack;
end;

procedure TFTambahCagub.setCB;
var
  i : integer;
begin
  CBDaerah.Items.Clear;
  DM.ZQProv.First;
  for i:= 1 to DM.ZQProv.RecordCount do
  begin
  CBDaerah.Items.Add(DM.ZQProv.FieldByName('nama_provinsi').AsString);
  DM.ZQProv.Next;
  end;
end;

function TFTambahCagub.getDaerah(NamaDaerah: String):String;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_provinsi as id from t_provinsi where nama_provinsi="'+NamaDaerah+'"';
   Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFTambahCagub.noOtomatis(tambah: integer): string;
begin
    Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_cagub';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahCagub.simpan;
begin
// Cek Apakah No Urut Sudah ada
with DM.ZQCari do
begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_cagub where no_urut="'+ENoUrut.Text+'"';
  Open;
end;
if DM.ZQCari.RecordCount >= 1 then
MessageDlg('Data CAGUB Sudah Ada!',mtWarning,[mbok],0) else
begin
  // Copy File
  if FileExists(ExtractFilePath(Application.ExeName)+'img\cagub\'+ExtractFileName(FUtama.OPD.FileName)) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\cagub\'+ExtractFileName(FUtama.OPD.FileName));
  CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\cagub\'+ExtractFileName(FUtama.OPD.FileName));
  RenameFile(ExtractFilePath(Application.ExeName)+'img\cagub\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\cagub\'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName));
  with DM.ZQCagub do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='insert into t_cagub (no_urut,nama_cagub,nama_cawagub,nama_akronim,daerah,foto,warna) values ("'+ENoUrut.Text+'","'+ENamaCagub.Text+'","'+ENamaCawagub.Text+'","'+ENamaAkronim.Text+'","'+getDaerah(CBDaerah.Text)+'","'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName)+'","'+CBWarna.Text+'")';
    ExecSQL;
    SQL.Clear;
    SQL.Text:=query;
    Open;
  end;
 // BSimpan.Enabled:=False;
  MessageDlg('Data CAGUB Berhasil Disimpan!',mtInformation,[mbok],0);
end;
end;

end.

