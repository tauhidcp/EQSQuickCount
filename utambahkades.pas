unit utambahkades;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ColorBox, ucekserial, ucakades;

type

  { TFTambahKades }

  TFTambahKades = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBKabKota: TComboBox;
    CBProv: TComboBox;
    CBWarna: TColorBox;
    CBKec: TComboBox;
    CBKel: TComboBox;
    ENamaKades: TEdit;
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
    procedure CBKabKotaChange(Sender: TObject);
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure CBKecChange(Sender: TObject);
    procedure CBKecKeyPress(Sender: TObject; var Key: char);
    procedure CBKelKeyPress(Sender: TObject; var Key: char);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure ImageFotoClick(Sender: TObject);
  private

  public
    procedure hapus;
    procedure setCB;
    function noOtomatis(tambah:integer):string;
    procedure simpan;
    function getKel(namakel:string):string;
    procedure setCBKabKotaSesuai(nama:string);
    procedure setCBKecSesuai(nama:string);
    procedure setCBKelSesuai(nama:string);
    function getIdProv(nama:string):string;
    function getIdKabkota(nama:string):string;
    function getIdKec(nama:string):string;
  end;

var
  FTambahKades: TFTambahKades;

const
  query = 'SELECT t_cakades.no_urut, t_cakades.nama_kades, t_kelurahan.nama_kelurahan, t_cakades.foto, t_cakades.warna FROM (t_cakades INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_cakades.daerah) order by t_cakades.no_urut asc';

implementation

uses udatamodule, uutama;

{$R *.lfm}

{ TFTambahKades }

procedure TFTambahKades.CBProvKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahKades.ImageFotoClick(Sender: TObject);
begin
  if FUtama.OPD.Execute then
  ImageFoto.Picture.LoadFromFile(FUtama.OPD.FileName);
end;

procedure TFTambahKades.hapus;
begin
  ENoUrut.Text:=noOtomatis(1);
  ENamaKades.Text:='';
  FUtama.OPD.FileName:='';
  CBProv.Text:='-Pilih-';
  CBKabKota.Text:='-Pilih-';
  CBKec.Text:='-Pilih-';
  CBKel.Text:='-Pilih-';
  ImageFoto.Picture.Clear;
  BSimpan.Enabled:=True;
  ENoUrut.Enabled:=True;
  CBWarna.Selected:=clBlack;
end;

procedure TFTambahKades.setCB;
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

  CBKec.Items.Clear;
  DM.ZQKec.First;
  for i:= 1 to DM.ZQKec.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQKec.FieldByName('nama_kecamatan').AsString);
  DM.ZQKec.Next;
  end;

  CBKel.Items.Clear;
  DM.ZQKelDesa.First;
  for i:= 1 to DM.ZQKelDesa.RecordCount do
  begin
  CBKel.Items.Add(DM.ZQKelDesa.FieldByName('nama_kelurahan').AsString);
  DM.ZQKelDesa.Next;
  end;
end;

function TFTambahKades.noOtomatis(tambah: integer): string;
begin
  Result := '';
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_cakades';
  Open;
  end;
  Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;


procedure TFTambahKades.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_cakades where no_urut="'+ENoUrut.Text+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('Data Calon KADES Sudah Ada!',mtWarning,[mbok],0) else
  begin
    // Copy File
    if FileExists(ExtractFilePath(Application.ExeName)+'img\cakades\'+ExtractFileName(FUtama.OPD.FileName)) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\cakades\'+ExtractFileName(FUtama.OPD.FileName));
    CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\cakades\'+ExtractFileName(FUtama.OPD.FileName));
    RenameFile(ExtractFilePath(Application.ExeName)+'img\cakades\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\cakades\'+ENoUrut.Text+ExtractFileExt(FUtama.OPD.FileName));
    with DM.ZQKades do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_cakades (no_urut,nama_kades,daerah,foto,warna) values ("'+ENoUrut.Text+'","'+ENamaKades.Text+'","'+getKel(CBKel.Text)+'","'+ENoUrut.Text+ExtractFileExt(FUtama.OPD.FileName)+'","'+CBWarna.Text+'")';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  //  BSimpan.Enabled:=False;
    MessageDlg('Data Calon KADES Berhasil Disimpan!',mtInformation,[mbok],0);
  end;
end;

function TFTambahKades.getKel(namakel: string): string;
begin
  Result:='';
  with DM.ZQCari2 do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_kelurahan as id from t_kelurahan where nama_kelurahan="'+namakel+'"';
   Open;
  end;
  if DM.ZQCari2.RecordCount>=1 then
  Result:=DM.ZQCari2.FieldByName('id').AsString;
end;

procedure TFTambahKades.setCBKabKotaSesuai(nama: string);
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

procedure TFTambahKades.setCBKecSesuai(nama: string);
var
  i : integer;
begin
  CBKec.Items.Clear;
  CBKec.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kecamatan from t_kecamatan where id_kota="'+getIdKabkota(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQCari.FieldByName('nama_kecamatan').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFTambahKades.setCBKelSesuai(nama: string);
var
  i : integer;
begin
  CBKel.Items.Clear;
  CBKel.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kelurahan from t_kelurahan where id_kecamatan="'+getIdKec(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKel.Items.Add(DM.ZQCari.FieldByName('nama_kelurahan').AsString);
  DM.ZQCari.Next;
  end;

end;

function TFTambahKades.getIdProv(nama: string): string;
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

function TFTambahKades.getIdKabkota(nama: string): string;
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

function TFTambahKades.getIdKec(nama: string): string;
begin
  Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_kecamatan as id from t_kecamatan where nama_kecamatan="'+nama+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFTambahKades.CBKabKotaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahKades.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFTambahKades.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahKades.BSimpanClick(Sender: TObject);
begin
  if (ENoUrut.Text='') or (ENamaKades.Text='') or (CBKel.Text='') or (CBKel.Text='-Pilih-')
  or (CBKec.Text='') or (CBKec.Text='-Pilih-')  or (CBKabKota.Text='') or (CBKabKota.Text='-Pilih-')
  or (CBProv.Text='') or (CBProv.Text='-Pilih-') or (FUtama.OPD.FileName='') then
    MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
    begin
      // Simpan
      if (BSimpan.Caption='Simpan') then
      begin

        if (cekSerial()=True) then
        simpan else
        begin
        if (cekData('t_cakades',3)=True) then
            MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
            simpan;
        end;

       end else
       // Update
       if (BSimpan.Caption='Perbarui') then
       begin
           if not (ExtractFileName(FUtama.OPD.FileName)=LNamaImage.Caption) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\cakades\'+LNamaImage.Caption);
           CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\cakades\'+ExtractFileName(FUtama.OPD.FileName));
           RenameFile(ExtractFilePath(Application.ExeName)+'img\cakades\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\cakades\'+ENoUrut.Text+ExtractFileExt(FUtama.OPD.FileName));
            with DM.ZQKades do
            begin
              Close;
              SQL.Clear;
              SQL.Text:='update t_cakades set nama_kades="'+ENamaKades.Text+'",daerah="'+getKel(CBKel.Text)+'",foto="'+ENoUrut.Text+ExtractFileExt(FUtama.OPD.FileName)+'",warna="'+CBWarna.Text+'" where no_urut="'+ENoUrut.Text+'"';
              ExecSQL;
              SQL.Clear;
              SQL.Text:=query;
              Open;
            end;
            LNamaImage.Caption:=ENoUrut.Text+ExtractFileExt(FUtama.OPD.FileName);
            FUtama.OPD.FileName:=LNamaImage.Caption;
            ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\cakades\'+LNamaImage.Caption);
            MessageDlg('Data Calon KADES Berhasil Diperbarui!',mtInformation,[mbok],0);
       end;
      fckades.AmbilGambar;
    end;
end;

procedure TFTambahKades.CBKabKotaChange(Sender: TObject);
begin
  setCBKecSesuai(CBKabKota.Text);
end;

procedure TFTambahKades.CBKecKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahKades.CBKelKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahKades.CBProvChange(Sender: TObject);
begin
  setCBKabKotaSesuai(CBProv.Text);
end;

end.

