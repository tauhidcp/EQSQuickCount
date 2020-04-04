unit utambahcalegdpdri;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ColorBox, ucekserial;

type

  { TFTambahCalegDPDRI }

  TFTambahCalegDPDRI = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBDapil: TComboBox;
    CBWarna: TColorBox;
    ENamaCaleg: TEdit;
    ENoUrut: TEdit;
    ImageFoto: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    LNamaImage: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    ShapeGambar: TShape;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBDapilKeyPress(Sender: TObject; var Key: char);
    procedure ENoUrutKeyPress(Sender: TObject; var Key: char);
    procedure ImageFotoClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  function noOtomatis(tambah:integer):string;
  procedure setCB;
  function getIdProv(nama:string):string;
  procedure simpan;
  end;

var
  FTambahCalegDPDRI: TFTambahCalegDPDRI;
const
  query = 'SELECT t_calegdpdri.no_urut, t_calegdpdri.nama_caleg, t_provinsi.nama_provinsi, t_calegdpdri.foto, t_calegdpdri.warna, t_calegdpdri.dapil FROM (t_calegdpdri INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdpdri.dapil) order by t_calegdpdri.no_urut asc';

implementation

uses udatamodule, uutama;

{$R *.lfm}

{ TFTambahCalegDPDRI }

procedure TFTambahCalegDPDRI.CBDapilKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCalegDPDRI.ENoUrutKeyPress(Sender: TObject; var Key: char);
begin
      if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahCalegDPDRI.ImageFotoClick(Sender: TObject);
begin
  if FUtama.OPD.Execute then
  ImageFoto.Picture.LoadFromFile(FUtama.OPD.FileName);
end;

procedure TFTambahCalegDPDRI.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahCalegDPDRI.BSimpanClick(Sender: TObject);
begin
  if (ENoUrut.Text='') or (ENamaCaleg.Text='') or (CBDapil.Text='') or (CBDapil.Text='-Pilih-') or (FUtama.OPD.FileName='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_calegdpdri',3)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
         if not (ExtractFileName(FUtama.OPD.FileName)=LNamaImage.Caption) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+LNamaImage.Caption);
         CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+ExtractFileName(FUtama.OPD.FileName));
         RenameFile(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+ENoUrut.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName));
          with DM.ZQDPDRI do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_calegdpdri set nama_caleg="'+ENamaCaleg.Text+'",dapil="'+getIdProv(CBDapil.Text)+'",foto="'+ENoUrut.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName)+'",warna="'+CBWarna.Text+'" where no_urut="'+ENoUrut.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          LNamaImage.Caption:=ENoUrut.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName);
          FUtama.OPD.FileName:=LNamaImage.Caption;
          ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+LNamaImage.Caption);
          MessageDlg('Data CALEG DPD RI Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
    fcalegdpd.AmbilGambar;
  end;
end;

procedure TFTambahCalegDPDRI.hapus;
begin
ENoUrut.Text:=noOtomatis(1);
ENamaCaleg.Text:='';
CBDapil.Text:='-Pilih-';
FUtama.OPD.FileName:='';
ImageFoto.Picture.Clear;
BSimpan.Enabled:=True;
ENoUrut.Enabled:=True;
CBWarna.Selected:=clBlack;
end;

function TFTambahCalegDPDRI.noOtomatis(tambah: integer): string;
begin
  Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_calegdpdri';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahCalegDPDRI.setCB;
var
  k : integer;
begin
  CBDapil.Items.Clear;
  DM.ZQProv.First;
  for k:= 1 to DM.ZQProv.RecordCount do
  begin
  CBDapil.Items.Add(DM.ZQProv.FieldByName('nama_provinsi').AsString);
  DM.ZQProv.Next;
  end;
end;

function TFTambahCalegDPDRI.getIdProv(nama: string): string;
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

procedure TFTambahCalegDPDRI.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_calegdpdri where no_urut="'+ENoUrut.Text+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('Data CALEG DPD RI Sudah Ada!',mtWarning,[mbok],0) else
  begin
    // Copy File
    if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+ExtractFileName(FUtama.OPD.FileName)) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+ExtractFileName(FUtama.OPD.FileName));
    CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+ExtractFileName(FUtama.OPD.FileName));
    RenameFile(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+ENoUrut.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName));
    with DM.ZQDPDRI do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_calegdpdri (no_urut,nama_caleg,dapil,foto,warna) values ("'+ENoUrut.Text+'","'+ENamaCaleg.Text+'","'+getIdProv(CBDapil.Text)+'","'+ENoUrut.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName)+'","'+CBWarna.Text+'")';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
 // BSimpan.Enabled:=False;
    MessageDlg('Data CALEG DPD RI Berhasil Disimpan!',mtInformation,[mbok],0);
  end;
end;

end.

