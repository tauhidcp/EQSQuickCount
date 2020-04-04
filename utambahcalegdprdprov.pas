unit utambahcalegdprdprov;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ColorBox, ucekserial;

type

  { TFTambahCalegDPRDProvinsi }

  TFTambahCalegDPRDProvinsi = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBProv: TComboBox;
    CBPartai: TComboBox;
    CBDapil: TComboBox;
    CBWarna: TColorBox;
    ENamaCaleg: TEdit;
    ENoUrut: TEdit;
    EID: TEdit;
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
    procedure CBDapilKeyPress(Sender: TObject; var Key: char);
    procedure CBPartaiKeyPress(Sender: TObject; var Key: char);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
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
  function getIdProvinsi(nama:string):string;
  function getIdPartai(nama:string):string;
  function getIdDapil(nama:string):string;
  procedure setCBSesuai(nama:string);
  procedure simpan;
  end;

var
  FTambahCalegDPRDProvinsi: TFTambahCalegDPRDProvinsi;

const
 query = 'SELECT t_calegdprdprov.id, t_calegdprdprov.no_urut, t_calegdprdprov.nama_caleg, t_provinsi.nama_provinsi, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprdprov.foto, t_calegdprdprov.warna, t_calegdprdprov.dapil FROM (((t_calegdprdprov INNER JOIN t_dapil ON t_calegdprdprov.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdprov.partai) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdprdprov.prov) order by t_calegdprdprov.id asc';

implementation

uses udatamodule, uutama;

{$R *.lfm}

{ TFTambahCalegDPRDProvinsi }

procedure TFTambahCalegDPRDProvinsi.CBProvKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCalegDPRDProvinsi.EIDKeyPress(Sender: TObject;
  var Key: char);
begin
 if not (key in['0'..'9',#8,#13,#32]) then
 begin
   key:=#0;
 end;
end;

procedure TFTambahCalegDPRDProvinsi.ENoUrutKeyPress(Sender: TObject;
  var Key: char);
begin
 if not (key in['0'..'9',#8,#13,#32]) then
 begin
   key:=#0;
 end;
end;

procedure TFTambahCalegDPRDProvinsi.ImageFotoClick(Sender: TObject);
begin
    if FUtama.OPD.Execute then
  ImageFoto.Picture.LoadFromFile(FUtama.OPD.FileName);
end;

procedure TFTambahCalegDPRDProvinsi.CBPartaiKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCalegDPRDProvinsi.CBProvChange(Sender: TObject);
begin
  CBDapil.Items.Clear;
  CBDapil.Text:='-Pilih-';
  setCBSesuai(CBProv.Text);
end;

procedure TFTambahCalegDPRDProvinsi.CBDapilKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCalegDPRDProvinsi.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahCalegDPRDProvinsi.BSimpanClick(Sender: TObject);
begin
  if (EID.Text='') or (ENoUrut.Text='') or (ENamaCaleg.Text='') or (CBPartai.Text='') or (CBPartai.Text='-Pilih-') or (CBDapil.Text='') or (CBDapil.Text='-Pilih-')
  or (CBProv.Text='') or (CBProv.Text='-Pilih-') or (FUtama.OPD.FileName='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_calegdprdprov',3)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
         if not (ExtractFileName(FUtama.OPD.FileName)=LNamaImage.Caption) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+LNamaImage.Caption);
         CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+ExtractFileName(FUtama.OPD.FileName));
         RenameFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName));
          with DM.ZQDPRDProv do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_calegdprdprov set no_urut="'+ENoUrut.Text+'",nama_caleg="'+ENamaCaleg.Text+'",prov="'+getIdProvinsi(CBProv.Text)+'",partai="'+getIdPartai(CBPartai.Text)+'",dapil="'+getIdDapil(CBDapil.Text)+'",foto="'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName)+'",warna="'+CBWarna.Text+'" where id="'+EID.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          LNamaImage.Caption:=EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName);
          FUtama.OPD.FileName:=LNamaImage.Caption;
          ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+LNamaImage.Caption);
          MessageDlg('Data CALEG DPRD Provinsi Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
    fcalegprov.AmbilGambar;
  end;
end;

procedure TFTambahCalegDPRDProvinsi.hapus;
begin
  EID.Text:=noOtomatis(1);
  ENoUrut.Text:=noOtomatis(1);
  ENamaCaleg.Text:='';
  CBProv.Text:='-Pilih-';
  CBPartai.Text:='-Pilih-';
  CBDapil.Text:='-Pilih-';
  FUtama.OPD.FileName:='';
  ImageFoto.Picture.Clear;
  BSimpan.Enabled:=True;
  EID.Enabled:=True;
  CBWarna.Selected:=clBlack;
end;

function TFTambahCalegDPRDProvinsi.noOtomatis(tambah: integer): string;
begin
  Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_calegdprdprov';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahCalegDPRDProvinsi.setCB;
var
  i,j,k : integer;
begin
  CBProv.Items.Clear;
  CBPartai.Items.Clear;
  CBDapil.Items.Clear;
  DM.ZQProv.First;
  for i:= 1 to DM.ZQProv.RecordCount do
  begin
  CBProv.Items.Add(DM.ZQProv.FieldByName('nama_provinsi').AsString);
  DM.ZQProv.Next;
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
  SQL.Text:='select * from t_dapil where kategori="DPRD Provinsi"';
  Open;
  end;
  DM.ZQCari.First;
  for k:= 1 to DM.ZQCari.RecordCount do
  begin
  CBDapil.Items.Add(DM.ZQCari.FieldByName('nama_dapil').AsString);
  DM.ZQCari.Next;
  end;
end;

function TFTambahCalegDPRDProvinsi.getIdProvinsi(nama: string): string;
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

function TFTambahCalegDPRDProvinsi.getIdPartai(nama: string): string;
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

function TFTambahCalegDPRDProvinsi.getIdDapil(nama: string): string;
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

procedure TFTambahCalegDPRDProvinsi.setCBSesuai(nama: string);
var
  k : integer;
begin
    with DM.ZQCari do begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_dapil where kategori="DPRD Provinsi" and kabkotaprov="'+getIdProvinsi(CBProv.Text)+'"';
    Open;
    end;
    DM.ZQCari.First;
    for k:= 1 to DM.ZQCari.RecordCount do
    begin
    CBDapil.Items.Add(DM.ZQCari.FieldByName('nama_dapil').AsString);
    DM.ZQCari.Next;
    end;
end;

procedure TFTambahCalegDPRDProvinsi.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_calegdprdprov where id="'+EID.Text+'" and prov="'+getIdProvinsi(CBProv.Text)+'" and partai="'+getIdPartai(CBPartai.Text)+'" and dapil="'+getIdDapil(CBDapil.Text)+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('Data CALEG DPRD Provinsi Sudah Ada!',mtWarning,[mbok],0) else
  begin
    // Copy File
    if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+ExtractFileName(FUtama.OPD.FileName)) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+ExtractFileName(FUtama.OPD.FileName));
    CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+ExtractFileName(FUtama.OPD.FileName));
    RenameFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName));
    with DM.ZQDPRDProv do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_calegdprdprov (id,no_urut,nama_caleg,prov,partai,dapil,foto,warna) values ("'+EID.Text+'","'+ENoUrut.Text+'","'+ENamaCaleg.Text+'","'+getIdProvinsi(CBProv.Text)+'","'+getIdPartai(CBPartai.Text)+'","'+getIdDapil(CBDapil.Text)+'","'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName)+'","'+CBWarna.Text+'")';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  //  BSimpan.Enabled:=False;
    MessageDlg('Data CALEG DPRD Provinsi Berhasil Disimpan!',mtInformation,[mbok],0);
  end;
end;

end.

