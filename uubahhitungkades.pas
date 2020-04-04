unit uubahhitungkades;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule;

type

  { TFUbahHitungKades }

  TFUbahHitungKades = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    CBKel: TComboBox;
    CBKades: TComboBox;
    CBTPS: TComboBox;
    EJumlahDPT: TEdit;
    EPerolehan: TEdit;
    ESuaraSah: TEdit;
    ESuaraTidakSah: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBKadesChange(Sender: TObject);
    procedure CBKadesKeyPress(Sender: TObject; var Key: char);
    procedure CBKelChange(Sender: TObject);
    procedure CBKelKeyPress(Sender: TObject; var Key: char);
    procedure CBTPSKeyPress(Sender: TObject; var Key: char);
    procedure EJumlahDPTKeyPress(Sender: TObject; var Key: char);
    procedure EPerolehanKeyPress(Sender: TObject; var Key: char);
    procedure ESuaraSahKeyPress(Sender: TObject; var Key: char);
    procedure ESuaraTidakSahKeyPress(Sender: TObject; var Key: char);
  private

  public
    procedure hapus;
    procedure setCB;
    function getIdKades(nama:string):string;
    function getIdDaerah(nama:string):string;
    function getIdKel(nama:string):string;
    function getIdTPS(nama:string;kel:string):string;
    procedure setCBKelSesuai(nama:string);
    procedure setCBTPSSesuai(nama:string);

  end;

var
  FUbahHitungKades: TFUbahHitungKades;

implementation

uses uutama;

{$R *.lfm}

{ TFUbahHitungKades }


procedure TFUbahHitungKades.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFUbahHitungKades.BSimpanClick(Sender: TObject);
begin
  if (CBKades.Text='') or (CBKades.Text='-Pilih-') or (CBKel.Text='') or (CBKel.Text='-Pilih-') or (CBTPS.Text='') or (CBTPS.Text='-Pilih-') or
     (EPerolehan.Text='') or (ESuaraSah.Text='') or (ESuaraTidakSah.Text='') or (EJumlahDPT.Text='') then
  MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
  begin
        // Cek Apakah Data Sudah ada
        with DM.ZQCari do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='select * from t_hitungkades where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and no_urut="'+getIdKades(CBKades.Text)+'"';
          Open;
        end;
        if DM.ZQCari.RecordCount >= 1 then
        begin
        // Update
        with DM.ZQHitungKades do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='update t_hitungkades set keldesa="'+getIdKel(CBKel.Text)+'",perolehan="'+EPerolehan.Text+'",suara_sah="'+ESuaraSah.Text+'",suara_tidaksah="'+ESuaraTidakSah.Text+'",dpt="'+EJumlahDPT.Text+'" where tps="'+getIdTPS(CBTPS.Text,CBKel.Text)+'" and no_urut="'+getIdKades(CBKades.Text)+'"';
          ExecSQL;
        end;
        MessageDlg('Data Perhitungan Calon KADES Berhasil Diperbarui!',mtInformation,[mbok],0);
        end else
        begin
          // Simpan
          with DM.ZQHitungKades do
          begin
            Close;
            SQL.Clear;
            SQL.Text:='insert into t_hitungkades (keldesa,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdKel(CBKel.Text)+'","'+getIdKades(CBKades.Text)+'","'+getIdTPS(CBTPS.Text,CBKel.Text)+'","'+EPerolehan.Text+'","'+ESuaraSah.Text+'","'+ESuaraTidakSah.Text+'","'+EJumlahDPT.Text+'")';
            ExecSQL;
          end;
          MessageDlg('Data Perhitungan Calon KADES Berhasil Diperbarui!',mtInformation,[mbok],0);
        end;
        fhkades.BRefresh.Click;
     end;
end;

procedure TFUbahHitungKades.CBKadesChange(Sender: TObject);
begin
  setCBKelSesuai(CBKades.Text);
end;

procedure TFUbahHitungKades.CBKadesKeyPress(Sender: TObject; var Key: char);
begin
  key :=#0;
end;

procedure TFUbahHitungKades.CBKelChange(Sender: TObject);
begin
  setCBTPSSesuai(CBKel.Text);
end;

procedure TFUbahHitungKades.CBKelKeyPress(Sender: TObject; var Key: char);
begin
  key :=#0;
end;

procedure TFUbahHitungKades.CBTPSKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFUbahHitungKades.EJumlahDPTKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungKades.EPerolehanKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungKades.ESuaraSahKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungKades.ESuaraTidakSahKeyPress(Sender: TObject;
  var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFUbahHitungKades.hapus;
begin
  CBKades.Text:='-Pilih-';
  CBKel.Text:='-Pilih-';
  CBTPS.Text:='-Pilih-';
  EPerolehan.Text:='';
  ESuaraSah.Text:='';
  ESuaraTidakSah.Text:='';
  EJumlahDPT.Text:='';
  setCB;
  BSimpan.Enabled:=True;
end;

procedure TFUbahHitungKades.setCB;
var
  i,j,k : integer;
begin
  CBKades.Items.Clear;
  CBKel.Items.Clear;
  CBTPS.Items.Clear;

  DM.ZQKades.First;
  for i:= 1 to DM.ZQKades.RecordCount do
  begin
  CBKades.Items.Add(DM.ZQKades.FieldByName('nama_kades').AsString);
  DM.ZQKades.Next;
  end;

  DM.ZQKelDesa.First;
  for j:= 1 to DM.ZQKelDesa.RecordCount do
  begin
  CBKel.Items.Add(DM.ZQKelDesa.FieldByName('nama_kelurahan').AsString);
  DM.ZQKelDesa.Next;
  end;

  DM.ZQTPS.First;
  for k:= 1 to DM.ZQKelDesa.RecordCount do
  begin
  CBTPS.Items.Add(DM.ZQTPS.FieldByName('no_tps').AsString);
  DM.ZQTPS.Next;
  end;

end;

function TFUbahHitungKades.getIdKades(nama: string): string;
begin
  Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_urut as id from t_cakades where nama_kades="'+nama+'"';
  Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFUbahHitungKades.getIdDaerah(nama: string): string;
begin
 Result:='';
 with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select daerah as id from t_cakades where nama_kades="'+nama+'"';
  Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

function TFUbahHitungKades.getIdKel(nama: string): string;
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

function TFUbahHitungKades.getIdTPS(nama: string; kel: string): string;
begin
 Result:='';
 with DM.ZQCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select id_tps as id from t_tps where no_tps="'+nama+'" and id_kelurahan="'+getIdKel(kel)+'"';
 Open;
 end;
 if DM.ZQCari.RecordCount>=1 then
 Result:=DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFUbahHitungKades.setCBKelSesuai(nama: string);
var
  i : integer;
begin
  CBKel.Items.Clear;
  CBKel.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_kelurahan from t_kelurahan where id_kelurahan="'+getIdDaerah(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBKel.Items.Add(DM.ZQCari.FieldByName('nama_kelurahan').AsString);
  DM.ZQCari.Next;
  end;

end;

procedure TFUbahHitungKades.setCBTPSSesuai(nama: string);
var
  i : integer;
begin
  CBTPS.Items.Clear;
  CBTPS.Text:='-Pilih-';

  with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select no_tps from t_tps where id_kelurahan="'+getIdKel(nama)+'"';
  Open;
  end;

  for i:= 1 to DM.ZQCari.RecordCount do
  begin
  CBTPS.Items.Add(DM.ZQCari.FieldByName('no_tps').AsString);
  DM.ZQCari.Next;
  end;

end;

end.

