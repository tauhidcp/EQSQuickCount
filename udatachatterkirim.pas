unit udatachatterkirim;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, rxdbgrid, udatamodule, Grids, DBGrids, ufilter, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset;

type

  { TFDataChatTerkirim }

  TFDataChatTerkirim = class(TForm)
    BDelete: TBitBtn;
    BEksport: TBitBtn;
    BFilter: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridChatTerkirim: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BDeleteClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridChatTerkirimPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FDataChatTerkirim: TFDataChatTerkirim;

const
  query = 'select * from t_outboxchat order by id asc';

implementation

uses uutama;

{$R *.lfm}

{ TFDataChatTerkirim }

procedure TFDataChatTerkirim.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDataChatTerkirim.BFilterClick(Sender: TObject);
begin
    with FFilter do
  begin
   Caption:='Filter Data Chat Terkirim';
   setup;
   LData.Caption:='ChatTerkirim';
   ShowModal;
  end;
end;

procedure TFDataChatTerkirim.BKosongkanClick(Sender: TObject);
begin
  //if GridChatTerkirim.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Chat Terkirim?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQChatTerkirim do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_outboxchat';
      ExecSQL;
      SQL.Clear;
      SQL.Text:='update t_telegrambot set outboxcount="0" where id="1"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFDataChatTerkirim.BRefreshClick(Sender: TObject);
begin
       with DM.ZQChatTerkirim do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFDataChatTerkirim.BEksportClick(Sender: TObject);
begin
    if GridChatTerkirim.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQChatTerkirim,FUtama.SaveExcel.FileName);
     MessageDlg('Data Chat Terkirim Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFDataChatTerkirim.BDeleteClick(Sender: TObject);
var
  id, status : string;
begin
  if GridChatTerkirim.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Chat Terkirim "'+GridChatTerkirim.DataSource.DataSet.Fields[5].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridChatTerkirim.DataSource.DataSet.Fields[0].Value;
  status := GridChatTerkirim.DataSource.DataSet.Fields[6].Value;
  // Hapus Database
  with DM.ZQChatTerkirim do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_outboxchat where id="'+id+'"';
      ExecSQL;
      if (status='Terkirim') then
      begin
      SQL.Clear;
      SQL.Text:='update t_telegrambot set outboxcount=outboxcount-1 where id="1"';
      ExecSQL;
      end;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFDataChatTerkirim.GridChatTerkirimPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridChatTerkirim) do
  begin
     if (GridChatTerkirim.DataSource.DataSet.Fields[6].Value = 'Pending') then
          begin
            Canvas.Brush.Color:=clYellow;
            Canvas.Font.Color:=clBlack;
          end else
     if (GridChatTerkirim.DataSource.DataSet.Fields[6].Value = 'Terkirim') then
          begin
            Canvas.Brush.Color:=clLime;
            Canvas.Font.Color:=clBlack;
          end;
      Options := Options + [goRowSelect];
  end;
end;

function TFDataChatTerkirim.SaveAsExcelFile(AQuery: TZQuery; AFileName: string
  ): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Chat_Terkirim');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, Copy(QuotedStr(AQuery.FieldByName('tanggal').AsString),0,(length(QuotedStr(AQuery.FieldByName('tanggal').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('jam').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('id_tujuan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('id_chat').AsString);
  MyWorksheet.WriteCellValueAsString(i, 5, AQuery.FieldByName('isipesan').AsString);
  MyWorksheet.WriteCellValueAsString(i, 6, AQuery.FieldByName('status').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

end.

