unit udapil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, rxdbgrid, Grids, DBGrids, comObj, Variants, fpspreadsheet, fpstypes,
  xlsxooxml, ZDataset, udatamodule, utambahdapil, db, ucekserial;

type

  { TFDataDAPIL }

  TFDataDAPIL = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridDAPIL: TRxDBGrid;
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
    procedure FormShow(Sender: TObject);
    procedure GridDAPILPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  function getNamaProvKab(nama:string;ket:string):string;
  function getIDProvKab(nama:string;ket:string):string;
  function ReadXLSFile(AQuery: TZQuery; AFileName:String): Boolean;
  end;

var
  FDataDAPIL: TFDataDAPIL;
  query, queryc : string;

implementation

uses uutama;

//const
// query  = 'select * from t_dapil where kategori="'+FUtama.LKategori.Caption+'" order by id_dapil asc';
// queryc = 'select * from t_dapil';

{$R *.lfm}

{ TFDataDAPIL }

// Write Excel File
function TFDataDAPIL.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('DAPIL');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_dapil').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama_dapil').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('kategori').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, getNamaProvKab(AQuery.FieldByName('kabkotaprov').AsString,AQuery.FieldByName('kategori').AsString));
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
function TFDataDAPIL.ReadXLSFile(AQuery: TZQuery; AFileName:String): Boolean;
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

   FUtama.PBLoading.Max:=MaxRow;
   FUtama.PBLoading.Visible:=True;

     for y := 1 to MaxRow do
      begin
      FUtama.PBLoading.Position:=y;
          if (Trim(XLApp.Cells[y,1].Value)<>'') and (Trim(XLApp.Cells[y,2].Value)<>'') and (Trim(XLApp.Cells[y,3].Value)<>'') and (Trim(XLApp.Cells[y,4].Value)<>'') then begin
          if (cekSerial()=True) then
          begin
          AQuery.SQL.Clear;
          AQuery.SQL.Text:='insert into t_dapil (id_dapil,nama_dapil,kategori,kabkotaprov) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+Trim(XLApp.Cells[y,3].Value)+'","'+getIDProvKab(XLApp.Cells[y,4].Value,XLApp.Cells[y,3].Value)+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_dapil',5)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_dapil (id_dapil,nama_dapil,kategori,kabkotaprov) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+Trim(XLApp.Cells[y,3].Value)+'","'+getIDProvKab(XLApp.Cells[y,4].Value,XLApp.Cells[y,3].Value)+'")';
             AQuery.ExecSQL;
             end;
          end;
          end;
      end;

 finally
   XLApp.Quit;
   XLAPP := Unassigned;
   FUtama.PBLoading.Visible:=False;
  end;
 end;
// End Read Excel File

procedure TFDataDAPIL.GridDAPILPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
        with TStringGrid(GridDAPIL) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFDataDAPIL.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDataDAPIL.FormShow(Sender: TObject);
begin
query  := 'select * from t_dapil where kategori="'+FUtama.LKategori.Caption+'" order by id_dapil asc';
queryc := 'select * from t_dapil';
with DM.ZQDapil do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFDataDAPIL.BEksportClick(Sender: TObject);
begin
     if GridDAPIL.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQDapil,FUtama.SaveExcel.FileName);
     MessageDlg('Data DAPIL Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFDataDAPIL.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridDAPIL.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data DAPIL "'+GridDAPIL.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridDAPIL.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQDapil do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_dapil where id_dapil="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFDataDAPIL.BImportClick(Sender: TObject);
begin
     if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQDapil.Close;
     ReadXLSFile(DM.ZQDapil,FUtama.ExcelDialog.FileName);
     DM.ZQDapil.SQL.Clear;
     DM.ZQDapil.SQL.Text:=query;
     DM.ZQDapil.Open;
     MessageDlg('Data DAPIL Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFDataDAPIL.BKosongkanClick(Sender: TObject);
begin
  //if GridDAPIL.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data DAPIL?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQDapil do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_dapil';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
//  end;
end;

procedure TFDataDAPIL.BRefreshClick(Sender: TObject);
begin
     with DM.ZQDapil do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFDataDAPIL.BTambahClick(Sender: TObject);
begin
   with FTambahDapil do
    begin
    Hapus;
    Caption:='Tambah Data DAPIL';
    PAtas.Caption:='Form Tambah Data DAPIL';
    EIDDapil.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

procedure TFDataDAPIL.BCariClick(Sender: TObject);
var
  cari : string;
begin
    InputQuery('Cari DAPIL', 'Nama DAPIL', cari);
    if not (cari='') then
    begin
    with DM.ZQDapil do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_dapil.kategori="'+FUtama.LKategori.Caption+'" and t_dapil.nama_dapil like "%'+cari+'%" order by id_dapil asc';

          Open;
        end;
    end;
end;

procedure TFDataDAPIL.BEditClick(Sender: TObject);
begin
    if GridDAPIL.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahDapil do
    begin
    Caption:='Ubah Data DAPIL';
    PAtas.Caption:='Form Ubah Data DAPIL';
    BSimpan.Caption:='Perbarui';
    EIDDapil.Enabled:=False;
    EIDDapil.Text:=GridDAPIL.DataSource.DataSet.Fields[0].Value;
    ENamaDapil.Text:=GridDAPIL.DataSource.DataSet.Fields[1].Value;
    CBKat.Text:=GridDAPIL.DataSource.DataSet.Fields[2].Value;
    // Set Kab Kota Prov
    if (GridDAPIL.DataSource.DataSet.Fields[2].Value='DPR RI') then
    begin
    with DM.ZQCari do begin
    Close;
    SQL.Clear;
    SQL.Text:='select nama_provinsi from t_provinsi where id_provinsi="'+GridDAPIL.DataSource.DataSet.Fields[3].AsString+'"';
    Open;
    First;
    end;
    FTambahDapil.Height:=280;
    LKabKotaProv.Caption:='Provinsi';
    CBKabKotaProv.Text:=DM.ZQCari.FieldByName('nama_provinsi').AsString;
    end else
    if (GridDAPIL.DataSource.DataSet.Fields[2].Value='DPRD Provinsi') then
    begin
    with DM.ZQCari do begin
    Close;
    SQL.Clear;
    SQL.Text:='select nama_provinsi from t_provinsi where id_provinsi="'+GridDAPIL.DataSource.DataSet.Fields[3].AsString+'"';
    Open;
    First;
    end;
    FTambahDapil.Height:=280;
    LKabKotaProv.Caption:='Provinsi';
    CBKabKotaProv.Text:=DM.ZQCari.FieldByName('nama_provinsi').AsString;
    end else
    if (GridDAPIL.DataSource.DataSet.Fields[2].Value='DPRD Kabupaten/Kota') then
    begin
    with DM.ZQCari do begin
    Close;
    SQL.Clear;
    SQL.Text:='select nama_kota from t_kabkota where id_kota="'+GridDAPIL.DataSource.DataSet.Fields[3].AsString+'"';
    Open;
    First;
    end;
    FTambahDapil.Height:=280;
    LKabKotaProv.Caption:='Kabupaten/Kota';
    CBKabKotaProv.Text:=DM.ZQCari.FieldByName('nama_kota').AsString;
    end;
    setCBSesuai(GridDAPIL.DataSource.DataSet.Fields[2].Value);
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

function TFDataDAPIL.getNamaProvKab(nama: string; ket: string): string;
begin
 Result := '';
 if (ket='DPR RI') then
 begin
 with DM.ZQCari do begin
 Close;
 SQL.Clear;
 SQL.Text:='select nama_provinsi as id from t_provinsi where id_provinsi="'+nama+'"';
 Open;
 First;
 end;
 Result := DM.ZQCari.FieldByName('id').AsString;
 end else
 if (ket='DPRD Provinsi') then
 begin
 with DM.ZQCari do begin
 Close;
 SQL.Clear;
 SQL.Text:='select nama_provinsi as id from t_provinsi where id_provinsi="'+nama+'"';
 Open;
 First;
 end;
 Result := DM.ZQCari.FieldByName('id').AsString;
 end else
 if (ket='DPRD Kabupaten/Kota') then
 begin
 with DM.ZQCari do begin
 Close;
 SQL.Clear;
 SQL.Text:='select nama_kota as id from t_kabkota where id_kota="'+nama+'"';
 Open;
 First;
 end;
 Result := DM.ZQCari.FieldByName('id').AsString;
 end;
end;

function TFDataDAPIL.getIDProvKab(nama: string; ket: string): string;
begin
 Result := '';
 if (ket='DPR RI') then
 begin
 with DM.ZQCari do begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_provinsi as id from t_provinsi where nama_provinsi="'+nama+'"';
 Open;
 First;
 end;
 Result := DM.ZQCari.FieldByName('id').AsString;
 end else
 if (ket='DPRD Provinsi') then
 begin
 with DM.ZQCari do begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_provinsi as id from t_provinsi where nama_provinsi="'+nama+'"';
 Open;
 First;
 end;
 Result := DM.ZQCari.FieldByName('id').AsString;
 end else
 if (ket='DPRD Kabupaten/Kota') then
 begin
 with DM.ZQCari do begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_kota as id from t_kabkota where nama_kota="'+nama+'"';
 Open;
 First;
 end;
 Result := DM.ZQCari.FieldByName('id').AsString;
 end;
end;

end.

