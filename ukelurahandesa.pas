unit ukelurahandesa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, comObj, Variants, Grids, rxdbgrid, fpspreadsheet, fpstypes,
  xlsxooxml, ZDataset, udatamodule, utambahkelurahandesa, ucekserial;

type

  { TFKelurahanDesa }

  TFKelurahanDesa = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridKelDesa: TRxDBGrid;
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
    procedure GridKelDesaPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FKelurahanDesa: TFKelurahanDesa;

const
  query = 'SELECT t_kelurahan.id_kelurahan, t_kelurahan.nama_kelurahan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM (((t_kelurahan INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) order by t_kelurahan.id_kelurahan asc';
  queryc = 'SELECT t_kelurahan.id_kelurahan, t_kelurahan.nama_kelurahan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM (((t_kelurahan INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';

implementation

uses uutama;

{$R *.lfm}

{ TFKelurahanDesa }

// Write Excel File
function TFKelurahanDesa.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_KelurahanDesa');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_kecamatan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('nama_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('nama_provinsi').AsString);
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
          AQuery.SQL.Text:='insert into t_kelurahan (id_kelurahan,id_kecamatan,nama_kelurahan) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahKelurahanDesa.getIdKec(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_kelurahan',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_kelurahan (id_kelurahan,id_kecamatan,nama_kelurahan) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahKelurahanDesa.getIdKec(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
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

procedure TFKelurahanDesa.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFKelurahanDesa.GridKelDesaPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
    with TStringGrid(GridKelDesa) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFKelurahanDesa.BRefreshClick(Sender: TObject);
begin
     with DM.ZQKelDesa do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFKelurahanDesa.BTambahClick(Sender: TObject);
begin
  with FTambahKelurahanDesa do
    begin
    Hapus;
    SetCB;
    Caption:='Tambah Data Kelurahan/Desa';
    PAtas.Caption:='Form Tambah Data Kelurahan/Desa';
    EIDKelDesa.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

procedure TFKelurahanDesa.BKosongkanClick(Sender: TObject);
begin
  //if GridKelDesa.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Kelurahan/Desa ?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQKelDesa do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_kelurahan';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFKelurahanDesa.BImportClick(Sender: TObject);
begin
  if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQKelDesa.Close;
     ReadXLSFile(DM.ZQKelDesa,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQKelDesa.SQL.Clear;
     DM.ZQKelDesa.SQL.Text:=query;
     DM.ZQKelDesa.Open;
     MessageDlg('Data Kelurahan/Desa Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFKelurahanDesa.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridKelDesa.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Kelurahan/Desa "'+GridKelDesa.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridKelDesa.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQKelDesa do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_kelurahan where id_kelurahan="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFKelurahanDesa.BCariClick(Sender: TObject);
var
  namakel : string;
begin
    InputQuery('Cari Kelurahan/Desa', 'Nama Kelurahan/Desa', namakel);
    if not (namakel='') then
    begin
    with DM.ZQKelDesa do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_kelurahan.nama_kelurahan like "%'+namakel+'%" order by t_kelurahan.id_kelurahan asc';
          Open;
        end;
    end;
end;

procedure TFKelurahanDesa.BEditClick(Sender: TObject);
begin
  if GridKelDesa.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahKelurahanDesa do
    begin
    SetCB;
    Caption:='Ubah Data Kelurahan/Desa';
    PAtas.Caption:='Form Ubah Data Kelurahan/Desa';
    BSimpan.Caption:='Perbarui';
    EIDKelDesa.Enabled:=False;
    EIDKelDesa.Text:=GridKelDesa.DataSource.DataSet.Fields[0].Value;
    ENamaKelDesa.Text:=GridKelDesa.DataSource.DataSet.Fields[1].Value;
    CBKec.Text:=GridKelDesa.DataSource.DataSet.Fields[2].Value;
    CBKabKota.Text:=GridKelDesa.DataSource.DataSet.Fields[3].Value;
    CBProv.Text:=GridKelDesa.DataSource.DataSet.Fields[4].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFKelurahanDesa.BEksportClick(Sender: TObject);
begin
   if GridKelDesa.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQKelDesa,FUtama.SaveExcel.FileName);
     MessageDlg('Data Kelurahan/Desa Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

end.

