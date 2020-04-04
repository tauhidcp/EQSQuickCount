unit udatasmsterkirim;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, rxdbgrid, udatamodule, Grids, DBGrids, ufilter, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset, db;

type

  { TFDataSMSTerkirim }

  TFDataSMSTerkirim = class(TForm)
    BDelete: TBitBtn;
    BEksport: TBitBtn;
    BFilter: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridSMSTerkirim: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BDeleteClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridSMSTerkirimPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  function getIdModem(nama:string):string;
  end;

var
  FDataSMSTerkirim: TFDataSMSTerkirim;

const
  query  = 'SELECT t_outboxsms.id, t_outboxsms.tanggal, t_outboxsms.jam, t_modem.nama_modem, t_outboxsms.no_tujuan, t_outboxsms.isi_pesan, t_outboxsms.status FROM (t_outboxsms INNER JOIN t_modem ON t_modem.id=t_outboxsms.id_modem) order by t_outboxsms.id asc';


implementation

uses uutama;

{$R *.lfm}

{ TFDataSMSTerkirim }

procedure TFDataSMSTerkirim.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDataSMSTerkirim.BFilterClick(Sender: TObject);
begin
    with FFilter do
  begin
   Caption:='Filter Data SMS Terkirim';
   setup;
   LData.Caption:='SMSTerkirim';
   ShowModal;
  end;
end;

procedure TFDataSMSTerkirim.BKosongkanClick(Sender: TObject);
begin
 // if GridSMSTerkirim.DataSource.DataSet.RecordCount>0 then
 // begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data SMS Terkirm?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQSMSTerkirim do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_outboxsms';
      ExecSQL;
      SQL.Clear;
      SQL.Text:='update t_modem set outboxcount="0"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFDataSMSTerkirim.BRefreshClick(Sender: TObject);
begin
       with DM.ZQSMSTerkirim do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFDataSMSTerkirim.BEksportClick(Sender: TObject);
begin
    if GridSMSTerkirim.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQSMSTerkirim,FUtama.SaveExcel.FileName);
     MessageDlg('Data SMS Terkirim Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFDataSMSTerkirim.BDeleteClick(Sender: TObject);
var
  id, status, modem  : string;
begin
  if GridSMSTerkirim.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data SMS Terkirim "'+GridSMSTerkirim.DataSource.DataSet.Fields[4].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridSMSTerkirim.DataSource.DataSet.Fields[0].Value;
  status := GridSMSTerkirim.DataSource.DataSet.Fields[6].Value;
  modem := GridSMSTerkirim.DataSource.DataSet.Fields[3].Value;
  // Hapus Database
  with DM.ZQSMSTerkirim do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_outboxsms where id="'+id+'"';
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

procedure TFDataSMSTerkirim.GridSMSTerkirimPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridSMSTerkirim) do
  begin
       if (GridSMSTerkirim.DataSource.DataSet.Fields[6].Value = 'Pending') then
          begin
            Canvas.Brush.Color:=clYellow;
            Canvas.Font.Color:=clBlack;
          end else
     if (GridSMSTerkirim.DataSource.DataSet.Fields[6].Value = 'Terkirim') then
          begin
            Canvas.Brush.Color:=clLime;
            Canvas.Font.Color:=clBlack;
          end;
      Options := Options + [goRowSelect];
  end;
end;

function TFDataSMSTerkirim.SaveAsExcelFile(AQuery: TZQuery; AFileName: string
  ): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_SMS_Terkirim');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, Copy(QuotedStr(AQuery.FieldByName('tanggal').AsString),0,(length(QuotedStr(AQuery.FieldByName('tanggal').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('jam').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('nama_modem').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, Copy(QuotedStr(AQuery.FieldByName('no_tujuan').AsString),0,(length(QuotedStr(AQuery.FieldByName('no_tujuan').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('isi_pesan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('status').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

function TFDataSMSTerkirim.getIdModem(nama: string): string;
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

