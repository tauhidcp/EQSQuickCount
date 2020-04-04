unit ufilterhitung;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, udatamodule;

type

  { TFFilterHitung }

  TFFilterHitung = class(TForm)
    BPilih: TBitBtn;
    CbDapil: TComboBox;
    CBKat: TComboBox;
    CbPartai: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    LKat: TLabel;
    LMode: TLabel;
    Panel1: TPanel;
    PAtas: TPanel;
    PBawah: TPanel;
    procedure BPilihClick(Sender: TObject);
    procedure CbDapilChange(Sender: TObject);
    procedure CbDapilKeyPress(Sender: TObject; var Key: char);
    procedure CBKatKeyPress(Sender: TObject; var Key: char);
    procedure CbPartaiChange(Sender: TObject);
    procedure CbPartaiKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private

  public

  procedure setCB;
  procedure hapus;
  function getIdPartai(nama:string):string;
  function getIdDAPIL(nama:string):string;
  procedure setCaleg(partai:string;dapil:string; caleg:string);
  function getIdKat(nama:string):string;
  procedure FilterExe;
  end;

var
  FFilterHitung: TFFilterHitung;
  qcapres, qcagub, qcabup, qkades, qdpd, qpartai, qdpr, qdprdp, qdprdk : string;

implementation

{$R *.lfm}

{ TFFilterHitung }

procedure TFFilterHitung.CbPartaiKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFFilterHitung.FormShow(Sender: TObject);
begin
  qcapres := 'SELECT t_capres.no_urut, t_capres.nama_capres, t_provinsi.nama_provinsi, '+
             't_kabkota.nama_kota, t_kecamatan.nama_kecamatan, '+
             't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungcapres.perolehan, '+
             't_hitungcapres.suara_sah, t_hitungcapres.suara_tidaksah, t_hitungcapres.dpt '+
             'FROM ((((((t_hitungcapres '+
             'INNER JOIN t_capres ON t_capres.no_urut=t_hitungcapres.no_urut) '+
             'INNER JOIN t_tps ON t_tps.id_tps=t_hitungcapres.tps) '+
             'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
             'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
             'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
             'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) ';
  qcagub  := 'SELECT t_cagub.no_urut, t_cagub.nama_cagub, t_provinsi.nama_provinsi, '+
             't_kabkota.nama_kota, t_kecamatan.nama_kecamatan, '+
             't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungcagub.perolehan, '+
             't_hitungcagub.suara_sah, t_hitungcagub.suara_tidaksah, t_hitungcagub.dpt '+
             'FROM ((((((t_hitungcagub '+
             'INNER JOIN t_cagub ON t_cagub.no_urut=t_hitungcagub.no_urut) '+
             'INNER JOIN t_tps ON t_tps.id_tps=t_hitungcagub.tps) '+
             'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
             'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
             'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
             'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) ';
  qcabup  := 'SELECT t_cabupkota.no_urut, t_cabupkota.nama_cabup, t_provinsi.nama_provinsi, '+
             't_kabkota.nama_kota, t_kecamatan.nama_kecamatan, '+
             't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungcabup.perolehan, '+
             't_hitungcabup.suara_sah, t_hitungcabup.suara_tidaksah, t_hitungcabup.dpt '+
             'FROM ((((((t_hitungcabup '+
             'INNER JOIN t_cabupkota ON t_cabupkota.no_urut=t_hitungcabup.no_urut) '+
             'INNER JOIN t_tps ON t_tps.id_tps=t_hitungcabup.tps) '+
             'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
             'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
             'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
             'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) ';
  qkades  := 'SELECT t_cakades.no_urut, t_cakades.nama_kades, t_provinsi.nama_provinsi, '+
             't_kabkota.nama_kota, t_kecamatan.nama_kecamatan, '+
             't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungkades.perolehan, '+
             't_hitungkades.suara_sah, t_hitungkades.suara_tidaksah, t_hitungkades.dpt '+
             'FROM ((((((t_hitungkades '+
             'INNER JOIN t_cakades ON t_cakades.no_urut=t_hitungkades.no_urut) '+
             'INNER JOIN t_tps ON t_tps.id_tps=t_hitungkades.tps) '+
             'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
             'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
             'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
             'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) ';
  qpartai := 'SELECT t_partai.no_urut, t_partai.nama_partai, t_provinsi.nama_provinsi, '+
             't_kabkota.nama_kota, t_kecamatan.nama_kecamatan, '+
             't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungpartai.suara_dprdkab, '+
             't_hitungpartai.suara_dprdprov, t_hitungpartai.suara_dprri, '+
             't_hitungpartai.suara_sah, '+
             't_hitungpartai.suara_tidaksah, t_hitungpartai.dpt '+
             'FROM ((((((t_hitungpartai '+
             'INNER JOIN t_partai ON t_partai.no_urut=t_hitungpartai.no_urut) '+
             'INNER JOIN t_tps ON t_tps.id_tps=t_hitungpartai.tps) '+
             'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
             'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
             'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
             'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) ';
  qdpd    := 'SELECT t_calegdpdri.no_urut, t_calegdpdri.nama_caleg, t_provinsi.nama_provinsi, '+
             't_kabkota.nama_kota, t_kecamatan.nama_kecamatan, '+
             't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungdpdri.perolehan, '+
             't_hitungdpdri.suara_sah, t_hitungdpdri.suara_tidaksah, t_hitungdpdri.dpt '+
             'FROM ((((((t_hitungdpdri '+
             'INNER JOIN t_calegdpdri ON t_calegdpdri.no_urut=t_hitungdpdri.no_urut) '+
             'INNER JOIN t_tps ON t_tps.id_tps=t_hitungdpdri.tps) '+
             'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
             'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
             'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
             'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) ';
  qdpr    := 'SELECT t_calegdprri.id, t_calegdprri.no_urut, '+
             't_calegdprri.nama_caleg, t_partai.nama_partai, t_provinsi.nama_provinsi,'+
             't_kabkota.nama_kota, t_dapil.nama_dapil, t_kecamatan.nama_kecamatan, '+
             't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungdprri.perolehan, '+
             't_hitungdprri.suara_sah, t_hitungdprri.suara_tidaksah, t_hitungdprri.dpt '+
             'FROM ((((((((t_calegdprri '+
             'INNER JOIN t_hitungdprri ON t_hitungdprri.id_caleg=t_calegdprri.id) '+
             'INNER JOIN t_tps ON t_tps.id_tps=t_hitungdprri.tps) '+
             'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
             'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
             'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
             'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) '+
             'INNER JOIN t_dapil ON t_calegdprri.dapil=t_dapil.id_dapil) '+
             'INNER JOIN t_partai ON t_partai.no_urut=t_calegdprri.partai) ';
  qdprdp  := 'SELECT t_calegdprdprov.id, t_calegdprdprov.no_urut, '+
             't_calegdprdprov.nama_caleg, t_partai.nama_partai, t_provinsi.nama_provinsi,'+
             't_kabkota.nama_kota, t_dapil.nama_dapil, t_kecamatan.nama_kecamatan, '+
             't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungdprdprov.perolehan, '+
             't_hitungdprdprov.suara_sah, t_hitungdprdprov.suara_tidaksah, t_hitungdprdprov.dpt '+
             'FROM ((((((((t_calegdprdprov '+
             'INNER JOIN t_hitungdprdprov ON t_hitungdprdprov.id_caleg=t_calegdprdprov.id) '+
             'INNER JOIN t_tps ON t_tps.id_tps=t_hitungdprdprov.tps) '+
             'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
             'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
             'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
             'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) '+
             'INNER JOIN t_dapil ON t_calegdprdprov.dapil=t_dapil.id_dapil) '+
             'INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdprov.partai) ';
  qdprdk  := 'SELECT t_calegdprdkabkota.id, t_calegdprdkabkota.no_urut, '+
             't_calegdprdkabkota.nama_caleg, t_partai.nama_partai, t_provinsi.nama_provinsi,'+
             't_kabkota.nama_kota, t_dapil.nama_dapil, t_kecamatan.nama_kecamatan, '+
             't_kelurahan.nama_kelurahan, t_tps.no_tps, t_hitungdprdkab.perolehan, '+
             't_hitungdprdkab.suara_sah, t_hitungdprdkab.suara_tidaksah, t_hitungdprdkab.dpt '+
             'FROM ((((((((t_hitungdprdkab '+
             'INNER JOIN t_calegdprdkabkota ON t_calegdprdkabkota.id=t_hitungdprdkab.id_caleg) '+
             'INNER JOIN t_tps ON t_tps.id_tps=t_hitungdprdkab.tps) '+
             'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
             'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
             'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
             'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) '+
             'INNER JOIN t_dapil ON t_calegdprdkabkota.dapil=t_dapil.id_dapil) '+
             'INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdkabkota.partai) ';
end;

procedure TFFilterHitung.setCB;
var
  i : integer;
begin
  CbPartai.Items.Clear;
  DM.ZQPartai.First;
  for i:= 1 to DM.ZQPartai.RecordCount do
  begin
  CbPartai.Items.Add(DM.ZQPartai.FieldByName('singkatan').AsString);
  DM.ZQPartai.Next;
  end;
  CbDapil.Items.Clear;
  DM.ZQDapil.First;
  for i:= 1 to DM.ZQDapil.RecordCount do
  begin
  CbDapil.Items.Add(DM.ZQDapil.FieldByName('nama_dapil').AsString);
  DM.ZQDapil.Next;
  end;
  CBKat.Items.Clear;
end;

procedure TFFilterHitung.hapus;
begin
 CbPartai.Text:='-Pilih-';
 CbDapil.Text:='-Pilih-';
 CBKat.Text:='-Pilih-';
end;

function TFFilterHitung.getIdPartai(nama: string): string;
begin
  Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_urut as id from t_partai where singkatan="'+nama+'"';
  Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFFilterHitung.getIdDAPIL(nama: string): string;
begin
 Result:='';
with DM.ZQCari do
begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_dapil as id from t_dapil where nama_dapil="'+nama+'"';
 Open;
end;
if DM.ZQCari.RecordCount>=1 then
Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFFilterHitung.setCaleg(partai: string; dapil: string; caleg:string);
var
  i : integer;
begin
  with DM.ZQCari2 do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select nama_caleg as nama from '+caleg+' where partai="'+getIdPartai(partai)+'" and dapil="'+getIdDAPIL(dapil)+'"';
   Open;
  end;
  CBKat.Items.Clear;
  DM.ZQCari2.First;
  for i:= 1 to DM.ZQCari2.RecordCount do
  begin
  CBKat.Items.Add(DM.ZQCari2.FieldByName('nama').AsString);
  DM.ZQCari2.Next;
  end;
end;

function TFFilterHitung.getIdKat(nama: string): string;
begin
  Result:='';
  if LMode.Caption='Capres' then
  begin
    with DM.ZQCari do
    begin
     Close;
     SQL.Clear;
     SQL.Text:='select no_urut as id from t_capres where nama_capres="'+nama+'"';
     Open;
    end;
  end;
  if LMode.Caption='Cagub' then
  begin
    with DM.ZQCari do
    begin
     Close;
     SQL.Clear;
     SQL.Text:='select no_urut as id from t_cagub where nama_cagub="'+nama+'"';
     Open;
    end;
  end;
  if LMode.Caption='Cabup' then
  begin
    with DM.ZQCari do
    begin
     Close;
     SQL.Clear;
     SQL.Text:='select no_urut as id from t_cabupkota where nama_cabup="'+nama+'"';
     Open;
    end;
  end;
  if LMode.Caption='Kades' then
  begin
    with DM.ZQCari do
    begin
     Close;
     SQL.Clear;
     SQL.Text:='select no_urut as id from t_cakades where nama_kades="'+nama+'"';
     Open;
    end;
  end;
  if LMode.Caption='Partai' then
  begin
    with DM.ZQCari do
    begin
     Close;
     SQL.Clear;
     SQL.Text:='select no_urut as id from t_partai where singkatan="'+nama+'"';
     Open;
    end;
  end;
  if LMode.Caption='DPD' then
  begin
    with DM.ZQCari do
    begin
     Close;
     SQL.Clear;
     SQL.Text:='select no_urut as id from t_calegdpdri where nama_caleg="'+nama+'"';
     Open;
    end;
  end;
  if LMode.Caption='DPR' then
  begin
    with DM.ZQCari do
    begin
     Close;
     SQL.Clear;
     SQL.Text:='select id from t_calegdprri where nama_caleg="'+nama+'"';
     Open;
    end;
  end;
  if LMode.Caption='DPRDProv' then
  begin
    with DM.ZQCari do
    begin
     Close;
     SQL.Clear;
     SQL.Text:='select id from t_calegdprdprov where nama_caleg="'+nama+'"';
     Open;
    end;
  end;
  if LMode.Caption='DPRDKab' then
  begin
    with DM.ZQCari do
    begin
     Close;
     SQL.Clear;
     SQL.Text:='select id from t_calegdprdkabkota where nama_caleg="'+nama+'"';
     Open;
    end;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFFilterHitung.CbDapilKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFFilterHitung.CbDapilChange(Sender: TObject);
begin
 if LMode.Caption='DPRDKab' then setCaleg(CbPartai.Text,CbDapil.Text,'t_calegdprdkabkota') else
 if LMode.Caption='DPRDProv' then setCaleg(CbPartai.Text,CbDapil.Text,'t_calegdprdprov') else
 if LMode.Caption='DPR' then setCaleg(CbPartai.Text,CbDapil.Text,'t_calegdprri');
end;

procedure TFFilterHitung.BPilihClick(Sender: TObject);
begin
  if not (CBKat.Text='-Pilih-') then
     FilterExe else MessageDlg('Jangan Kosongkan Inputan!',mtWarning,[mbok],0);
end;

procedure TFFilterHitung.CBKatKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFFilterHitung.CbPartaiChange(Sender: TObject);
begin
 if LMode.Caption='DPRDKab' then setCaleg(CbPartai.Text,CbDapil.Text,'t_calegdprdkabkota') else
 if LMode.Caption='DPRDProv' then setCaleg(CbPartai.Text,CbDapil.Text,'t_calegdprdprov') else
 if LMode.Caption='DPR' then setCaleg(CbPartai.Text,CbDapil.Text,'t_calegdprri');
end;

procedure TFFilterHitung.FilterExe;
begin
 if LMode.Caption='Capres' then
 begin
   with DM.ZQHCapres do
   begin
    Close;
    SQL.Clear;
    SQL.Text:=qcapres+'where t_capres.no_urut="'+getIdKat(CBKat.Text)+'" ORDER BY t_capres.no_urut ASC';
    Open;
   end;
 end;
 if LMode.Caption='Cagub' then
 begin
   with DM.ZQHCagub do
   begin
    Close;
    SQL.Clear;
    SQL.Text:=qcagub+'where t_cagub.no_urut="'+getIdKat(CBKat.Text)+'" ORDER BY t_cagub.no_urut ASC';
    Open;
   end;
 end;
 if LMode.Caption='Cabup' then
 begin
   with DM.ZQHCabup do
   begin
    Close;
    SQL.Clear;
    SQL.Text:=qcabup+'where t_cabupkota.no_urut="'+getIdKat(CBKat.Text)+'" ORDER BY t_cabupkota.no_urut ASC';
    Open;
   end;
 end;
 if LMode.Caption='Kades' then
 begin
   with DM.ZQHKades do
   begin
    Close;
    SQL.Clear;
    SQL.Text:=qkades+'where t_cakades.no_urut="'+getIdKat(CBKat.Text)+'" ORDER BY t_cakades.no_urut ASC';
    Open;
   end;
 end;
 if LMode.Caption='Partai' then
 begin
   with DM.ZQHPartai do
   begin
    Close;
    SQL.Clear;
    SQL.Text:=qpartai+'where t_partai.no_urut="'+getIdKat(CBKat.Text)+'" ORDER BY t_partai.no_urut ASC';
    Open;
   end;
 end;
 if LMode.Caption='DPD' then
 begin
   with DM.ZQHDPD do
   begin
    Close;
    SQL.Clear;
    SQL.Text:=qdpd+'where t_calegdpdri.no_urut="'+getIdKat(CBKat.Text)+'" ORDER BY t_calegdpdri.no_urut ASC';
    Open;
   end;
 end;
 if LMode.Caption='DPR' then
 begin
   with DM.ZQHDPR do
   begin
    Close;
    SQL.Clear;
    SQL.Text:=qdpr+'where t_calegdprri.id="'+getIdKat(CBKat.Text)+'" ORDER BY t_calegdprri.id ASC';
    Open;
   end;
 end;
 if LMode.Caption='DPRDProv' then
 begin
   with DM.ZQHDPRDP do
   begin
    Close;
    SQL.Clear;
    SQL.Text:=qdprdp+'where t_calegdprdprov.id="'+getIdKat(CBKat.Text)+'" ORDER BY t_calegdprdprov.id ASC';
    Open;
   end;
 end;
 if LMode.Caption='DPRDKab' then
 begin
   with DM.ZQHDPRDK do
   begin
    Close;
    SQL.Clear;
    SQL.Text:=qdprdk+'where t_calegdprdkabkota.id="'+getIdKat(CBKat.Text)+'" ORDER BY t_calegdprdkabkota.id ASC';
    Open;
   end;
 end;
end;

end.

