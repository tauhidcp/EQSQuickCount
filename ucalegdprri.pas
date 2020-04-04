unit ucalegdprri;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, Grids, rxdbgrid;

type

  { TFCalegDPRRI }

  TFCalegDPRRI = class(TForm)
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
  FCalegDPRRI: TFCalegDPRRI;
  jpg: TJpegImage;

const
  query = 'SELECT t_calegdprri.id, t_calegdprri.no_urut, t_calegdprri.nama_caleg, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprri.foto, t_calegdprri.warna, t_calegdprri.dapil FROM ((t_calegdprri INNER JOIN t_dapil ON t_calegdprri.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprri.partai) order by t_calegdprri.id asc';
  queryc = 'SELECT t_calegdprri.id, t_calegdprri.no_urut, t_calegdprri.nama_caleg, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprri.foto, t_calegdprri.warna, t_calegdprri.dapil FROM ((t_calegdprri INNER JOIN t_dapil ON t_calegdprri.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprri.partai)';

implementation

uses uutama, udatamodule, utambahcalegdprri;

{$R *.lfm}

{ TFCalegDPRRI }

procedure TFCalegDPRRI.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;


procedure TFCalegDPRRI.BTambahClick(Sender: TObject);
begin
  with FTambahCalegDPRRI do
  begin
  Hapus;
  setCB;
  Caption:='Tambah CALEG DPR RI';
  PAtas.Caption:='Form Tambah CALEG DPR RI';
  ENoUrut.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;

procedure TFCalegDPRRI.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridCaleg.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus CALEG DPR RI "'+GridCaleg.DataSource.DataSet.Fields[2].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridCaleg.DataSource.DataSet.Fields[0].Value;
  DeleteFile('img\caleg\dprri\'+GridCaleg.DataSource.DataSet.Fields[5].Value);
  // Hapus Database
  with DM.ZQDPRRI do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_calegdprri where id="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
  end;
  end;
end;

procedure TFCalegDPRRI.BRefreshClick(Sender: TObject);
begin
   with DM.ZQDPRRI do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  AmbilGambar;
end;

procedure TFCalegDPRRI.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari CALEG DPR RI', 'Nama CALEG Atau Nama Partai', nama);
    if not (nama='') then
    begin
    with DM.ZQDPRRI do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_calegdprri.nama_caleg like "%'+nama+'%" or t_partai.nama_partai like "%'+nama+'%" order by t_calegdprri.id asc';
          Open;
        end;
    end;
end;

procedure TFCalegDPRRI.BEditClick(Sender: TObject);
begin
    if GridCaleg.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahCalegDPRRI do
    begin
    setCB;
    Caption:='Ubah CALEG DPR RI';
    PAtas.Caption:='Form Ubah CALEG DPR RI';
    BSimpan.Caption:='Perbarui';
    EID.Enabled:=False;
    BBaru.Enabled:=False;
    EID.Text:=GridCaleg.DataSource.DataSet.Fields[0].Value;
    ENoUrut.Text:=GridCaleg.DataSource.DataSet.Fields[1].Value;
    ENamaCaleg.Text:=GridCaleg.DataSource.DataSet.Fields[2].Value;
    CBPartai.Text:=GridCaleg.DataSource.DataSet.Fields[3].Value;
    CBDapil.Text:=GridCaleg.DataSource.DataSet.Fields[4].Value;
    if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+GridCaleg.DataSource.DataSet.Fields[5].Value) then
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+GridCaleg.DataSource.DataSet.Fields[5].Value);
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+GridCaleg.DataSource.DataSet.Fields[5].Value; end else
    begin
    ImageFoto.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    FUtama.OPD.FileName:=ExtractFilePath(Application.ExeName)+'img\noimage.jpg';
    end;

    LNamaImage.Caption:=GridCaleg.DataSource.DataSet.Fields[5].Value;
    CBWarna.Selected:=StringToColor(GridCaleg.DataSource.DataSet.Fields[6].AsString);
    BSimpan.Enabled:=True;
    ShowModal;
    end;
  end;
end;

procedure TFCalegDPRRI.GridCalegCellClick(Column: TColumn);
begin
  AmbilGambar;
end;

procedure TFCalegDPRRI.GridCalegPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridCaleg) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFCalegDPRRI.AmbilGambar;
begin
  if (GridCaleg.DataSource.DataSet.RecordCount > 0) then
     begin
     ImageCaleg.Picture.Clear;
     jpg := TJpegImage.Create;
     if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+GridCaleg.DataSource.DataSet.Fields[5].Value) then
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+GridCaleg.DataSource.DataSet.Fields[5].Value) else
     jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
     ImageCaleg.Picture.Bitmap.Assign(jpg);
     jpg.Free;
     end else
ImageCaleg.Picture.Clear;
end;

end.

