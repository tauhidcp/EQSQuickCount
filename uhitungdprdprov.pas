unit uhitungdprdprov;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, VirtualTrees, rxdbgrid, udatamodule, uubahhitungdprdprov,
  fpspreadsheet, fpstypes, xlsxooxml, upilihpartai, comObj, Variants, ZDataset,
  ucekserial, Grids, DBGrids, ufilterhitung;

type

  { TFHitungDPRDProv }

  TFHitungDPRDProv = class(TForm)
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BFilter: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridHitungDPRDProv: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridHitungDPRDProvPrepareCanvas(sender: TObject;
      DataCol: Integer; Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  procedure BuatNode;
  procedure HapusNode;
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FHitungDPRDProv: TFHitungDPRDProv;
  i,j,k,l,m,n : integer;

const
  query =   'SELECT t_calegdprdprov.id, t_calegdprdprov.no_urut, '+
            't_calegdprdprov.nama_caleg, t_partai.nama_partai, t_provinsi.nama_provinsi,'+
            't_kabkota.nama_kota, t_dapil.nama_dapil, t_kecamatan.nama_kecamatan, '+
            't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungdprdprov.perolehan, '+
            't_hitungdprdprov.suara_sah, t_hitungdprdprov.suara_tidaksah, t_hitungdprdprov.dpt '+
            'FROM ((((((((t_calegdprdprov '+
            'INNER JOIN t_hitungdprdprov ON t_hitungdprdprov.id_caleg=t_calegdprdprov.id) '+
            'INNER JOIN t_tps ON t_tps.id_tps=t_hitungdprdprov.tps) '+
            'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
            'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
            'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
            'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) '+
            'INNER JOIN t_dapil ON t_calegdprdprov.dapil=t_dapil.id_dapil) '+
            'INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdprov.partai) '+
            'ORDER BY t_calegdprdprov.id ASC';

implementation

uses uutama;

{$R *.lfm}

{ TFHitungDPRDProv }

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
  SQL.Text:='select id from t_calegdprdprov where nama_caleg="'+nama+'" and dapil="'+getIdDapil(dapil)+'" and partai="'+getNoPartai(partai)+'"';
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
          AQuery.SQL.Text:='insert into t_hitungdprdprov (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values '+
          '("'+getIdDapil(XLApp.Cells[y,4].Value)+'","'+
          getNoUrut(XLApp.Cells[y,2].Value,XLApp.Cells[y,4].Value,XLApp.Cells[y,3].Value)+'","'+getIdTPS(XLApp.Cells[y,6].Value,XLApp.Cells[y,5].Value)+'","'+Trim(XLApp.Cells[y,7].Value)
          +'","'+Trim(XLApp.Cells[y,8].Value)+'","'+Trim(XLApp.Cells[y,9].Value)+'","'+Trim(XLApp.Cells[y,10].Value)
          +'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_hitungdprdprov',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_hitungdprdprov (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values '+
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

procedure TFHitungDPRDProv.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFHitungDPRDProv.GridHitungDPRDProvPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
        with TStringGrid(GridHitungDPRDProv) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFHitungDPRDProv.BuatNode;
begin

end;

procedure TFHitungDPRDProv.HapusNode;
begin

end;

function TFHitungDPRDProv.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Hitung_DPRDProv');
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

procedure TFHitungDPRDProv.BEditClick(Sender: TObject);
begin
    with FUbahHitungDPRDProv do
  begin
    Caption:='Ubah Data Perhitungan DPRD Provinsi';
    hapus;
    ShowModal;
  end;
end;

procedure TFHitungDPRDProv.BEksportClick(Sender: TObject);
begin
 if FUtama.SaveExcel.Execute then
    begin
    SaveAsExcelFile(DM.ZQHDPRDP,FUtama.SaveExcel.FileName);
    MessageDlg('Data Hasil Perhitungan DPRD Provinsi Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
    end;
end;

procedure TFHitungDPRDProv.BFilterClick(Sender: TObject);
begin
    with FFilterHitung do
    begin
    Caption:='Filter Data Perhitungan';
    LMode.Caption:='DPRDProv';
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

procedure TFHitungDPRDProv.BImportClick(Sender: TObject);
begin
  if FUtama.ExcelDialog.Execute then
     begin
     ReadXLSFile(DM.ZQCari5,FUtama.ExcelDialog.FileName,FUtama);
     MessageDlg('Data Perhitungan DPRD Provinsi Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFHitungDPRDProv.BKosongkanClick(Sender: TObject);
begin
 if MessageDlg('Anda Akan Menghapus SEMUA Data Perhitungan CALEG DPRD Provinsi?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQCari do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_hitungdprdprov';
      ExecSQL;
    end;
  BRefresh.Click;
  end;
end;

procedure TFHitungDPRDProv.BRefreshClick(Sender: TObject);
begin
  with DM.ZQHDPRDP do
  begin
  Close;
  SQL.Clear;
  SQL.Text:=query;
  Open;
  end;
end;

end.

