unit usaintelague;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, rxdbgrid, udatamodule, Grids, DBGrids;

type

  { TFSainteLague }

  TFSainteLague = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBDapil: TComboBox;
    EJmlKursi: TEdit;
    Label1: TLabel;
    LKabKotaProv: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    GridSainte: TRxDBGrid;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBDapilKeyPress(Sender: TObject; var Key: char);
    procedure EJmlKursiKeyPress(Sender: TObject; var Key: char);
    procedure GridSaintePrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private

  public

    procedure hapus;
    procedure setData;
    procedure Kalkulasi;
    function getIdDapil(nama:string):string;
    procedure isidata;

  end;

var
  FSainteLague: TFSainteLague;
  query,kat : string;

implementation

uses uutama;

{$R *.lfm}

{ TFSainteLague }

procedure TFSainteLague.CBDapilKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFSainteLague.EJmlKursiKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFSainteLague.GridSaintePrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
          with TStringGrid(GridSainte) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

procedure TFSainteLague.BBaruClick(Sender: TObject);
begin
  hapus;
  setData;
end;

procedure TFSainteLague.BSimpanClick(Sender: TObject);
begin
  if (CBDapil.Text='-Pilih-') or (EJmlKursi.Text='') then
  MessageDlg('Jangan Kosongkan Inputan!',mtWarning,[mbok],0) else
  begin
  Kalkulasi;
  isidata;
  end;
end;

procedure TFSainteLague.hapus;
var
  i : integer;
begin
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='truncate t_perolehankursi';
    ExecSQL;
    SQL.Clear;
    SQL.Text:='truncate t_totpartai';
    ExecSQL;
    SQL.Clear;
    SQL.Text:='truncate t_totcaleg';
    ExecSQL;
  end;
  CBDapil.Text:='-Pilih-';
  EJmlKursi.Text:='';
  CBDapil.Items.Clear;
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dapil where kategori="'+FUtama.LKategori.Caption+'" order by id_dapil asc';
  Open;
  First;
  end;
  for i := 1 to DM.ZQCari.RecordCount do begin
  CBDapil.Items.Add(DM.ZQCari.FieldByName('nama_dapil').AsString);
  DM.ZQCari.Next;
  end;
  isidata;
end;

procedure TFSainteLague.setData;
var
  i,j : integer;
  ket : string;
  total, total1, total2, total3, total4, tc : integer;
begin
 total :=0;
 total1:=0;
 total2:=0;
 total3:=0;
 total4:=0;
 // DPR RI
 if (FUtama.LKategori.Caption='DPR RI') then
 begin
 DM.ZQDPRRI.First;
 for i := 1 to DM.ZQDPRRI.RecordCount do
 begin
 with DM.ZQCari do
 begin
   Close;
   SQL.Clear;
   SQL.Text:='select sum(perolehan) as total from t_hitungdprri where id_caleg="'+DM.ZQDPRRI.FieldByName('id').AsString+'"';
   Open;
 end;
 tc := DM.ZQCari.FieldByName('total').AsInteger;
 with DM.ZQCari3 do
 begin
   Close;
   SQL.Clear;
   SQL.Text:='insert into t_totcaleg (id,id_caleg,perolehan,dapil) values ("'+IntToStr(i)+'","'+DM.ZQDPRRI.FieldByName('id').AsString+'","'+IntToStr(tc)+'","'+DM.ZQDPRRI.FieldByName('dapil').AsString+'")';
   ExecSQL;
 end;
 tc := 0;
 DM.ZQDPRRI.Next;
 end;
 end;
 // DPRD Prov
 if (FUtama.LKategori.Caption='DPRD Provinsi') then
 begin
 DM.ZQDPRDProv.First;
 for i := 1 to DM.ZQDPRDProv.RecordCount do
 begin
 with DM.ZQCari do
 begin
   Close;
   SQL.Clear;
   SQL.Text:='select sum(perolehan) as total from t_hitungdprdprov where id_caleg="'+DM.ZQDPRDProv.FieldByName('id').AsString+'"';
   Open;
 end;
 tc := DM.ZQCari.FieldByName('total').AsInteger;
 with DM.ZQCari3 do
 begin
   Close;
   SQL.Clear;
   SQL.Text:='insert into t_totcaleg (id,id_caleg,perolehan,dapil) values ("'+IntToStr(i)+'","'+DM.ZQDPRDProv.FieldByName('id').AsString+'","'+IntToStr(tc)+'","'+DM.ZQDPRDProv.FieldByName('dapil').AsString+'")';
   ExecSQL;
 end;
 tc := 0;
 DM.ZQDPRDProv.Next;
 end;
 end;
 // DPRD Kabupaten/Kota
 if (FUtama.LKategori.Caption='DPRD Kabupaten/Kota') then
 begin
 DM.ZQDPRDKab.First;
 for i := 1 to DM.ZQDPRDKab.RecordCount do
 begin
 with DM.ZQCari do
 begin
   Close;
   SQL.Clear;
   SQL.Text:='select sum(perolehan) as total from t_hitungdprdkab where id_caleg="'+DM.ZQDPRDKab.FieldByName('id').AsString+'"';
   Open;
 end;
 tc := DM.ZQCari.FieldByName('total').AsInteger;
 with DM.ZQCari3 do
 begin
   Close;
   SQL.Clear;
   SQL.Text:='insert into t_totcaleg (id,id_caleg,perolehan,dapil) values ("'+IntToStr(i)+'","'+DM.ZQDPRDKab.FieldByName('id').AsString+'","'+IntToStr(tc)+'","'+DM.ZQDPRDKab.FieldByName('dapil').AsString+'")';
   ExecSQL;
 end;
 tc := 0;
 DM.ZQDPRDKab.Next;
 end;
 end;
 // Partai
 DM.ZQPartai.First;
 for i := 1 to DM.ZQPartai.RecordCount do
 begin
  if (FUtama.LKategori.Caption='DPR RI') then begin ket :='suara_dprri'; end;
  if (FUtama.LKategori.Caption='DPRD Provinsi') then begin ket :='suara_dprdprov'; end;
  if (FUtama.LKategori.Caption='DPRD Kabupaten/Kota') then begin ket :='suara_dprdkab'; end;
  // Total Suara Partai
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select sum('+ket+') as total from t_hitungpartai where no_urut="'+DM.ZQPartai.FieldByName('no_urut').AsString+'"';
    Open;
  end;
  total1 := DM.ZQCari.FieldByName('total').AsInteger;

  // Total Suara Caleg Dari Masing-Masing Partai DPR RI
  if (FUtama.LKategori.Caption='DPR RI') then
  begin
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select id from t_calegdprri where partai="'+DM.ZQPartai.FieldByName('no_urut').AsString+'"';
    Open;
  end;
  DM.ZQCari.First;
  for j := 1 to DM.ZQCari.RecordCount do
  begin
  with DM.ZQCari2 do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select sum(perolehan) as total from t_hitungdprri where id_caleg="'+DM.ZQCari.FieldByName('id').AsString+'"';
    Open;
  end;
  total2 := total2 + DM.ZQCari2.FieldByName('total').AsInteger;
  DM.ZQCari.Next;
  end;
  total := total1 + total2 ;
  end;
  // Total Suara Caleg Dari Masing-Masing Partai DPR Provinsi
  if (FUtama.LKategori.Caption='DPRD Provinsi') then
  begin
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select id from t_calegdprdprov where partai="'+DM.ZQPartai.FieldByName('no_urut').AsString+'"';
    Open;
  end;
  DM.ZQCari.First;
  for j := 1 to DM.ZQCari.RecordCount do
  begin
  with DM.ZQCari2 do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select sum(perolehan) as total from t_hitungdprdprov where id_caleg="'+DM.ZQCari.FieldByName('id').AsString+'"';
    Open;
  end;
  total3 := total3 + DM.ZQCari2.FieldByName('total').AsInteger;
  DM.ZQCari.Next;
  end;
  total := total1 + total3 ;
  end;
  // Total Suara Caleg Dari Masing-Masing Partai DPR Kabupaten/Kota
  if (FUtama.LKategori.Caption='DPRD Kabupaten/Kota') then
  begin
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select id from t_calegdprdkabkota where partai="'+DM.ZQPartai.FieldByName('no_urut').AsString+'"';
    Open;
  end;
  DM.ZQCari.First;
  for j := 1 to DM.ZQCari.RecordCount do
  begin
  with DM.ZQCari2 do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select sum(perolehan) as total from t_hitungdprdkab where id_caleg="'+DM.ZQCari.FieldByName('id').AsString+'"';
    Open;
  end;
  total4 := total4 + DM.ZQCari2.FieldByName('total').AsInteger;
  DM.ZQCari.Next;
  end;
  total := total1 + total4;
  end;
 //total := total1;
 // Simpan Ke Tabel Total Partai
 with DM.ZQCari3 do
 begin
   Close;
   SQL.Clear;
   SQL.Text:='insert into t_totpartai (id,idpartai,totalsuara,pembagi) values ("'+IntToStr(i)+'","'+DM.ZQPartai.FieldByName('no_urut').AsString+'","'+IntToStr(total)+'","1")';
   ExecSQL;
 end;
 total :=0;
 total1:=0;
 total2:=0;
 total3:=0;
 total4:=0;
 DM.ZQPartai.Next;
 end;
 end;

procedure TFSainteLague.Kalkulasi;
var
  i,pembagi,j : integer;
  bagi : real;
  kat,ket : string;
begin
 pembagi := 1;
 bagi    := 0;

 for j := 1 to StrToInt(EJmlKursi.Text) do begin
 with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT id,idpartai,pembagi FROM t_totpartai WHERE totalsuara=(SELECT MAX(totalsuara) FROM t_totpartai)';
    Open;
    First;
  end;

 //for i := 1 to DM.ZQCari.RecordCount do
 // begin

  with DM.ZQCari2 do
   begin
     Close;
     SQL.Clear;
     SQL.Text:='SELECT MAX(totalsuara) AS tot FROM t_totpartai where id="'+DM.ZQCari.FieldByName('id').AsString+'"';
     Open;
     First;
   end;

   if (FUtama.LKategori.Caption='DPR RI') then begin ket :='t_calegdprri'; kat :='t_totcaleg'; end;
   if (FUtama.LKategori.Caption='DPRD Provinsi') then begin ket :='t_calegdprdprov'; kat :='t_totcaleg'; end;
   if (FUtama.LKategori.Caption='DPRD Kabupaten/Kota') then begin ket :='t_calegdprdkabkota'; kat :='t_totcaleg'; end;

    with DM.ZQHasil do begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT id_caleg,perolehan FROM '+
              '('+kat+' INNER JOIN '+ket+' ON '+ket+'.id='+kat+'.id_caleg) '+
              'WHERE '+
              'id_caleg NOT IN (SELECT idcaleg FROM t_perolehankursi) '+
              'AND '+ket+'.partai="'+DM.ZQCari.FieldByName('idpartai').AsString+'"'+
              'AND '+kat+'.dapil="'+getIdDapil(CBDapil.Text)+'" '+
              'ORDER BY perolehan DESC LIMIT 1';
    Open;
    First;
    end;

   with DM.ZQCari3 do
    begin
      try
      Close;
      // Simpan Ke Tabel t_perolehankursi
      bagi    := DM.ZQCari2.FieldByName('tot').AsInteger;
      SQL.Clear;
      SQL.Text:='insert into t_perolehankursi (id,dapil,kursike,idpartai,idcaleg,suaracaleg,hasilbagi) values ("'+IntToStr(j)+'","'+getIdDapil(CBDapil.Text)+'","'+IntToStr(j)+'","'+DM.ZQCari.FieldByName('idpartai').AsString+'","'+DM.ZQHasil.FieldByName('id_caleg').AsString+'","'+DM.ZQHasil.FieldByName('perolehan').AsString+'","'+FloatToStr(bagi)+'")';
      ExecSQL;
      // Update Tabel t_totpartai
      pembagi := DM.ZQCari.FieldByName('pembagi').AsInteger+2;
      bagi    := DM.ZQCari2.FieldByName('tot').AsInteger/pembagi;
      SQL.Clear;
      SQL.Text:='UPDATE t_totpartai set totalsuara="'+FloatToStr(bagi)+'",pembagi="'+FloatToStr(pembagi)+'" where id="'+DM.ZQCari.FieldByName('id').AsString+'"';
      ExecSQL;
      except
      end;
    end;

 // DM.ZQCari.Next;

 // end;
  end;
end;

function TFSainteLague.getIdDapil(nama: string): string;
begin
 Result:='';
 with DM.ZQCari4 do begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_dapil as id from t_dapil where nama_dapil="'+nama+'"';
 Open;
 First;
 end;
 Result := DM.ZQCari4.FieldByName('id').AsString;
end;

procedure TFSainteLague.isidata;
var
  kat:string;
begin
  if (FUtama.LKategori.Caption='DPR RI') then kat :='t_calegdprri';
  if (FUtama.LKategori.Caption='DPRD Provinsi') then kat :='t_calegdprdprov';
  if (FUtama.LKategori.Caption='DPRD Kabupaten/Kota') then kat :='t_calegdprdkabkota';

   query  := 'SELECT t_perolehankursi.id, t_dapil.nama_dapil, t_perolehankursi.kursike, '+
             't_partai.nama_partai, '+kat+'.nama_caleg, t_perolehankursi.suaracaleg, t_perolehankursi.hasilbagi '+
             'FROM '+
             '(((t_perolehankursi INNER JOIN t_dapil ON t_dapil.id_dapil=t_perolehankursi.dapil) '+
             'INNER JOIN '+kat+' ON '+kat+'.id=t_perolehankursi.idcaleg) '+
             'INNER JOIN t_partai ON t_partai.no_urut=t_perolehankursi.idpartai) '+
             'order by t_perolehankursi.id asc';

    with DM.ZQKursi do
    begin
    Close;
    SQL.Clear;
    SQL.Text:=query;
    Open;
    end;

    GridSainte.Columns[0].Width:=50;
    GridSainte.Columns[1].Width:=(FSainteLague.Width-70) div 6;
    GridSainte.Columns[2].Width:=(FSainteLague.Width-70) div 6;
    GridSainte.Columns[3].Width:=(FSainteLague.Width-70) div 6;
    GridSainte.Columns[4].Width:=(FSainteLague.Width-70) div 6;
    GridSainte.Columns[5].Width:=(FSainteLague.Width-70) div 6;
    GridSainte.Columns[6].Width:=(FSainteLague.Width-70) div 6;
end;


end.

