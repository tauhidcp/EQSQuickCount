unit utambahdpt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ucekserial;

type

  { TFTambahDPT }

  TFTambahDPT = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBKabKota: TComboBox;
    CBKec: TComboBox;
    CBKelDesa: TComboBox;
    CBProv: TComboBox;
    CBTPS: TComboBox;
    EID: TEdit;
    ENoKTP: TEdit;
    ENama: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBKabKotaChange(Sender: TObject);
    procedure CBKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure CBKecChange(Sender: TObject);
    procedure CBKecKeyPress(Sender: TObject; var Key: char);
    procedure CBKelDesaChange(Sender: TObject);
    procedure CBKelDesaKeyPress(Sender: TObject; var Key: char);
    procedure CBProvChange(Sender: TObject);
    procedure CBProvKeyPress(Sender: TObject; var Key: char);
    procedure CBTPSKeyPress(Sender: TObject; var Key: char);
    procedure EIDKeyPress(Sender: TObject; var Key: char);
    procedure ENoKTPKeyPress(Sender: TObject; var Key: char);
  private

  public

  function noOtomatis(tambah:integer):string;
  procedure hapus;
  procedure setCB;
  function getIdProv(nama:string):string;
  function getIdKota(nama:string):string;
  function getIdKec(nama:string):string;
  function getIdKelurahan(nama:string):string;
  function getIdTPS(no:string;kel:string):string;
  procedure setCBKabSesuai(nama:string);
  procedure setCBKecSesuai(nama:string);
  procedure setCBKelSesuai(nama:string);
  procedure setCBSesuai(nama:string);
  procedure simpan;

  end;

var
  FTambahDPT: TFTambahDPT;

const
 query = 'SELECT t_dpt.id, t_dpt.ktp, t_dpt.nama, t_tps.no_tps, t_kelurahan.nama_kelurahan, t_kecamatan.nama_kecamatan, t_kabkota.nama_kota, t_provinsi.nama_provinsi FROM (((((t_dpt INNER JOIN t_tps ON t_tps.id_tps=t_dpt.tps) INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi) order by t_dpt.id asc';

implementation

uses udatamodule;

{$R *.lfm}

{ TFTambahDPT }

procedure TFTambahDPT.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahDPT.BSimpanClick(Sender: TObject);
begin
  if (EID.Text='') or (ENama.Text='') or (ENoKTP.Text='') or (CBKelDesa.Text='-Pilih-') or (CBKelDesa.Text='')
    or (CBKec.Text='-Pilih-') or (CBKec.Text='') or (CBKabKota.Text='-Pilih-') or (CBKabKota.Text='')
    or (CBProv.Text='-Pilih-') or (CBProv.Text='')
    or (CBTPS.Text='-Pilih-') or (CBTPS.Text='') then
    MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
    begin
      // Simpan
      if (BSimpan.Caption='Simpan') then
      begin

        if (cekSerial()=True) then
        simpan else
        begin
        if (cekData('t_dpt',10)=True) then
            MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
            simpan;
        end;

       end else
       // Update
       if (BSimpan.Caption='Perbarui') then
       begin
            with DM.ZQDPT do
            begin
              Close;
              SQL.Clear;
              SQL.Text:='update t_dpt set ktp="'+ENoKTP.Text+'",nama="'+ENama.Text+'",tps="'+getIdTPS(CBTPS.Text,CBKelDesa.Text)+'",desa_kelurahan="'+getIdKelurahan(CBKelDesa.Text)+'" where id="'+EID.Text+'"';
              ExecSQL;
              SQL.Clear;
              SQL.Text:=query;
              Open;
            end;
            MessageDlg('Data DPT Berhasil Diperbarui!',mtInformation,[mbok],0);
       end;
    end;
end;

procedure TFTambahDPT.CBKabKotaChange(Sender: TObject);
begin
  setCBKecSesuai(CBKabKota.Text);
end;

procedure TFTambahDPT.CBKabKotaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDPT.CBKecChange(Sender: TObject);
begin
  setCBKelSesuai(CBKec.Text);
end;

procedure TFTambahDPT.CBKecKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDPT.CBKelDesaChange(Sender: TObject);
begin
  setCBSesuai(CBKelDesa.Text);
end;

procedure TFTambahDPT.CBKelDesaKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDPT.CBProvChange(Sender: TObject);
begin
  setCBKabSesuai(CBProv.Text);
end;

procedure TFTambahDPT.CBProvKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDPT.CBTPSKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahDPT.EIDKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahDPT.ENoKTPKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;


function TFTambahDPT.noOtomatis(tambah: integer): string;
begin
  Result := '';
with DM.ZQCari do
begin
Close;
SQL.Clear;
SQL.Text:='select * from t_dpt';
Open;
end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahDPT.hapus;
begin
  EID.Text:=noOtomatis(1);
  ENoKTP.Text:='';
  ENama.Text:='';
  CBProv.Text:='-Pilih-';
  CBKabKota.Text:='-Pilih-';
  CBKelDesa.Text:='-Pilih-';
  CBKec.Text:='-Pilih-';
  CBTPS.Text:='-Pilih-';
  BSimpan.Enabled:=True;
end;

procedure TFTambahDPT.setCB;
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
  CBTPS.Items.Clear;
  DM.ZQTPS.First;
  for j := 1 to DM.ZQTPS.RecordCount do
  begin
  CBTPS.Items.Add(DM.ZQTPS.FieldByName('no_tps').AsString);
  DM.ZQTPS.Next;
  end;
end;

function TFTambahDPT.getIdProv(nama: string): string;
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

function TFTambahDPT.getIdKota(nama: string): string;
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

function TFTambahDPT.getIdKec(nama: string): string;
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

function TFTambahDPT.getIdTPS(no:string;kel:string):string;
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

procedure TFTambahDPT.setCBKabSesuai(nama: string);
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

procedure TFTambahDPT.setCBKecSesuai(nama: string);
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

procedure TFTambahDPT.setCBKelSesuai(nama: string);
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

procedure TFTambahDPT.setCBSesuai(nama: string);
var
  i : integer;
begin
  CBTPS.Items.Clear;
  CBTPS.Text:='-Pilih-';
  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_tps from t_tps where id_kelurahan="'+getIdKelurahan(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBTPS.Items.Add(DM.ZQCari.FieldByName('no_tps').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFTambahDPT.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_dpt where ktp="'+ENoKTP.Text+'" or id="'+EID.Text+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('Data DPT dengan No KTP atau ID Sudah digunakan dengan nama '+DM.ZQCari.FieldByName('nama').AsString,mtWarning,[mbok],0) else
  begin
    with DM.ZQDPT do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_dpt (id,ktp,nama,tps,desa_kelurahan) values ("'+EID.Text+'","'+ENoKTP.Text+'","'+ENama.Text+'","'+getIdTPS(CBTPS.Text,CBKelDesa.Text)+'","'+getIdKelurahan(CBKelDesa.Text)+'")';
      ExecSQL;
      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
  //  BSimpan.Enabled:=False;
    MessageDlg('Data DPT Berhasil Disimpan!',mtInformation,[mbok],0);
  end;
end;

function TFTambahDPT.getIdKelurahan(nama: string): string;
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

end.

