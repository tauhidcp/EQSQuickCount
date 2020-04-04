unit upolling;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, comObj, Variants, Grids, Menus, rxdbgrid, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset, udatamodule, ukirimsms, db;

type

  { TFPolling }

  TFPolling = class(TForm)
    BCari: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridPolling: TRxDBGrid;
    MenuKirimPesan: TMenuItem;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PopKirimSMS: TMenuItem;
    PopSMS: TPopupMenu;
    procedure BCariClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridPollingPrepareCanvas(sender: TObject; DataCol: Integer;
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
  FPolling: TFPolling;

const
  query = 'SELECT t_polling.id_polling, t_polling.nama, t_kelurahan.nama_kelurahan, t_polling.nohp, t_polling.idtelegram, t_polling.idchat, t_polling.pekerjaan FROM (t_polling INNER JOIN t_kelurahan ON t_polling.desa_kelurahan=t_kelurahan.id_kelurahan) order by t_polling.id_polling asc';
  queryc = 'SELECT t_polling.id_polling, t_polling.nama, t_kelurahan.nama_kelurahan, t_polling.nohp, t_polling.idtelegram, t_polling.idchat, t_polling.pekerjaan FROM (t_polling INNER JOIN t_kelurahan ON t_polling.desa_kelurahan=t_kelurahan.id_kelurahan)';

implementation

uses uutama, uchat;

{$R *.lfm}

{ TFPolling }

// Write Excel File
function TFPolling.SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Polling');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id_polling').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('nama').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('nama_kelurahan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, Copy(QuotedStr(AQuery.FieldByName('nohp').AsString),0,(length(QuotedStr(AQuery.FieldByName('nohp').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('pekerjaan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('idtelegram').AsString);
 // MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('idchat').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;
// End Write Excel File

procedure TFPolling.GridPollingPrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridPolling) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFPolling.MenuKirimPesanClick(Sender: TObject);
begin
      if GridPolling.DataSource.DataSet.RecordCount>0 then
  begin
 with FChat do
 begin
 hapus;
 EIDChat.Text:=GridPolling.DataSource.DataSet.Fields[4].Value;
 LNama.Caption:=GridPolling.DataSource.DataSet.Fields[1].Value;
 LAlamat.Caption:=GridPolling.DataSource.DataSet.Fields[2].Value;
 LStatus.Caption:='Polling';
 ShowModal;
 end;
  end;
end;

procedure TFPolling.PopKirimSMSClick(Sender: TObject);
begin
    if GridPolling.DataSource.DataSet.RecordCount>0 then
    begin
with FKirimSMS do
begin
hapus;
ENoHP.Text:=GridPolling.DataSource.DataSet.Fields[3].Value;
LNama.Caption:=GridPolling.DataSource.DataSet.Fields[1].Value;
LAlamat.Caption:=GridPolling.DataSource.DataSet.Fields[2].Value;
setCB;
ShowModal;
end;
    end;
end;

procedure TFPolling.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFPolling.BEksportClick(Sender: TObject);
begin
  if GridPolling.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQPolling,FUtama.SaveExcel.FileName);
     MessageDlg('Data Polling Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFPolling.BCariClick(Sender: TObject);
var
  nama : string;
begin
    InputQuery('Cari Data Polling', 'Nama Atau Nomor Handphone', nama);
    if not (nama='') then
    begin
    with DM.ZQPolling do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_polling.nama like "%'+nama+'%" or t_polling.nohp like "%'+nama+'%" order by t_polling.id_polling asc';
          Open;
        end;
    end;
end;

procedure TFPolling.BHapusClick(Sender: TObject);
var
  id : string;
begin
  if GridPolling.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Polling "'+GridPolling.DataSource.DataSet.Fields[1].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridPolling.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQPolling do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_polling where id_polling="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFPolling.BKosongkanClick(Sender: TObject);
begin
  //if GridPolling.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Polling?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQPolling do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_polling';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  //end;
end;

procedure TFPolling.BRefreshClick(Sender: TObject);
begin
   with DM.ZQPolling do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;


end.

