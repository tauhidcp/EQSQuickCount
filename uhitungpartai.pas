unit uhitungpartai;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, VirtualTrees, rxdbgrid, udatamodule, uubahhitungpartai,
  fpspreadsheet, fpstypes, xlsxooxml, comObj, Variants, ZDataset, ucekserial,
  Grids, DBGrids, ufilterhitung;

type

  { TFHitungPartai }

  TFHitungPartai = class(TForm)
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BFilter: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridHitungPartai: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridHitungPartaiPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FHitungPartai: TFHitungPartai;
  i,j,k,l,m,n : integer;

const
  query =   'SELECT t_partai.no_urut, t_partai.nama_partai, t_provinsi.nama_provinsi, '+
            't_kabkota.nama_kota, t_kecamatan.nama_kecamatan, '+
            't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungpartai.suara_dprdkab, '+
            't_hitungpartai.suara_dprdprov, t_hitungpartai.suara_dprri, '+
            't_hitungpartai.suara_sah, '+
            't_hitungpartai.suara_tidaksah, t_hitungpartai.dpt '+
            'FROM ((((((t_hitungpartai '+
            'INNER JOIN t_partai ON t_partai.no_urut=t_hitungpartai.no_urut) '+
            'INNER JOIN t_tps ON t_tps.id_tps=t_hitungpartai.tps) '+
            'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
            'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
            'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
            'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) '+
            'ORDER BY t_partai.no_urut ASC';

implementation

uses uutama;

{$R *.lfm}

{ TFHitungPartai }

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
          AQuery.SQL.Text:='insert into t_hitungpartai (no_urut,tps,suara_dprdkab,suara_dprdprov,suara_dprri,suara_sah,suara_tidaksah,dpt) values '+
          '("'+getNoPartai(XLApp.Cells[y,2].Value)+'","'+
          getIdTPS(XLApp.Cells[y,4].Value,XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,5].Value)
          +'","'+Trim(XLApp.Cells[y,6].Value)+'","'+Trim(XLApp.Cells[y,7].Value)+'","'+Trim(XLApp.Cells[y,8].Value)
          +'","'+Trim(XLApp.Cells[y,9].Value)+'","'+Trim(XLApp.Cells[y,10].Value)
          +'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_hitungpartai',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_hitungpartai (no_urut,tps,suara_dprdkab,suara_dprdprov,suara_dprri,suara_sah,suara_tidaksah,dpt) values '+
             '("'+getNoPartai(XLApp.Cells[y,2].Value)+'","'+
             getIdTPS(XLApp.Cells[y,4].Value,XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,5].Value)
             +'","'+Trim(XLApp.Cells[y,6].Value)+'","'+Trim(XLApp.Cells[y,7].Value)+'","'+Trim(XLApp.Cells[y,8].Value)
             +'","'+Trim(XLApp.Cells[y,9].Value)+'","'+Trim(XLApp.Cells[y,10].Value)
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

procedure TFHitungPartai.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFHitungPartai.GridHitungPartaiPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
        with TStringGrid(GridHitungPartai) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

function TFHitungPartai.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Hitung_Partai');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('no_urut').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama_partai').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_provinsi').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('nama_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('nama_kecamatan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('no_tps').AsString);
  MyWorksheet.WriteCellValueAsString(i, 7, AQuery.FieldByName('suara_dprdkab').AsString);
  MyWorksheet.WriteCellValueAsString(i, 8, AQuery.FieldByName('suara_dprdprov').AsString);
  MyWorksheet.WriteCellValueAsString(i, 9, AQuery.FieldByName('suara_dprri').AsString);
  MyWorksheet.WriteCellValueAsString(i, 10, AQuery.FieldByName('suara_sah').AsString);
  MyWorksheet.WriteCellValueAsString(i, 11, AQuery.FieldByName('suara_tidaksah').AsString);
  MyWorksheet.WriteCellValueAsString(i, 12, AQuery.FieldByName('dpt').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

procedure TFHitungPartai.BEditClick(Sender: TObject);
begin
  with FUbahHitungPartai do begin
     Caption:='Ubah Data Perhitungan Partai';
     hapus;
    ShowModal;
  end;
end;

procedure TFHitungPartai.BEksportClick(Sender: TObject);
begin
 if FUtama.SaveExcel.Execute then
    begin
    SaveAsExcelFile(DM.ZQHPartai,FUtama.SaveExcel.FileName);
    MessageDlg('Data Hasil Perhitungan Partai Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
    end;
end;

procedure TFHitungPartai.BFilterClick(Sender: TObject);
var
  i : integer;
begin
  with FFilterHitung do
  begin
    Caption:='Filter Data Perhitungan';
    LMode.Caption:='Partai';
    LKat.Caption:='Partai';
    setCB;
    hapus;
    // Set Property
    Label1.Visible:=False;
    Label2.Visible:=False;
    CbPartai.Visible:=False;
    CbDapil.Visible:=False;
    Height:=164;
    CBKat.Top:=22;
    LKat.Top:=22;
    CBKat.Items.Clear;
    DM.ZQPartai.First;
    for i:= 1 to DM.ZQPartai.RecordCount do
    begin
    CBKat.Items.Add(DM.ZQPartai.FieldByName('singkatan').AsString);
    DM.ZQPartai.Next;
    end;
    // End Set
    ShowModal;
    end;
  end;

procedure TFHitungPartai.BImportClick(Sender: TObject);
begin
     if FUtama.ExcelDialog.Execute then
     begin
     ReadXLSFile(DM.ZQCari5,FUtama.ExcelDialog.FileName,FUtama);
     MessageDlg('Data Perhitungan Partai Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFHitungPartai.BKosongkanClick(Sender: TObject);
begin
if MessageDlg('Anda Akan Menghapus SEMUA Data Perhitungan Partai?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQCari do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_hitungpartai';
      ExecSQL;
    end;
  BRefresh.Click;
  end;
end;

procedure TFHitungPartai.BRefreshClick(Sender: TObject);
begin
 with DM.ZQHPartai do
  begin
  Close;
  SQL.Clear;
  SQL.Text:=query;
  Open;
  end;
end;

end.

