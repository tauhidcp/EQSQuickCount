unit uusulantimses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, comObj, Variants, Grids, Menus, rxdbgrid, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset, udatamodule, utambahusulantimses, ukirimsms, ucekserial;

type

  { TFUsulanTIMSES }

  TFUsulanTIMSES = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridUsulanRelawan: TRxDBGrid;
    KirimPesanTelegram: TMenuItem;
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
    procedure GridUsulanRelawanPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure KirimPesanTelegramClick(Sender: TObject);
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
  FUsulanTIMSES: TFUsulanTIMSES;

const
  query = 'SELECT t_usulantimses.id_usulan, t_usulantimses.nama, t_kelurahan.nama_kelurahan, t_usulantimses.nohp, t_usulantimses.idchat, t_usulantimses.idtelegram FROM (t_usulantimses INNER JOIN t_kelurahan ON t_usulantimses.desa_kelurahan=t_kelurahan.id_kelurahan) order by t_usulantimses.id_usulan asc';
  queryc = 'SELECT t_usulantimses.id_usulan, t_usulantimses.nama, t_kelurahan.nama_kelurahan, t_usulantimses.nohp, t_usulantimses.idchat, t_usulantimses.idtelegram FROM (t_usulantimses INNER JOIN t_kelurahan ON t_usulantimses.desa_kelurahan=t_kelurahan.id_kelurahan)';

implementation

uses uutama, uchat;

{$R *.lfm}

{ TFUsulanTIMSES }

// Write Excel File
function TFUsulanTIMSES.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Koordinator_TPS');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_usulan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, Copy(QuotedStr(AQuery.FieldByName('nohp').AsString),0,(length(QuotedStr(AQuery.FieldByName('nohp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('idtelegram').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

function TFUsulanTIMSES.getNamaProv(namakabkota: String): String;
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

function TFUsulanTIMSES.getNamaKab(namakec: String): String;
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

function TFUsulanTIMSES.getNamaKec(namakel: String): String;
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
        if (Trim(XLApp.Cells[y,1].Value)<>'') and (Trim(XLApp.Cells[y,2].Value)<>'') and (Trim(XLApp.Cells[y,3].Value)<>'') and (Trim(XLApp.Cells[y,4].Value)<>'') and (Trim(XLApp.Cells[y,5].Value)<>'') then begin
        if (cekSerial()=True) then
        begin
        AQuery.SQL.Clear;
        AQuery.SQL.Text:='insert into t_usulantimses (id_usulan,nama,desa_kelurahan,nohp,idchat,idtelegram) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+FTambahUsulanTimses.getIdKelurahan(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,4].Value)+'","-","'+Trim(XLApp.Cells[y,5].Value)+'")';
        AQuery.ExecSQL;
        end else
        begin
        if (cekData('t_usulantimses',10)=True) then exit else
           begin
           AQuery.SQL.Clear;
           AQuery.SQL.Text:='insert into t_usulantimses (id_usulan,nama,desa_kelurahan,nohp,idchat,idtelegram) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+FTambahUsulanTimses.getIdKelurahan(XLApp.Cells[y,3].Value)+'","'+Trim(XLApp.Cells[y,4].Value)+'","-","'+Trim(XLApp.Cells[y,5].Value)+'")';
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

procedure TFUsulanTIMSES.GridUsulanRelawanPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridUsulanRelawan) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFUsulanTIMSES.KirimPesanTelegramClick(Sender: TObject);
begin
  if GridUsulanRelawan.DataSource.DataSet.RecordCount>0 then
  begin
 with FChat do
 begin
 hapus;
 EIDChat.Text:=GridUsulanRelawan.DataSource.DataSet.Fields[5].Value;
 LNama.Caption:=GridUsulanRelawan.DataSource.DataSet.Fields[1].Value;
 LAlamat.Caption:=GridUsulanRelawan.DataSource.DataSet.Fields[2].Value;
 LStatus.Caption:='KoordinatorTPS';
 ShowModal;
 end;
  end;
end;

procedure TFUsulanTIMSES.PopKirimSMSClick(Sender: TObject);
begin
 if GridUsulanRelawan.DataSource.DataSet.RecordCount>0 then
  begin
 with FKirimSMS do
 begin
 hapus;
 ENoHP.Text:=GridUsulanRelawan.DataSource.DataSet.Fields[3].Value;
 LNama.Caption:=GridUsulanRelawan.DataSource.DataSet.Fields[1].Value;
 LAlamat.Caption:=GridUsulanRelawan.DataSource.DataSet.Fields[2].Value;
 setCB;
 ShowModal;
 end;
  end;
end;

procedure TFUsulanTIMSES.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFUsulanTIMSES.BEksportClick(Sender: TObject);
begin
    if GridUsulanRelawan.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQUsulTimses,FUtama.SaveExcel.FileName);
     MessageDlg('Data Koordinator TPS Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFUsulanTIMSES.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari Koordinator TPS', 'Nama Atau Nomor HP', nama);
    if not (nama='') then
    begin
    with DM.ZQUsulTimses do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_usulantimses.nama like "%'+nama+'%" or t_usulantimses.nohp like "%'+nama+'%" order by t_usulantimses.id_usulan asc';
          Open;
        end;
    end;
end;

procedure TFUsulanTIMSES.BEditClick(Sender: TObject);
begin
    if GridUsulanRelawan.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahUsulanTimses do
    begin
    SetCB;
    Caption:='Ubah Koordinator TPS';
    PAtas.Caption:='Form Ubah Koordinator TPS';
    BSimpan.Caption:='Perbarui';
    EID.Enabled:=False;
    EID.Text:=GridUsulanRelawan.DataSource.DataSet.Fields[0].Value;
    ENama.Text:=GridUsulanRelawan.DataSource.DataSet.Fields[1].Value;
    CBKelDesa.Text:=GridUsulanRelawan.DataSource.DataSet.Fields[2].Value;
    EIDTelegram.Text:=GridUsulanRelawan.DataSource.DataSet.Fields[5].Value;
    CBKec.Text:=getNamaKec(CBKelDesa.Text);
    CBKabKota.Text:=getNamaKab(CBKec.Text);
    CBProv.Text:=getNamaProv(CBKabKota.Text);
    ENoHP.Text:=GridUsulanRelawan.DataSource.DataSet.Fields[3].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFUsulanTIMSES.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridUsulanRelawan.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Koordinator TPS "'+GridUsulanRelawan.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridUsulanRelawan.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQUsulTimses do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_usulantimses where id_usulan="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFUsulanTIMSES.BImportClick(Sender: TObject);
begin
    if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQUsulTimses.Close;
     ReadXLSFile(DM.ZQUsulTimses,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQUsulTimses.SQL.Clear;
     DM.ZQUsulTimses.SQL.Text:=query;
     DM.ZQUsulTimses.Open;
     MessageDlg('Data Koordinator TPS Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFUsulanTIMSES.BKosongkanClick(Sender: TObject);
begin
  //if GridUsulanRelawan.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Koordinator TPS ?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQUsulTimses do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_usulantimses';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFUsulanTIMSES.BRefreshClick(Sender: TObject);
begin
   with DM.ZQUsulTimses do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFUsulanTIMSES.BTambahClick(Sender: TObject);
begin
    with FTambahUsulanTimses do
    begin
    Hapus;
    SetCB;
    Caption:='Tambah Koordinator TPS';
    PAtas.Caption:='Form Tambah Koordinator TPS';
    EID.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;


end.

