unit ucalegdprdprov;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, Grids, rxdbgrid;

type

  { TFCalegDPRDProv }

  TFCalegDPRDProv = class(TForm)
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
  end;

var
  FCalegDPRDProv: TFCalegDPRDProv;
  jpg: TJpegImage;

const
  query = 'SELECT t_calegdprdprov.id, t_calegdprdprov.no_urut, t_calegdprdprov.nama_caleg, t_provinsi.nama_provinsi, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprdprov.foto, t_calegdprdprov.warna, t_calegdprdprov.dapil FROM (((t_calegdprdprov INNER JOIN t_dapil ON t_calegdprdprov.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdprov.partai) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdprdprov.prov) order by t_calegdprdprov.id asc';
  queryc = 'SELECT t_calegdprdprov.id, t_calegdprdprov.no_urut, t_calegdprdprov.nama_caleg, t_provinsi.nama_provinsi, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprdprov.foto, t_calegdprdprov.warna, t_calegdprdprov.dapil FROM (((t_calegdprdprov INNER JOIN t_dapil ON t_calegdprdprov.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdprov.partai) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdprdprov.prov)';

implementation

uses uutama, udatamodule, utambahcalegdprdprov;

{$R *.lfm}

{ TFCalegDPRDProv }

procedure TFCalegDPRDProv.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;


procedure TFCalegDPRDProv.BTambahClick(Sender: TObject);
begin
  with FTambahCalegDPRDProvinsi do
  begin
  Hapus;
  setCB;
  Caption:='Tambah CALEG DPRD Provinsi';
  PAtas.Caption:='Form Tambah CALEG DPRD Provinsi';
  ENoUrut.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;



procedure TFCalegDPRDProv.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridCaleg.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus CALEG DPRD Provinsi "'+GridCaleg.DataSource.DataSet.Fields[2].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridCaleg.DataSource.DataSet.Fields[0].Value;
  DeleteFile('img\caleg\dprdprov\'+GridCaleg.DataSource.DataSet.Fields[6].Value);
  // Hapus Database
  with DM.ZQDPRDProv do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_calegdprdprov where id="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
  end;
  end;
end;

procedure TFCalegDPRDProv.BRefreshClick(Sender: TObject);
begin
  with DM.ZQDPRDProv do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
 AmbilGambar;
end;

procedure TFCalegDPRDProv.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari CALEG DPRD Provinsi', 'Nama CALEG Atau Nama Partai', nama);
    if not (nama='') then
    begin
    with DM.ZQDPRDProv do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_calegdprdprov.nama_caleg like "%'+nama+'%" or t_partai.nama_partai like "%'+nama+'%" order by t_calegdprdprov.id asc';
          Open;
        end;
    end;
end;

procedure TFCalegDPRDProv.BEditClick(Sender: TObject);
begin
  if GridCaleg.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahCalegDPRDProvinsi do
    begin
    setCB;
    Caption:='Ubah CALEG DPRD Provinsi';
    PAtas.Caption:='Form Ubah CALEG DPRD Provinsi';
    BSimpan.Caption:='Perbarui';
    EID.Enabled:=False;
    BBaru.Enabled:=False;
    EID.Text:=GridCaleg.DataSource.DataSet.Fields[0].Value;
    ENoUrut.Text:=GridCaleg.DataSource.DataSet.Fields[1].Value;
    ENamaCaleg.Text:=GridCaleg.DataSource.DataSet.Fields[2].Value;
    CBProv.Text:=GridCaleg.DataSource.DataSet.Fields[3].Value;
    setCBSesuai(CBProv.Text);
    CBPartai.Text:=GridCaleg.DataSource.DataSet.Fields[4].Value;
    CBDapil.Text:=GridCaleg.DataSource.DataSet.Fields[5].Value;
    if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+GridCaleg.DataSource.DataSet.Fields[6].Value) then
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+GridCaleg.DataSource.DataSet.Fields[6].Value);
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+GridCaleg.DataSource.DataSet.Fields[6].Value; end else
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

procedure TFCalegDPRDProv.GridCalegCellClick(Column: TColumn);
begin
  AmbilGambar;
end;

procedure TFCalegDPRDProv.GridCalegPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridCaleg) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFCalegDPRDProv.AmbilGambar;
begin
  if (GridCaleg.DataSource.DataSet.RecordCount > 0) then
     begin
     ImageCaleg.Picture.Clear;
     jpg := TJpegImage.Create;
     if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+GridCaleg.DataSource.DataSet.Fields[6].Value) then
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+GridCaleg.DataSource.DataSet.Fields[6].Value) else
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
     ImageCaleg.Picture.Bitmap.Assign(jpg);
     jpg.Free;
     end else
ImageCaleg.Picture.Clear;
end;

end.

