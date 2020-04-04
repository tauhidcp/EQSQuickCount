unit utambahcapres;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ColorBox, ucekserial;

type

  { TFTambahCapres }

  TFTambahCapres = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBWarna: TColorBox;
    ENamaCapres: TEdit;
    ENoUrut: TEdit;
    ENamaCawapres: TEdit;
    ENamaAkronim: TEdit;
    ImageFoto: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LNamaImage: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    ShapeGambar: TShape;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure ENoUrutKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure ImageFotoClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  procedure hapus;
  function noOtomatis(tambah:integer):string;
  procedure simpan;
  end;

var
  FTambahCapres: TFTambahCapres;

const
  query = 'select * from t_capres order by no_urut asc';

implementation

uses udatamodule, ucapres, uutama;

{$R *.lfm}

{ TFTambahCapres }

procedure TFTambahCapres.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahCapres.BSimpanClick(Sender: TObject);
begin
  if (ENoUrut.Text='') or (ENamaCapres.Text='') or (ENamaCawapres.Text='') or (ENamaAkronim.Text='') or (FUtama.OPD.FileName='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_capres',3)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

    end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
         if not (ExtractFileName(FUtama.OPD.FileName)=LNamaImage.Caption) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\capres\'+LNamaImage.Caption);
         CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\capres\'+ExtractFileName(FUtama.OPD.FileName));
         RenameFile(ExtractFilePath(Application.ExeName)+'img\capres\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\capres\'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName));
          with DM.ZQCapres do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_capres set nama_capres="'+ENamaCapres.Text+'",nama_cawapres="'+ENamaCawapres.Text+'",nama_akronim="'+ENamaAkronim.Text+'",foto="'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName)+'",warna="'+CBWarna.Text+'" where no_urut="'+ENoUrut.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          LNamaImage.Caption:=ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName);
          FUtama.OPD.FileName:=LNamaImage.Caption;
          ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\capres\'+LNamaImage.Caption);
          MessageDlg('Data CAPRES Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
    fcapres.AmbilGambar;
  end;
end;


procedure TFTambahCapres.ENoUrutKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahCapres.FormKeyPress(Sender: TObject; var Key: char);
begin
      if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahCapres.ImageFotoClick(Sender: TObject);
begin
  if FUtama.OPD.Execute then
  ImageFoto.Picture.LoadFromFile(FUtama.OPD.FileName);
end;

procedure TFTambahCapres.hapus;
begin
  ENoUrut.Text:=noOtomatis(1);
  ENamaCapres.Text:='';
  ENamaCawapres.Text:='';
  ENamaAkronim.Text:='';
  FUtama.OPD.FileName:='';
  ImageFoto.Picture.Clear;
  BSimpan.Enabled:=True;
  ENoUrut.Enabled:=True;
  CBWarna.Selected:=clBlack;
end;

function TFTambahCapres.noOtomatis(tambah: integer): string;
begin
  Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_capres';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahCapres.simpan;
begin
// Cek Apakah No Urut Sudah ada
    with DM.ZQCari do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='select * from t_capres where no_urut="'+ENoUrut.Text+'"';
      Open;
    end;
    if DM.ZQCari.RecordCount >= 1 then
    MessageDlg('Data CAPRES Dengan No Urut '+ENoUrut.Text+' Sudah Ada!',mtWarning,[mbok],0) else
    begin
      // Copy File
      if FileExists(ExtractFilePath(Application.ExeName)+'img\capres\'+ExtractFileName(FUtama.OPD.FileName)) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\capres\'+ExtractFileName(FUtama.OPD.FileName));
      CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\capres\'+ExtractFileName(FUtama.OPD.FileName));
      RenameFile(ExtractFilePath(Application.ExeName)+'img\capres\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\capres\'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName));
      with DM.ZQCapres do
      begin
        Close;
        SQL.Clear;
        SQL.Text:='insert into t_capres (no_urut,nama_capres,nama_cawapres,nama_akronim,foto,warna) values ("'+ENoUrut.Text+'","'+ENamaCapres.Text+'","'+ENamaCawapres.Text+'","'+ENamaAkronim.Text+'","'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName)+'","'+CBWarna.Text+'")';
        ExecSQL;
        SQL.Clear;
        SQL.Text:=query;
        Open;
      end;
      MessageDlg('Data CAPRES Berhasil Disimpan!',mtInformation,[mbok],0);
    end;
end;

end.

