unit ugrafikpeta;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls, TAChartUtils, TATransformations,
  LCLIntf, udatamodule, ufilterpeta, TADrawUtils, IntfGraphics, TACustomSource;

type

  { TFGrafikPeta }

  TFGrafikPeta = class(TForm)
    BCari: TBitBtn;
    BCetak: TBitBtn;
    Bars: TBarSeries;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    GrafikPeta: TChart;
    GrafikPetaBarSeries1: TBarSeries;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BCariClick(Sender: TObject);
    procedure BCetakClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

    procedure BuatGrafik;
    procedure HapusGrafik;

  end;

var
  FGrafikPeta: TFGrafikPeta;
  jml : integer;

const
  query = 'SELECT t_petasuara.id, t_provinsi.nama_provinsi as nama_provinsi, t_provinsi.id_provinsi as id_provinsi,'+
          't_kabkota.nama_kota as nama_kota, t_kabkota.id_kota as id_kota, t_kecamatan.nama_kecamatan as nama_kecamatan, t_kecamatan.id_kecamatan as id_kecamatan, '+
          't_kelurahan.nama_kelurahan as nama_kelurahan, t_kelurahan.id_kelurahan as id_kelurahan, t_tps.no_tps as no_tps, t_tps.id_tps as id_tps FROM '+
          '(((((t_petasuara INNER JOIN t_tps ON t_tps.id_tps=t_petasuara.idtps)'+
          'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
          'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
          'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
          'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';

implementation

uses uutama;

{$R *.lfm}

{ TFGrafikPeta }

function GenerateRandomColor(const Mix: TColor = clWhite): TColor;
var
  Red, Green, Blue: Integer;
begin
  Red := Random(256);
  Green := Random(256);
  Blue := Random(256);

  Red := (Red + GetRValue(ColorToRGB(Mix))) div 2;
  Green := (Green + GetGValue(ColorToRGB(Mix))) div 2;
  Blue := (Blue + GetBValue(ColorToRGB(Mix))) div 2;
  Result := RGB(Red, Green, Blue);
end;

procedure TFGrafikPeta.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFGrafikPeta.FormCreate(Sender: TObject);
begin
  Bars := TBarSeries.Create(GrafikPeta);
  Bars.Marks.Style := TSeriesMarksStyle(smsValue);
  Bars.Marks.Distance:= 125;
end;

procedure TFGrafikPeta.FormShow(Sender: TObject);
begin
  jml := DM.ZQKelDesa.RecordCount;
end;

procedure TFGrafikPeta.BuatGrafik;
var
  Count: integer;
begin
  DM.ZQKelDesa.First;
  for Count := 1 to DM.ZQKelDesa.RecordCount do
  begin
    with DM.ZQTotKelurahan do begin
    Close;
    SQL.Clear;
    SQL.Text:=query+' where t_kelurahan.id_kelurahan="'+DM.ZQKelDesa.FieldByName('id_kelurahan').AsString+'"';
    Open;
    end;
    Bars.AddXY(
              Count,
              DM.ZQTotKelurahan.RecordCount,
              DM.ZQKelDesa.FieldByName('nama_kelurahan').AsString,
              GenerateRandomColor
              );
    DM.ZQKelDesa.Next;
  end;
  GrafikPeta.AddSeries(Bars);
  GrafikPeta.AxisList.BottomAxis.Marks.Source := Bars.Source;
  GrafikPeta.AxisList.BottomAxis.Marks.Style := smsLabel;
end;

procedure TFGrafikPeta.HapusGrafik;
var
i : integer;
begin
  for i := 1 to jml do Bars.Clear;
end;

procedure TFGrafikPeta.BRefreshClick(Sender: TObject);
begin
  HapusGrafik;
  BuatGrafik;
end;

procedure TFGrafikPeta.BCetakClick(Sender: TObject);
var
  namaimg,titel : string;
begin
  namaimg:='gpeta.bmp';
  titel  :='Grafik Peta Suara';
  if FUtama.SimpanGrafik.Execute then
     begin
     GrafikPeta.SaveToBitmapFile(ExtractFilePath(Application.ExeName)+'tmp/'+namaimg);
     FUtama.SaveGrafik(FUtama.SimpanGrafik.FileName,titel,namaimg,'','','','','','');
     if MessageDlg(titel+' berhasil dicetak ke PDF '+' ('+FUtama.SimpanGrafik.FileName+'). '+'Anda ingin membukanya?',mtConfirmation,[mbyes,mbno],0)=mrYes then
     begin
     OpenDocument(FUtama.SimpanGrafik.FileName);
     end;
    DeleteFile(ExtractFilePath(Application.ExeName)+'tmp/'+namaimg);
  end;
end;

procedure TFGrafikPeta.BCariClick(Sender: TObject);
begin
    HapusGrafik;
    with FFilterPeta do
    begin
    Caption:='Filter Grafik Peta Suara';
    SetCB;
    Hapus;
    LStatus.Caption:='Grafik';
    Label6.Visible:=False;
    Height:=235;
    ShowModal;
    end;
    jml := DM.ZQKelDesa.RecordCount;
    BuatGrafik;
end;

end.

