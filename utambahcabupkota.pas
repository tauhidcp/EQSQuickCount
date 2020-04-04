unit utambahcabupkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ColorBox, ucekserial;

type

  { TFTambahCabupKota }

  TFTambahCabupKota = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBProv: TComboBox;
    CBWarna: TColorBox;
    CBDaerah: TComboBox;
    ENamaAkronim: TEdit;
    ENamaCabup: TEdit;
    ENamaCawabup: TEdit;
    ENoUrut: TEdit;
    ImageFoto: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LNamaImage: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    ShapeGambar: TShape;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBDaerahKeyPress(Sender: TObject; var Key: char);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
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
  function getIdProv(nama:String):String;
  procedure setCBKabSesuai(nama:string);
  procedure simpan;
  end;

var
  FTambahCabupKota: TFTambahCabupKota;

const
  query = 'SELECT t_cabupkota.no_urut, t_cabupkota.nama_cabup, t_cabupkota.nama_cawabup, t_cabupkota.nama_akronim, t_kabkota.nama_kota, t_cabupkota.foto, t_cabupkota.warna FROM (t_cabupkota INNER JOIN t_kabkota ON t_kabkota.id_kota=t_cabupkota.daerah) order by t_cabupkota.no_urut asc';

implementation

uses udatamodule, ucabupkota, uutama;

{$R *.lfm}

{ TFTambahCabupKota }

procedure TFTambahCabupKota.ImageFotoClick(Sender: TObject);
begin
    if FUtama.OPD.Execute then
  ImageFoto.Picture.LoadFromFile(FUtama.OPD.FileName);
end;

procedure TFTambahCabupKota.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahCabupKota.BSimpanClick(Sender: TObject);
begin
    if (ENoUrut.Text='') or (ENamaCabup.Text='') or (ENamaCawabup.Text='') or (ENamaAkronim.Text='') or (CBProv.Text='') or (CBProv.Text='-Pilih-') or (CBDaerah.Text='') or (CBDaerah.Text='-Pilih-') or (FUtama.OPD.FileName='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_cabupkota',3)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
         if not (ExtractFileName(FUtama.OPD.FileName)=LNamaImage.Caption) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\cabup\'+LNamaImage.Caption);
         CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\cabup\'+ExtractFileName(FUtama.OPD.FileName));
         RenameFile(ExtractFilePath(Application.ExeName)+'img\cabup\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\cabup\'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName));
          with DM.ZQCabupKota do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_cabupkota set nama_cabup="'+ENamaCabup.Text+'",nama_cawabup="'+ENamaCawabup.Text+'",nama_akronim="'+ENamaAkronim.Text+'",daerah="'+getDaerah(CBDaerah.Text)+'",foto="'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName)+'",warna="'+CBWarna.Text+'" where no_urut="'+ENoUrut.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          LNamaImage.Caption:=ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName);
          FUtama.OPD.FileName:=LNamaImage.Caption;
          ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\cabup\'+LNamaImage.Caption);
          MessageDlg('Data CABUP/Kota Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
    fcabupkota.AmbilGambar;
  end;
end;

procedure TFTambahCabupKota.CBDaerahKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCabupKota.CBProvChange(Sender: TObject);
begin
  setCBKabSesuai(CBProv.Text);
end;

procedure TFTambahCabupKota.CBProvKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCabupKota.ENoUrutKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahCabupKota.hapus;
begin
  ENoUrut.Text:=noOtomatis(1);
  ENamaCabup.Text:='';
  ENamaCawabup.Text:='';
  ENamaAkronim.Text:='';
  FUtama.OPD.FileName:='';
  CBProv.Text:='-Pilih-';
  CBDaerah.Text:='-Pilih-';
  ImageFoto.Picture.Clear;
  BSimpan.Enabled:=True;
  ENoUrut.Enabled:=True;
  CBWarna.Selected:=clBlack;
end;

procedure TFTambahCabupKota.setCB;
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

  CBDaerah.Items.Clear;
  DM.ZQKabKota.First;
  for i:= 1 to DM.ZQKabKota.RecordCount do
  begin
  CBDaerah.Items.Add(DM.ZQKabKota.FieldByName('nama_kota').AsString);
  DM.ZQKabKota.Next;
  end;
end;

function TFTambahCabupKota.getDaerah(NamaDaerah: String): String;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_kota as id from t_kabkota where nama_kota="'+NamaDaerah+'"';
   Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFTambahCabupKota.getIdProv(nama: String): String;
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

function TFTambahCabupKota.noOtomatis(tambah: integer): string;
begin
    Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_cabupkota';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahCabupKota.setCBKabSesuai(nama: string);
var
  i : integer;
begin
  CBDaerah.Items.Clear;
  CBDaerah.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kota from t_kabkota where id_provinsi="'+getIdProv(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBDaerah.Items.Add(DM.ZQCari.FieldByName('nama_kota').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFTambahCabupKota.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_cabupkota where no_urut="'+ENoUrut.Text+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('Data CABUP/Kota Sudah Ada!',mtWarning,[mbok],0) else
  begin
    // Copy File
    if FileExists(ExtractFilePath(Application.ExeName)+'img\cabup\'+ExtractFileName(FUtama.OPD.FileName)) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\cabup\'+ExtractFileName(FUtama.OPD.FileName));
    CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\cabup\'+ExtractFileName(FUtama.OPD.FileName));
    RenameFile(ExtractFilePath(Application.ExeName)+'img\cabup\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\cabup\'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName));
    with DM.ZQCabupKota do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_cabupkota (no_urut,nama_cabup,nama_cawabup,nama_akronim,daerah,foto,warna) values ("'+ENoUrut.Text+'","'+ENamaCabup.Text+'","'+ENamaCawabup.Text+'","'+ENamaAkronim.Text+'","'+getDaerah(CBDaerah.Text)+'","'+ENoUrut.Text+ENamaAkronim.Text+ExtractFileExt(FUtama.OPD.FileName)+'","'+CBWarna.Text+'")';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  //  BSimpan.Enabled:=False;
    MessageDlg('Data CABUP/Kota Berhasil Disimpan!',mtInformation,[mbok],0);
  end;
end;

end.

