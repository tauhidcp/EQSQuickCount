unit ucabupkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, Grids, rxdbgrid;

type

  { TFCabupKota }

  TFCabupKota = class(TForm)
    BEdit: TBitBtn;
    BHapus: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridCabupKota: TRxDBGrid;
    ImageCabupKota: TImage;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PImage: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridCabupKotaCellClick(Column: TColumn);
    procedure GridCabupKotaPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
    procedure AmbilGambar;
    function getNamaProv(namakabkota:String):String;
  end;

var
  FCabupKota: TFCabupKota;
  jpg: TJpegImage;

const
  query = 'SELECT t_cabupkota.no_urut, t_cabupkota.nama_cabup, t_cabupkota.nama_cawabup, t_cabupkota.nama_akronim, t_kabkota.nama_kota, t_cabupkota.foto, t_cabupkota.warna FROM (t_cabupkota INNER JOIN t_kabkota ON t_kabkota.id_kota=t_cabupkota.daerah) order by t_cabupkota.no_urut asc';

implementation

uses uutama, udatamodule, utambahcabupkota;

{$R *.lfm}

{ TFCabupKota }

procedure TFCabupKota.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFCabupKota.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridCabupKota.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data CABUP/Kota "'+GridCabupKota.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridCabupKota.DataSource.DataSet.Fields[0].Value;
  // Hapus File
  DeleteFile('img\cabup\'+GridCabupKota.DataSource.DataSet.Fields[5].Value);
  // Hapus Database
  with DM.ZQCabupKota do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_cabupkota where no_urut="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
  end;
  end;
end;

procedure TFCabupKota.BEditClick(Sender: TObject);
begin
  if GridCabupKota.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahCabupKota do
    begin
    setCB;
    Caption:='Ubah Data Cabup/Kota';
    PAtas.Caption:='Form Ubah Data Cabup/Kota';
    BSimpan.Caption:='Perbarui';
    ENoUrut.Enabled:=False;
    BBaru.Enabled:=False;
    ENoUrut.Text:=GridCabupKota.DataSource.DataSet.Fields[0].Value;
    ENamaCabup.Text:=GridCabupKota.DataSource.DataSet.Fields[1].Value;
    ENamaCawabup.Text:=GridCabupKota.DataSource.DataSet.Fields[2].Value;
    ENamaAkronim.Text:=GridCabupKota.DataSource.DataSet.Fields[3].Value;
    CBProv.Text:=getNamaProv(GridCabupKota.DataSource.DataSet.Fields[4].Value);
    CBDaerah.Text:=GridCabupKota.DataSource.DataSet.Fields[4].Value;

    if FileExists(ExtractFilePath(Application.ExeName)+'img\cabup\'+GridCabupKota.DataSource.DataSet.Fields[5].Value) then
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\cabup\'+GridCabupKota.DataSource.DataSet.Fields[5].Value);
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\cabup\'+GridCabupKota.DataSource.DataSet.Fields[5].Value; end else
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\noimage.jpg';
    end;
    LNamaImage.Caption:=GridCabupKota.DataSource.DataSet.Fields[5].Value;
    CBWarna.Selected:=StringToColor(GridCabupKota.DataSource.DataSet.Fields[6].AsString);
    BSimpan.Enabled:=True;
    ShowModal;
    end;
  end;
end;

procedure TFCabupKota.BTambahClick(Sender: TObject);
begin
  with FTambahCabupKota do
  begin
  Hapus;
  setCB;
  Caption:='Tambah Data Cabup/Kota';
  PAtas.Caption:='Form Tambah Data Cabup/Kota';
  ENoUrut.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;

procedure TFCabupKota.GridCabupKotaCellClick(Column: TColumn);
begin
  AmbilGambar;
end;

procedure TFCabupKota.GridCabupKotaPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
    with TStringGrid(GridCabupKota) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFCabupKota.AmbilGambar;
begin
  if (GridCabupKota.DataSource.DataSet.RecordCount > 0) then
     begin
     ImageCabupKota.Picture.Clear;
     jpg := TJpegImage.Create;
     if FileExists(ExtractFilePath(Application.ExeName)+'img\cabup\'+GridCabupKota.DataSource.DataSet.Fields[5].Value) then
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\cabup\'+GridCabupKota.DataSource.DataSet.Fields[5].Value) else
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
     ImageCabupKota.Picture.Bitmap.Assign(jpg);
     jpg.Free;
     end else
ImageCabupKota.Picture.Clear;
end;

function TFCabupKota.getNamaProv(namakabkota: String): String;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_provinsi as id from t_kabkota where nama_kota="'+namakabkota+'"';
   Open;
  end;
  with DM.ZQCari2 do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select nama_provinsi as nama from t_provinsi where id_provinsi="'+DM.ZQCari.FieldByName('id').AsString+'"';
   Open;
  end;
  if DM.ZQCari2.RecordCount>=1 then
  Result:=DM.ZQCari2.FieldByName('nama').AsString;
end;



end.

