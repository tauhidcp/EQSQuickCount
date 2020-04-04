unit udukunganindependen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, comObj, Variants, Grids, Menus, rxdbgrid, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset, udatamodule, ukirimsms, utambahdukunganindie, ucekserial;

type

  { TFDukunganIndependen }

  TFDukunganIndependen = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    GridDukunganIndie: TRxDBGrid;
    MenuKirimPesan: TMenuItem;
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
    procedure GridDukunganIndiePrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure MenuKirimPesanClick(Sender: TObject);
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
  FDukunganIndependen: TFDukunganIndependen;

const
  query = 'SELECT t_dukunganindie.id_dukung, t_dukunganindie.noktp, t_dukunganindie.nama, t_kelurahan.nama_kelurahan, t_dukunganindie.nohp, t_dukunganindie.idtelegram, t_dukunganindie.idchat FROM (t_dukunganindie INNER JOIN t_kelurahan ON t_dukunganindie.desa_kelurahan=t_kelurahan.id_kelurahan) order by t_dukunganindie.id_dukung asc';
  queryc = 'SELECT t_dukunganindie.id_dukung, t_dukunganindie.noktp, t_dukunganindie.nama, t_kelurahan.nama_kelurahan, t_dukunganindie.nohp, t_dukunganindie.idtelegram, t_dukunganindie.idchat FROM (t_dukunganindie INNER JOIN t_kelurahan ON t_dukunganindie.desa_kelurahan=t_kelurahan.id_kelurahan)';

implementation

uses uutama, uchat;

{$R *.lfm}

{ TFDukunganIndependen }

// Write Excel File
function TFDukunganIndependen.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_DukunganIndependen');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_dukung').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, Copy(QuotedStr(AQuery.FieldByName('noktp').AsString),0,(length(QuotedStr(AQuery.FieldByName('noktp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, Copy(QuotedStr(AQuery.FieldByName('nohp').AsString),0,(length(QuotedStr(AQuery.FieldByName('nohp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('idtelegram').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

function TFDukunganIndependen.getNamaProv(namakabkota: String): String;
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

function TFDukunganIndependen.getNamaKab(namakec: String): String;
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

function TFDukunganIndependen.getNamaKec(namakel: String): String;
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
        AQuery.SQL.Text:='insert into t_dukunganindie (id_dukung,noktp,nama,desa_kelurahan,nohp,idtelegram,idchat) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+Trim(XLApp.Cells[y,3].Value)+'","'+FTambahDukunganIndependen.getIdKelurahan(XLApp.Cells[y,4].Value)+'","'+Trim(XLApp.Cells[y,5].Value)+'","'+Trim(XLApp.Cells[y,6].Value)+'","-")';
        AQuery.ExecSQL;
        end else
        begin
        if (cekData('t_dukunganindie',10)=True) then exit else
           begin
           AQuery.SQL.Clear;
           AQuery.SQL.Text:='insert into t_dukunganindie (id_dukung,noktp,nama,desa_kelurahan,nohp,idtelegram,idchat) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+Trim(XLApp.Cells[y,2].Value)+'","'+Trim(XLApp.Cells[y,3].Value)+'","'+FTambahDukunganIndependen.getIdKelurahan(XLApp.Cells[y,4].Value)+'","'+Trim(XLApp.Cells[y,5].Value)+'","'+Trim(XLApp.Cells[y,6].Value)+'","-")';
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

procedure TFDukunganIndependen.GridDukunganIndiePrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  with TStringGrid(GridDukunganIndie) do
  begin
     Options := Options + [goRowSelect];
  end;
end;

procedure TFDukunganIndependen.MenuKirimPesanClick(Sender: TObject);
begin
    if GridDukunganIndie.DataSource.DataSet.RecordCount>0 then
  begin
 with FChat do
 begin
 hapus;
 EIDChat.Text:=GridDukunganIndie.DataSource.DataSet.Fields[5].Value;
 LNama.Caption:=GridDukunganIndie.DataSource.DataSet.Fields[2].Value;
 LAlamat.Caption:=GridDukunganIndie.DataSource.DataSet.Fields[3].Value;
 LStatus.Caption:='Dukung';
 ShowModal;
 end;
  end;
end;

procedure TFDukunganIndependen.PopKirimSMSClick(Sender: TObject);
begin
  if GridDukunganIndie.DataSource.DataSet.RecordCount>0 then
  begin
  with FKirimSMS do
  begin
  hapus;
  ENoHP.Text:=GridDukunganIndie.DataSource.DataSet.Fields[4].Value;
  LNama.Caption:=GridDukunganIndie.DataSource.DataSet.Fields[2].Value;
  LAlamat.Caption:=GridDukunganIndie.DataSource.DataSet.Fields[3].Value;
  setCB;
  ShowModal;
  end;
  end;
end;

procedure TFDukunganIndependen.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDukunganIndependen.BEksportClick(Sender: TObject);
begin
  if GridDukunganIndie.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQDukIndie,FUtama.SaveExcel.FileName);
     MessageDlg('Data Dukungan Independen Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFDukunganIndependen.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari Dukungan Independen', 'Nama Atau Nomor Handphone', nama);
    if not (nama='') then
    begin
    with DM.ZQDukIndie do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_dukunganindie.nama like "%'+nama+'%" or t_dukunganindie.nohp like "%'+nama+'%" order by t_dukunganindie.id_dukung asc';
          Open;
        end;
    end;
end;

procedure TFDukunganIndependen.BEditClick(Sender: TObject);
begin
  if GridDukunganIndie.DataSource.DataSet.RecordCount>0 then
    begin
    with FTambahDukunganIndependen do
    begin
    SetCB;
    Caption:='Ubah Dukungan Independen';
    PAtas.Caption:='Form Ubah Dukungan Independen';
    BSimpan.Caption:='Perbarui';
    EID.Enabled:=False;
    EID.Text:=GridDukunganIndie.DataSource.DataSet.Fields[0].Value;
    ENoKTP.Text:=GridDukunganIndie.DataSource.DataSet.Fields[1].Value;
    ENama.Text:=GridDukunganIndie.DataSource.DataSet.Fields[2].Value;
    CBKelDesa.Text:=GridDukunganIndie.DataSource.DataSet.Fields[3].Value;
    EIDTelegram.Text:=GridDukunganIndie.DataSource.DataSet.Fields[6].Value;
    CBKec.Text:=getNamaKec(CBKelDesa.Text);
    CBKabKota.Text:=getNamaKab(CBKec.Text);
    CBProv.Text:=getNamaProv(CBKabKota.Text);
    ENoHP.Text:=GridDukunganIndie.DataSource.DataSet.Fields[4].Value;
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
end;

procedure TFDukunganIndependen.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridDukunganIndie.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Dukungan Independen "'+GridDukunganIndie.DataSource.DataSet.Fields[2].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridDukunganIndie.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQDukIndie do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_dukunganindie where id_dukung="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFDukunganIndependen.BImportClick(Sender: TObject);
begin
     if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQDukIndie.Close;
     ReadXLSFile(DM.ZQDukIndie,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQDukIndie.SQL.Clear;
     DM.ZQDukIndie.SQL.Text:=query;
     DM.ZQDukIndie.Open;
     MessageDlg('Data Dukungan Independen Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFDukunganIndependen.BKosongkanClick(Sender: TObject);
begin
  //if GridDukunganIndie.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Dukungan Independen?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQDukIndie do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_dukunganindie';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  //end;
end;

procedure TFDukunganIndependen.BRefreshClick(Sender: TObject);
begin
   with DM.ZQDukIndie do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFDukunganIndependen.BTambahClick(Sender: TObject);
begin
      with FTambahDukunganIndependen do
    begin
    Hapus;
    SetCB;
    Caption:='Tambah Dukungan Independen';
    PAtas.Caption:='Form Tambah Dukungan Independen';
    EID.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

end.

