unit upartai;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, Buttons, Grids, rxdbgrid;

type

  { TFPartai }

  TFPartai = class(TForm)
    BTambah: TBitBtn;
    BEdit: TBitBtn;
    BHapus: TBitBtn;
    BTutup: TBitBtn;
    GridPartai: TRxDBGrid;
    ImagePartai: TImage;
    PImage: TPanel;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridPartaiCellClick(Column: TColumn);
    procedure AmbilGambar;
    procedure GridPartaiPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FPartai: TFPartai;
  jpg: TJpegImage;

const
  query = 'select * from t_partai order by no_urut asc';

implementation

uses uutama, udatamodule, utambahpartai;

{$R *.lfm}

{ TFPartai }

procedure TFPartai.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFPartai.GridPartaiCellClick(Column: TColumn);
begin
  AmbilGambar;
end;

procedure TFPartai.AmbilGambar;
begin
    if (GridPartai.DataSource.DataSet.RecordCount > 0) then
     begin
     ImagePartai.Picture.Clear;
     jpg := TJpegImage.Create;
     if FileExists(ExtractFilePath(Application.ExeName)+'img\partai\'+GridPartai.DataSource.DataSet.Fields[3].Value) then
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\partai\'+GridPartai.DataSource.DataSet.Fields[3].Value) else
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
     ImagePartai.Picture.Bitmap.Assign(jpg);
     jpg.Free;
     end else
     ImagePartai.Picture.Clear;
end;

procedure TFPartai.GridPartaiPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
  with TStringGrid(GridPartai) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFPartai.BTambahClick(Sender: TObject);
begin
  with FTambahPartai do
  begin
  Hapus;
  Caption:='Tambah Data Partai';
  PAtas.Caption:='Form Tambah Data Partai';
  ENoUrut.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;

procedure TFPartai.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridPartai.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Partai "'+GridPartai.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridPartai.DataSource.DataSet.Fields[0].Value;
  // Hapus File
  DeleteFile('img\partai\'+GridPartai.DataSource.DataSet.Fields[3].Value);
  // Hapus Database
  with DM.ZQPartai do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_partai where no_urut="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
  end;
  end;
end;

procedure TFPartai.BEditClick(Sender: TObject);
begin
  if GridPartai.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahPartai do
    begin
    Caption:='Ubah Data Partai';
    PAtas.Caption:='Form Ubah Data Partai';
    BSimpan.Caption:='Perbarui';
    ENoUrut.Enabled:=False;
    BBaru.Enabled:=False;
    ENoUrut.Text:=GridPartai.DataSource.DataSet.Fields[0].Value;
    ENamaPartai.Text:=GridPartai.DataSource.DataSet.Fields[1].Value;
    ESingkatan.Text:=GridPartai.DataSource.DataSet.Fields[2].Value;
    if FileExists(ExtractFilePath(Application.ExeName)+'img\partai\'+GridPartai.DataSource.DataSet.Fields[3].Value) then
    begin
    ImageGambarPartai.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\partai\'+GridPartai.DataSource.DataSet.Fields[3].Value);
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\partai\'+GridPartai.DataSource.DataSet.Fields[3].Value; end else
    begin
    ImageGambarPartai.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\noimage.jpg';
    end;

    LNamaImage.Caption:=GridPartai.DataSource.DataSet.Fields[3].Value;
    CBWarna.Selected:=StringToColor(GridPartai.DataSource.DataSet.Fields[4].AsString);
    BSimpan.Enabled:=True;
    ShowModal;
    end;
  end;
end;

end.

