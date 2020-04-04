unit utambahcalegdprri;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ColorBox, ucekserial;

type

  { TFTambahCalegDPRRI }

  TFTambahCalegDPRRI = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBPartai: TComboBox;
    CBDapil: TComboBox;
    CBWarna: TColorBox;
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
    LNamaImage: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    ShapeGambar: TShape;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBDapilKeyPress(Sender: TObject; var Key: char);
    procedure CBPartaiKeyPress(Sender: TObject; var Key: char);
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
  function getIdPartai(nama:string):string;
  function getIdDapil(nama:string):string;
  procedure simpan;
  end;

var
  FTambahCalegDPRRI: TFTambahCalegDPRRI;

  const
    query = 'SELECT t_calegdprri.id, t_calegdprri.no_urut, t_calegdprri.nama_caleg, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprri.foto, t_calegdprri.warna, t_calegdprri.dapil FROM ((t_calegdprri INNER JOIN t_dapil ON t_calegdprri.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprri.partai) order by t_calegdprri.id asc';

implementation

uses udatamodule, uutama;

{$R *.lfm}

{ TFTambahCalegDPRRI }

procedure TFTambahCalegDPRRI.CBPartaiKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCalegDPRRI.EIDKeyPress(Sender: TObject; var Key: char);
begin
        if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahCalegDPRRI.ENoUrutKeyPress(Sender: TObject; var Key: char);
begin
      if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahCalegDPRRI.ImageFotoClick(Sender: TObject);
begin
    if FUtama.OPD.Execute then
  ImageFoto.Picture.LoadFromFile(FUtama.OPD.FileName);
end;

procedure TFTambahCalegDPRRI.CBDapilKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahCalegDPRRI.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahCalegDPRRI.BSimpanClick(Sender: TObject);
begin
  if (EID.Text='') or (ENoUrut.Text='') or (ENamaCaleg.Text='') or (CBPartai.Text='') or (CBPartai.Text='-Pilih-') or (CBDapil.Text='') or (CBDapil.Text='-Pilih-') or (FUtama.OPD.FileName='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
    // Simpan
    if (BSimpan.Caption='Simpan') then
    begin

     if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_calegdprri',3)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end else
     // Update
     if (BSimpan.Caption='Perbarui') then
     begin
         if not (ExtractFileName(FUtama.OPD.FileName)=LNamaImage.Caption) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+LNamaImage.Caption);
         CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+ExtractFileName(FUtama.OPD.FileName));
         RenameFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName));
          with DM.ZQDPRRI do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_calegdprri set no_urut="'+EID.Text+'",nama_caleg="'+ENamaCaleg.Text+'",partai="'+getIdPartai(CBPartai.Text)+'",dapil="'+getIdDapil(CBDapil.Text)+'",foto="'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName)+'",warna="'+CBWarna.Text+'" where id="'+EID.Text+'"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:=query;
            Open;
          end;
          LNamaImage.Caption:=EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName);
          FUtama.OPD.FileName:=LNamaImage.Caption;
          ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+LNamaImage.Caption);
          MessageDlg('Data CALEG DPR RI Berhasil Diperbarui!',mtInformation,[mbok],0);
     end;
    fcalegdpr.AmbilGambar;
  end;
end;

procedure TFTambahCalegDPRRI.hapus;
begin
EID.Text:=noOtomatis(1);
ENoUrut.Text:=noOtomatis(1);
ENamaCaleg.Text:='';
CBPartai.Text:='-Pilih-';
CBDapil.Text:='-Pilih-';
FUtama.OPD.FileName:='';
ImageFoto.Picture.Clear;
BSimpan.Enabled:=True;
EID.Enabled:=True;
CBWarna.Selected:=clBlack;
end;

function TFTambahCalegDPRRI.noOtomatis(tambah: integer): string;
begin
  Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_calegdprri';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahCalegDPRRI.setCB;
var
  j,k : integer;
begin
  CBPartai.Items.Clear;
  CBDapil.Items.Clear;
  DM.ZQPartai.First;
  for j:= 1 to DM.ZQPartai.RecordCount do
  begin
  CBPartai.Items.Add(DM.ZQPartai.FieldByName('nama_partai').AsString);
  DM.ZQPartai.Next;
  end;
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapil where kategori="DPR RI"';
  Open;
  end;
  DM.ZQCari.First;
  for k:= 1 to DM.ZQCari.RecordCount do
  begin
  CBDapil.Items.Add(DM.ZQCari.FieldByName('nama_dapil').AsString);
  DM.ZQCari.Next;
  end;
end;

function TFTambahCalegDPRRI.getIdPartai(nama: string): string;
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

function TFTambahCalegDPRRI.getIdDapil(nama: string): string;
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

procedure TFTambahCalegDPRRI.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_calegdprri where id="'+EID.Text+'" and partai="'+getIdPartai(CBPartai.Text)+'" and dapil="'+getIdDapil(CBDapil.Text)+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('Data CALEG DPR RI Sudah Ada!',mtWarning,[mbok],0) else
  begin
    // Copy File
    if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+ExtractFileName(FUtama.OPD.FileName)) then DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+ExtractFileName(FUtama.OPD.FileName));
    CopyFile(FUtama.OPD.FileName,ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+ExtractFileName(FUtama.OPD.FileName));
    RenameFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+ExtractFileName(FUtama.OPD.FileName),ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName));
    with DM.ZQDPRRI do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_calegdprri (id,no_urut,nama_caleg,partai,dapil,foto,warna) values ("'+EID.Text+'","'+ENoUrut.Text+'","'+ENamaCaleg.Text+'","'+getIdPartai(CBPartai.Text)+'","'+getIdDapil(CBDapil.Text)+'","'+EID.Text+CBDapil.Text+ExtractFileExt(FUtama.OPD.FileName)+'","'+CBWarna.Text+'")';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  //  BSimpan.Enabled:=False;
    MessageDlg('Data CALEG DPR RI Berhasil Disimpan!',mtInformation,[mbok],0);
  end;
end;

end.

