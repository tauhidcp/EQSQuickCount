unit ucalegkabkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, Grids, rxdbgrid;

type

  { TFCalegKabKota }

  TFCalegKabKota = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BHapus: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridCaleg: TRxDBGrid;
    ImageCaleg: TImage;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PImage: TPanel;
    procedure BCariClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridCalegCellClick(Column: TColumn);
    procedure GridCalegPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
    procedure AmbilGambar;
  function getNamaProv(namakabkota:String):String;
  end;

var
  FCalegKabKota: TFCalegKabKota;
  jpg: TJpegImage;

const
  query = 'SELECT t_calegdprdkabkota.id, t_calegdprdkabkota.no_urut, t_calegdprdkabkota.nama_caleg, t_kabkota.nama_kota, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprdkabkota.foto, t_calegdprdkabkota.warna, t_calegdprdkabkota.dapil FROM (((t_calegdprdkabkota INNER JOIN t_dapil ON t_calegdprdkabkota.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdkabkota.partai) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_calegdprdkabkota.kabkota) order by t_calegdprdkabkota.id asc';
  queryc = 'SELECT t_calegdprdkabkota.id, t_calegdprdkabkota.no_urut, t_calegdprdkabkota.nama_caleg, t_kabkota.nama_kota, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprdkabkota.foto, t_calegdprdkabkota.warna, t_calegdprdkabkota.dapil FROM (((t_calegdprdkabkota INNER JOIN t_dapil ON t_calegdprdkabkota.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdkabkota.partai) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_calegdprdkabkota.kabkota)';

implementation

uses uutama, udatamodule, utambahcalegdprdkabkota;

{$R *.lfm}

{ TFCalegKabKota }

procedure TFCalegKabKota.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;


procedure TFCalegKabKota.BTambahClick(Sender: TObject);
begin
  with FTambahCalegKabKota do
  begin
  Hapus;
  setCB;
  Caption:='Tambah CALEG DPRD Kabupaten/Kota';
  PAtas.Caption:='Form Tambah CALEG DPRD Kabupaten/Kota';
  ENoUrut.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;

procedure TFCalegKabKota.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridCaleg.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus CALEG DPRD Kabupaten/Kota "'+GridCaleg.DataSource.DataSet.Fields[2].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridCaleg.DataSource.DataSet.Fields[0].Value;
  DeleteFile('img\caleg\dprdkabkota\'+GridCaleg.DataSource.DataSet.Fields[6].Value);
  // Hapus Database
  with DM.ZQDPRDKab do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_calegdprdkabkota where id="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
  end;
  end;
end;

procedure TFCalegKabKota.BRefreshClick(Sender: TObject);
begin
  with DM.ZQDPRDKab do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
end;

procedure TFCalegKabKota.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari CALEG DPRD Kabupaten/Kota', 'Nama CALEG Atau Nama Partai', nama);
    if not (nama='') then
    begin
    with DM.ZQDPRDKab do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_calegdprdkabkota.nama_caleg like "%'+nama+'%" or t_partai.nama_partai like "%'+nama+'%" order by t_calegdprdkabkota.id asc';
          Open;
        end;
    end;
end;

procedure TFCalegKabKota.BEditClick(Sender: TObject);
begin
  if GridCaleg.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahCalegKabKota do
    begin
    setCB;
    Caption:='Ubah CALEG DPRD Kabupaten/Kota';
    PAtas.Caption:='Form Ubah CALEG DPRD Kabupaten/Kota';
    BSimpan.Caption:='Perbarui';
    EID.Enabled:=False;
    BBaru.Enabled:=False;
    EID.Text:=GridCaleg.DataSource.DataSet.Fields[0].Value;
    ENoUrut.Text:=GridCaleg.DataSource.DataSet.Fields[1].Value;
    ENamaCaleg.Text:=GridCaleg.DataSource.DataSet.Fields[2].Value;
    CBProv.Text:=getNamaProv(GridCaleg.DataSource.DataSet.Fields[3].Value);
    CBKabKota.Text:=GridCaleg.DataSource.DataSet.Fields[3].Value;
    setCBSesuai(CBKabKota.Text);
    CBPartai.Text:=GridCaleg.DataSource.DataSet.Fields[4].Value;
    CBDapil.Text:=GridCaleg.DataSource.DataSet.Fields[5].Value;
    if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+GridCaleg.DataSource.DataSet.Fields[6].Value) then
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+GridCaleg.DataSource.DataSet.Fields[6].Value);
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+GridCaleg.DataSource.DataSet.Fields[6].Value; end else
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\noimage.jpg';
    end;

    LNamaImage.Caption:=GridCaleg.DataSource.DataSet.Fields[6].Value;
    CBWarna.Selected:=StringToColor(GridCaleg.DataSource.DataSet.Fields[7].AsString);
    BSimpan.Enabled:=True;
    ShowModal;
    end;
  end;
end;

procedure TFCalegKabKota.GridCalegCellClick(Column: TColumn);
begin
  AmbilGambar;
end;

procedure TFCalegKabKota.GridCalegPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridCaleg) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFCalegKabKota.AmbilGambar;
begin
  if (GridCaleg.DataSource.DataSet.RecordCount > 0) then
     begin
     ImageCaleg.Picture.Clear;
     jpg := TJpegImage.Create;
     if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+GridCaleg.DataSource.DataSet.Fields[6].Value) then
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+GridCaleg.DataSource.DataSet.Fields[6].Value) else
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
     ImageCaleg.Picture.Bitmap.Assign(jpg);
     jpg.Free;
     end else
ImageCaleg.Picture.Clear;
end;

function TFCalegKabKota.getNamaProv(namakabkota: String): String;
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

