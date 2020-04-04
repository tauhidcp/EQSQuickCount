unit utambahcalegdprdkabkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ColorBox, ucekserial;

type

  { TFTambahCalegKabKota }

  TFTambahCalegKabKota = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBPartai: TComboBox;
    CBKabKota: TComboBox;
    CBProv: TComboBox;
    CBWarna: TColorBox;
    CBDapil: TComboBox;
    EID: TEdit;
    ENamaCaleg: TEdit;
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
    Label9: TLabel;
    LNamaImage: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    ShapeGambar: TShape;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBKabKotaChange(Sender: TObject);
    procedure CBPartaiKeyPress(Sender: TObject; var Key: char);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure CBDapilKeyPress(Sender: TObject; var Key: char);
    procedure EIDKeyPress(Sender: TObject; var Key: char);
    procedure ENoUrutKeyPress(Sender: TObject; var Key: char);
    procedure ImageFotoClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  function noOtomatis(tambah:integer):string;
  procedure setCB;
  function getIdKabkota(nama:string):string;
  function getIdPartai(nama:string):string;
  function getIdDapil(nama:string):string;
  procedure setCBSesuai(nama:string);
  function getIdProv(nama:String):String;
  procedure setCBKabSesuai(nama:string);
  procedure simpan;
  end;

var
  FTambahCalegKabKota: TFTambahCalegKabKota;

  const
    query = 'SELECT t_calegdprdkabkota.id, t_calegdprdkabkota.no_urut, t_calegdprdkabkota.nama_caleg, t_kabkota.nama_kota, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprdkabkota.foto, t_calegdprdkabkota.warna, t_calegdprdkabkota.dapil FROM (((t_calegdprdkabkota INNER JOIN t_dapil ON t_calegdprdkabkota.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdkabkota.partai) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_calegdprdkabkota.kabkota) order by t_calegdprdkabkota.id asc';

implementation

uses udatamodule, uutama;

{$R *.lfm}

{ TFTambahCalegKabKota }

procedure TFTambahCalegKabKota.CBProvKeyPress(Sender: TObject; var Key: char
  );
begin
  key:=#0;
end;

procedure TFTambahCalegKabKota.CBPartaiKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCalegKabKota.CBProvChange(Sender: TObject);
begin
  CBKabKota.Items.Clear;
  CBKabKota.Text:='-Pilih-';
  setCBKabSesuai(CBProv.Text);
end;

procedure TFTambahCalegKabKota.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahCalegKabKota.BSimpanClick(Sender: TObject);
begin
  if (EID.Text='') or (ENoUrut.Text='') or (ENamaCaleg.Text='') or (CBKabKota.Text='') or (CBKabKota.Text='-Pilih-') or (CBPartai.Text='') or (CBPartai.Text='-Pilih-')
  or (CBProv.Text='') or (CBProv.Text='-Pilih-') or (CBDapil.Text='') or (CBDapil.Text='-Pilih-') or (FUtama.OPD.FileName='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_calegdprdkabkota',3)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
         if not (ExtractFileName(FUtama.OPD.FileName)=LNamaImage.Caption) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+LNamaImage.Caption);
         CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+ExtractFileName(FUtama.OPD.FileName));
         RenameFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName));
          with DM.ZQDPRDKab do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_calegdprdkabkota set no_urut="'+ENoUrut.Text+'",nama_caleg="'+ENamaCaleg.Text+'",kabkota="'+getIdKabkota(CBKabKota.Text)+'",partai="'+getIdPartai(CBPartai.Text)+'",dapil="'+getIdDapil(CBDapil.Text)+'",foto="'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName)+'",warna="'+CBWarna.Text+'" where id="'+EID.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          LNamaImage.Caption:=EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName);
          FUtama.OPD.FileName:=LNamaImage.Caption;
          ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+LNamaImage.Caption);
          MessageDlg('Data CALEG DPRD Kabupaten/Kota Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
    fcalegkab.AmbilGambar;
  end;
end;

procedure TFTambahCalegKabKota.CBKabKotaChange(Sender: TObject);
begin
  CBDapil.Items.Clear;
  CBDapil.Text:='-Pilih-';
  setCBSesuai(CBKabKota.Text);
end;

procedure TFTambahCalegKabKota.CBKabKotaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCalegKabKota.CBDapilKeyPress(Sender: TObject; var Key: char
  );
begin
  key:=#0;
end;

procedure TFTambahCalegKabKota.EIDKeyPress(Sender: TObject; var Key: char);
begin
 if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahCalegKabKota.ENoUrutKeyPress(Sender: TObject; var Key: char);
begin
if not (key in['0'..'9',#8,#13,#32]) then
 begin
   key:=#0;
 end;
end;

procedure TFTambahCalegKabKota.ImageFotoClick(Sender: TObject);
begin
  if FUtama.OPD.Execute then
  ImageFoto.Picture.LoadFromFile(FUtama.OPD.FileName);
end;


procedure TFTambahCalegKabKota.hapus;
begin
  EID.Text:=noOtomatis(1);
  ENoUrut.Text:=noOtomatis(1);
  ENamaCaleg.Text:='';
  CBProv.Text:='-Pilih-';
  CBKabKota.Text:='-Pilih-';
  CBPartai.Text:='-Pilih-';
  CBDapil.Text:='-Pilih-';
  FUtama.OPD.FileName:='';
  ImageFoto.Picture.Clear;
  BSimpan.Enabled:=True;
  EID.Enabled:=True;
  CBWarna.Selected:=clBlack;
end;

function TFTambahCalegKabKota.noOtomatis(tambah: integer): string;
begin
  Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_calegdprdkabkota';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahCalegKabKota.setCB;
var
  i,j,k : integer;
begin
  CBProv.Items.Clear;
  CBKabKota.Items.Clear;
  CBPartai.Items.Clear;
  CBDapil.Items.Clear;
  DM.ZQProv.First;
  for i:= 1 to DM.ZQProv.RecordCount do
  begin
  CBProv.Items.Add(DM.ZQProv.FieldByName('nama_provinsi').AsString);
  DM.ZQProv.Next;
  end;
  DM.ZQKabKota.First;
  for i:= 1 to DM.ZQKabKota.RecordCount do
  begin
  CBKabKota.Items.Add(DM.ZQKabKota.FieldByName('nama_kota').AsString);
  DM.ZQKabKota.Next;
  end;
  DM.ZQPartai.First;
  for j:= 1 to DM.ZQPartai.RecordCount do
  begin
  CBPartai.Items.Add(DM.ZQPartai.FieldByName('nama_partai').AsString);
  DM.ZQPartai.Next;
  end;
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapil where kategori="DPRD Kabupaten/Kota"';
  Open;
  end;
  DM.ZQCari.First;
  for k:= 1 to DM.ZQCari.RecordCount do
  begin
  CBDapil.Items.Add(DM.ZQCari.FieldByName('nama_dapil').AsString);
  DM.ZQCari.Next;
  end;
end;

function TFTambahCalegKabKota.getIdKabkota(nama: string): string;
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

function TFTambahCalegKabKota.getIdPartai(nama: string): string;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select no_urut as id from t_partai where nama_partai="'+nama+'"';
   Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFTambahCalegKabKota.getIdDapil(nama: string): string;
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

procedure TFTambahCalegKabKota.setCBSesuai(nama: string);
var
  k : integer;
begin
  with DM.ZQCari do begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_dapil where kategori="DPRD Kabupaten/Kota" and kabkotaprov="'+getIdKabkota(CBKabKota.Text)+'"';
    Open;
    end;
    DM.ZQCari.First;
    for k:= 1 to DM.ZQCari.RecordCount do
    begin
    CBDapil.Items.Add(DM.ZQCari.FieldByName('nama_dapil').AsString);
    DM.ZQCari.Next;
    end;
end;

function TFTambahCalegKabKota.getIdProv(nama: String): String;
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

procedure TFTambahCalegKabKota.setCBKabSesuai(nama: string);
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

procedure TFTambahCalegKabKota.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_calegdprdkabkota where id="'+EID.Text+'" and kabkota="'+getIdKabkota(CBProv.Text)+'" and partai="'+getIdPartai(CBKabKota.Text)+'" and dapil="'+getIdDapil(CBPartai.Text)+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('Data CALEG Kabupaten/Kota Sudah Ada!',mtWarning,[mbok],0) else
  begin
    // Copy File
    if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+ExtractFileName(FUtama.OPD.FileName)) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+ExtractFileName(FUtama.OPD.FileName));
    CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+ExtractFileName(FUtama.OPD.FileName));
    RenameFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName));
    with DM.ZQDPRDKab do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_calegdprdkabkota (id,no_urut,nama_caleg,kabkota,partai,dapil,foto,warna) values ("'+EID.Text+'","'+ENoUrut.Text+'","'+ENamaCaleg.Text+'","'+getIdKabkota(CBKabKota.Text)+'","'+getIdPartai(CBPartai.Text)+'","'+getIdDapil(CBDapil.Text)+'","'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName)+'","'+CBWarna.Text+'")';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  //  BSimpan.Enabled:=False;
    MessageDlg('Data CALEG DPRD Kabupaten/Kota Berhasil Disimpan!',mtInformation,[mbok],0);
  end;
end;

end.

