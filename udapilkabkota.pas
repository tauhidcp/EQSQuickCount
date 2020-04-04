unit udapilkabkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, Grids, rxdbgrid, VirtualTrees, comObj, Variants,
  fpspreadsheet, fpstypes, xlsxooxml, ZDataset, udatamodule,
  utambahdapilkabkota, db, ucekserial;

type

  { TFDapilKabKota }

  TFDapilKabKota = class(TForm)
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
  FDapilKabKota: TFDapilKabKota;
  NodeA, NodeB: PVirtualNode;
  i,j : integer;

const
 query = 'SELECT t_dapilkabkota.id, t_dapil.nama_dapil, t_kecamatan.nama_kecamatan FROM ((t_dapilkabkota INNER JOIN t_dapil ON t_dapil.id_dapil=t_dapilkabkota.id_dapil) INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_dapilkabkota.kecamatan) order by t_dapilkabkota.id asc';
 queryc = 'SELECT t_dapilkabkota.id, t_dapil.nama_dapil, t_kecamatan.nama_kecamatan FROM ((t_dapilkabkota INNER JOIN t_dapil ON t_dapil.id_dapil=t_dapilkabkota.id_dapil) INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_dapilkabkota.kecamatan)';

implementation

uses uutama;

type
  PTreeData = ^TTreeData;
  TTreeData = record
    Column0: String;
    Column1: String;
   // Column2: String;
end;

{$R *.lfm}

{ TFDapilKabKota }

// Write Excel File
function TFDapilKabKota.SaveAsExcelFile(isix: string; AFileName: string): Boolean;
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i,j : integer;
  jmlx,isi : TStringList;
begin

try
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Data_Dapil_KabKota');
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

function TFDapilKabKota.getIdX(nama: string): string;
begin
 Result:='';
with DM.ZQCari do
begin
Close;
SQL.Clear;
SQL.Text:='select id_kecamatan as id from t_kecamatan where nama_kecamatan="'+nama+'"';
Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFDapilKabKota.SearchText(nama: string);
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
          AQuery.SQL.Text:='insert into t_dapilkabkota (id,kecamatan,id_dapil) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahDapilKabKota.getIDKec(XLApp.Cells[y,3].Value)+'","'+FTambahDapilKabKota.getIDDapil(XLApp.Cells[y,2].Value)+'")';
          AQuery.ExecSQL;
          end else
          begin
          if (cekData('t_dapilkabkota',5)=True) then exit else
             begin
             AQuery.SQL.Clear;
             AQuery.SQL.Text:='insert into t_dapilkabkota (id,kecamatan,id_dapil) values ("'+IntToStr(XLApp.Cells[y,1].Value)+'","'+FTambahDapilKabKota.getIDKec(XLApp.Cells[y,3].Value)+'","'+FTambahDapilKabKota.getIDDapil(XLApp.Cells[y,2].Value)+'")';
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

procedure TFDapilKabKota.TreeDapilChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  TreeDapil.Refresh;
end;

procedure TFDapilKabKota.TreeDapilFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  TreeDapil.Refresh;
end;

procedure TFDapilKabKota.TreeDapilFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Data: PTreeData;
begin
 Data:=TreeDapil.GetNodeData(Node);
 if Assigned(Data) then begin
   Data^.Column0 := '';
   Data^.Column1 := '';
 //  Data^.Column2 := '';
 end;
end;

procedure TFDapilKabKota.TreeDapilGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeData);
end;

procedure TFDapilKabKota.TreeDapilGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var
  Data: PTreeData;
begin
  Data := TreeDapil.GetNodeData(Node);
  case Column of
    0: CellText := Data^.Column0;
    1: CellText := Data^.Column1;
   // 2: CellText := Data^.Column2;
  end;
end;

procedure TFDapilKabKota.TreeDapilNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const NewText: String);
var
  Data: PTreeData;
begin
  Data := TreeDapil.GetNodeData(Node);
  case Column of
    0: Data^.Column0 := NewText;
    1: Data^.Column1 := NewText;
 //   2: Data^.Column2 := NewText;
  end;
end;

procedure TFDapilKabKota.BuatNode;
var
  Data : PTreeData;
  Kategori : String;
Begin
  FUtama.PBLoading.Visible:=True;
  // Dapil
  Kategori:='DPRD Kabupaten/Kota';
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
  SQL.Text:='select * from t_dapilkabkota where id_dapil="'+DM.ZQTreeDapil.FieldByName('id_dapil').AsString+'"';
  Open;
  end;
  for j := 1 to DM.ZQKabCari.RecordCount do begin
  with DM.ZQCari3 do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_kecamatan where id_kecamatan="'+DM.ZQKabCari.FieldByName('kecamatan').AsString+'"';
  Open;
  end;
  NodeB := TreeDapil.AddChild(NodeA);
  Data := TreeDapil.GetNodeData(NodeB);
  Data^.Column0:='';
  Data^.Column1:= DM.ZQCari3.FieldByName('nama_kecamatan').AsString;
//  Data^.Column2:=' Kecamatan '

  DM.ZQKabCari.Next;
  end; // Daerah

  DM.ZQTreeDapil.Next;
  end; // provinsi

 FUtama.PBLoading.Visible:=False;

end;

procedure TFDapilKabKota.HapusNode;
begin
 TreeDapil.Clear;
 FUtama.PBLoading.Visible:=False;
end;

procedure TFDapilKabKota.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDapilKabKota.BEksportClick(Sender: TObject);
var
  exportText : string;
begin
 exportText := TreeDapil.ContentToText(tstVisible, ';');
  if FUtama.SaveExcel.Execute then
     begin
     SaveAsExcelFile(exportText,FUtama.SaveExcel.FileName);
     MessageDlg('Data DAPIL Kabupaten/Kota Berhasil Dieksport Ke '+FUtama.SaveExcel.FileName,mtInformation,[mbok],0);
     end;
  end;

procedure TFDapilKabKota.BCariClick(Sender: TObject);
var
  cari : string;
begin
    InputQuery('Cari DAPIL Kabupaten/Kota', 'Nama DAPIL', cari);
    if not (cari='') then
    begin
    SearchText(cari);
    {with DM.ZQDAPILKabKota do
        begin
          Close;
          SQL.Clear;
          SQL.Text:=queryc+' where t_dapil.nama_dapil like "%'+cari+'%" order by t_dapilkabkota.id asc';
          Open;
        end;
    end; }
end;

end;

procedure TFDapilKabKota.BEditClick(Sender: TObject);
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
      with FTambahDapilKabKota do
      begin
      SetCB;
      Caption:='Ubah DAPIL Kabupaten/Kota';
      PAtas.Caption:='Form Ubah DAPIL Kabupaten/Kota';
      BSimpan.Caption:='Perbarui';
      EIDDapil.Enabled:=False;
      with DM.ZQCari2 do begin
      Close;
      SQL.Clear;
      SQL.Text:='select * from t_dapilkabkota where kecamatan="'+getIDKec(Trim(d))+'"';
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
      CBKec.Text:=Trim(d);
      setCBSesuai(CBDapil.Text);
      BBaru.Enabled:=False;
      BSimpan.Enabled:=True;
      ShowModal;
      end;
    end;
  end;
end;

procedure TFDapilKabKota.BHapusClick(Sender: TObject);
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
            SQL.Text:='delete from t_dapilkabkota where kecamatan="'+getIdX(d)+'"';
            ExecSQL;
          end;
         BRefresh.Click;
        end;
      end;
  end;
end;

procedure TFDapilKabKota.BImportClick(Sender: TObject);
begin
   if FUtama.ExcelDialog.Execute then
     begin
     DM.ZQDAPILKabKota.Close;
     ReadXLSFile(DM.ZQDAPILKabKota,FUtama.ExcelDialog.FileName,FUtama);
     DM.ZQDAPILKabKota.SQL.Clear;
     DM.ZQDAPILKabKota.SQL.Text:=query;
     DM.ZQDAPILKabKota.Open;
     MessageDlg('Data DAPIL Kabupaten/Kota Berhasil Diimport!',mtInformation,[mbok],0);
     end;
end;

procedure TFDapilKabKota.BKosongkanClick(Sender: TObject);
begin
  //if GridDAPILKabKota.DataSource.DataSet.RecordCount>0 then
  //begin
  if MessageDlg('Anda Akan Menghapus SEMUA Data DAPIL Kabupaten/Kota?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
  // Hapus Database
  with DM.ZQDAPILKabKota do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='truncate table t_dapilkabkota';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  BRefresh.Click;
  end;
 // end;
end;

procedure TFDapilKabKota.BRefreshClick(Sender: TObject);
begin
 HapusNode;
 BuatNode;
end;

procedure TFDapilKabKota.BTambahClick(Sender: TObject);
begin
    with FTambahDapilKabKota do
    begin
    Hapus;
    setCB;
    Caption:='Tambah DAPIL Kabupaten/Kota';
    PAtas.Caption:='Form Tambah DAPIL Kabupaten/Kota';
    EIDDapil.Enabled:=True;
    BSimpan.Caption:='Simpan';
    BBaru.Enabled:=True;
    ShowModal;
    end;
end;

end.

