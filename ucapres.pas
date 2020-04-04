unit ucapres;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, Grids, rxdbgrid;

type

  { TFCapres }

  TFCapres = class(TForm)
    BEdit: TBitBtn;
    BHapus: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridCapres: TRxDBGrid;
    ImageCapres: TImage;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PImage: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridCapresCellClick(Column: TColumn);
    procedure GridCapresPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  procedure AmbilGambar;

  end;

var
  FCapres: TFCapres;
  jpg: TJpegImage;

const
  query = 'select * from t_capres order by no_urut asc';

implementation

uses uutama, udatamodule, utambahcapres;

{$R *.lfm}

{ TFCapres }

procedure TFCapres.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;


procedure TFCapres.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridCapres.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data CAPRES "'+GridCapres.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridCapres.DataSource.DataSet.Fields[0].Value;
  // Hapus File
  DeleteFile('img\capres\'+GridCapres.DataSource.DataSet.Fields[4].Value);
  // Hapus Database
  with DM.ZQCapres do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_capres where no_urut="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
  end;
  end;
end;

procedure TFCapres.BEditClick(Sender: TObject);
begin
  if GridCapres.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahCapres do
    begin
    Caption:='Ubah Data Capres';
    PAtas.Caption:='Form Ubah Data Capres';
    BSimpan.Caption:='Perbarui';
    ENoUrut.Enabled:=False;
    BBaru.Enabled:=False;
    ENoUrut.Text:=GridCapres.DataSource.DataSet.Fields[0].Value;
    ENamaCapres.Text:=GridCapres.DataSource.DataSet.Fields[1].Value;
    ENamaCawapres.Text:=GridCapres.DataSource.DataSet.Fields[2].Value;
    ENamaAkronim.Text:=GridCapres.DataSource.DataSet.Fields[3].Value;
    if FileExists(ExtractFilePath(Application.ExeName)+'img\capres\'+GridCapres.DataSource.DataSet.Fields[4].Value) then
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\capres\'+GridCapres.DataSource.DataSet.Fields[4].Value);
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\capres\'+GridCapres.DataSource.DataSet.Fields[4].Value; end else
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\noimage.jpg';
    end;

    LNamaImage.Caption:=GridCapres.DataSource.DataSet.Fields[4].Value;
    CBWarna.Selected:=StringToColor(GridCapres.DataSource.DataSet.Fields[5].AsString);
    BSimpan.Enabled:=True;
    ShowModal;
    end;
  end;
end;

procedure TFCapres.BTambahClick(Sender: TObject);
begin
  with FTambahCapres do
  begin
  Hapus;
  Caption:='Tambah Data Capres';
  PAtas.Caption:='Form Tambah Data Capres';
  ENoUrut.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;

procedure TFCapres.GridCapresCellClick(Column: TColumn);
begin
  AmbilGambar;
end;

procedure TFCapres.GridCapresPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
    with TStringGrid(GridCapres) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFCapres.AmbilGambar;
begin
     if (GridCapres.DataSource.DataSet.RecordCount > 0) then
     begin
     ImageCapres.Picture.Clear;
     jpg := TJpegImage.Create;
     if FileExists(ExtractFilePath(Application.ExeName)+'img\capres\'+GridCapres.DataSource.DataSet.Fields[4].Value) then
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\capres\'+GridCapres.DataSource.DataSet.Fields[4].Value) else
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
     ImageCapres.Picture.Bitmap.Assign(jpg);
     jpg.Free;
     end else
     ImageCapres.Picture.Clear;
end;



end.

