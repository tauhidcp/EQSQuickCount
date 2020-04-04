unit uprovinsi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, Grids, rxdbgrid, comObj, Variants, fpspreadsheet, fpstypes,
  xlsxooxml, udatamodule, utambahprov, ZDataset, ucekserial;

type

  { TFProvinsi }

  TFProvinsi = class(TForm)
    BEdit: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BCari: TBitBtn;
    BEksport: TBitBtn;
    BRefresh: TBitBtn;
    BKosongkan: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridProv: TRxDBGrid;
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
    procedure GridProvPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FProvinsi: TFProvinsi;

  const
    query = 'select * from t_provinsi order by id_provinsi asc';
    queryc = 'select * from t_provinsi';

implementation

uses uutama;

{$R *.lfm}

{ TFProvinsi }

// Write Excel File
function TFProvinsi.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Provinsi');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_provinsi').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama_provinsi').AsString);
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
          if (Trim(XLApp.Cells[y,1].Value)<>'') and (Trim(XLApp.Cells[y,2].Value)<>'') then begin
          if (cekSerial()=True) then
          begin
          AQuery.SQL.Clear;
          AQuery.SQL.Text:='insert into t_provinsi (id_provinsi,nama_provinsi) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_provinsi',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_provinsi (id_provinsi,nama_provinsi) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
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

procedure TFProvinsi.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFProvinsi.GridProvPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
    with TStringGrid(GridProv) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFProvinsi.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridProv.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Provinsi "'+GridProv.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridProv.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQProv do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_provinsi where id_provinsi="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFProvinsi.BImportClick(Sender: TObject);
begin
  if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQProv.Close;
     ReadXLSFile(DM.ZQProv,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQProv.SQL.Clear;
     DM.ZQProv.SQL.Text:=query;
     DM.ZQProv.Open;
     MessageDlg('Data Provinsi Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFProvinsi.BEditClick(Sender: TObject);
begin
    if GridProv.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahProv do
    begin
    Caption:='Ubah Data Provinsi';
    PAtas.Caption:='Form Ubah Data Provinsi';
    BSimpan.Caption:='Perbarui';
    EIDProv.Enabled:=False;
    EIDProv.Text:=GridProv.DataSource.DataSet.Fields[0].Value;
    ENamaProv.Text:=GridProv.DataSource.DataSet.Fields[1].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFProvinsi.BEksportClick(Sender: TObject);
begin
   if GridProv.DataSource.DataSet.RecordCount>0 then
  begin
  if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQProv,FUtama.SaveExcel.FileName);
     MessageDlg('Data Provinsi Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFProvinsi.BCariClick(Sender: TObject);
var
  namaprov : string;
begin
    InputQuery('Cari Provinsi', 'Nama Provinsi', namaprov);
    if not (namaprov='') then
    begin
    with DM.ZQProv do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where nama_provinsi like "%'+namaprov+'%" order by id_provinsi asc';
          Open;
        end;
    end;
end;

procedure TFProvinsi.BKosongkanClick(Sender: TObject);
begin
  //if GridProv.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Provinsi ?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQProv do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_provinsi';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  //end;
end;

procedure TFProvinsi.BRefreshClick(Sender: TObject);
begin
  with DM.ZQProv do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFProvinsi.BTambahClick(Sender: TObject);
begin
  with FTambahProv do
    begin
    Hapus;
    Caption:='Tambah Data Provinsi';
    PAtas.Caption:='Form Tambah Data Provinsi';
    EIDProv.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

end.

