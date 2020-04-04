unit ukecamatan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, comObj, Variants, Grids, rxdbgrid, fpspreadsheet, fpstypes,
  xlsxooxml, ZDataset, udatamodule, utambahkecamatan, ucekserial;

type

  { TFKecamatan }

  TFKecamatan = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridKec: TRxDBGrid;
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
    procedure GridKecPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FKecamatan: TFKecamatan;

const
  query = 'SELECT t_kecamatan.id_kecamatan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM ((t_kecamatan INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) order by t_kecamatan.id_kecamatan asc';
  queryc = 'SELECT t_kecamatan.id_kecamatan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM ((t_kecamatan INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';

implementation

uses uutama;

{$R *.lfm}

{ TFKecamatan }

// Write Excel File
function TFKecamatan.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Kecamatan');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_kecamatan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama_kecamatan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('nama_provinsi').AsString);
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
          AQuery.SQL.Text:='insert into t_kecamatan (id_kecamatan,id_kota,nama_kecamatan) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahKecamatan.getIdKota(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_kecamatan',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_kecamatan (id_kecamatan,id_kota,nama_kecamatan) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahKecamatan.getIdKota(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
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

procedure TFKecamatan.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFKecamatan.GridKecPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
    with TStringGrid(GridKec) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFKecamatan.BRefreshClick(Sender: TObject);
begin
   with DM.ZQKec do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFKecamatan.BTambahClick(Sender: TObject);
begin
    with FTambahKecamatan do
    begin
    Hapus;
    SetCB;
    Caption:='Tambah Data Kecamatan';
    PAtas.Caption:='Form Tambah Data Kecamatan';
    EIDKecamatan.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

procedure TFKecamatan.BKosongkanClick(Sender: TObject);
begin
  //if GridKec.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Kecamatan?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQKec do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_kecamatan';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFKecamatan.BImportClick(Sender: TObject);
begin
  if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQKec.Close;
     ReadXLSFile(DM.ZQKec,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQKec.SQL.Clear;
     DM.ZQKec.SQL.Text:=query;
     DM.ZQKec.Open;
      MessageDlg('Data Kecamatan Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFKecamatan.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridKec.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Kecamatan "'+GridKec.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridKec.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQKec do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_kecamatan where id_kecamatan="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFKecamatan.BCariClick(Sender: TObject);
var
  namakec : string;
begin
    InputQuery('Cari Kecamatan', 'Nama Kecamatan', namakec);
    if not (namakec='') then
    begin
    with DM.ZQKec do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_kecamatan.nama_kecamatan like "%'+namakec+'%" order by t_kecamatan.id_kecamatan asc';
          Open;
        end;
    end;
end;

procedure TFKecamatan.BEditClick(Sender: TObject);
begin
  if GridKec.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahKecamatan do
    begin
    SetCB;
    Caption:='Ubah Data Kecamatan';
    PAtas.Caption:='Form Ubah Data Kecamatan';
    BSimpan.Caption:='Perbarui';
    EIDKecamatan.Enabled:=False;
    EIDKecamatan.Text:=GridKec.DataSource.DataSet.Fields[0].Value;
    ENamaKecamatan.Text:=GridKec.DataSource.DataSet.Fields[1].Value;
    CBKabKota.Text:=GridKec.DataSource.DataSet.Fields[2].Value;
    CBProv.Text:=GridKec.DataSource.DataSet.Fields[3].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFKecamatan.BEksportClick(Sender: TObject);
begin
   if GridKec.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQKec,FUtama.SaveExcel.FileName);
     MessageDlg('Data Kecamatan Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

end.

