unit uusulsaran;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, comObj, Variants, Grids, Menus, rxdbgrid, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset, udatamodule, ukirimsms, db;

type

  { TFUsulSaran }

  TFUsulSaran = class(TForm)
    BCari: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    MenuKirimPesan: TMenuItem;
    PopKirimSMS: TMenuItem;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PopSMS: TPopupMenu;
    GridUsulSaran: TRxDBGrid;
    procedure BCariClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridUsulSaranAfterQuickSearch(Sender: TObject; Field: TField;
      var AValue: string);
    procedure GridUsulSaranPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure MenuKirimPesanClick(Sender: TObject);
    procedure PopKirimSMSClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FUsulSaran: TFUsulSaran;

const
  query = 'SELECT t_usulsaran.id_usul, t_usulsaran.nama, t_kelurahan.nama_kelurahan, t_usulsaran.nohp, t_usulsaran.idtelegram, t_usulsaran.idchat, t_usulsaran.pekerjaan, t_usulsaran.usulan FROM (t_usulsaran INNER JOIN t_kelurahan ON t_usulsaran.desa_kelurahan=t_kelurahan.id_kelurahan) order by t_usulsaran.id_usul asc';
  queryc = 'SELECT t_usulsaran.id_usul, t_usulsaran.nama, t_kelurahan.nama_kelurahan, t_usulsaran.nohp, t_usulsaran.idtelegram, t_usulsaran.idchat, t_usulsaran.pekerjaan, t_usulsaran.usulan FROM (t_usulsaran INNER JOIN t_kelurahan ON t_usulsaran.desa_kelurahan=t_kelurahan.id_kelurahan)';

implementation

uses uutama, uchat;

{$R *.lfm}

{ TFUsulSaran }

// Write Excel File
function TFUsulSaran.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_UsulSaran');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_usul').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, Copy(QuotedStr(AQuery.FieldByName('nohp').AsString),0,(length(QuotedStr(AQuery.FieldByName('nohp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('idtelegram').AsString);
 // MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('idchat').AsString);
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('pekerjaan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('usulan').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;
// End Write Excel File

procedure TFUsulSaran.GridUsulSaranPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridUsulSaran) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFUsulSaran.MenuKirimPesanClick(Sender: TObject);
begin
 if GridUsulSaran.DataSource.DataSet.RecordCount>0 then
  begin
 with FChat do
 begin
 hapus;
 EIDChat.Text:=GridUsulSaran.DataSource.DataSet.Fields[4].Value;
 LNama.Caption:=GridUsulSaran.DataSource.DataSet.Fields[1].Value;
 LAlamat.Caption:=GridUsulSaran.DataSource.DataSet.Fields[2].Value;
 LStatus.Caption:='Usul';
 LSMS.Show;
 ShowModal;
 end;
  end;
end;

procedure TFUsulSaran.PopKirimSMSClick(Sender: TObject);
begin
  if GridUsulSaran.DataSource.DataSet.RecordCount>0 then
  begin
with FKirimSMS do
begin
hapus;
ENoHP.Text:=GridUsulSaran.DataSource.DataSet.Fields[3].Value;
LNama.Caption:=GridUsulSaran.DataSource.DataSet.Fields[1].Value;
LAlamat.Caption:=GridUsulSaran.DataSource.DataSet.Fields[2].Value;
LSMS.Show;
setCB;
ShowModal;
end;
end;
end;

procedure TFUsulSaran.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFUsulSaran.GridUsulSaranAfterQuickSearch(Sender: TObject;
  Field: TField; var AValue: string);
begin

end;

procedure TFUsulSaran.BEksportClick(Sender: TObject);
begin
  if GridUsulSaran.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQUsulSaran,FUtama.SaveExcel.FileName);
     MessageDlg('Data Usul Saran Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFUsulSaran.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari Usul Saran', 'Nama Atau Nomor Handphone', nama);
    if not (nama='') then
    begin
    with DM.ZQUsulSaran do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_usulsaran.nama like "%'+nama+'%" or t_usulsaran.nohp like "%'+nama+'%" order by t_usulsaran.id_usul asc';
          Open;
        end;
    end;
end;

procedure TFUsulSaran.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridUsulSaran.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Usul Saran "'+GridUsulSaran.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridUsulSaran.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQUsulSaran do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_usulsaran where id_usul="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFUsulSaran.BKosongkanClick(Sender: TObject);
begin
  //if GridUsulSaran.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Usul Saran?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQUsulSaran do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_usulsaran';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFUsulSaran.BRefreshClick(Sender: TObject);
begin
    with DM.ZQUsulSaran do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;


end.

