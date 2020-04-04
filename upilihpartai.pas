unit upilihpartai;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Buttons, udatamodule;

type

  { TFPilihPartai }

  TFPilihPartai = class(TForm)
    BPilih: TBitBtn;
    CbDapil: TComboBox;
    CbPartai: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    LMode: TLabel;
    Panel1: TPanel;
    PAtas: TPanel;
    PBawah: TPanel;
    procedure BPilihClick(Sender: TObject);
    procedure CbDapilKeyPress(Sender: TObject; var Key: char);
    procedure CBLimitKeyPress(Sender: TObject; var Key: char);
    procedure CbPartaiKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FPilihPartai: TFPilihPartai;

implementation

uses uutama;

{$R *.lfm}

{ TFPilihPartai }

procedure TFPilihPartai.CbPartaiKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;


procedure TFPilihPartai.BPilihClick(Sender: TObject);
begin
  if (CbDapil.Text='-Pilih-') or (CbPartai.Text='-Pilih-') or (LMode.Caption='LMode') then
    MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
      begin
        if LMode.Caption='DPR' then
        begin
          with DM.ZQGDPR do
          begin
            Close;
            SQL.Clear;
            if (CbPartai.Text='Semua') and (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprri.id AS id, t_calegdprri.no_urut, t_calegdprri.nama_caleg, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprri.foto, t_calegdprri.warna, t_calegdprri.dapil FROM ((t_calegdprri INNER JOIN t_dapil ON t_calegdprri.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprri.partai)'
            else if not (CbPartai.Text='Semua') and not (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprri.id AS id, t_calegdprri.no_urut, t_calegdprri.nama_caleg, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprri.foto, t_calegdprri.warna, t_calegdprri.dapil FROM ((t_calegdprri INNER JOIN t_dapil ON t_calegdprri.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprri.partai) where t_partai.singkatan="'+CbPartai.Text+'" and t_dapil.nama_dapil="'+CbDapil.Text+'"'
            else if not (CbPartai.Text='Semua') and (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprri.id AS id, t_calegdprri.no_urut, t_calegdprri.nama_caleg, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprri.foto, t_calegdprri.warna, t_calegdprri.dapil FROM ((t_calegdprri INNER JOIN t_dapil ON t_calegdprri.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprri.partai) where t_partai.singkatan="'+CbPartai.Text+'"'
            else if (CbPartai.Text='Semua') and not (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprri.id AS id, t_calegdprri.no_urut, t_calegdprri.nama_caleg, t_partai.nama_partai, t_dapil.nama_dapil, t_calegdprri.foto, t_calegdprri.warna, t_calegdprri.dapil FROM ((t_calegdprri INNER JOIN t_dapil ON t_calegdprri.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprri.partai) where t_dapil.nama_dapil="'+CbDapil.Text+'"';
            Open;
          end;
        end;
        if LMode.Caption='DPRDProv' then
        begin
          with DM.ZQGDPRDP do
          begin
            Close;
            SQL.Clear;
            if (CbPartai.Text='Semua') and (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprdprov.id AS id, t_calegdprdprov.no_urut, t_calegdprdprov.nama_caleg, t_partai.nama_partai, t_provinsi.nama_provinsi, t_dapil.nama_dapil, t_calegdprdprov.foto, t_calegdprdprov.warna, t_calegdprdprov.dapil FROM (((t_calegdprdprov INNER JOIN t_dapil ON t_calegdprdprov.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdprov.partai) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdprdprov.prov)'
            else if not (CbPartai.Text='Semua') and not (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprdprov.id AS id, t_calegdprdprov.no_urut, t_calegdprdprov.nama_caleg, t_partai.nama_partai, t_provinsi.nama_provinsi, t_dapil.nama_dapil, t_calegdprdprov.foto, t_calegdprdprov.warna, t_calegdprdprov.dapil FROM (((t_calegdprdprov INNER JOIN t_dapil ON t_calegdprdprov.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdprov.partai) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdprdprov.prov) where t_partai.singkatan="'+CbPartai.Text+'" and t_dapil.nama_dapil="'+CbDapil.Text+'"'
            else if not (CbPartai.Text='Semua') and (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprdprov.id AS id, t_calegdprdprov.no_urut, t_calegdprdprov.nama_caleg, t_partai.nama_partai, t_provinsi.nama_provinsi, t_dapil.nama_dapil, t_calegdprdprov.foto, t_calegdprdprov.warna, t_calegdprdprov.dapil FROM (((t_calegdprdprov INNER JOIN t_dapil ON t_calegdprdprov.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdprov.partai) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdprdprov.prov) where t_partai.singkatan="'+CbPartai.Text+'"'
            else if (CbPartai.Text='Semua') and not (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprdprov.id AS id, t_calegdprdprov.no_urut, t_calegdprdprov.nama_caleg, t_partai.nama_partai, t_provinsi.nama_provinsi, t_dapil.nama_dapil, t_calegdprdprov.foto, t_calegdprdprov.warna, t_calegdprdprov.dapil FROM (((t_calegdprdprov INNER JOIN t_dapil ON t_calegdprdprov.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdprov.partai) INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_calegdprdprov.prov) where t_dapil.nama_dapil="'+CbDapil.Text+'"';
            Open;
          end;
        end;
        if LMode.Caption='DPRDKab' then
        begin
          with DM.ZQGDPRDK do
          begin
            Close;
            SQL.Clear;
            if (CbPartai.Text='Semua') and (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprdkabkota.id AS id, t_calegdprdkabkota.no_urut, t_calegdprdkabkota.nama_caleg, t_partai.nama_partai, t_kabkota.nama_kota, t_dapil.nama_dapil, t_calegdprdkabkota.foto, t_calegdprdkabkota.warna, t_calegdprdkabkota.dapil FROM (((t_calegdprdkabkota INNER JOIN t_dapil ON t_calegdprdkabkota.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdkabkota.partai) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_calegdprdkabkota.kabkota)'
            else if not (CbPartai.Text='Semua') and not (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprdkabkota.id AS id, t_calegdprdkabkota.no_urut, t_calegdprdkabkota.nama_caleg, t_partai.nama_partai, t_kabkota.nama_kota, t_dapil.nama_dapil, t_calegdprdkabkota.foto, t_calegdprdkabkota.warna, t_calegdprdkabkota.dapil FROM (((t_calegdprdkabkota INNER JOIN t_dapil ON t_calegdprdkabkota.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdkabkota.partai) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_calegdprdkabkota.kabkota) where t_partai.singkatan="'+CbPartai.Text+'" and t_dapil.nama_dapil="'+CbDapil.Text+'"'
            else if not (CbPartai.Text='Semua') and (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprdkabkota.id AS id, t_calegdprdkabkota.no_urut, t_calegdprdkabkota.nama_caleg, t_partai.nama_partai, t_kabkota.nama_kota, t_dapil.nama_dapil, t_calegdprdkabkota.foto, t_calegdprdkabkota.warna, t_calegdprdkabkota.dapil FROM (((t_calegdprdkabkota INNER JOIN t_dapil ON t_calegdprdkabkota.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdkabkota.partai) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_calegdprdkabkota.kabkota) where t_partai.singkatan="'+CbPartai.Text+'"'
            else if (CbPartai.Text='Semua') and not (CbDapil.Text='Semua') then
            SQL.Text:='SELECT t_calegdprdkabkota.id AS id, t_calegdprdkabkota.no_urut, t_calegdprdkabkota.nama_caleg, t_partai.nama_partai, t_kabkota.nama_kota, t_dapil.nama_dapil, t_calegdprdkabkota.foto, t_calegdprdkabkota.warna, t_calegdprdkabkota.dapil FROM (((t_calegdprdkabkota INNER JOIN t_dapil ON t_calegdprdkabkota.dapil=t_dapil.id_dapil) INNER JOIN t_partai ON t_partai.no_urut=t_calegdprdkabkota.partai) INNER JOIN t_kabkota ON t_kabkota.id_kota=t_calegdprdkabkota.kabkota) where t_dapil.nama_dapil="'+CbDapil.Text+'"';
            Open;
          end;
        end;
        Close;
      end;
end;

procedure TFPilihPartai.CbDapilKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFPilihPartai.CBLimitKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFPilihPartai.FormShow(Sender: TObject);
var
  i,j : integer;
begin
  with DM.ZQDapil do
      begin
        Close;
        SQL.Clear;
        SQL.Text:='select * from t_dapil where kategori="'+FUtama.LKategori.Caption+'" order by id_dapil asc';
        Open;
      end;
  DM.ZQPartai.First;
  CbPartai.Items.Clear;
  CbPartai.Text:='-Pilih-';
  CbPartai.Items.Add('Semua');
  for i := 1 to DM.ZQPartai.RecordCount do begin
    CbPartai.Items.Add(DM.ZQPartai.FieldByName('singkatan').AsString);
    DM.ZQPartai.Next;
  end;
  CbDapil.Items.Clear;
  CbDapil.Text:='-Pilih-';
  CbDapil.Items.Add('Semua');
  for j := 1 to DM.ZQDapil.RecordCount do begin
    CbDapil.Items.Add(DM.ZQDapil.FieldByName('nama_dapil').AsString);
    DM.ZQDapil.Next;
  end;
end;

end.

