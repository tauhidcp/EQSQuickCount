unit usaksi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, comObj, Variants, Grids, Menus, rxdbgrid, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset, udatamodule, utambahsaksi, ukirimsms, ucekserial;

type

  { TFSaksi }

  TFSaksi = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridSaksi: TRxDBGrid;
    PopChat: TMenuItem;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PopKirimSMS: TMenuItem;
    PopSMS: TPopupMenu;
    procedure BCariClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridSaksiPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure PopChatClick(Sender: TObject);
    procedure PopKirimSMSClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  function getNamaProv(namakabkota:String):String;
  function getNamaKab(namakec:String):String;
  function getNamaKec(namakel:String):String;
  end;

var
  FSaksi: TFSaksi;

const
  query = 'SELECT t_saksi.id_saksi, t_saksi.nama_saksi, t_kelurahan.nama_kelurahan, t_tps.no_tps, t_saksi.nohp, t_saksi.id_telegram FROM ((t_saksi INNER JOIN t_kelurahan ON t_saksi.desa_kelurahan=t_kelurahan.id_kelurahan) INNER JOIN t_tps ON t_tps.id_tps=t_saksi.tps) order by t_saksi.id_saksi asc';
  queryc = 'SELECT t_saksi.id_saksi, t_saksi.nama_saksi, t_kelurahan.nama_kelurahan, t_tps.no_tps, t_saksi.nohp, t_saksi.id_telegram FROM ((t_saksi INNER JOIN t_kelurahan ON t_saksi.desa_kelurahan=t_kelurahan.id_kelurahan) INNER JOIN t_tps ON t_tps.id_tps=t_saksi.tps)';

implementation

uses uutama, uchat;

{$R *.lfm}

{ TFSaksi }

// Write Excel File
function TFSaksi.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Saksi');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_saksi').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama_saksi').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, Copy(QuotedStr(AQuery.FieldByName('no_tps').AsString),0,(length(QuotedStr(AQuery.FieldByName('no_tps').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 4, Copy(QuotedStr(AQuery.FieldByName('nohp').AsString),0,(length(QuotedStr(AQuery.FieldByName('nohp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('id_telegram').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

function TFSaksi.getNamaProv(namakabkota: String): String;
begin
   Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select id_provinsi as id from t_kabkota where nama_kota="'+namakabkota+'"';
  Open;
 end;
 with DM.ZQCari2 do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_provinsi as nama from t_provinsi where id_provinsi="'+DM.ZQCari.FieldByName('id').AsString+'"';
  Open;
 end;
 if DM.ZQCari2.RecordCount>=1 then
 Result:=DM.ZQCari2.FieldByName('nama').AsString;
end;

function TFSaksi.getNamaKab(namakec: String): String;
begin
 Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select id_kota as id from t_kecamatan where nama_kecamatan="'+namakec+'"';
  Open;
 end;
 with DM.ZQCari2 do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kota as nama from t_kabkota where id_kota="'+DM.ZQCari.FieldByName('id').AsString+'"';
  Open;
 end;
 if DM.ZQCari2.RecordCount>=1 then
 Result:=DM.ZQCari2.FieldByName('nama').AsString;
end;

function TFSaksi.getNamaKec(namakel: String): String;
begin
 Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select id_kecamatan as id from t_kelurahan where nama_kelurahan="'+namakel+'"';
  Open;
 end;
 with DM.ZQCari2 do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kecamatan as nama from t_kecamatan where id_kecamatan="'+DM.ZQCari.FieldByName('id').AsString+'"';
  Open;
 end;
 if DM.ZQCari2.RecordCount>=1 then
 Result:=DM.ZQCari2.FieldByName('nama').AsString;
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
          if (Trim(XLApp.Cells[y,1].Value)<>'') and (Trim(XLApp.Cells[y,2].Value)<>'') and (Trim(XLApp.Cells[y,3].Value)<>'') and (Trim(XLApp.Cells[y,4].Value)<>'') and (Trim(XLApp.Cells[y,5].Value)<>'') and (Trim(XLApp.Cells[y,6].Value)<>'') then begin
          if (cekSerial()=True) then
          begin
          AQuery.SQL.Clear;
          AQuery.SQL.Text:='insert into t_saksi (id_saksi,nama_saksi,desa_kelurahan,tps,nohp,id_telegram,chat_id) values ("'+Trim(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+FTambahSaksi.getIdKelurahan(Trim(XLApp.Cells[y,3].Value))+'","'+FTambahSaksi.getIdTPS(Trim(XLApp.Cells[y,4].Value),Trim(XLApp.Cells[y,3].Value))+'","'+Trim(XLApp.Cells[y,5].Value)+'","'+Trim(XLApp.Cells[y,6].Value)+'","0")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_saksi',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_saksi (id_saksi,nama_saksi,desa_kelurahan,tps,nohp,id_telegram,chat_id) values ("'+Trim(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+FTambahSaksi.getIdKelurahan(Trim(XLApp.Cells[y,3].Value))+'","'+FTambahSaksi.getIdTPS(Trim(XLApp.Cells[y,4].Value),Trim(XLApp.Cells[y,3].Value))+'","'+Trim(XLApp.Cells[y,5].Value)+'","'+Trim(XLApp.Cells[y,6].Value)+'","0")';
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

procedure TFSaksi.GridSaksiPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridSaksi) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFSaksi.PopChatClick(Sender: TObject);
begin
  if GridSaksi.DataSource.DataSet.RecordCount>0 then
  begin
 with FChat do
 begin
 hapus;
 EIDChat.Text:=GridSaksi.DataSource.DataSet.Fields[5].Value;
 LNama.Caption:=GridSaksi.DataSource.DataSet.Fields[1].Value;
 LAlamat.Caption:=GridSaksi.DataSource.DataSet.Fields[2].Value;
 LTPS.Caption:=GridSaksi.DataSource.DataSet.Fields[3].Value;
 LStatus.Caption:='Saksi';
 ShowModal;
 end;
  end;
end;

procedure TFSaksi.PopKirimSMSClick(Sender: TObject);
begin
if GridSaksi.DataSource.DataSet.RecordCount>0 then
  begin
 with FKirimSMS do
 begin
 hapus;
 ENoHP.Text:=GridSaksi.DataSource.DataSet.Fields[4].Value;
 LNama.Caption:=GridSaksi.DataSource.DataSet.Fields[1].Value;
 LAlamat.Caption:=GridSaksi.DataSource.DataSet.Fields[2].Value;
 LTPS.Caption:=GridSaksi.DataSource.DataSet.Fields[3].Value;
 setCB;
 ShowModal;
 end;
  end;
end;

procedure TFSaksi.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFSaksi.BEksportClick(Sender: TObject);
begin
  if GridSaksi.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQSaksi,FUtama.SaveExcel.FileName);
     MessageDlg('Data Saksi Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFSaksi.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari Saksi', 'Nama Atau Nomor Handphone', nama);
    if not (nama='') then
    begin
    with DM.ZQSaksi do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_saksi.nama_saksi like "%'+nama+'%" or t_saksi.nohp like "%'+nama+'%" order by t_saksi.id_saksi asc';
          Open;
        end;
    end;
end;

procedure TFSaksi.BEditClick(Sender: TObject);
begin
    if GridSaksi.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahSaksi do
    begin
    SetCB;
    Caption:='Ubah Data Saksi';
    PAtas.Caption:='Form Ubah Data Saksi';
    BSimpan.Caption:='Perbarui';
    EID.Enabled:=False;
    EID.Text:=GridSaksi.DataSource.DataSet.Fields[0].Value;
    ENama.Text:=GridSaksi.DataSource.DataSet.Fields[1].Value;
    CBKelDesa.Text:=GridSaksi.DataSource.DataSet.Fields[2].Value;
    CBTPS.Text:=GridSaksi.DataSource.DataSet.Fields[3].Value;
    CBKec.Text:=getNamaKec(CBKelDesa.Text);
    CBKabKota.Text:=getNamaKab(CBKec.Text);
    CBProv.Text:=getNamaProv(CBKabKota.Text);
    ENoHP.Text:=GridSaksi.DataSource.DataSet.Fields[4].Value;
    EIDTelegram.Text:=GridSaksi.DataSource.DataSet.Fields[5].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFSaksi.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridSaksi.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Saksi "'+GridSaksi.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridSaksi.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQSaksi do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_saksi where id_saksi="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFSaksi.BImportClick(Sender: TObject);
begin
     if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQSaksi.Close;
     ReadXLSFile(DM.ZQSaksi,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQSaksi.SQL.Clear;
     DM.ZQSaksi.SQL.Text:=query;
     DM.ZQSaksi.Open;
     MessageDlg('Data Saksi Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFSaksi.BKosongkanClick(Sender: TObject);
begin
  //if GridSaksi.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Saksi ?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQSaksi do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_saksi';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFSaksi.BRefreshClick(Sender: TObject);
begin
   with DM.ZQSaksi do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFSaksi.BTambahClick(Sender: TObject);
begin
    with FTambahSaksi do
    begin
    Hapus;
    SetCB;
    Caption:='Tambah Data Saksi';
    PAtas.Caption:='Form Tambah Data Saksi';
    EID.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;


end.

