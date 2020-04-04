unit ugrafikdprdkabkota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Spin, ComCtrls, udatamodule,
  TADrawUtils, TAChartUtils, upilihpartai;

type

  { TFGrafikDPRDKabKota }

  TFGrafikDPRDKabKota = class(TForm)
    BCetak: TBitBtn;
    BFilter: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    CkAutoRefresh: TCheckBox;
    GrafikCaleg: TChart;
    GrafikCalegBarSeries2: TBarSeries;
    GrafikCapresBarSeries3: TBarSeries;
    GroupAutoRefresh: TGroupBox;
    Label1: TLabel;
    Bars: TBarSeries;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PContainer: TPanel;
    PContainer1: TPanel;
    PJmlPemilih: TPanel;
    PPersen: TPanel;
    PProgress: TPanel;
    PProgress1: TPanel;
    ProgressSuaraMasuk: TProgressBar;
    PSuaraMasuk: TPanel;
    PSuaraSah: TPanel;
    PSuaraTidakSah: TPanel;
    PTPSMasuk: TPanel;
    SInterval: TSpinEdit;
    TimerRefresh: TTimer;
    procedure BCetakClick(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure CkAutoRefreshChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GrafikCalegAfterDraw(ASender: TChart; ADrawer: IChartDrawer);
    procedure TimerRefreshTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure BuatGrafik;
    procedure HapusGrafik;
    procedure Persentase;
    procedure UkuranPanel;
    function NilaiUnik(NamaTabel:String;NamaField:String):Integer;
  end;

var
  FGrafikDPRDKabKota: TFGrafikDPRDKabKota;
  jml : integer;

implementation

uses uutama, IntfGraphics, TACustomSource, lclintf;

{$R *.lfm}

{ TFGrafikDPRDKabKota }

function BuatQuery(Total:String):String;
begin
 Result := 'SELECT sum('+Total+') as jml FROM '+
           '((((((t_hitungdprdkab INNER JOIN t_calegdprdkabkota ON t_calegdprdkabkota.id=t_hitungdprdkab.id_caleg) '+
           'INNER JOIN t_tps ON t_tps.id_tps=t_hitungdprdkab.tps) '+
           'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
           'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
           'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
           'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';
end;

procedure TFGrafikDPRDKabKota.BTutupClick(Sender: TObject);
begin
  TimerRefresh.Enabled:=False;
  CkAutoRefresh.Checked:=False;
  BRefresh.Visible:=True;
  BCetak.Left:=208;
  BFilter.Left:=290;
  SInterval.Value:=1;
  SInterval.Enabled:=True;
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFGrafikDPRDKabKota.BRefreshClick(Sender: TObject);
begin
  HapusGrafik;
  BuatGrafik;
  Persentase;
end;

procedure TFGrafikDPRDKabKota.BCetakClick(Sender: TObject);
var
  namaimg,titel : string;
begin
  namaimg:='gdprdkabkota.bmp';
  titel  :='Grafik Perhitungan DPRD Kabupaten/Kota';
  if FUtama.SimpanGrafik.Execute then
     begin
     GrafikCaleg.SaveToBitmapFile(ExtractFilePath(Application.ExeName)+'tmp/'+namaimg);
     FUtama.SaveGrafik(FUtama.SimpanGrafik.FileName,titel,namaimg,PSuaraSah.Caption,PSuaraTidakSah.Caption,PTPSMasuk.Caption,PSuaraMasuk.Caption,PJmlPemilih.Caption,PPersen.Caption);
     if MessageDlg(titel+' berhasil dicetak ke PDF '+' ('+FUtama.SimpanGrafik.FileName+'). '+'Anda ingin membukanya?',mtConfirmation,[mbyes,mbno],0)=mrYes then
     begin
     OpenDocument(FUtama.SimpanGrafik.FileName);
     end;
    DeleteFile(ExtractFilePath(Application.ExeName)+'tmp/'+namaimg);
  end;
end;

procedure TFGrafikDPRDKabKota.BFilterClick(Sender: TObject);
begin
  HapusGrafik;
  with FPilihPartai do
  begin
    Caption:='Form Pilih Partai';
    LMode.Caption:='DPRDKab';
    ShowModal;
  end;
  jml := DM.ZQGDPRDK.RecordCount;
  BuatGrafik;
  Persentase;
end;

procedure TFGrafikDPRDKabKota.CkAutoRefreshChange(Sender: TObject);
begin
  if CkAutoRefresh.Checked=True
  then begin
    TimerRefresh.Interval:=StrToInt(SInterval.Text)*1000;
    BRefresh.Visible:=False;
    BCetak.Left:=120;
    BFilter.Left:=204;
    SInterval.Enabled:=False;
    TimerRefresh.Enabled:=True;
  end else
    begin
    TimerRefresh.Interval:=1000;
    BCetak.Left:=208;
    BFilter.Left:=290;
    BRefresh.Visible:=True;
    SInterval.Enabled:=True;
    TimerRefresh.Enabled:=False;
    end;
end;


procedure TFGrafikDPRDKabKota.FormCreate(Sender: TObject);
begin
  Bars := TBarSeries.Create(GrafikCaleg);
  Bars.Marks.Style := TSeriesMarksStyle(smsValue);
  Bars.Marks.Distance:= 125;
end;

procedure TFGrafikDPRDKabKota.FormResize(Sender: TObject);
begin
  UkuranPanel;
end;

procedure TFGrafikDPRDKabKota.FormShow(Sender: TObject);
begin
    jml := DM.ZQGDPRDK.RecordCount;
end;

procedure TFGrafikDPRDKabKota.GrafikCalegAfterDraw(ASender: TChart;
  ADrawer: IChartDrawer);
var
  i: Integer;
  item: TChartValueText;
  ximg,p,l: Integer;
  xgr: Double;
  bmp: TBitmap;
  intfimg: TLazIntfImage;
  jpg: TJpegImage;
begin
  if (DM.ZQGDPRDK.RecordCount>0) then begin
  DM.ZQGDPRDK.First;

  for i:=0 to GrafikCaleg.BottomAxis.ValueCount-1 do begin
    bmp := TBitmap.Create;
    jpg := TJpegImage.Create;
    item := GrafikCaleg.BottomAxis.Value[i];
    xgr := GrafikCalegBarSeries2.AxisToGraphX(item.FValue);
    ximg := GrafikCaleg.XGraphToImage(xgr);
    // Extract Gambar dari Database
    if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+DM.ZQGDPRDK.FieldByName('foto').AsString) then
    jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+DM.ZQGDPRDK.FieldByName('foto').AsString) else
    jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    bmp.Assign(jpg);
    if (GrafikCaleg.BottomAxis.ValueCount<=2) then
    begin
    p := Bars.GetBarWidth(i) div 4;
    l := Bars.GetBarWidth(i) div 4;
    end else
    if (GrafikCaleg.BottomAxis.ValueCount<5) and (GrafikCaleg.BottomAxis.ValueCount>2) then
    begin
    p := Bars.GetBarWidth(i) div 3;
    l := Bars.GetBarWidth(i) div 3;
    end else
    if (GrafikCaleg.BottomAxis.ValueCount>=5) then
    begin
    p := Bars.GetBarWidth(i) div 2;
    l := Bars.GetBarWidth(i) div 2;
    end;
    bmp.Canvas.StretchDraw(Rect(0, 0, p, l),bmp);
    bmp.SetSize(p,l);

    intfimg := bmp.CreateIntfImage;
    ADrawer.PutImage(ximg - bmp.Width div 2, ClientHeight - bmp.Height-220, intfimg);

  DM.ZQGDPRDK.Next;
  intfimg.Free;
  bmp.Free;
  jpg.Free;
  end;
  end;
end;

procedure TFGrafikDPRDKabKota.TimerRefreshTimer(Sender: TObject);
begin
  HapusGrafik;
  BuatGrafik;
  Persentase;
end;

procedure TFGrafikDPRDKabKota.BuatGrafik;
var
i : integer;
persen : Real;
begin
  if (DM.ZQGDPRDK.RecordCount>0) then begin
  DM.ZQGDPRDK.First;
  for i := 0 to DM.ZQGDPRDK.RecordCount-1 do
  begin
  with DM.ZQGrafikDPRKab do
  begin
  Close;
  SQL.Clear;
  SQL.Text:=BuatQuery('t_hitungdprdkab.perolehan')+' where t_calegdprdkabkota.id="'+DM.ZQGDPRDK.FieldByName('id').AsString+'"';
  Open;
  end;
  if (NilaiUnik('t_hitungdprdkab','suara_sah') > 0) and (DM.ZQGrafikDPRKab.FieldByName('jml').AsInteger > 0) then
  persen := StrToFloat(FormatFloat('0.##',(DM.ZQGrafikDPRKab.FieldByName('jml').AsInteger/NilaiUnik('t_hitungdprdkab','suara_sah'))*100)) else
  persen := 0;
  Bars.AddXY(DM.ZQGDPRDK.FieldByName('id').AsInteger,
             persen,
             DM.ZQGDPRDK.FieldByName('nama_caleg').AsString+sLineBreak+'('+
             FormatCurr('#,###',DM.ZQGrafikDPRKab.FieldByName('jml').AsCurrency)
             +')',

             StringToColor(DM.ZQGDPRDK.FieldByName('warna').AsString)
             );
  DM.ZQGDPRDK.Next;
  end;
  GrafikCaleg.AddSeries(Bars);
  GrafikCaleg.AxisList.BottomAxis.Marks.Source := Bars.Source;
  GrafikCaleg.AxisList.BottomAxis.Marks.Style := smsLabel;
  end;
end;

procedure TFGrafikDPRDKabKota.HapusGrafik;
var
i : integer;
begin
  for i := 1 to jml do Bars.Clear;
end;

procedure TFGrafikDPRDKabKota.Persentase;
var
  suara,jumlah,posisi : LongInt;
  persenx : string;
begin
  with DM.ZQCari do
  begin
  // Suara Sah
  PSuaraSah.Caption:='Suara Sah : '+FormatCurr('#,###',NilaiUnik('t_hitungdprdkab','suara_sah'));
  // Suara Tidak Sah
  PSuaraTidakSah.Caption:='Suara Tidak Sah : '+FormatCurr('#,###',NilaiUnik('t_hitungdprdkab','suara_tidaksah'));
  // TPS Masuk
  Close;
  SQL.Clear;
  SQL.Text:='select distinct(tps) as jml from t_hitungdprdkab';
  Open;
  PTPSMasuk.Caption:='TPS Masuk : '+FormatCurr('#,###',RecordCount);
  // Suara Masuk
  PSuaraMasuk.Caption:='Suara Masuk : '+FormatCurr('#,###',NilaiUnik('t_hitungdprdkab','dpt'));
  suara := NilaiUnik('t_hitungdprdkab','dpt');
  // Jumlah Pemilih
  Close;
  SQL.Clear;
  SQL.Text:='select pemilih_dprdkabkota as jml from t_config';
  Open;
  PJmlPemilih.Caption:='Jumlah Pemilih : '+FormatCurr('#,###',FieldByName('jml').AsCurrency);
  jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
  // Jumlah Pemilih Belum Diatur
  if (jumlah<=0) then
  begin
  ProgressSuaraMasuk.Position := 0;
  PPersen.Caption := '0%';
  exit;
  end else
  begin
  // ProgressBar
  if (suara>0) then posisi := Trunc((suara/jumlah)*100) else posisi:= 0;
  ProgressSuaraMasuk.Position := posisi;
  // Persentase
  if (suara>0) then
  begin
  persenx := FormatFloat('0.##',((suara/jumlah)*100))+'%';
  if (Length(persenx)<=0) then persenx:='0%';
  end else persenx := '0%';
  PPersen.Caption:= persenx;
  end;
  end;
end;

procedure TFGrafikDPRDKabKota.UkuranPanel;
begin
  PSuaraSah.Width:=PContainer.Width div 5;
  PSuaraTidakSah.Width:=PContainer.Width div 5;
  PTPSMasuk.Width:=PContainer.Width div 5;
  PSuaraMasuk.Width:=PContainer.Width div 5;
  PJmlPemilih.Width:=PContainer.Width div 5;
end;

function TFGrafikDPRDKabKota.NilaiUnik(NamaTabel: String; NamaField: String
  ): Integer;
var
  i,hasil : LongInt;
begin
  Result:=0;
  hasil :=0;
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select '+NamaField+' from '+NamaTabel+' group by tps';
  Open;
  First;
  end;
  for i := 0 to DM.ZQCari.RecordCount-1 do begin
  hasil := hasil+DM.ZQCari.FieldByName(NamaField).AsInteger;
  DM.ZQCari.Next;
  end;
  Result:=hasil;
end;

end.

