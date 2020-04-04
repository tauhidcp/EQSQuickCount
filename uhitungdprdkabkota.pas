unit uhitungdprdkabkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, VirtualTrees, rxdbgrid, udatamodule, uubahhitungdprdkabkota,
  fpspreadsheet, fpstypes, xlsxooxml, upilihpartai, comObj, Variants, ZDataset,
  ucekserial, Grids, DBGrids, ufilterhitung;

type

  { TFHitungDPRDKabKota }

  TFHitungDPRDKabKota = class(TForm)
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BFilter: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridHitungDPRDKab: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridHitungDPRDKabPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);

  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FHitungDPRDKabKota: TFHitungDPRDKabKota;
  i,j,k,l,m,n : integer;

const
  query =   'SELECT t_calegdprdkabkota.id, t_calegdprdkabkota.no_urut, '+
            't_calegdprdkabkota.nama_caleg, t_partai.nama_partai, t_provinsi.nama_provinsi,'+
            't_kabkota.nama_kota, t_dapil.nama_dapil, t_kecamatan.nama_kecamatan, '+
            't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungdprdkab.perolehan, '+
            't_hitungdprdkab.suara_sah, t_hitungdprdkab.suara_tidaksah, t_hitungdprdkab.dpt '+
            'FROM ((((((((t_hitungdprdkab '+
            'INNER JOIN t_calegdprdkabkota ON t_calegdprdkabkota.id=t_hitungdprdkab.id_caleg) '+
            'INNER JOIN t_tps ON t_tps.id_tps=t_hitungdprdkab.tps) '+
            'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
            'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
            'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
            'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) '+
            'INNER JOIN t_dapil ON t_calegdprdkabkota.dapil=t_dapil.id_dapil) '+
            'INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdkabkota.partai) '+
            'ORDER BY t_calegdprdkabkota.id ASC';

implementation

uses uutama;

{$R *.lfm}

{ TFHitungDPRDKabKota }

// getNoPartai
function getNoPartai(nama: string): string;
begin
 Result:='';
  with DM.ZQCari4 do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select no_urut as id from t_partai where nama_partai="'+nama+'"';
   Open;
  end;
  if DM.ZQCari4.RecordCount>=1 then
  Result:=DM.ZQCari4.FieldByName('id').AsString;
end;

// getIDDapil
function getIdDapil(nama: string): string;
begin
 Result:='';
  with DM.ZQCari3 do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_dapil as id from t_dapil where nama_dapil="'+nama+'"';
   Open;
  end;
  if DM.ZQCari3.RecordCount>=1 then
  Result:=DM.ZQCari3.FieldByName('id').AsString;
end;

// getIDKelurahan
function getIdKelurahan(nama: string): string;
begin
 Result:='';
  with DM.ZQTimerCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_kelurahan as id from t_kelurahan where nama_kelurahan="'+nama+'"';
   Open;
  end;
  if DM.ZQTimerCari.RecordCount>=1 then
  Result:=DM.ZQTimerCari.FieldByName('id').AsString;
end;

// getNoUrut Caleg
function getNoUrut(nama: string;dapil:string;partai:string): string;
begin
 Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select id from t_calegdprdkabkota where nama_caleg="'+nama+'" and dapil="'+getIdDapil(dapil)+'" and partai="'+getNoPartai(partai)+'"';
  Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

// getIDTPS
function getIdTPS(no: string;kelurahan:string): string;
begin
 Result:='';
 with DM.ZQCari2 do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select id_tps as id from t_tps where no_tps="'+no+'" and id_kelurahan="'+getIdKelurahan(kelurahan)+'"';
  Open;
 end;
 if DM.ZQCari2.RecordCount>=1 then
 Result:=DM.ZQCari2.FieldByName('id').AsString;
end;

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
   AQuery.Close;

     for y := 1 to MaxRow do
      begin
      utama.PBLoading.Position:=y;
          if (Trim(XLApp.Cells[y,1].Value)<>'') and (Trim(XLApp.Cells[y,2].Value)<>'') and (Trim(XLApp.Cells[y,3].Value)<>'') and
             (Trim(XLApp.Cells[y,4].Value)<>'') and (Trim(XLApp.Cells[y,5].Value)<>'') and (Trim(XLApp.Cells[y,6].Value)<>'') and
             (Trim(XLApp.Cells[y,7].Value)<>'') and (Trim(XLApp.Cells[y,8].Value)<>'') and (Trim(XLApp.Cells[y,9].Value)<>'')
             and (Trim(XLApp.Cells[y,10].Value)<>'') then begin
          if (cekSerial()=True) then
          begin
          AQuery.SQL.Clear;
          AQuery.SQL.Text:='insert into t_hitungdprdkab (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values '+
          '("'+getIdDapil(XLApp.Cells[y,4].Value)+'","'+
          getNoUrut(XLApp.Cells[y,2].Value,XLApp.Cells[y,4].Value,XLApp.Cells[y,3].Value)+'","'+getIdTPS(XLApp.Cells[y,6].Value,XLApp.Cells[y,5].Value)+'","'+Trim(XLApp.Cells[y,7].Value)
          +'","'+Trim(XLApp.Cells[y,8].Value)+'","'+Trim(XLApp.Cells[y,9].Value)+'","'+Trim(XLApp.Cells[y,10].Value)
          +'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_hitungdprdkab',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_hitungdprdkab (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values '+
             '("'+getIdDapil(XLApp.Cells[y,4].Value)+'","'+
             getNoUrut(XLApp.Cells[y,2].Value,XLApp.Cells[y,4].Value,XLApp.Cells[y,3].Value)+'","'+getIdTPS(XLApp.Cells[y,6].Value,XLApp.Cells[y,5].Value)+'","'+Trim(XLApp.Cells[y,7].Value)
             +'","'+Trim(XLApp.Cells[y,8].Value)+'","'+Trim(XLApp.Cells[y,9].Value)+'","'+Trim(XLApp.Cells[y,10].Value)
             +'")';
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

procedure TFHitungDPRDKabKota.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFHitungDPRDKabKota.GridHitungDPRDKabPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
        with TStringGrid(GridHitungDPRDKab) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

function TFHitungDPRDKabKota.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Hitung_DPRDKab');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('no_urut').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_caleg').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('nama_partai').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('nama_provinsi').AsString);
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('nama_dapil').AsString);
  MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('nama_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 7, AQuery.FieldByName('nama_kecamatan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 8, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 9, AQuery.FieldByName('no_tps').AsString);
  MyWorksheet.WriteCellValueAsString(i, 10, AQuery.FieldByName('perolehan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 11, AQuery.FieldByName('suara_sah').AsString);
  MyWorksheet.WriteCellValueAsString(i, 12, AQuery.FieldByName('suara_tidaksah').AsString);
  MyWorksheet.WriteCellValueAsString(i, 13, AQuery.FieldByName('dpt').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

procedure TFHitungDPRDKabKota.BEditClick(Sender: TObject);
begin
    with FUbahHitungDPRDKab do
  begin
    Caption:='Ubah Data Perhitungan DPRD Kabupaten/Kota';
    hapus;
    ShowModal;
  end;
end;

procedure TFHitungDPRDKabKota.BEksportClick(Sender: TObject);
begin
 if FUtama.SaveExcel.Execute then
    begin
    SaveAsExcelFile(DM.ZQHDPRDK,FUtama.SaveExcel.FileName);
    MessageDlg('Data Hasil Perhitungan DPRD Kabupaten/Kota Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
    end;
end;

procedure TFHitungDPRDKabKota.BFilterClick(Sender: TObject);
begin
      with FFilterHitung do
  begin
    Caption:='Filter Data Perhitungan';
    LMode.Caption:='DPRDKab';
    LKat.Caption:='Caleg';
    setCB;
    hapus;
    // Set Property
    Label1.Visible:=True;
    Label2.Visible:=True;
    CbPartai.Visible:=True;
    CbDapil.Visible:=True;
    Height:=249;
    CBKat.Top:=104;
    LKat.Top:=104;
    // End Set
    ShowModal;
  end;

end;

procedure TFHitungDPRDKabKota.BImportClick(Sender: TObject);
begin
  if FUtama.ExcelDialog.Execute then
     begin
     ReadXLSFile(DM.ZQCari5,FUtama.ExcelDialog.FileName,FUtama);
     MessageDlg('Data Perhitungan DPRD Kabupaten/Kota Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFHitungDPRDKabKota.BKosongkanClick(Sender: TObject);
begin
 if MessageDlg('Anda Akan Menghapus SEMUA Data Perhitungan CALEG DPRD Kabupaten/Kota?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQCari do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_hitungdprdkab';
      ExecSQL;
    end;
  BRefresh.Click;
  end;
end;

procedure TFHitungDPRDKabKota.BRefreshClick(Sender: TObject);
begin
  with DM.ZQHDPRDK do
  begin
  Close;
  SQL.Clear;
  SQL.Text:=query;
  Open;
  end;
end;

end.

