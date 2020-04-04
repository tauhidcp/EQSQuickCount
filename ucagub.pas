unit ucagub;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, DBGrids, Grids, rxdbgrid;

type

  { TFCagub }

  TFCagub = class(TForm)
    BEdit: TBitBtn;
    BHapus: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridCagub: TRxDBGrid;
    ImageCagub: TImage;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PImage: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridCagubCellClick(Column: TColumn);
    procedure GridCagubPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
    procedure AmbilGambar;
  end;

var
  FCagub: TFCagub;
  jpg: TJpegImage;

const
  query = 'SELECT t_cagub.no_urut, t_cagub.nama_cagub, t_cagub.nama_cawagub, t_cagub.nama_akronim, t_provinsi.nama_provinsi, t_cagub.foto, t_cagub.warna FROM (t_cagub INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_cagub.daerah) order by t_cagub.no_urut asc';

implementation

uses uutama, udatamodule, utambahcagub;

{$R *.lfm}

{ TFCagub }

procedure TFCagub.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFCagub.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridCagub.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data CAGUB "'+GridCagub.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridCagub.DataSource.DataSet.Fields[0].Value;
  // Hapus File
  DeleteFile('img\cagub\'+GridCagub.DataSource.DataSet.Fields[5].Value);
  // Hapus Database
  with DM.ZQCagub do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_cagub where no_urut="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
  end;
  end;
end;

procedure TFCagub.BEditClick(Sender: TObject);
begin
  if GridCagub.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahCagub do
    begin
    setCB;
    Caption:='Ubah Data Cagub';
    PAtas.Caption:='Form Ubah Data Cagub';
    BSimpan.Caption:='Perbarui';
    ENoUrut.Enabled:=False;
    BBaru.Enabled:=False;
    ENoUrut.Text:=GridCagub.DataSource.DataSet.Fields[0].Value;
    ENamaCagub.Text:=GridCagub.DataSource.DataSet.Fields[1].Value;
    ENamaCawagub.Text:=GridCagub.DataSource.DataSet.Fields[2].Value;
    ENamaAkronim.Text:=GridCagub.DataSource.DataSet.Fields[3].Value;
    CBDaerah.Text:=GridCagub.DataSource.DataSet.Fields[4].Value;
    if FileExists(ExtractFilePath(Application.ExeName)+'img\cagub\'+GridCagub.DataSource.DataSet.Fields[5].Value) then
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\cagub\'+GridCagub.DataSource.DataSet.Fields[5].Value);
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\cagub\'+GridCagub.DataSource.DataSet.Fields[5].Value; end else
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\noimage.jpg';
    end;

    LNamaImage.Caption:=GridCagub.DataSource.DataSet.Fields[5].Value;
    CBWarna.Selected:=StringToColor(GridCagub.DataSource.DataSet.Fields[6].AsString);
    BSimpan.Enabled:=True;
    ShowModal;
    end;
  end;
end;

procedure TFCagub.BTambahClick(Sender: TObject);
begin
  with FTambahCagub do
  begin
  Hapus;
  setCB;
  Caption:='Tambah Data Cagub';
  PAtas.Caption:='Form Tambah Data Cagub';
  ENoUrut.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;

procedure TFCagub.GridCagubCellClick(Column: TColumn);
begin
  AmbilGambar;
end;

procedure TFCagub.GridCagubPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
    with TStringGrid(GridCagub) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFCagub.AmbilGambar;
begin
    if (GridCagub.DataSource.DataSet.RecordCount > 0) then
     begin
     ImageCagub.Picture.Clear;
     jpg := TJpegImage.Create;
     if FileExists(ExtractFilePath(Application.ExeName)+'img\cagub\'+GridCagub.DataSource.DataSet.Fields[5].Value) then
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\cagub\'+GridCagub.DataSource.DataSet.Fields[5].Value) else
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
     ImageCagub.Picture.Bitmap.Assign(jpg);
     jpg.Free;
     end else
ImageCagub.Picture.Clear;
end;

end.

