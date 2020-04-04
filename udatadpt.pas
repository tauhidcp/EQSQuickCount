unit udatadpt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, rxdbgrid, DBGrids, comObj, Variants, fpspreadsheet, fpstypes,
  xlsxooxml, ZDataset, udatamodule, utambahdpt, ucekserial, Grids, Menus;

type

  { TFDataDPT }

  TFDataDPT = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridDPT: TRxDBGrid;
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
    procedure GridDPTPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private

  public

  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;

  end;

var
  FDataDPT: TFDataDPT;

const
  query  = 'SELECT t_dpt.id, t_dpt.ktp, t_dpt.nama, t_tps.no_tps, t_kelurahan.nama_kelurahan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM (((((t_dpt INNER JOIN t_tps ON t_tps.id_tps=t_dpt.tps) INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) order by t_dpt.id asc';
  queryc = 'SELECT t_dpt.id, t_dpt.ktp, t_dpt.nama, t_tps.no_tps, t_kelurahan.nama_kelurahan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM (((((t_dpt INNER JOIN t_tps ON t_tps.id_tps=t_dpt.tps) INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';

implementation

uses uutama;

{$R *.lfm}

{ TFDataDPT }

function cariKTP(no: string): integer;
begin
 Result:=0;
 with DM.ZQCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select * from t_dpt where ktp="'+no+'"';
 Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=1;
end;

function TFDataDPT.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_DPT');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, Copy(QuotedStr(AQuery.FieldByName('ktp').AsString),0,(length(QuotedStr(AQuery.FieldByName('ktp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, Copy(QuotedStr(AQuery.FieldByName('no_tps').AsString),0,(length(QuotedStr(AQuery.FieldByName('no_tps').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('nama_kecamatan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('nama_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 7, AQuery.FieldByName('nama_provinsi').AsString);
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
          if (Trim(XLApp.Cells[y,1].Value)<>'') and (Trim(XLApp.Cells[y,2].Value)<>'') and (Trim(XLApp.Cells[y,3].Value)<>'') and (Trim(XLApp.Cells[y,4].Value)<>'') and (Trim(XLApp.Cells[y,5].Value)<>'') then begin
          if (cariKTP(Trim(XLApp.Cells[y,2].Value))=0) then
          begin
          if (cekSerial()=True) then
          begin
          AQuery.SQL.Clear;
          AQuery.SQL.Text:='insert into t_dpt (id,ktp,nama,tps,desa_kelurahan) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+Trim(XLApp.Cells[y,3].Value)+'","'+FTambahDPT.getIdTPS(Trim(XLApp.Cells[y,4].Value),Trim(XLApp.Cells[y,5].Value))+'","'+FTambahDPT.getIdKelurahan(Trim(XLApp.Cells[y,5].Value))+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_dpt',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_dpt (id,ktp,nama,tps,desa_kelurahan) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+Trim(XLApp.Cells[y,3].Value)+'","'+FTambahDPT.getIdTPS(Trim(XLApp.Cells[y,4].Value),Trim(XLApp.Cells[y,5].Value))+'","'+FTambahDPT.getIdKelurahan(Trim(XLApp.Cells[y,5].Value))+'")';
             AQuery.ExecSQL;
             end;
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

procedure TFDataDPT.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDataDPT.BRefreshClick(Sender: TObject);
begin
     with DM.ZQDPT do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFDataDPT.BKosongkanClick(Sender: TObject);
begin
    if MessageDlg('Anda Akan Menghapus SEMUA Data DPT?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQDPT do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_dpt';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
end;

procedure TFDataDPT.BImportClick(Sender: TObject);
begin
    if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQDPT.Close;
     ReadXLSFile(DM.ZQDPT,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQDPT.SQL.Clear;
     DM.ZQDPT.SQL.Text:=query;
     DM.ZQDPT.Open;
     MessageDlg('Data DPT Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFDataDPT.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridDPT.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data DPT "'+GridDPT.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridDPT.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQDPT do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_dpt where id="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFDataDPT.BCariClick(Sender: TObject);
var
  ktp : string;
begin
    InputQuery('Cari DPT', 'Nomor KTP atau Nama', ktp);
    if not (ktp='') then
    begin
    with DM.ZQDPT do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_dpt.ktp like "%'+ktp+'%" or t_dpt.nama like "%'+ktp+'%" order by t_dpt.id asc';
          Open;
        end;
    end;
end;

procedure TFDataDPT.BEditClick(Sender: TObject);
begin
   if GridDPT.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahDPT do
    begin
    SetCB;
    Caption:='Ubah Data DPT';
    PAtas.Caption:='Form Ubah Data DPT';
    BSimpan.Caption:='Perbarui';
    EID.Enabled:=False;
    EID.Text:=GridDPT.DataSource.DataSet.Fields[0].Value;
    ENoKTP.Text:=GridDPT.DataSource.DataSet.Fields[1].Value;
    ENama.Text:=GridDPT.DataSource.DataSet.Fields[2].Value;
    CBTPS.Text:=GridDPT.DataSource.DataSet.Fields[3].Value;
    CBKelDesa.Text:=GridDPT.DataSource.DataSet.Fields[4].Value;
    CBKec.Text:=GridDPT.DataSource.DataSet.Fields[5].Value;
    CBKabKota.Text:=GridDPT.DataSource.DataSet.Fields[6].Value;
    CBProv.Text:=GridDPT.DataSource.DataSet.Fields[7].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFDataDPT.BEksportClick(Sender: TObject);
begin
     if GridDPT.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQDPT,FUtama.SaveExcel.FileName);
     MessageDlg('Data DPT Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFDataDPT.BTambahClick(Sender: TObject);
begin
    with FTambahDPT do
    begin
    Hapus;
    SetCB;
    Caption:='Tambah Data DPT';
    PAtas.Caption:='Form Tambah Data DPT';
    EID.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

procedure TFDataDPT.GridDPTPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridDPT) do
  begin
      Options := Options + [goRowSelect];
  end;
end;



end.

