unit ukabupatenkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, comObj, Variants, udatamodule, Grids, rxdbgrid,
  fpspreadsheet, fpstypes, xlsxooxml, ZDataset, utambahkabupatenkota, ucekserial;

type

  { TFKabupatenKota }

  TFKabupatenKota = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridKabKota: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BCariClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridKabKotaPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FKabupatenKota: TFKabupatenKota;

const
  query = 'SELECT t_kabkota.id_kota, t_provinsi.nama_provinsi, t_kabkota.nama_kota FROM (t_kabkota INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) order by t_kabkota.id_kota asc';
  queryc = 'SELECT t_kabkota.id_kota, t_provinsi.nama_provinsi, t_kabkota.nama_kota FROM (t_kabkota INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';

implementation

uses uutama;

{$R *.lfm}

{ TFKabupatenKota }

// Write Excel File
function TFKabupatenKota.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_KabKota');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_provinsi').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;
// End Write Excel File

// Read Excel File
function ReadXLSFile(AQuery: TZQuery; AFileName:String; utama:TFUtama): Boolean;
var
XLApp,Sheet: OLEVariant;
y,MaxRow : Integer;
path: variant;
begin
 XLApp := CreateOleObject('Excel.Application');
 try
   XLApp.Visible := False;
   XLApp.DisplayAlerts := False;
   path := AFileName;
   XLApp.Workbooks.Open(path);
   Sheet := XLApp.WorkSheets[1];
   MaxRow := Sheet.Usedrange.EntireRow.count;
   utama.PBLoading.Max:=MaxRow;
   utama.PBLoading.Visible:=True;

     for y := 1 to MaxRow do
      begin
      utama.PBLoading.Position:=y;
          if (Trim(XLApp.Cells[y,1].Value)<>'') and (Trim(XLApp.Cells[y,2].Value)<>'') and (Trim(XLApp.Cells[y,3].Value)<>'') then begin
          if (cekSerial()=True) then
          begin
          AQuery.SQL.Clear;
          AQuery.SQL.Text:='insert into t_kabkota (id_kota,id_provinsi,nama_kota) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahKabupatenKota.getIdProvinsi(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_kabkota',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_kabkota (id_kota,id_provinsi,nama_kota) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahKabupatenKota.getIdProvinsi(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
             AQuery.ExecSQL;
             end;
          end;
          end;
      end;

 finally
   XLApp.Quit;
   XLAPP := Unassigned;
   utama.PBLoading.Visible:=False;
  end;
 end;
// End Read Excel File

procedure TFKabupatenKota.GridKabKotaPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
    with TStringGrid(GridKabKota) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFKabupatenKota.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFKabupatenKota.BKosongkanClick(Sender: TObject);
begin
  //if GridKabKota.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Kabupaten/Kota?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQKabKota do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_kabkota';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFKabupatenKota.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridKabKota.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Kabupaten/Kota "'+GridKabKota.DataSource.DataSet.Fields[2].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridKabKota.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQKabKota do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_kabkota where id_kota="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFKabupatenKota.BImportClick(Sender: TObject);
begin
    if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQKabKota.Close;
     ReadXLSFile(DM.ZQKabKota,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQKabKota.SQL.Clear;
     DM.ZQKabKota.SQL.Text:=query;
     DM.ZQKabKota.Open;
     MessageDlg('Data Kabupaten/Kota Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFKabupatenKota.BCariClick(Sender: TObject);
var
  namakab : string;
begin
    InputQuery('Cari Kabupaten/Kota', 'Nama Kabupaten/Kota', namakab);
    if not (namakab='') then
    begin
    with DM.ZQKabKota do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_kabkota.nama_kota like "%'+namakab+'%" order by t_kabkota.id_kota asc';
          Open;
        end;
    end;
end;

procedure TFKabupatenKota.BEditClick(Sender: TObject);
begin
  if GridKabKota.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahKabupatenKota do
    begin
    SetCB;
    Caption:='Ubah Data Kabupaten/Kota';
    PAtas.Caption:='Form Ubah Data Kabupaten/Kota';
    BSimpan.Caption:='Perbarui';
    EIDKota.Enabled:=False;
    EIDKota.Text:=GridKabKota.DataSource.DataSet.Fields[0].Value;
    ENamaKota.Text:=GridKabKota.DataSource.DataSet.Fields[2].Value;
    CBProv.Text:=GridKabKota.DataSource.DataSet.Fields[1].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFKabupatenKota.BEksportClick(Sender: TObject);
begin
   if GridKabKota.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQKabKota,FUtama.SaveExcel.FileName);
     MessageDlg('Data Kabupaten/Kota Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFKabupatenKota.BRefreshClick(Sender: TObject);
begin
    with DM.ZQKabKota do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFKabupatenKota.BTambahClick(Sender: TObject);
begin
    with FTambahKabupatenKota do
    begin
    Hapus;
    SetCB;
    Caption:='Tambah Data Kabupaten/Kota';
    PAtas.Caption:='Form Tambah Data Kabupaten/Kota';
    EIDKota.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

end.

