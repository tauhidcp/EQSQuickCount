unit udapilprovinsi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, Grids, rxdbgrid, VirtualTrees, comObj, Variants,
  fpspreadsheet, fpstypes, xlsxooxml, ZDataset, udatamodule,
  utambahdapilprovinsi, ucekserial;

type

  { TFDapilProvinsi }

  TFDapilProvinsi = class(TForm)
    BCari: TBitBtn;
    BEdit: TBitBtn;
    BEksport: TBitBtn;
    BHapus: TBitBtn;
    BImport: TBitBtn;
    BKosongkan: TBitBtn;
    BRefresh: TBitBtn;
    BTambah: TBitBtn;
    BTutup: TBitBtn;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    TreeDapil: TVirtualStringTree;
    procedure BCariClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BKosongkanClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure TreeDapilChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeDapilFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure TreeDapilFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeDapilGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure TreeDapilGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure TreeDapilNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; const NewText: String);
  private
    { private declarations }
  public
    { public declarations }
  procedure BuatNode;
  procedure HapusNode;
  function SaveAsExcelFile(isix: string; AFileName: string): Boolean;
  function getIdX(nama:string):string;
  procedure SearchText(nama:string);
  end;

var
  FDapilProvinsi: TFDapilProvinsi;
  NodeA, NodeB: PVirtualNode;
  i,j : integer;

const
  query = 'SELECT t_dapilprovinsi.id, t_dapil.nama_dapil, t_kabkota.nama_kota FROM ((t_dapilprovinsi INNER JOIN t_dapil ON t_dapil.id_dapil=t_dapilprovinsi.id_dapil) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_dapilprovinsi.kabkota) order by t_dapilprovinsi.id asc';
  queryc = 'SELECT t_dapilprovinsi.id, t_dapil.nama_dapil, t_kabkota.nama_kota FROM ((t_dapilprovinsi INNER JOIN t_dapil ON t_dapil.id_dapil=t_dapilprovinsi.id_dapil) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_dapilprovinsi.kabkota)';

implementation

uses uutama;

type
  PTreeData = ^TTreeData;
  TTreeData = record
    Column0: String;
    Column1: String;
end;

{$R *.lfm}

{ TFDapilProvinsi }

// Write Excel File
function TFDapilProvinsi.SaveAsExcelFile(isix: string; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i,j : integer;
  jmlx,isi : TStringList;
begin

try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Dapil_Provinsi');
  jmlx := TStringList.Create;
  isi  := TStringList.Create;
  FUtama.Split(#13, isix, jmlx);

  FUtama.PBLoading.Max:=jmlx.Count-1;
  FUtama.PBLoading.Visible:=True;

  for i := 0 to (jmlx.Count-1) do begin
  FUtama.PBLoading.Position:=i;
  FUtama.Split(';', jmlx[i], isi);
    for j := 0 to (isi.Count-1) do begin
      MyWorksheet.WriteCellValueAsString(i, j, Trim(''''+isi[j]));
    end;
  end;

  MyWorkbook.WriteToFile(AFileName, sfOOXML, True);
  finally
  MyWorkbook.Free;
  jmlx.Free;
  isi.Free;
  FUtama.PBLoading.Visible:=False;
  end;
  end;

function TFDapilProvinsi.getIdX(nama: string): string;
begin
 Result:='';
with DM.ZQCari do
begin
Close;
SQL.Clear;
SQL.Text:='select id_kota as id from t_kabkota where nama_kota="'+nama+'"';
Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFDapilProvinsi.SearchText(nama: string);
var
  XNode: PVirtualNode;
  Data: PTreeData;
begin
  if TreeDapil.GetFirst = nil then Exit;
  XNode := nil;
  repeat
    if XNode = nil then
      XNode := TreeDapil.GetFirst
    else
    XNode := TreeDapil.GetNext(XNode);
    Data := TreeDapil.GetNodeData(XNode);
    if Data^.Column1 = nama then
    begin
      TreeDapil.ClearSelection;
      TreeDapil.FocusedNode := XNode;
      TreeDapil.Selected[XNode] := True;
      TreeDapil.Expanded[XNode] := True;
      TreeDapil.Refresh;
      TreeDapil.SetFocus;
      break;
    end;
  until XNode = TreeDapil.GetLast();
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
         if (Trim(XLApp.Cells[y,1].Value)<>'') and (Trim(XLApp.Cells[y,2].Value)<>'') and (Trim(XLApp.Cells[y,3].Value)<>'') then begin
         if (cekSerial()=True) then
          begin
          AQuery.SQL.Clear;
          AQuery.SQL.Text:='insert into t_dapilprovinsi (id,kabkota,id_dapil) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahDapilProvinsi.getIDKab(XLApp.Cells[y,3].Value)+'","'+FTambahDapilProvinsi.getIDDapil(XLApp.Cells[y,2].Value)+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_dapilprovinsi',5)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_dapilprovinsi (id,kabkota,id_dapil) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahDapilProvinsi.getIDKab(XLApp.Cells[y,3].Value)+'","'+FTambahDapilProvinsi.getIDDapil(XLApp.Cells[y,2].Value)+'")';
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


procedure TFDapilProvinsi.TreeDapilChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  TreeDapil.Refresh;
end;

procedure TFDapilProvinsi.TreeDapilFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  TreeDapil.Refresh;
end;

procedure TFDapilProvinsi.TreeDapilFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Data: PTreeData;
begin
 Data:=TreeDapil.GetNodeData(Node);
 if Assigned(Data) then begin
   Data^.Column0 := '';
   Data^.Column1 := '';
 end;
end;

procedure TFDapilProvinsi.TreeDapilGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeData);
end;

procedure TFDapilProvinsi.TreeDapilGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var
  Data: PTreeData;
begin
  Data := TreeDapil.GetNodeData(Node);
  case Column of
    0: CellText := Data^.Column0;
    1: CellText := Data^.Column1;
  end;
end;

procedure TFDapilProvinsi.TreeDapilNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const NewText: String);
var
  Data: PTreeData;
begin
  Data := TreeDapil.GetNodeData(Node);
  case Column of
    0: Data^.Column0 := NewText;
    1: Data^.Column1 := NewText;
  end;
end;

procedure TFDapilProvinsi.BuatNode;
var
  Data : PTreeData;
  Kategori : String;
Begin
  FUtama.PBLoading.Visible:=True;
  // Dapil
  Kategori:='DPRD Provinsi';
  with DM.ZQTreeDapil do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapil where kategori="'+Kategori+'"';
  Open;
  end;
  FUtama.PBLoading.Max:=DM.ZQTreeDapil.RecordCount;

  DM.ZQTreeDapil.First;
  for i := 1 to DM.ZQTreeDapil.RecordCount do begin
  FUtama.PBLoading.Position:=i;

  NodeA:= TreeDapil.AddChild(nil);
  Data := TreeDapil.GetNodeData(NodeA);
  Data^.Column0:= IntToStr(i);
  Data^.Column1:= 'DAPIL '+DM.ZQTreeDapil.FieldByName('nama_dapil').AsString;
//  Data^.Column2:= '';

  // Daerah Cari
  with DM.ZQKabCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapilprovinsi where id_dapil="'+DM.ZQTreeDapil.FieldByName('id_dapil').AsString+'"';
  Open;
  end;
  for j := 1 to DM.ZQKabCari.RecordCount do begin
  with DM.ZQCari3 do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_kabkota where id_kota="'+DM.ZQKabCari.FieldByName('kabkota').AsString+'"';
  Open;
  end;
  NodeB := TreeDapil.AddChild(NodeA);
  Data := TreeDapil.GetNodeData(NodeB);
  Data^.Column0:='';
  Data^.Column1:= DM.ZQCari3.FieldByName('nama_kota').AsString;
//  Data^.Column2:=' Kecamatan '

  DM.ZQKabCari.Next;
  end; // Daerah

  DM.ZQTreeDapil.Next;
  end; // provinsi

 FUtama.PBLoading.Visible:=False;

end;

procedure TFDapilProvinsi.HapusNode;
begin
 TreeDapil.Clear;
 FUtama.PBLoading.Visible:=False;
end;

procedure TFDapilProvinsi.BTutupClick(Sender: TObject);
begin
 FUtama.ImageBack.Visible:=True;
 Close;
end;

procedure TFDapilProvinsi.BEksportClick(Sender: TObject);
var
  exportText : string;
begin
 exportText := TreeDapil.ContentToText(tstVisible, ';');
  if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(exportText,FUtama.SaveExcel.FileName);
     MessageDlg('Data DAPIL Provinsi Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;

procedure TFDapilProvinsi.BCariClick(Sender: TObject);
var
  cari : string;
begin
    InputQuery('Cari DAPIL Provinsi', 'Nama DAPIL Provinsi', cari);
    if not (cari='') then
    begin
    SearchText(cari);
    {with DM.ZQDAPILProv do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_dapil.nama_dapil like "%'+cari+'%" order by t_dapilprovinsi.id asc';
          Open;
        end;}
    end;
end;

procedure TFDapilProvinsi.BEditClick(Sender: TObject);
var
  d, cek: string;
begin
  if not Assigned(TreeDapil.FocusedNode) then
    Exit
  else begin
  d := TreeDapil.Text[TreeDapil.FocusedNode,1];
  cek:=copy(d, 0, 5);
  if ((Trim(d)<>'') and not (Trim(cek)='DAPIL')) then
      begin
    with FTambahDapilProvinsi do
    begin
    SetCB;
    Caption:='Ubah DAPIL Provinsi';
    PAtas.Caption:='Form Ubah DAPIL Provinsi';
    BSimpan.Caption:='Perbarui';
    EIDDapil.Enabled:=False;
    with DM.ZQCari2 do begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_dapilprovinsi where kabkota="'+getIdX(Trim(d))+'"';
    Open;
    First;
    end;
    with DM.ZQCari3 do begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_dapil where id_dapil="'+DM.ZQCari2.FieldByName('id_dapil').AsString+'"';
    Open;
    First;
    end;
    EIDDapil.Text:=DM.ZQCari2.FieldByName('id').AsString;
    CBDapil.Text:=DM.ZQCari3.FieldByName('nama_dapil').AsString;
    CBKab.Text:=Trim(d);
    setCBSesuai(CBDapil.Text);
    BBaru.Enabled:=False;
    BSimpan.Enabled:=True;
    ShowModal;
    end;
    end;
  end;
end;

procedure TFDapilProvinsi.BHapusClick(Sender: TObject);
var
  d, cek: string;
begin
  if not Assigned(TreeDapil.FocusedNode) then
    Exit
  else begin
    d := TreeDapil.Text[TreeDapil.FocusedNode,1];
    cek:=copy(d, 0, 5);
    if ((Trim(d)<>'') and not (Trim(cek)='DAPIL')) then
      begin
        if MessageDlg('Anda Akan Menghapus Data DAPIL "'+d+'" Ini?',mtConfirmation,[mbyes,mbno],0)=mryes then
        begin
        // Hapus Database
        with DM.ZQCari do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='delete from t_dapilprovinsi where kabkota="'+getIdX(d)+'"';
            ExecSQL;
          end;
         BRefresh.Click;
        end;
      end;
  end;
end;

procedure TFDapilProvinsi.BImportClick(Sender: TObject);
begin
     if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQDAPILProv.Close;
     ReadXLSFile(DM.ZQDAPILProv,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQDAPILProv.SQL.Clear;
     DM.ZQDAPILProv.SQL.Text:=query;
     DM.ZQDAPILProv.Open;
     MessageDlg('Data DAPIL Provinsi Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFDapilProvinsi.BKosongkanClick(Sender: TObject);
begin
  //if GridDAPILProv.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data DAPIL Provinsi?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQDAPILProv do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_dapilprovinsi';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  BRefresh.Click;
  end;
 // end;
end;

procedure TFDapilProvinsi.BRefreshClick(Sender: TObject);
begin
 HapusNode;
 BuatNode;
end;

procedure TFDapilProvinsi.BTambahClick(Sender: TObject);
begin
    with FTambahDapilProvinsi do
    begin
    Hapus;
    setCB;
    Caption:='Tambah DAPIL Provinsi';
    PAtas.Caption:='Form Tambah DAPIL Provinsi';
    EIDDapil.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

end.

