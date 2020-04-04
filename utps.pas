unit utps;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Grids, DBGrids, rxdbgrid, comObj, Variants, fpspreadsheet, fpstypes,
  xlsxooxml, ZDataset, udatamodule, utambahtps, ucekserial;

type

  { TFTps }

  TFTps = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridTPS: TRxDBGrid;
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
    procedure GridTPSPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;

  end;

var
  FTps: TFTps;

const
  query = 'SELECT t_tps.id_tps, t_tps.no_tps, t_kelurahan.nama_kelurahan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM ((((t_tps INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) order by t_tps.id_tps asc';
  queryc = 'SELECT t_tps.id_tps, t_tps.no_tps, t_kelurahan.nama_kelurahan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM ((((t_tps INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';

implementation

uses uutama;

{$R *.lfm}

{ TFTps }

// Write Excel File
function TFTps.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_TPS');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_tps').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, Copy(QuotedStr(AQuery.FieldByName('no_tps').AsString),0,(length(QuotedStr(AQuery.FieldByName('no_tps').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('nama_kecamatan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('nama_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('nama_provinsi').AsString);
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
          AQuery.SQL.Text:='insert into t_tps (id_tps,id_kelurahan,no_tps) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahTPS.getIdKelKota(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_tps',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_tps (id_tps,id_kelurahan,no_tps) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahTPS.getIdKelKota(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'")';
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

procedure TFTps.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;


procedure TFTps.GridTPSPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
    with TStringGrid(GridTPS) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFTps.BRefreshClick(Sender: TObject);
begin
   with DM.ZQTPS do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFTps.BTambahClick(Sender: TObject);
begin
    with FTambahTPS do
    begin
    Hapus;
    SetCB;
    Caption:='Tambah Data TPS';
    PAtas.Caption:='Form Tambah Data TPS';
    EIDTPS.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

procedure TFTps.BKosongkanClick(Sender: TObject);
begin
  //if GridTPS.DataSource.DataSet.RecordCount>0 then
 // begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data TPS?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQTPS do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_tps';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
//  end;
end;

procedure TFTps.BImportClick(Sender: TObject);
begin
  if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQTPS.Close;
     ReadXLSFile(DM.ZQTPS,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQTPS.SQL.Clear;
     DM.ZQTPS.SQL.Text:=query;
     DM.ZQTPS.Open;
     MessageDlg('Data TPS Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFTps.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridTPS.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data TPS "'+GridTPS.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridTPS.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQTPS do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_tps where id_tps="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFTps.BCariClick(Sender: TObject);
var
  notps : string;
begin
    InputQuery('Cari TPS', 'Nomor/Nama TPS Atau Kelurahan', notps);
    if not (notps='') then
    begin
    with DM.ZQTPS do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_tps.no_tps like "%'+notps+'%" or t_kelurahan.nama_kelurahan like "%'+notps+'%" order by t_tps.id_tps asc';
          Open;
        end;
    end;
end;

procedure TFTps.BEditClick(Sender: TObject);
begin
    if GridTPS.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahTPS do
    begin
    SetCB;
    Caption:='Ubah Data TPS';
    PAtas.Caption:='Form Ubah Data TPS';
    BSimpan.Caption:='Perbarui';
    EIDTPS.Enabled:=False;
    EIDTPS.Text:=GridTPS.DataSource.DataSet.Fields[0].Value;
    ENoNamaTPS.Text:=GridTPS.DataSource.DataSet.Fields[1].Value;
    CBKelDesa.Text:=GridTPS.DataSource.DataSet.Fields[2].Value;
    CBKec.Text:=GridTPS.DataSource.DataSet.Fields[3].Value;
    CBKabKota.Text:=GridTPS.DataSource.DataSet.Fields[4].Value;
    CBProv.Text:=GridTPS.DataSource.DataSet.Fields[5].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFTps.BEksportClick(Sender: TObject);
begin
   if GridTPS.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQTPS,FUtama.SaveExcel.FileName);
     MessageDlg('Data TPS Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

end.

