unit ufilterpeta;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, udatamodule;

type

  { TFFilterPeta }

  TFFilterPeta = class(TForm)
    BFilter: TBitBtn;
    CBKelDesa: TComboBox;
    CBProv: TComboBox;
    CBKabKota: TComboBox;
    CBKec: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LStatus: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    PAtas: TPanel;
    PBawah: TPanel;
    procedure BFilterClick(Sender: TObject);
    procedure CBKabKotaChange(Sender: TObject);
    procedure CBKecChange(Sender: TObject);
    procedure CBKecKeyPress(Sender: TObject; var Key: char);
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure CBKelDesaKeyPress(Sender: TObject; var Key: char);
    procedure CBKoorKelChange(Sender: TObject);
    procedure CBKoorTPSChange(Sender: TObject);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure CBTPSChange(Sender: TObject);
    procedure CBTPSKeyPress(Sender: TObject; var Key: char);
    procedure CBKoorKelKeyPress(Sender: TObject; var Key: char);
    procedure CBKoorTPSKeyPress(Sender: TObject; var Key: char);
  private

  public

    procedure Hapus;
    procedure SetCB;
    function getIdKec(nama:string):string;
    function getIdProv(nama:string):string;
    function getIdKota(nama:string):string;
    function getIdKelurahan(nama:string):string;
    function getIdTPS(no:string;kel:string):string;

    procedure setCBKabSesuai(nama:string);
    procedure setCBKecSesuai(nama:string);
    procedure setCBKelSesuai(nama:string);
  end;

var
  FFilterPeta: TFFilterPeta;

const
 query = 'SELECT t_petasuara.id, t_petasuara.nama, t_petasuara.ktp, t_petasuara.alamat, t_petasuara.nohp, '+
          't_tps.no_tps as no_tps, t_kelurahan.nama_kelurahan, '+
          't_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM '+
          '(((((t_petasuara INNER JOIN t_tps ON t_tps.id_tps=t_petasuara.idtps)'+
          'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
          'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
          'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
          'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';

implementation

uses UUtama;

{$R *.lfm}

{ TFFilterPeta }

procedure TFFilterPeta.CBKecKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFFilterPeta.CBKabKotaChange(Sender: TObject);
begin
  setCBKecSesuai(CBKabKota.Text);
end;

procedure TFFilterPeta.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFFilterPeta.BFilterClick(Sender: TObject);
begin
  if (LStatus.Caption='Peta') then
  begin
  if (CBProv.Text='-Pilih-') or (CBKabKota.Text='-Pilih-') or (CBKec.Text='-Pilih-') or (CBKelDesa.Text='-Pilih-') then
    MessageDlg('Jangan Kosongkan Inputan!',mtWarning,[mbok],0) else
    begin
    with DM.ZQPetaSuara do
  begin
    Close;
    SQL.Clear;
    SQL.Text:=query+' where t_kelurahan.id_kelurahan="'+getIdKelurahan(CBKelDesa.Text)+'"';
    Open;
  end;
    end;
  end;
  if (LStatus.Caption='Grafik') then
  begin
  if (CBProv.Text='-Pilih-') or (CBKabKota.Text='-Pilih-') or (CBKec.Text='-Pilih-')
    then
    MessageDlg('Jangan Kosongkan Inputan!',mtWarning,[mbok],0) else
    begin
    with DM.ZQKelDesa do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT t_kelurahan.id_kelurahan, t_kelurahan.nama_kelurahan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM (((t_kelurahan INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) where t_kecamatan.id_kecamatan="'+getIdKec(CBKec.Text)+'"';
    Open;
    end;
  end;
  Close;
  end;

end;

procedure TFFilterPeta.CBKabKotaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;


procedure TFFilterPeta.CBKelDesaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFFilterPeta.CBKoorKelChange(Sender: TObject);
begin
end;

procedure TFFilterPeta.CBKoorTPSChange(Sender: TObject);
begin
end;

procedure TFFilterPeta.CBProvChange(Sender: TObject);
begin
  setCBKabSesuai(CBProv.Text);
end;

procedure TFFilterPeta.CBProvKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFFilterPeta.CBTPSChange(Sender: TObject);
begin

end;

procedure TFFilterPeta.CBTPSKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFFilterPeta.CBKoorKelKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFFilterPeta.CBKoorTPSKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFFilterPeta.Hapus;
begin
  CBProv.Text:='-Pilih-';
  CBKabKota.Text:='-Pilih-';
  CBKec.Text:='-Pilih-';
  CBKelDesa.Text:='-Pilih-';
  //CBTPS.Text:='-Pilih-';
 // CBKoorKel.Text:='-Pilih-';
 // CBKoorTPS.Text:='-Pilih-';
end;

procedure TFFilterPeta.SetCB;
var
  i,j : integer;
begin
  CBProv.Items.Clear;
  DM.ZQProv.First;
  for i:= 1 to DM.ZQProv.RecordCount do
  begin
  CBProv.Items.Add(DM.ZQProv.FieldByName('nama_provinsi').AsString);
  DM.ZQProv.Next;
  end;
  CBKabKota.Items.Clear;
  DM.ZQKabKota.First;
  for i:= 1 to DM.ZQKabKota.RecordCount do
  begin
  CBKabKota.Items.Add(DM.ZQKabKota.FieldByName('nama_kota').AsString);
  DM.ZQKabKota.Next;
  end;
  CBKec.Items.Clear;
  DM.ZQKec.First;
  for i:= 1 to DM.ZQKec.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQKec.FieldByName('nama_kecamatan').AsString);
  DM.ZQKec.Next;
  end;
  CBKelDesa.Items.Clear;
  DM.ZQKelDesa.First;
  for i:= 1 to DM.ZQKelDesa.RecordCount do
  begin
  CBKelDesa.Items.Add(DM.ZQKelDesa.FieldByName('nama_kelurahan').AsString);
  DM.ZQKelDesa.Next;
  end;
end;

function TFFilterPeta.getIdKec(nama: string): string;
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

function TFFilterPeta.getIdProv(nama: string): string;
begin
  Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_provinsi as id from t_provinsi where nama_provinsi="'+nama+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFFilterPeta.getIdKota(nama: string): string;
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

function TFFilterPeta.getIdKelurahan(nama: string): string;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_kelurahan as id from t_kelurahan where nama_kelurahan="'+nama+'"';
   Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFFilterPeta.getIdTPS(no: string; kel: string): string;
begin
  Result:='';
  with DM.ZQCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_tps as id from t_tps where no_tps="'+no+'" and id_kelurahan="'+getIdKelurahan(kel)+'"';
   Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFFilterPeta.setCBKabSesuai(nama: string);
var
  i : integer;
begin
  CBKabKota.Items.Clear;
  CBKabKota.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kota from t_kabkota where id_provinsi="'+getIdProv(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKabKota.Items.Add(DM.ZQCari.FieldByName('nama_kota').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFFilterPeta.setCBKecSesuai(nama: string);
var
  i : integer;
begin
  CBKec.Items.Clear;
  CBKec.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kecamatan from t_kecamatan where id_kota="'+getIdKota(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKec.Items.Add(DM.ZQCari.FieldByName('nama_kecamatan').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFFilterPeta.setCBKelSesuai(nama: string);
var
  i : integer;
begin
  CBKelDesa.Items.Clear;
  CBKelDesa.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kelurahan from t_kelurahan where id_kecamatan="'+getIdKec(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKelDesa.Items.Add(DM.ZQCari.FieldByName('nama_kelurahan').AsString);
  DM.ZQCari.Next;
  end;

end;

end.

