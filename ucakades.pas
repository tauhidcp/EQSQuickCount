unit ucakades;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, rxdbgrid, Grids, DBGrids;

type

  { TFCalonKades }

  TFCalonKades = class(TForm)
    BEdit: TBitBtn;
    BHapus: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridCalonKades: TRxDBGrid;
    ImageCalonKADES: TImage;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PImage: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridCalonKadesCellClick(Column: TColumn);
    procedure GridCalonKadesPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private

  public
    procedure AmbilGambar;
    function getKec(namakel:String):String;
    function getKab(namakel:String):String;
    function getProv(namakel:String):String;
  end;

var
  FCalonKades: TFCalonKades;
  jpg: TJpegImage;

const
  query = 'SELECT t_cakades.no_urut, t_cakades.nama_kades, t_kelurahan.nama_kelurahan, t_cakades.foto, t_cakades.warna FROM (t_cakades INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_cakades.daerah) order by t_cakades.no_urut asc';

implementation

uses uutama, utambahkades, udatamodule;

{$R *.lfm}

{ TFCalonKades }

procedure TFCalonKades.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFCalonKades.BTambahClick(Sender: TObject);
begin
  with FTambahKades do
  begin
  Hapus;
  setCB;
  Caption:='Tambah Data Calon KADES';
  PAtas.Caption:='Form Tambah Data Calon KADES';
  ENoUrut.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;

procedure TFCalonKades.BEditClick(Sender: TObject);
begin
  if GridCalonKades.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahKades do
    begin
    setCB;
    Caption:='Ubah Data Calon KADES';
    PAtas.Caption:='Form Ubah Data Calon KADES';
    BSimpan.Caption:='Perbarui';
    ENoUrut.Enabled:=False;
    BBaru.Enabled:=False;
    ENoUrut.Text:=GridCalonKades.DataSource.DataSet.Fields[0].Value;
    ENamaKades.Text:=GridCalonKades.DataSource.DataSet.Fields[1].Value;
    CBKel.Text:=GridCalonKades.DataSource.DataSet.Fields[2].Value;
    CBKec.Text:=getKec(CBKel.Text);
    CBKabKota.Text:=getKab(CBKec.Text);
    CBProv.Text:=getProv(CBKabKota.Text);
    if FileExists(ExtractFilePath(Application.ExeName)+'img\cakades\'+GridCalonKades.DataSource.DataSet.Fields[3].Value) then
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\cakades\'+GridCalonKades.DataSource.DataSet.Fields[3].Value);
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\cakades\'+GridCalonKades.DataSource.DataSet.Fields[3].Value; end else
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\noimage.jpg';
    end;
    LNamaImage.Caption:=GridCalonKades.DataSource.DataSet.Fields[3].Value;
    CBWarna.Selected:=StringToColor(GridCalonKades.DataSource.DataSet.Fields[4].AsString);
    BSimpan.Enabled:=True;
    ShowModal;
    end;
  end;
end;

procedure TFCalonKades.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridCalonKades.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Calon KADES "'+GridCalonKades.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridCalonKades.DataSource.DataSet.Fields[0].Value;
  // Hapus File
  DeleteFile('img\cakades\'+GridCalonKades.DataSource.DataSet.Fields[3].Value);
  // Hapus Database
  with DM.ZQKades do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_cakades where no_urut="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
  end;
  end;
end;

procedure TFCalonKades.GridCalonKadesCellClick(Column: TColumn);
begin
  AmbilGambar;
end;

procedure TFCalonKades.GridCalonKadesPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  with TStringGrid(GridCalonKades) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFCalonKades.AmbilGambar;
begin
  if (GridCalonKades.DataSource.DataSet.RecordCount > 0) then
     begin
     ImageCalonKADES.Picture.Clear;
     jpg := TJpegImage.Create;
     if FileExists(ExtractFilePath(Application.ExeName)+'img\cakades\'+GridCalonKades.DataSource.DataSet.Fields[3].Value) then
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\cakades\'+GridCalonKades.DataSource.DataSet.Fields[3].Value) else
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
     ImageCalonKADES.Picture.Bitmap.Assign(jpg);
     jpg.Free;
     end else
ImageCalonKADES.Picture.Clear;
end;

function TFCalonKades.getKec(namakel: String): String;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_kecamatan as id from t_kelurahan where nama_kelurahan="'+namakel+'"';
   Open;
  end;
  with DM.ZQCari2 do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select nama_kecamatan as nama from t_kecamatan where id_kecamatan="'+DM.ZQCari.FieldByName('id').AsString+'"';
   Open;
  end;
  if DM.ZQCari2.RecordCount>=1 then
  Result:=DM.ZQCari2.FieldByName('nama').AsString;
end;

function TFCalonKades.getKab(namakel: String): String;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_kota as id from t_kecamatan where nama_kecamatan="'+namakel+'"';
   Open;
  end;
  with DM.ZQCari2 do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select nama_kota as nama from t_kabkota where id_kota="'+DM.ZQCari.FieldByName('id').AsString+'"';
   Open;
  end;
  if DM.ZQCari2.RecordCount>=1 then
  Result:=DM.ZQCari2.FieldByName('nama').AsString;
end;

function TFCalonKades.getProv(namakel: String): String;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_provinsi as id from t_kabkota where nama_kota="'+namakel+'"';
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

