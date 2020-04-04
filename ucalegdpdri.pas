unit ucalegdpdri;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, Grids, rxdbgrid;

type

  { TFCalegDPDRI }

  TFCalegDPDRI = class(TForm)
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
    procedure AmbilGambar;
    { public declarations }
  end;

var
  FCalegDPDRI: TFCalegDPDRI;
  jpg: TJpegImage;

const
  query = 'SELECT t_calegdpdri.no_urut, t_calegdpdri.nama_caleg, t_provinsi.nama_provinsi, t_calegdpdri.foto, t_calegdpdri.warna, t_calegdpdri.dapil FROM (t_calegdpdri INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdpdri.dapil) order by t_calegdpdri.no_urut asc';
  queryc = 'SELECT t_calegdpdri.no_urut, t_calegdpdri.nama_caleg, t_provinsi.nama_provinsi, t_calegdpdri.foto, t_calegdpdri.warna, t_calegdpdri.dapil FROM (t_calegdpdri INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdpdri.dapil)';

implementation

uses uutama, udatamodule, utambahcalegdpdri;

{$R *.lfm}

{ TFCalegDPDRI }

procedure TFCalegDPDRI.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFCalegDPDRI.BTambahClick(Sender: TObject);
begin
  with FTambahCalegDPDRI do
  begin
  Hapus;
  setCB;
  Caption:='Tambah CALEG DPD RI';
  PAtas.Caption:='Form Tambah CALEG DPD RI';
  ENoUrut.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;

procedure TFCalegDPDRI.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari CALEG DPD RI', 'Nama CALEG', nama);
    if not (nama='') then
    begin
    with DM.ZQDPDRI do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_calegdpdri.nama_caleg like "%'+nama+'%" order by t_calegdpdri.no_urut asc';
          Open;
        end;
    end;
end;

procedure TFCalegDPDRI.BEditClick(Sender: TObject);
begin
  if GridCaleg.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahCalegDPDRI do
    begin
    setCB;
    Caption:='Ubah CALEG DPD RI';
    PAtas.Caption:='Form Ubah CALEG DPD RI';
    BSimpan.Caption:='Perbarui';
    ENoUrut.Enabled:=False;
    BBaru.Enabled:=False;
    ENoUrut.Text:=GridCaleg.DataSource.DataSet.Fields[0].Value;
    ENamaCaleg.Text:=GridCaleg.DataSource.DataSet.Fields[1].Value;
    CBDapil.Text:=GridCaleg.DataSource.DataSet.Fields[2].Value;
    if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+GridCaleg.DataSource.DataSet.Fields[3].Value) then
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+GridCaleg.DataSource.DataSet.Fields[3].Value);
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+GridCaleg.DataSource.DataSet.Fields[3].Value; end else
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\noimage.jpg';
    end;

    LNamaImage.Caption:=GridCaleg.DataSource.DataSet.Fields[3].Value;
    CBWarna.Selected:=StringToColor(GridCaleg.DataSource.DataSet.Fields[4].AsString);
    BSimpan.Enabled:=True;
    ShowModal;
    end;
  end;
end;

procedure TFCalegDPDRI.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridCaleg.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus CALEG DPD RI "'+GridCaleg.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridCaleg.DataSource.DataSet.Fields[0].Value;
  DeleteFile('img\caleg\dpdri\'+GridCaleg.DataSource.DataSet.Fields[3].Value);
  // Hapus Database
  with DM.ZQDPDRI do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_calegdpdri where no_urut="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
  end;
  end;
end;

procedure TFCalegDPDRI.BRefreshClick(Sender: TObject);
begin
  with DM.ZQDPDRI do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
 AmbilGambar;
end;

procedure TFCalegDPDRI.GridCalegCellClick(Column: TColumn);
begin
  AmbilGambar;
end;

procedure TFCalegDPDRI.GridCalegPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridCaleg) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFCalegDPDRI.AmbilGambar;
begin
  if (GridCaleg.DataSource.DataSet.RecordCount > 0) then
     begin
     ImageCaleg.Picture.Clear;
     jpg := TJpegImage.Create;
     if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+GridCaleg.DataSource.DataSet.Fields[3].Value) then
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+GridCaleg.DataSource.DataSet.Fields[3].Value) else
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
     ImageCaleg.Picture.Bitmap.Assign(jpg);
     jpg.Free;
     end else
ImageCaleg.Picture.Clear;
end;

end.

