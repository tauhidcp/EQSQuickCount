unit udatapengguna;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, rxdbgrid, udatamodule, Grids, DBGrids, utambahpengguna, encode_decode,
  uhakakses;

type

  { TFDataPengguna }

  TFDataPengguna = class(TForm)
    BEdit: TBitBtn;
    BHapus: TBitBtn;
    BHakAkses: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridPengguna: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BHakAksesClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridPenggunaPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FDataPengguna: TFDataPengguna;

const
  query = 'select * from t_pengguna order by id asc';

implementation

uses uutama;

{$R *.lfm}

{ TFDataPengguna }

procedure TFDataPengguna.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDataPengguna.BTambahClick(Sender: TObject);
begin
  with FTambahPengguna do
  begin
  Caption:='Tambah Pengguna';
  PAtas.Caption:='Form Tambah Pengguna';
  hapus;
  ENamaLengkap.Enabled:=True;
  EUsername.Enabled:=True;
  BSimpan.Caption:='Simpan';
  BBaru.Enabled:=True;
  ShowModal;
  end;
end;

procedure TFDataPengguna.BEditClick(Sender: TObject);
begin
  if GridPengguna.DataSource.DataSet.RecordCount>0 then
  begin
  with FTambahPengguna do
    begin
    Caption:='Ubah Data Pengguna';
    PAtas.Caption:='Form Ubah Data Pengguna';
    BSimpan.Caption:='Perbarui';
    BBaru.Enabled:=False;
    if GridPengguna.DataSource.DataSet.Fields[1].Value='Administrator' then
    begin
    ENamaLengkap.Enabled:=False;
    EUsername.Enabled:=False;
    end else
    begin
    ENamaLengkap.Enabled:=True;
    EUsername.Enabled:=True;
    end;
    EID.Enabled:=False;
    EID.Caption:=GridPengguna.DataSource.DataSet.Fields[0].Value;
    LID.Caption:=GridPengguna.DataSource.DataSet.Fields[0].Value;
    ENamaLengkap.Text:=GridPengguna.DataSource.DataSet.Fields[1].Value;
    EUsername.Text:=GridPengguna.DataSource.DataSet.Fields[2].Value;
    EPassword.Text:=GSMDecode7Bit(GSMDecode7Bit(GridPengguna.DataSource.DataSet.Fields[3].Value));
    EPassword2.Text:=GSMDecode7Bit(GSMDecode7Bit(GridPengguna.DataSource.DataSet.Fields[3].Value));
    ENoHP.Text:=GridPengguna.DataSource.DataSet.Fields[4].Value;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
  end;
end;

procedure TFDataPengguna.BHakAksesClick(Sender: TObject);
begin
  if GridPengguna.DataSource.DataSet.RecordCount>0 then
  begin
  if GridPengguna.DataSource.DataSet.Fields[1].Value='Administrator' then MessageDlg('Hak Akses Administrator Tidak Bisa Diubah!',mtWarning,[mbok],0) else
  begin
  with FHakAkses do
    begin
    Caption:='Ubah Hak Akses Pengguna';
    PAtas.Caption:='Form Ubah Hak Akses Pengguna';
    LID.Caption:=GridPengguna.DataSource.DataSet.Fields[0].Value;
    PAtasNama.Caption:=GridPengguna.DataSource.DataSet.Fields[1].Value+' ('+GridPengguna.DataSource.DataSet.Fields[2].Value+')';
    setCheck(GridPengguna.DataSource.DataSet.Fields[0].Value);
    PageAkses.ActivePage:=DataMaster;
    ShowModal;
    end;
  end;
  end;
end;

procedure TFDataPengguna.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridPengguna.DataSource.DataSet.RecordCount>0 then
  begin
  if GridPengguna.DataSource.DataSet.Fields[1].Value='Administrator' then MessageDlg('Administrator Tidak Bisa Dihapus!',mtWarning,[mbok],0) else
  begin
  if MessageDlg('Anda Akan Menghapus Data Pengguna "'+GridPengguna.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridPengguna.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQPengguna do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_pengguna where id="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
    with DM.ZQCari3 do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_hak_akses where id_pengguna="'+id+'"';
      ExecSQL;
    end;
  end;
  end;
  end;
end;

procedure TFDataPengguna.GridPenggunaPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridPengguna) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

end.

