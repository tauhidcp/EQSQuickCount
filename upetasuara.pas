unit upetasuara;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Menus, rxdbgrid, utambahpetasuara, udatamodule,
  fpspreadsheet, fpstypes, xlsxooxml,  ucekserial, ZDataset, comObj, Variants,
  ukirimsms, Grids, DBGrids, ufilterpeta;

type

  { TFPetaSuara }

  TFPetaSuara = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEdit1: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridPeta: TRxDBGrid;
    SMSDPT: TMenuItem;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PopupSMS: TPopupMenu;
    procedure BCariClick(Sender: TObject);
    procedure BEdit1Click(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridPetaPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure PopKirimSMSClick(Sender: TObject);
    procedure SMSDPTClick(Sender: TObject);
  private

  public
    function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
    function getNoTPS(kel:string;no: string):string;
    function getNoTPSById(id:string):string;
    function getKelurahanById(id:string):string;
    function getKecamatanById(id:string):string;
    function getIdKelurahan(nama: string): string;
    function cariKTP(no:string):integer;
    function ReadXLSFile(AQuery: TZQuery; AFileName:String): Boolean;
    function cariTPSByKTP(ktp:string):string;
  end;

var
  FPetaSuara: TFPetaSuara;

const

  query = 'SELECT t_petasuara.id, t_petasuara.nama, t_petasuara.ktp, t_petasuara.alamat, t_petasuara.nohp, '+
          't_tps.no_tps as no_tps, t_kelurahan.nama_kelurahan, '+
          't_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM '+
          '(((((t_petasuara INNER JOIN t_tps ON t_tps.id_tps=t_petasuara.idtps)'+
          'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
          'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
          'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
          'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';

implementation

uses uutama;

{$R *.lfm}

{ TFPetaSuara }

// Read Excel File
function TFPetaSuara.ReadXLSFile(AQuery: TZQuery; AFileName:String): Boolean;
var
XLApp,Sheet: OLEVariant;
y,MaxRow : Integer;
path: variant;
noTPS: string;
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
          if (Trim(XLApp.Cells[y,1].Value)<>'') and (Trim(XLApp.Cells[y,2].Value)<>'') and (Trim(XLApp.Cells[y,3].Value)<>'') and (Trim(XLApp.Cells[y,4].Value)<>'') and (Trim(XLApp.Cells[y,5].Value)<>'') and (Trim(XLApp.Cells[y,6].Value)<>'')  and (Trim(XLApp.Cells[y,7].Value)<>'') and (Trim(XLApp.Cells[y,8].Value)<>'') then begin
          if (cariKTP(Trim(XLApp.Cells[y,4].Value))=0) then
          begin
          noTPS:=cariTPSByKTP(Trim(XLApp.Cells[y,4].Value));
          if (cekSerial()=True) then
          begin
          AQuery.SQL.Clear;
          AQuery.SQL.Text:='insert into t_petasuara (id,nama,alamat,ktp,idtps,nohp) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+Trim(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,4].Value)+'","'+noTPS+'","'+Trim(XLApp.Cells[y,8].Value)+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_petasuara',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_petasuara (id,nama,alamat,ktp,idtps,nohp) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+Trim(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,4].Value)+'","'+noTPS+'","'+Trim(XLApp.Cells[y,8].Value)+'")';
             AQuery.ExecSQL;
             end;
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

function TFPetaSuara.cariTPSByKTP(ktp: string): string;
begin
 Result:='';
 with DM.ZQCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select tps from t_dpt where ktp="'+ktp+'"';
 Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('tps').AsString;
end;

// End Read Excel File

procedure TFPetaSuara.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFPetaSuara.GridPetaPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
        with TStringGrid(GridPeta) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFPetaSuara.PopKirimSMSClick(Sender: TObject);
var
  d,e,f: string;
begin
if GridPeta.DataSource.DataSet.RecordCount>0 then
begin
    d := GridPeta.DataSource.DataSet.Fields[4].Value;
    e := GridPeta.DataSource.DataSet.Fields[1].Value;
    f := GridPeta.DataSource.DataSet.Fields[3].Value;

if (Trim(d)<>'') then
      begin
       with FKirimSMS do
       begin
       hapus;
       ENoHP.Text     :=d;
       LNama.Caption  :=e;
       LAlamat.Caption:=f;
       setCB;
       ShowModal;
       end;
      end;
  end;
end;

procedure TFPetaSuara.SMSDPTClick(Sender: TObject);
begin
  if GridPeta.DataSource.DataSet.RecordCount>0 then
  begin
   with FKirimSMS do
   begin
   hapus;
   ENoHP.Text:=GridPeta.DataSource.DataSet.Fields[4].Value;
   LNama.Caption:=GridPeta.DataSource.DataSet.Fields[1].Value;
   LAlamat.Caption:=GridPeta.DataSource.DataSet.Fields[3].Value;
   LTPS.Caption:=GridPeta.DataSource.DataSet.Fields[5].Value;
   setCB;
   ShowModal;
   end;
  end;
end;

procedure TFPetaSuara.BRefreshClick(Sender: TObject);
begin
      with DM.ZQPetaSuara do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFPetaSuara.BEksportClick(Sender: TObject);
begin
 if FUtama.SaveExcel.Execute then
      begin
      SaveAsExcelFile(DM.ZQPetaSuara,FUtama.SaveExcel.FileName);
      MessageDlg('Data Peta Suara Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
      end;
end;

procedure TFPetaSuara.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridPeta.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Peta Suara "'+GridPeta.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridPeta.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQPetaSuara do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_petasuara where id="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;


procedure TFPetaSuara.BCariClick(Sender: TObject);
begin
  with FFilterPeta do
    begin
    Caption:='Filter Peta Suara';
    SetCB;
    Hapus;
    LStatus.Caption:='Peta';
    CBKelDesa.Visible:=True;
    Label6.Visible:=True;
    Height:=262;
    ShowModal;
    end;
end;

procedure TFPetaSuara.BEdit1Click(Sender: TObject);
begin
  if GridPeta.DataSource.DataSet.RecordCount>0 then
   begin
        with FTambahPetaSuara do
        begin
          Hapus;
          SetCB;
          Caption:='Ubah Data Peta Suara';
          PAtas.Caption:='Form Ubah Data Peta Suara';
          ENo.Enabled:=True;
          BSimpan.Caption:='Perbarui';
          BBaru.Enabled:=False;
          ENo.Enabled:=False;
          ENo.Text:=GridPeta.DataSource.DataSet.Fields[0].Value;
          ENama.Text:=GridPeta.DataSource.DataSet.Fields[1].Value;
          EKtp.Text:=GridPeta.DataSource.DataSet.Fields[2].Value;
          EAlamat.Text:=GridPeta.DataSource.DataSet.Fields[3].Value;
          ENoHP.Text:=GridPeta.DataSource.DataSet.Fields[4].Value;
          CBTPS.Text:=GridPeta.DataSource.DataSet.Fields[5].Value;
          CBKelDesa.Text:=GridPeta.DataSource.DataSet.Fields[6].Value;
          CBKec.Text:=GridPeta.DataSource.DataSet.Fields[7].Value;
          CBKabKota.Text:=GridPeta.DataSource.DataSet.Fields[8].Value;
          CBProv.Text:=GridPeta.DataSource.DataSet.Fields[9].Value;
          ShowModal;
        end;
   end;
end;

procedure TFPetaSuara.BEditClick(Sender: TObject);
begin
  with FTambahPetaSuara do
  begin
          Hapus;
          SetCB;
          Caption:='Tambah Data Peta Suara';
          PAtas.Caption:='Form Tambah Data Peta Suara';
          ENo.Enabled:=True;
          BSimpan.Caption:='Simpan';
          BBaru.Enabled:=True;
          ShowModal;
        end;
end;

procedure TFPetaSuara.BImportClick(Sender: TObject);
begin
    if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQCari3.Close;
     ReadXLSFile(DM.ZQCari3,FUtama.ExcelDialog.FileName);
     BRefresh.Click;
     MessageDlg('Data Peta Suara Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFPetaSuara.BKosongkanClick(Sender: TObject);
begin
    if MessageDlg('Anda Akan Menghapus SEMUA Data Peta Suara?',mtConfirmation,[mbyes,mbno],0)=mryes then
      begin
      // Hapus Database
      with DM.ZQPetaSuara do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='truncate table t_petasuara';
          ExecSQL;
          SQL.Clear;
          SQL.Text:=query;
          Open;
        end;
      end;
end;

function TFPetaSuara.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Peta_Suara');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('alamat').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, Copy(QuotedStr(AQuery.FieldByName('ktp').AsString),0,(length(QuotedStr(AQuery.FieldByName('ktp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 4, Copy(QuotedStr(AQuery.FieldByName('nohp').AsString),0,(length(QuotedStr(AQuery.FieldByName('nohp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 5, Copy(QuotedStr(AQuery.FieldByName('no_tps').AsString),0,(length(QuotedStr(AQuery.FieldByName('no_tps').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 7, AQuery.FieldByName('nama_kecamatan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 8, AQuery.FieldByName('nama_kota').AsString);
  MyWorksheet.WriteCellValueAsString(i, 9, AQuery.FieldByName('nama_provinsi').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

function TFPetaSuara.getIdKelurahan(nama: string): string;
begin
Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_kelurahan as id from t_kelurahan where nama_kelurahan="'+nama+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFPetaSuara.getNoTPS(kel: string; no: string): string;
begin
Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_tps as id from t_tps where no_tps="'+no+'" and id_kelurahan="'+getIdKelurahan(kel)+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFPetaSuara.getNoTPSById(id: string): string;
begin
Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select no_tps as id from t_tps where id_tps="'+id+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFPetaSuara.getKelurahanById(id: string): string;
begin
Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_kelurahan as id from t_tps where id_tps="'+id+'"';
 Open;
end;
with DM.ZQCari2 do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select nama_kelurahan as id from t_kelurahan where id_kelurahan="'+DM.ZQCari.FieldByName('id').AsString+'"';
 Open;
end;
if DM.ZQCari2.RecordCount>=1 then
Result:=DM.ZQCari2.FieldByName('id').AsString;
end;

function TFPetaSuara.getKecamatanById(id: string): string;
begin
Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_kelurahan as id from t_tps where id_tps="'+id+'"';
 Open;
end;
with DM.ZQCari2 do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_kecamatan as id from t_kelurahan where id_kelurahan="'+DM.ZQCari.FieldByName('id').AsString+'"';
 Open;
end;
with DM.ZQCari3 do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select nama_kecamatan as id from t_kecamatan where id_kecamatan="'+DM.ZQCari2.FieldByName('id').AsString+'"';
 Open;
end;
if DM.ZQCari3.RecordCount>=1 then
Result:=DM.ZQCari3.FieldByName('id').AsString;
end;

function TFPetaSuara.cariKTP(no: string): integer;
begin
Result:=0;
with DM.ZQCari do
begin
Close;
SQL.Clear;
SQL.Text:='select * from t_petasuara where ktp="'+no+'"';
Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=1;
end;



end.

