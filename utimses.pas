unit utimses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, comObj, Variants, Grids, Menus, rxdbgrid, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset, udatamodule, utambahtimses, ukirimsms, ucekserial;

type

  { TFTIMSES }

  TFTIMSES = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridTimses: TRxDBGrid;
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
    procedure GridTimsesPrepareCanvas(sender: TObject; DataCol: Integer;
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
  FTIMSES: TFTIMSES;

const
  query = 'SELECT t_timses.id_timses, t_timses.nama_timses, t_kelurahan.nama_kelurahan, t_timses.nohp, t_timses.id_telegram FROM (t_timses INNER JOIN t_kelurahan ON t_timses.desa_kelurahan=t_kelurahan.id_kelurahan) order by t_timses.id_timses asc';
  queryc = 'SELECT t_timses.id_timses, t_timses.nama_timses, t_kelurahan.nama_kelurahan, t_timses.nohp, t_timses.id_telegram FROM (t_timses INNER JOIN t_kelurahan ON t_timses.desa_kelurahan=t_kelurahan.id_kelurahan)';

implementation

uses uutama, uchat;

{$R *.lfm}

{ TFTIMSES }

// Write Excel File
function TFTIMSES.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Relawan');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_timses').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama_timses').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, Copy(QuotedStr(AQuery.FieldByName('nohp').AsString),0,(length(QuotedStr(AQuery.FieldByName('nohp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('id_telegram').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

function TFTIMSES.getNamaProv(namakabkota: String): String;
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

function TFTIMSES.getNamaKab(namakec: String): String;
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

function TFTIMSES.getNamaKec(namakel: String): String;
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
          AQuery.SQL.Text:='insert into t_timses (id_timses,nama_timses,desa_kelurahan,nohp,id_telegram,chat_id) values ("'+Trim(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+FTambahTimses.getIdKelurahan(Trim(XLApp.Cells[y,3].Value))+'","'+Trim(XLApp.Cells[y,4].Value)+'","'+Trim(XLApp.Cells[y,5].Value)+'","0")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_timses',10)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_timses (id_timses,nama_timses,desa_kelurahan,nohp,id_telegram,chat_id) values ("'+Trim(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+FTambahTimses.getIdKelurahan(Trim(XLApp.Cells[y,3].Value))+'","'+Trim(XLApp.Cells[y,4].Value)+'","'+Trim(XLApp.Cells[y,5].Value)+'","0")';
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

procedure TFTIMSES.GridTimsesPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridTimses) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFTIMSES.PopChatClick(Sender: TObject);
begin
  if GridTimses.DataSource.DataSet.RecordCount>0 then
   begin
 with FChat do
 begin
 hapus;
 EIDChat.Text:=GridTimses.DataSource.DataSet.Fields[4].Value;
 LNama.Caption:=GridTimses.DataSource.DataSet.Fields[1].Value;
 LAlamat.Caption:=GridTimses.DataSource.DataSet.Fields[2].Value;
 LStatus.Caption:='Timses';
 ShowModal;
 end;
   end;
end;

procedure TFTIMSES.PopKirimSMSClick(Sender: TObject);
begin
 if GridTimses.DataSource.DataSet.RecordCount>0 then
  begin
 with FKirimSMS do
 begin
 hapus;
 ENoHP.Text:=GridTimses.DataSource.DataSet.Fields[3].Value;
 LNama.Caption:=GridTimses.DataSource.DataSet.Fields[1].Value;
 LAlamat.Caption:=GridTimses.DataSource.DataSet.Fields[2].Value;
 setCB;
 ShowModal;
 end;
  end;
end;

procedure TFTIMSES.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFTIMSES.BEksportClick(Sender: TObject);
begin
  if GridTimses.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQTimses,FUtama.SaveExcel.FileName);
     MessageDlg('Data Relawan (TIMSES) Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFTIMSES.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridTimses.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Relawan (TIMSES) "'+GridTimses.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridTimses.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQTimses do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_timses where id_timses="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFTIMSES.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari Relawan (TIMSES)', 'Nama Atau Nomor Handphone', nama);
    if not (nama='') then
    begin
    with DM.ZQTimses do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_timses.nama_timses like "%'+nama+'%" or t_timses.nohp like "%'+nama+'%" order by t_timses.id_timses asc';
          Open;
        end;
    end;
end;

procedure TFTIMSES.BEditClick(Sender: TObject);
begin
    if GridTimses.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahTimses do
    begin
    SetCB;
    Caption:='Ubah Relawan (TIMSES)';
    PAtas.Caption:='Form Ubah Relawan (TIMSES)';
    BSimpan.Caption:='Perbarui';
    EID.Enabled:=False;
    EID.Text:=GridTimses.DataSource.DataSet.Fields[0].Value;
    ENama.Text:=GridTimses.DataSource.DataSet.Fields[1].Value;
    CBKelDesa.Text:=GridTimses.DataSource.DataSet.Fields[2].Value;
    CBKec.Text:=getNamaKec(CBKelDesa.Text);
    CBKabKota.Text:=getNamaKab(CBKec.Text);
    CBProv.Text:=getNamaProv(CBKabKota.Text);
    ENoHP.Text:=GridTimses.DataSource.DataSet.Fields[3].Value;
    EIDTelegram.Text:=GridTimses.DataSource.DataSet.Fields[4].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFTIMSES.BImportClick(Sender: TObject);
begin
     if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQTimses.Close;
     ReadXLSFile(DM.ZQTimses,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQTimses.SQL.Clear;
     DM.ZQTimses.SQL.Text:=query;
     DM.ZQTimses.Open;
     MessageDlg('Data Relawan (TIMSES) Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFTIMSES.BKosongkanClick(Sender: TObject);
begin
  //if GridTimses.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Relawan (TIMSES)?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQTimses do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_timses';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  //end;
end;

procedure TFTIMSES.BRefreshClick(Sender: TObject);
begin
     with DM.ZQTimses do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFTIMSES.BTambahClick(Sender: TObject);
begin
    with FTambahTimses do
    begin
    Hapus;
    SetCB;
    Caption:='Tambah Relawan (TIMSES)';
    PAtas.Caption:='Form Tambah Relawan (TIMSES)';
    EID.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;


end.

