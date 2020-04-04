unit udataformatsmschat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, rxdbgrid, udatamodule, Grids, DBGrids, fpspreadsheet, fpstypes,
  xlsxooxml, ZDataset;

type

  { TFDataFormatSMSChat }

  TFDataFormatSMSChat = class(TForm)
    BEksport: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridFormat: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BEksportClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridFormatPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FDataFormatSMSChat: TFDataFormatSMSChat;

  const
    query = 'select * from t_format order by id asc';

implementation

uses uutama;

{$R *.lfm}

{ TFDataFormatSMSChat }

procedure TFDataFormatSMSChat.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDataFormatSMSChat.BEksportClick(Sender: TObject);
begin
  if GridFormat.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQFormat,FUtama.SaveExcel.FileName);
     MessageDlg('Data Format SMS dan Chat Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFDataFormatSMSChat.BRefreshClick(Sender: TObject);
begin
       with DM.ZQFormat do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFDataFormatSMSChat.GridFormatPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridFormat) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

function TFDataFormatSMSChat.SaveAsExcelFile(AQuery: TZQuery; AFileName: string
  ): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Format_SMS_Chat');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, AQuery.FieldByName('format').AsString);
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('keterangan').AsString);
  AQuery.Next;
  end;
  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  FUtama.PBLoading.Visible:=False;
  end;
end;

end.

