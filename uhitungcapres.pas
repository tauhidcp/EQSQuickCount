unit uhitungcapres;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ComCtrls, Menus, VirtualTrees, rxdbgrid, udatamodule,
  uubahhitungcapres, fpspreadsheet, fpstypes, xlsxooxml, comObj, Variants,
  ZDataset, ucekserial, Grids, DBGrids, ufilterhitung;

type

  { TFHitungCapres }

  TFHitungCapres = class(TForm)
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BFilter: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridHitungCapres: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BEditClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridHitungCapresPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FHitungCapres: TFHitungCapres;
  i,j,k,l,m,n : integer;

const
  query =   'SELECT t_capres.no_urut, t_capres.nama_capres, t_provinsi.nama_provinsi, '+
            't_kabkota.nama_kota, t_kecamatan.nama_kecamatan, '+
            't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungcapres.perolehan, '+
            't_hitungcapres.suara_sah, t_hitungcapres.suara_tidaksah, t_hitungcapres.dpt '+
            'FROM ((((((t_hitungcapres '+
            'INNER JOIN t_capres ON t_capres.no_urut=t_hitungcapres.no_urut) '+
            'INNER JOIN t_tps ON t_tps.id_tps=t_hitungcapres.tps) '+
            'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
            'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
            'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
            'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) '+
            'ORDER BY t_capres.no_urut ASC';

implementation

uses uutama;

{$R *.lfm}

{ TFHitungCapres }

// Eksport Excel
function TFHitungCapres.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Hitung_Capres');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('no_urut').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama_capres').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_provinsi').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('nama_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('nama_kecamatan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('no_tps').AsString);
  MyWorksheet.WriteCellValueAsString(i, 7, AQuery.FieldByName('perolehan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 8, AQuery.FieldByName('suara_sah').AsString);
  MyWorksheet.WriteCellValueAsString(i, 9, AQuery.FieldByName('suara_tidaksah').AsString);
  MyWorksheet.WriteCellValueAsString(i, 10, AQuery.FieldByName('dpt').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;
// End Eksport

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

// getNoUrut Capres
function getNoUrut(nama: string): string;
begin
 Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_urut as id from t_capres where nama_capres="'+nama+'"';
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
             (Trim(XLApp.Cells[y,7].Value)<>'') and (Trim(XLApp.Cells[y,8].Value)<>'') then begin
          if (cekSerial()=True) then
          begin
          AQuery.SQL.Clear;
          AQuery.SQL.Text:='insert into t_hitungcapres (no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values '+
          '("'+
          getNoUrut(XLApp.Cells[y,2].Value)+'","'+getIdTPS(XLApp.Cells[y,4].Value,XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,5].Value)
          +'","'+Trim(XLApp.Cells[y,6].Value)+'","'+Trim(XLApp.Cells[y,7].Value)+'","'+Trim(XLApp.Cells[y,8].Value)
          +'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_hitungcapres',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_hitungcapres (no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values '+
             '("'+
             getNoUrut(XLApp.Cells[y,2].Value)+'","'+getIdTPS(XLApp.Cells[y,4].Value,XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,5].Value)
             +'","'+Trim(XLApp.Cells[y,6].Value)+'","'+Trim(XLApp.Cells[y,7].Value)+'","'+Trim(XLApp.Cells[y,8].Value)
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

procedure TFHitungCapres.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFHitungCapres.GridHitungCapresPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
        with TStringGrid(GridHitungCapres) do
  begin
      Options := Options + [goRowSelect];
  end;
end;


procedure TFHitungCapres.BRefreshClick(Sender: TObject);
begin
  with DM.ZQHCapres do
  begin
  Close;
  SQL.Clear;
  SQL.Text:=query;
  Open;
  end;
end;

procedure TFHitungCapres.BEditClick(Sender: TObject);
begin
 with FUbahHitungCapres do begin
 Caption:='Ubah Data Perhitungan CAPRES';
 hapus;
 setCB;
 ShowModal;
 end;
end;

procedure TFHitungCapres.BEksportClick(Sender: TObject);
begin
 if FUtama.SaveExcel.Execute then
    begin
    SaveAsExcelFile(DM.ZQHCapres,FUtama.SaveExcel.FileName);
    MessageDlg('Data Hasil Perhitungan CAPRES Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
    end;
end;

procedure TFHitungCapres.BFilterClick(Sender: TObject);
begin
with FFilterHitung do
  begin
    Caption:='Filter Data Perhitungan';
    LMode.Caption:='Capres';
    LKat.Caption:='CAPRES';
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
    DM.ZQCapres.First;
    for i:= 1 to DM.ZQCapres.RecordCount do
    begin
    CBKat.Items.Add(DM.ZQCapres.FieldByName('nama_capres').AsString);
    DM.ZQCapres.Next;
    end;
    // End Set
    ShowModal;
  end;
end;

procedure TFHitungCapres.BImportClick(Sender: TObject);
begin
    if FUtama.ExcelDialog.Execute then
     begin
     ReadXLSFile(DM.ZQCari5,FUtama.ExcelDialog.FileName,FUtama);
     MessageDlg('Data Perhitungan CAPRES Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFHitungCapres.BKosongkanClick(Sender: TObject);
begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Perhitungan CAPRES?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQCari do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_hitungcapres';
      ExecSQL;
    end;
  BRefresh.Click;
  end;
end;


end.

