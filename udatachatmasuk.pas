unit udatachatmasuk;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, rxdbgrid, udatamodule, Grids, DBGrids, Menus, ufilter, fpspreadsheet,
  fpstypes, xlsxooxml, ZDataset, uchat;

type

  { TFDataChatMasuk }

  TFDataChatMasuk = class(TForm)
    BDelete: TBitBtn;
    BEksport: TBitBtn;
    BFilter: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GridChatMasuk: TRxDBGrid;
    MenuBalas: TMenuItem;
    MenuDetailPesan: TMenuItem;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PopBalas: TPopupMenu;
    procedure BDeleteClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure GridChatMasukPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure MenuBalasClick(Sender: TObject);
    procedure MenuDetailPesanClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  function SaveAsExcelFile(AQuery: TZQuery; AFileName: string): Boolean;
  end;

var
  FDataChatMasuk: TFDataChatMasuk;

const
  query = 'select * from t_inboxchat order by id asc';

implementation

uses uutama;

{$R *.lfm}

{ TFDataChatMasuk }

procedure TFDataChatMasuk.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDataChatMasuk.BFilterClick(Sender: TObject);
begin
    with FFilter do
  begin
   Caption:='Filter Data Chat Masuk';
   setup;
   LData.Caption:='ChatMasuk';
   ShowModal;
  end;
end;

procedure TFDataChatMasuk.BKosongkanClick(Sender: TObject);
begin
  //if GridChatMasuk.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data Chat Masuk?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQChatMasuk do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_inboxchat';
      ExecSQL;
      SQL.Clear;
      SQL.Text:='update t_telegrambot set inboxcount="0" where id="1"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
 // end;
end;

procedure TFDataChatMasuk.BRefreshClick(Sender: TObject);
begin
       with DM.ZQChatMasuk do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
end;

procedure TFDataChatMasuk.BEksportClick(Sender: TObject);
begin
    if GridChatMasuk.DataSource.DataSet.RecordCount>0 then
  begin
    if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(DM.ZQChatMasuk,FUtama.SaveExcel.FileName);
     MessageDlg('Data Chat Masuk Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;
end;

procedure TFDataChatMasuk.BDeleteClick(Sender: TObject);
var
  id : string;
begin
  if GridChatMasuk.DataSource.DataSet.RecordCount>0 then
  begin
  if MessageDlg('Anda Akan Menghapus Data Chat Masuk "'+GridChatMasuk.DataSource.DataSet.Fields[4].Value+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  id := GridChatMasuk.DataSource.DataSet.Fields[0].Value;
  // Hapus Database
  with DM.ZQChatMasuk do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='delete from t_inboxchat where id="'+id+'"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:='update t_telegrambot set inboxcount=inboxcount-1 where id="1"';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  end;
  end;
end;

procedure TFDataChatMasuk.GridChatMasukPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
      with TStringGrid(GridChatMasuk) do
  begin
  if (GridChatMasuk.DataSource.DataSet.Fields[6].Value = 'False') then
     begin
       Canvas.Brush.Color:=clYellow;
       Canvas.Font.Color:=clBlack;
     end else
if (GridChatMasuk.DataSource.DataSet.Fields[6].Value = 'True') then
     begin
       Canvas.Brush.Color:=clLime;
       Canvas.Font.Color:=clBlack;
     end;
      Options := Options + [goRowSelect];
  end;
end;

procedure TFDataChatMasuk.MenuBalasClick(Sender: TObject);
begin
    if GridChatMasuk.DataSource.DataSet.RecordCount>0 then
  begin
 with FChat do
 begin
 hapus;
 EIDChat.Text:=GridChatMasuk.DataSource.DataSet.Fields[4].Value;
 LNama.Caption:='';
 LAlamat.Caption:='';
 LTPS.Caption:='';
 LStatus.Caption:='Balas';
 ShowModal;
 end;
  end;
end;

procedure TFDataChatMasuk.MenuDetailPesanClick(Sender: TObject);
begin
  if GridChatMasuk.DataSource.DataSet.RecordCount>0 then
  begin
  ShowMessage('> ID Pengirim : '+GridChatMasuk.DataSource.DataSet.Fields[4].AsString+sLineBreak+
              '> Isi Pesan   : '+sLineBreak+GridChatMasuk.DataSource.DataSet.Fields[5].AsString);
  end;
end;

function TFDataChatMasuk.SaveAsExcelFile(AQuery: TZQuery; AFileName: string
  ): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i : integer;
begin
try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Chat_Masuk');
  AQuery.First;
  FUtama.PBLoading.Max:=AQuery.RecordCount-1;
  FUtama.PBLoading.Visible:=True;
  for i := 0 to AQuery.RecordCount-1 do begin
  FUtama.PBLoading.Position:=i;
  MyWorksheet.WriteCellValueAsString(i, 0, AQuery.FieldByName('id').AsString);
  MyWorksheet.WriteCellValueAsString(i, 1, Copy(QuotedStr(AQuery.FieldByName('tanggal').AsString),0,(length(QuotedStr(AQuery.FieldByName('tanggal').AsString))-1)));
  MyWorksheet.WriteCellValueAsString(i, 2, AQuery.FieldByName('jam').AsString);
  MyWorksheet.WriteCellValueAsString(i, 3, AQuery.FieldByName('id_pengirim').AsString);
  MyWorksheet.WriteCellValueAsString(i, 4, AQuery.FieldByName('id_chat').AsString);
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

end.

