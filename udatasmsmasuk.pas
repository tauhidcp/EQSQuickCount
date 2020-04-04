unit udatasmsmasuk;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Menus, rxdbgrid, udatamodule, Grids, DBGrids, ufilter, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset, ukirimsms;

type

  { TFDataSMSMasuk }

  TFDataSMSMasuk = class(TForm)
    BDelete: TBitBtn;
    BEksport: TBitBtn;
    BFilter: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridSMSMasuk: TRxDBGrid;
    MenuBalas: TMenuItem;
    MenuDetailSMS: TMenuItem;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PopBalas: TPopupMenu;
    procedure BDeleteClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridSMSMasukPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure MenuBalasClick(Sender: TObject);
    procedure MenuDetailSMSClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  function getIdModem(nama:string):string;
  end;

var
  FDataSMSMasuk: TFDataSMSMasuk;

const
  query = 'SELECT t_inboxsms.id, t_inboxsms.tanggal, t_inboxsms.jam, t_modem.nama_modem, t_inboxsms.no_pengirim, t_inboxsms.isi_pesan, t_inboxsms.processed FROM (t_inboxsms INNER JOIN t_modem ON t_modem.id=t_inboxsms.id_modem) order by t_inboxsms.id asc';

implementation

uses uutama;

{$R *.lfm}

{ TFDataSMSMasuk }

procedure TFDataSMSMasuk.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDataSMSMasuk.BFilterClick(Sender: TObject);
begin
  with FFilter do
  begin
   Caption:='Filter Data SMS Masuk';
   setup;
   LData.Caption:='SMSMasuk';
   ShowModal;
  end;
end;

procedure TFDataSMSMasuk.BKosongkanClick(Sender: TObject);
begin
 // if GridSMSMasuk.DataSource.DataSet.RecordCount>0 then
 // begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data SMS Masuk?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQSMSMasuk do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_inboxsms';
      ExecSQL;
      SQL.Clear;
      SQL.Text:='update t_modem set inboxcount="0"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFDataSMSMasuk.BRefreshClick(Sender: TObject);
begin
     with DM.ZQSMSMasuk do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFDataSMSMasuk.BDeleteClick(Sender: TObject);
var
  id, status, modem : string;
begin
  if GridSMSMasuk.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data SMS Masuk "'+GridSMSMasuk.DataSource.DataSet.Fields[4].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridSMSMasuk.DataSource.DataSet.Fields[0].Value;
  status := GridSMSMasuk.DataSource.DataSet.Fields[6].Value;
  modem := GridSMSMasuk.DataSource.DataSet.Fields[3].Value;
  // Hapus Database
  with DM.ZQSMSMasuk do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_inboxsms where id="'+id+'"';
      ExecSQL;
      if (status='Terkirim') then
      begin
      SQL.Clear;
      SQL.Text:='update t_modem set outboxcount=outboxcount-1 where id="'+getIdModem(modem)+'"';
      ExecSQL;
      end;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFDataSMSMasuk.BEksportClick(Sender: TObject);
begin
  if GridSMSMasuk.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQSMSMasuk,FUtama.SaveExcel.FileName);
     MessageDlg('Data SMS Masuk Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFDataSMSMasuk.GridSMSMasukPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridSMSMasuk) do
  begin

    if (GridSMSMasuk.DataSource.DataSet.Fields[6].Value = 'False') then
       begin
         Canvas.Brush.Color:=clYellow;
         Canvas.Font.Color:=clBlack;
       end else
  if (GridSMSMasuk.DataSource.DataSet.Fields[6].Value = 'True') then
       begin
         Canvas.Brush.Color:=clLime;
         Canvas.Font.Color:=clBlack;
       end;
      Options := Options + [goRowSelect];
  end;
end;

procedure TFDataSMSMasuk.MenuBalasClick(Sender: TObject);
begin
  if GridSMSMasuk.DataSource.DataSet.RecordCount>0 then
  begin
 with FKirimSMS do
 begin
 hapus;
 ENoHP.Text:=GridSMSMasuk.DataSource.DataSet.Fields[4].Value;
 LNama.Caption:='';
 LAlamat.Caption:='';
 LTPS.Caption:='';
 setCB;
 ShowModal;
 end;
  end;
end;

procedure TFDataSMSMasuk.MenuDetailSMSClick(Sender: TObject);
begin
  if GridSMSMasuk.DataSource.DataSet.RecordCount>0 then
  begin
  ShowMessage('> No Pengirim : '+GridSMSMasuk.DataSource.DataSet.Fields[4].AsString+sLineBreak+
              '> Isi SMS     : '+sLineBreak+GridSMSMasuk.DataSource.DataSet.Fields[5].AsString);
  end;
end;

function TFDataSMSMasuk.SaveAsExcelFile(AQuery: TZQuery; AFileName: string
  ): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_SMS_Masuk');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, Copy(QuotedStr(AQuery.FieldByName('tanggal').AsString),0,(length(QuotedStr(AQuery.FieldByName('tanggal').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('jam').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('nama_modem').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, Copy(QuotedStr(AQuery.FieldByName('no_pengirim').AsString),0,(length(QuotedStr(AQuery.FieldByName('no_pengirim').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('isi_pesan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('processed').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

function TFDataSMSMasuk.getIdModem(nama: string): string;
begin
    Result :='';
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select id from t_modem where nama_modem="'+nama+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;


end.

