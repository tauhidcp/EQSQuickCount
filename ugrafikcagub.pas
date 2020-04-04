unit ugrafikcagub;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TASeries, TAGraph, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Spin, ComCtrls, udatamodule,
  TADrawUtils, TAChartUtils;

type

  { TFGrafikCagub }

  TFGrafikCagub = class(TForm)
    BCetak: TBitBtn;
    BRefresh: TBitBtn;
    BTutup: TBitBtn;
    CkAutoRefresh: TCheckBox;
    GrafikCagub: TChart;
    GrafikCapresBarSeries1: TBarSeries;
    GrafikCagubBarSeries2: TBarSeries;
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
    procedure BRefreshClick(Sender: TObject);
    procedure BTutupClick(Sender: TObject);
    procedure CkAutoRefreshChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GrafikCagubAfterDraw(ASender: TChart; ADrawer: IChartDrawer);
    procedure SIntervalChange(Sender: TObject);
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
  FGrafikCagub: TFGrafikCagub;
  jml : integer;

implementation

uses uutama, IntfGraphics, TACustomSource, lclintf;

{$R *.lfm}

{ TFGrafikCagub }

function BuatQuery(Total:String):String;
begin
 Result := 'SELECT sum('+Total+') as jml FROM '+
           '((((((t_hitungcagub INNER JOIN t_cagub ON t_cagub.no_urut=t_hitungcagub.no_urut) '+
           'INNER JOIN t_tps ON t_tps.id_tps=t_hitungcagub.tps) '+
           'INNER JOIN t_kelurahan ON t_kelurahan.id_kelurahan=t_tps.id_kelurahan) '+
           'INNER JOIN t_kecamatan ON t_kecamatan.id_kecamatan=t_kelurahan.id_kecamatan) '+
           'INNER JOIN t_kabkota ON t_kabkota.id_kota=t_kecamatan.id_kota) '+
           'INNER JOIN t_provinsi ON t_provinsi.id_provinsi=t_kabkota.id_provinsi)';
end;

procedure TFGrafikCagub.BTutupClick(Sender: TObject);
begin
  TimerRefresh.Enabled:=False;
  CkAutoRefresh.Checked:=False;
  BRefresh.Visible:=True;
  BCetak.Left:=208;
  SInterval.Value:=1;
  SInterval.Enabled:=True;
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFGrafikCagub.BRefreshClick(Sender: TObject);
begin
  HapusGrafik;
  BuatGrafik;
  Persentase;
end;

procedure TFGrafikCagub.BCetakClick(Sender: TObject);
var
  namaimg,titel : string;
begin
  namaimg:='gcagub.bmp';
  titel  :='Grafik Perhitungan Calon Gubernur';
  if FUtama.SimpanGrafik.Execute then
     begin
     GrafikCagub.SaveToBitmapFile(ExtractFilePath(Application.ExeName)+'tmp/'+namaimg);
     FUtama.SaveGrafik(FUtama.SimpanGrafik.FileName,titel,namaimg,PSuaraSah.Caption,PSuaraTidakSah.Caption,PTPSMasuk.Caption,PSuaraMasuk.Caption,PJmlPemilih.Caption,PPersen.Caption);
     if MessageDlg(titel+' berhasil dicetak ke PDF '+' ('+FUtama.SimpanGrafik.FileName+'). '+'Anda ingin membukanya?',mtConfirmation,[mbyes,mbno],0)=mrYes then
     begin
     OpenDocument(FUtama.SimpanGrafik.FileName);
     end;
    DeleteFile(ExtractFilePath(Application.ExeName)+'tmp/'+namaimg);
  end;
end;

procedure TFGrafikCagub.CkAutoRefreshChange(Sender: TObject);
begin
  if CkAutoRefresh.Checked=True
  then begin
    TimerRefresh.Interval:=StrToInt(SInterval.Text)*1000;
    BRefresh.Visible:=False;
    BCetak.Left:=120;
    SInterval.Enabled:=False;
    TimerRefresh.Enabled:=True;
  end else
    begin
    TimerRefresh.Interval:=1000;
    BCetak.Left:=208;
    BRefresh.Visible:=True;
    SInterval.Enabled:=True;
    TimerRefresh.Enabled:=False;
    end;
end;

procedure TFGrafikCagub.FormCreate(Sender: TObject);
begin
  Bars := TBarSeries.Create(GrafikCagub);
  Bars.Marks.Style := TSeriesMarksStyle(smsValue);
  Bars.Marks.Distance:= 125;
end;

procedure TFGrafikCagub.FormResize(Sender: TObject);
begin
  UkuranPanel;
end;

procedure TFGrafikCagub.FormShow(Sender: TObject);
begin
  jml := DM.ZQCagub.RecordCount;
end;

procedure TFGrafikCagub.GrafikCagubAfterDraw(ASender: TChart;
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
  if (DM.ZQCagub.RecordCount>0) then
  begin
  DM.ZQCagub.First;

  for i:=0 to GrafikCagub.BottomAxis.ValueCount-1 do begin
    bmp := TBitmap.Create;
    jpg := TJpegImage.Create;
    item := GrafikCagub.BottomAxis.Value[i];
    xgr := GrafikCagubBarSeries2.AxisToGraphX(item.FValue);
    ximg := GrafikCagub.XGraphToImage(xgr);
    // Extract Gambar dari Database
    if FileExists(ExtractFilePath(Application.ExeName)+'img\cagub\'+DM.ZQCagub.FieldByName('foto').AsString) then
    jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\cagub\'+DM.ZQCagub.FieldByName('foto').AsString) else
    jpg.LoadfromFile(ExtractFilePath(Application.ExeName)+'img\noimage.jpg');
    bmp.Assign(jpg);

    if (GrafikCagub.BottomAxis.ValueCount<=2) then
    begin
    p := Bars.GetBarWidth(i) div 4;
    l := Bars.GetBarWidth(i) div 4;
    end else
    if (GrafikCagub.BottomAxis.ValueCount<5) and (GrafikCagub.BottomAxis.ValueCount>2) then
    begin
    p := Bars.GetBarWidth(i) div 3;
    l := Bars.GetBarWidth(i) div 3;
    end else
    if (GrafikCagub.BottomAxis.ValueCount>=5) then
    begin
    p := Bars.GetBarWidth(i) div 2;
    l := Bars.GetBarWidth(i) div 2;
    end;

    bmp.Canvas.StretchDraw(Rect(0, 0, p, l),bmp);
    bmp.SetSize(p,l);

    intfimg := bmp.CreateIntfImage;
    ADrawer.PutImage(ximg - bmp.Width div 2, ClientHeight - bmp.Height-220, intfimg);

  DM.ZQCagub.Next;
  intfimg.Free;
  bmp.Free;
  jpg.Free;
  end;
  end;
end;

procedure TFGrafikCagub.SIntervalChange(Sender: TObject);
begin

end;

procedure TFGrafikCagub.TimerRefreshTimer(Sender: TObject);
begin
  HapusGrafik;
  BuatGrafik;
  Persentase;
end;

procedure TFGrafikCagub.BuatGrafik;
var
i : integer;
persen : Real;
begin
    if (DM.ZQCagub.RecordCount>0) then
  begin
  DM.ZQCagub.First;
  for i := 0 to DM.ZQCagub.RecordCount-1 do
  begin
  with DM.ZQGrafikCagub do
  begin
  Close;
  SQL.Clear;
  SQL.Text:=BuatQuery('t_hitungcagub.perolehan')+' where t_cagub.no_urut="'+DM.ZQCagub.FieldByName('no_urut').AsString+'"';
  Open;
  end;
  if (NilaiUnik('t_hitungcagub','suara_sah') > 0) and (DM.ZQGrafikCagub.FieldByName('jml').AsInteger > 0) then
  persen := StrToFloat(FormatFloat('0.##',(DM.ZQGrafikCagub.FieldByName('jml').AsInteger/NilaiUnik('t_hitungcagub','suara_sah'))*100)) else
  persen := 0;
  Bars.AddXY(DM.ZQCagub.FieldByName('no_urut').AsInteger,
             persen,
             DM.ZQCagub.FieldByName('nama_akronim').AsString+sLineBreak+'('+
             FormatCurr('#,###',DM.ZQGrafikCagub.FieldByName('jml').AsCurrency)
             +')',
             StringToColor(DM.ZQCagub.FieldByName('warna').AsString)
             );
  DM.ZQCagub.Next;
  end;
  GrafikCagub.AddSeries(Bars);
  GrafikCagub.AxisList.BottomAxis.Marks.Source := Bars.Source;
  GrafikCagub.AxisList.BottomAxis.Marks.Style := smsLabel;
  end;
end;

procedure TFGrafikCagub.HapusGrafik;
var
i : integer;
begin
  for i := 1 to jml do Bars.Clear;
end;

procedure TFGrafikCagub.Persentase;
var
  suara,jumlah,posisi : LongInt;
  persenx : string;
begin
  with DM.ZQCari do
  begin
  // Suara Sah
  PSuaraSah.Caption:='Suara Sah : '+FormatCurr('#,###',NilaiUnik('t_hitungcagub','suara_sah'));
  // Suara Tidak Sah
  PSuaraTidakSah.Caption:='Suara Tidak Sah : '+FormatCurr('#,###',NilaiUnik('t_hitungcagub','suara_tidaksah'));
  // TPS Masuk
  Close;
  SQL.Clear;
  SQL.Text:='select distinct(tps) as jml from t_hitungcagub';
  Open;
  PTPSMasuk.Caption:='TPS Masuk : '+FormatCurr('#,###',RecordCount);
  // Suara Masuk
  PSuaraMasuk.Caption:='Suara Masuk : '+FormatCurr('#,###',NilaiUnik('t_hitungcagub','dpt'));
  suara := NilaiUnik('t_hitungcagub','dpt');
  // Jumlah Pemilih
  Close;
  SQL.Clear;
  SQL.Text:='select pemilih_cagub as jml from t_config';
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
  if (suara>0) then posisi := Trunc((suara/jumlah)*100) else posisi := 0;
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

procedure TFGrafikCagub.UkuranPanel;
begin
  PSuaraSah.Width:=PContainer.Width div 5;
  PSuaraTidakSah.Width:=PContainer.Width div 5;
  PTPSMasuk.Width:=PContainer.Width div 5;
  PSuaraMasuk.Width:=PContainer.Width div 5;
  PJmlPemilih.Width:=PContainer.Width div 5;
end;

function TFGrafikCagub.NilaiUnik(NamaTabel: String; NamaField: String): Integer;
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

