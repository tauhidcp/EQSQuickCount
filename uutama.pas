unit UUtama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs, LR_Class, Forms, Controls,
  Graphics, Dialogs, ComCtrls, Menus, ExtCtrls, ExtDlgs, StdCtrls, SpkToolbar,
  spkt_Tab, spkt_Pane, spkt_Buttons, upartai, uprovinsi, ukabupatenkota,
  ukelurahandesa, utps, ukecamatan, ucapres, ucagub, ucabupkota, udapilkabkota,
  udapilprovinsi, udapilri, ucalegkabkota, ucalegdpdri, ucalegdprri,
  ucalegdprdprov, utimses, usaksi, uusulantimses, udukunganindependen, upolling,
  uusulsaran, uhitungcapres, uhitungcagub, uhitungcabupkota, uhitungpartai,
  uhitungdpdri, uhitungdprri, uhitungdprdprov, uhitungdprdkabkota, udapil,
  ugrafikcapres, ugrafikcagub, ugrafikcabupkota, ugrafikpartai, ugrafikdpdri,
  ugrafikdprri, ugrafikdprdprov, ugrafikdprdkabkota, udatasmsmasuk,
  udatasmsterkirim, udatachatmasuk, udatachatterkirim, udatapengguna,
  udataformatsmschat, ukirimchat, usms, udatamodule, windows, wininet,
  upengaturan, uidentitas, uregister, fphttpclient, fpjson, jsonparser, lclintf,
  usmsprocess, uchatprocess, ucekserial, libjpfpdf, uresetdb, udatasmsbalasan,
  ucakades, uhitungkades, ugrafikkades, upetasuara, zipper, AbZipper,
  AbUtils, AbArcTyp, udatadpt, ugrafikpeta, upilihpartai, usaintelague, ufilterpeta, process;

type

  { TFUtama }

  TFUtama = class(TForm)
    BBantuan: TSpkLargeButton;
    ExcelDialog: TOpenDialog;
    ImageBack: TImage;
    ImageList: TImageList;
    BBotTelegram: TMenuItem;
    BModem1: TMenuItem;
    BModem2: TMenuItem;
    BModem3: TMenuItem;
    BModem4: TMenuItem;
    BModem5: TMenuItem;
    BModem6: TMenuItem;
    BModem7: TMenuItem;
    BModem8: TMenuItem;
    ImgProfile: TImage;
    LKategori: TLabel;
    OPD: TOpenPictureDialog;
    OpenRestore: TOpenDialog;
    PBLoading: TProgressBar;
    PanelTengah: TPanel;
    PanelTools: TSpkPane;
    BBackupDatabase: TSpkLargeButton;
    BRestoreDatabase: TSpkLargeButton;
    BPerhitunganPartai: TSpkLargeButton;
    BGrafikPartai: TSpkLargeButton;
    BIdentitasLembaga: TSpkLargeButton;
    BPengaturanAplikasi: TSpkLargeButton;
    PanelRegister: TSpkPane;
    BRegister: TSpkLargeButton;
    PanelDataKampanye: TSpkPane;
    BDataTimsesRelawan: TSpkLargeButton;
    BDataSaksi: TSpkLargeButton;
    BDataUsulanTimsesRelawan: TSpkLargeButton;
    BDataDukunganIndependen: TSpkLargeButton;
    BDataPolling: TSpkLargeButton;
    BDataUsulSaran: TSpkLargeButton;
    PNC: TPanel;
    PopModem: TPopupMenu;
    PopBot: TPopupMenu;
    BDapilRI: TSpkLargeButton;
    BDapilProvinsi: TSpkLargeButton;
    BDapilKabKota: TSpkLargeButton;
    PanelDapil: TSpkPane;
    PProfile: TPanel;
    PQS: TPanel;
    PrintDialog: TPrintDialog;
    SaveBackup: TSaveDialog;
    SimpanGrafik: TSaveDialog;
    SaveExcel: TSaveDialog;
    BtDataDapil: TSpkLargeButton;
    BSMSChatAutoRespond: TSpkLargeButton;
    BResetDB: TSpkLargeButton;
    BDataSMSBalasan: TSpkLargeButton;
    BDataCALEGDPR: TSpkLargeButton;
    BDataCALEGDPRDProv: TSpkLargeButton;
    BDataCALEGDPRDKabKota: TSpkLargeButton;
    BPerhitunganCALEGDPR: TSpkLargeButton;
    BPerhitunganCALEGDPRDProv: TSpkLargeButton;
    BPerhitunganCALEGDPRDKabKota: TSpkLargeButton;
    BGrafikCalegDPR: TSpkLargeButton;
    BGrafikCalegDPRDProv: TSpkLargeButton;
    BGrafikCalegDPRDKabKota: TSpkLargeButton;
    BDataCaKades: TSpkLargeButton;
    BPerhitunganKades: TSpkLargeButton;
    BGrafikKades: TSpkLargeButton;
    PanelPeta: TSpkPane;
    BPerkiraan: TSpkLargeButton;
    BPemilih: TSpkLargeButton;
    PanelDPT: TSpkPane;
    BGRafikPeta: TSpkLargeButton;
    BHitungSainte: TSpkLargeButton;
    PanelSainte: TSpkPane;
    SubMenuSainte: TSpkTab;
    SubMenuDataKampanye: TSpkTab;
    PanelDataMasterCalon: TSpkPane;
    PanelModulSMS: TSpkPane;
    PanelPengaturan: TSpkPane;
    PanelBantuan: TSpkPane;
    PanelModulTelegram: TSpkPane;
    BSettingModem: TSpkLargeButton;
    BBotSetting: TSpkLargeButton;
    BDataCALEGDPD: TSpkLargeButton;
    BDataCAGUB: TSpkLargeButton;
    BDataCABUPKOTA: TSpkLargeButton;
    BDataCAPRES: TSpkLargeButton;
    PanelDataMaster: TSpkPane;
    BDataPartai: TSpkLargeButton;
    BKirimSMS: TSpkLargeButton;
    BChatting: TSpkLargeButton;
    PanelGrafikPerhitungan: TSpkPane;
    BGrafikCapres: TSpkLargeButton;
    BGrafikCAGUB: TSpkLargeButton;
    BGrafikCABUPKOTA: TSpkLargeButton;
    BGrafikCALEGDPD: TSpkLargeButton;
    PanelDataPerhitunganCepat: TSpkPane;
    BPerhitunganCAPRES: TSpkLargeButton;
    BPerhitunganCAGUB: TSpkLargeButton;
    BPerhitunganCABUPKOTA: TSpkLargeButton;
    BPerhitunganCALEGDPD: TSpkLargeButton;
    BDataProv: TSpkLargeButton;
    BDataKabKota: TSpkLargeButton;
    BDataKecamatan: TSpkLargeButton;
    BDataKelDesa: TSpkLargeButton;
    BDataTPS: TSpkLargeButton;
    BSMSMasuk: TSpkLargeButton;
    BSMSTerkirim: TSpkLargeButton;
    PanelDataSMS: TSpkPane;
    BChatMasuk: TSpkLargeButton;
    BChatTerkirim: TSpkLargeButton;
    PanelDataChat: TSpkPane;
    BDataPengguna: TSpkLargeButton;
    SubMenuDataPerhitungan: TSpkTab;
    StatusBar: TStatusBar;
    SubMenuGrafikPerhitungan: TSpkTab;
    SubMenuModulTelegram: TSpkTab;
    SubMenuPengaturan: TSpkTab;
    SubMenuDataMaster: TSpkTab;
    SubMenuModulSMS: TSpkTab;
    SubMenuBantuan: TSpkTab;
    MenuUtama: TSpkToolbar;
    TimerUtama: TTimer;
    procedure BBackupDatabaseClick(Sender: TObject);
    procedure BBantuanClick(Sender: TObject);
    procedure BBotTelegramClick(Sender: TObject);
    procedure BChatMasukClick(Sender: TObject);
    procedure BChatTerkirimClick(Sender: TObject);
    procedure BChattingClick(Sender: TObject);
    procedure BDapilKabKotaClick(Sender: TObject);
    procedure BDapilProvinsiClick(Sender: TObject);
    procedure BDapilRIClick(Sender: TObject);
    procedure BDataCABUPKOTAClick(Sender: TObject);
    procedure BDataCAGUBClick(Sender: TObject);
    procedure BDataCaKadesClick(Sender: TObject);
    procedure BDataCALEGDPDClick(Sender: TObject);
    procedure BDataCALEGDPRClick(Sender: TObject);
    procedure BDataCALEGDPRDKabKotaClick(Sender: TObject);
    procedure BDataCALEGDPRDProvClick(Sender: TObject);
    procedure BDataCAPRESClick(Sender: TObject);
    procedure BDataDukunganIndependenClick(Sender: TObject);
    procedure BDataKabKotaClick(Sender: TObject);
    procedure BDataKecamatanClick(Sender: TObject);
    procedure BDataKelDesaClick(Sender: TObject);
    procedure BDataPartaiClick(Sender: TObject);
    procedure BDataPenggunaClick(Sender: TObject);
    procedure BDataPollingClick(Sender: TObject);
    procedure BDataProvClick(Sender: TObject);
    procedure BDataSaksiClick(Sender: TObject);
    procedure BDataSMSBalasanClick(Sender: TObject);
    procedure BDataTimsesRelawanClick(Sender: TObject);
    procedure BDataTPSClick(Sender: TObject);
    procedure BDataUsulanTimsesRelawanClick(Sender: TObject);
    procedure BDataUsulSaranClick(Sender: TObject);
    procedure BGrafikCABUPKOTAClick(Sender: TObject);
    procedure BGrafikCAGUBClick(Sender: TObject);
    procedure BGrafikCALEGDPDClick(Sender: TObject);
    procedure BGrafikCalegDPRClick(Sender: TObject);
    procedure BGrafikCalegDPRDKabKotaClick(Sender: TObject);
    procedure BGrafikCalegDPRDProvClick(Sender: TObject);
    procedure BGrafikCapresClick(Sender: TObject);
    procedure BGrafikKadesClick(Sender: TObject);
    procedure BGrafikPartaiClick(Sender: TObject);
    procedure BGRafikPetaClick(Sender: TObject);
    procedure BHitungSainteClick(Sender: TObject);
    procedure BIdentitasLembagaClick(Sender: TObject);
    procedure BKirimSMSClick(Sender: TObject);
    procedure BModem1Click(Sender: TObject);
    procedure BModem2Click(Sender: TObject);
    procedure BModem3Click(Sender: TObject);
    procedure BModem4Click(Sender: TObject);
    procedure BModem5Click(Sender: TObject);
    procedure BModem6Click(Sender: TObject);
    procedure BModem7Click(Sender: TObject);
    procedure BModem8Click(Sender: TObject);
    procedure BPemilihClick(Sender: TObject);
    procedure BPengaturanAplikasiClick(Sender: TObject);
    procedure BPerhitunganCABUPKOTAClick(Sender: TObject);
    procedure BPerhitunganCAGUBClick(Sender: TObject);
    procedure BPerhitunganCALEGDPDClick(Sender: TObject);
    procedure BPerhitunganCALEGDPRClick(Sender: TObject);
    procedure BPerhitunganCALEGDPRDKabKotaClick(Sender: TObject);
    procedure BPerhitunganCALEGDPRDProvClick(Sender: TObject);
    procedure BPerhitunganCAPRESClick(Sender: TObject);
    procedure BPerhitunganKadesClick(Sender: TObject);
    procedure BPerhitunganPartaiClick(Sender: TObject);
    procedure BPerkiraanClick(Sender: TObject);
    procedure BRegisterClick(Sender: TObject);
    procedure BResetDBClick(Sender: TObject);
    procedure BRestoreDatabaseClick(Sender: TObject);
    procedure BSMSChatAutoRespondClick(Sender: TObject);
    procedure BSMSMasukClick(Sender: TObject);
    procedure BSMSTerkirimClick(Sender: TObject);
    procedure BtDataDapilClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ImgProfileClick(Sender: TObject);
    procedure PNCClick(Sender: TObject);
    procedure SetStatusBar;
    procedure TimerUtamaTimer(Sender: TObject);
    procedure UkuranForm;
    procedure TutupForm;

  private
    { private declarations }
  public
    { public declarations }
  function getNamaStatusModem(id:string):string;
  function getStatusModem(id:string):string;
  function getStatusBot(id:string):string;
  function getNamaStatusBot(id:string):string;
  procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
  function SaveGrafik(AFileName, titel, namaimage, sah, tidaksah, tps, masuk, pemilih, persen: string): Boolean;
  procedure Identitas;
  end;

var
  FUtama: TFUtama;
  fpartai : TFPartai;
  fprov : TFProvinsi;
  fkabkota : TFKabupatenKota;
  fkec : TFKecamatan;
  fkeldes : TFKelurahanDesa;
  ftps : TFTps;
  fcapres : TFCapres;
  fcagub : TFCagub;
  fcabupkota : TFCabupKota;
  fcalegkab : TFCalegKabKota;
  fcalegprov : TFCalegDPRDProv;
  fcalegdpd  : TFCalegDPDRI;
  fcalegdpr : TFCalegDPRRI;
  fdapilri : TFDapilRI;
  fdapilprov : TFDapilProvinsi;
  fdapilkabkota : TFDapilKabKota;
  ftimses : TFTIMSES;
  fsaksi : TFSaksi;
  fusultimses : TFUsulanTIMSES;
  fdukungindie : TFDukunganIndependen;
  fpolling : TFPolling;
  fusulsaran : TFUsulSaran;
  fhcapres : TFHitungCapres;
  fhcagub : TFHitungCagub;
  fhcabup : TFHitungCabupKota;
  fhpartai : TFHitungPartai;
  fhdpd : TFHitungDPDRI;
  fhdpr : TFHitungDPRRI;
  fhdprdprov : TFHitungDPRDProv;
  fhdprdkab : TFHitungDPRDKabKota;
  fdapil : TFDataDAPIL;
  fgcapres : TFGrafikCapres;
  fgcagub : TFGrafikCagub;
  fgcabup : TFGrafikCabupKota;
  fgpartai : TFGrafikPartai;
  fgdpdri  : TFGrafikDPDRI;
  fgdprri : TFGrafikDPRRI;
  fgdprdprov : TFGrafikDPRDProv;
  fgdprdkab  : TFGrafikDPRDKabKota;
  tfsmsmasuk : TFDataSMSMasuk;
  tfsmsterkirim : TFDataSMSTerkirim;
  tfchatmasuk : TFDataChatMasuk;
  tfchatterkirim : TFDataChatTerkirim;
  tfpengguna : TFDataPengguna;
  tfformat   : TFDataFormatSMSChat;
  Flags: Windows.DWORD; // flags to pass to API function
  fdsmsb     : TFDataSMSBalasan;
  fgkades    : TFGrafikKades;
  fhkades    : TFHitungKades;
  fckades    : TFCalonKades;
  fpeta      : TFPetaSuara;
  fdpt       : TFDataDPT;
  fgpeta     : TFGrafikPeta;

implementation

{$R *.lfm}

{ TFUtama }

procedure TFUtama.Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

procedure TFUtama.FormResize(Sender: TObject);
begin
  SetStatusBar;
  UkuranForm;
end;

procedure TFUtama.FormShow(Sender: TObject);
begin
  DM.ZQPengaturan.First;
  ImageBack.Picture.Clear;
  if FileExists(ExtractFilePath(Application.ExeName)+DM.ZQPengaturan.FieldByName('background').AsString) then
  ImageBack.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+DM.ZQPengaturan.FieldByName('background').AsString);
  PBLoading.Position:=100;
  Identitas;
end;

procedure TFUtama.FormWindowStateChange(Sender: TObject);
begin
   if WindowState=wsMinimized then
     begin
     TutupForm;
     ImageBack.Visible:=True;
     end;
end;

procedure TFUtama.ImgProfileClick(Sender: TObject);
begin
  if (cekSerial()=True) then
     begin
  if OPD.Execute then
  begin
       if not (OPD.FileName='') then
       begin
       // Copy File
       ImgProfile.Picture.Clear;
       if FileExists(ExtractFilePath(Application.ExeName)+'img\'+ExtractFileName(OPD.FileName)) then DeleteFile(PChar(ExtractFilePath(Application.ExeName)+'img\'+ExtractFileName(OPD.FileName)));
       FileUtil.CopyFile(OPD.FileName,ExtractFilePath(Application.ExeName)+'img\'+ExtractFileName(OPD.FileName));
       if FileExists(ExtractFilePath(Application.ExeName)+'img\'+DM.ZQCalegInfo.FieldByName('foto').AsString) then DeleteFile(PChar(ExtractFilePath(Application.ExeName)+'img\'+DM.ZQCalegInfo.FieldByName('foto').AsString));
       RenameFile(ExtractFilePath(Application.ExeName)+'img\'+ExtractFileName(OPD.FileName),ExtractFilePath(Application.ExeName)+'img\fotocaleg'+ExtractFileExt(FUtama.OPD.FileName));
       with DM.ZQCalegInfo do
       begin
         Close;
         SQL.Clear;
         SQL.Text:='update t_caleginfo set foto="'+'fotocaleg'+ExtractFileExt(OPD.FileName)+'" where id="1"';
         ExecSQL;
         SQL.Clear;
         SQL.Text:='select * from t_caleginfo where id="1"';
         Open;
       end;
       Identitas;
       end;
  end;
     end else MessageDlg('Fitur Ini Tidak Bisa Digunakan Karena Software Belum Diaktivasi!',mtWarning,[mbok],0);
end;

procedure TFUtama.PNCClick(Sender: TObject);
var
  UserString: string;
begin
if (cekSerial()=True) then
     begin
  DM.ZQCalegInfo.First;
  UserString := InputBox('Identitas Pengguna','Nama Pengguna',DM.ZQCalegInfo.FieldByName('nama').AsString);
  If not (UserString='') then
  begin
  with DM.ZQCalegInfo do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='update t_caleginfo set nama="'+UserString+'" where id="1"';
   ExecSQL;
   SQL.Clear;
   SQL.Text:='select * from t_caleginfo where id="1"';
   Open;
  end;
  Identitas;
  end;
  end else MessageDlg('Fitur Ini Tidak Bisa Digunakan Karena Software Belum Diaktivasi!',mtWarning,[mbok],0);
end;

procedure TFUtama.SetStatusBar;
begin
  StatusBar.Panels.Items[0].Width:=FUtama.Width div 4;
  StatusBar.Panels.Items[1].Width:=FUtama.Width div 4;
  StatusBar.Panels.Items[2].Width:=FUtama.Width div 4;
  StatusBar.Panels.Items[3].Width:=FUtama.Width div 4;
end;

procedure TFUtama.TimerUtamaTimer(Sender: TObject);
begin
  // Database Host
  StatusBar.Panels.Items[1].Text:=' Database ['+DM.KoneksiDatabase.HostName+']';
  // Judul Menu Modem dan Bot
  BModem1.Caption:=getNamaStatusModem(IntToStr(1));
  BModem2.Caption:=getNamaStatusModem(IntToStr(2));
  BModem3.Caption:=getNamaStatusModem(IntToStr(3));
  BModem4.Caption:=getNamaStatusModem(IntToStr(4));
  BModem5.Caption:=getNamaStatusModem(IntToStr(5));
  BModem6.Caption:=getNamaStatusModem(IntToStr(6));
  BModem7.Caption:=getNamaStatusModem(IntToStr(7));
  BModem8.Caption:=getNamaStatusModem(IntToStr(8));
  BBotTelegram.Caption:=getNamaStatusBot(IntToStr(1));
  // Status Modem
  StatusBar.Panels.Items[2].Text:=' Modem ['+getStatusModem(IntToStr(1))+','+
                                             getStatusModem(IntToStr(2))+','+
                                             getStatusModem(IntToStr(3))+','+
                                             getStatusModem(IntToStr(4))+','+
                                             getStatusModem(IntToStr(5))+','+
                                             getStatusModem(IntToStr(6))+','+
                                             getStatusModem(IntToStr(7))+','+
                                             getStatusModem(IntToStr(8))+']';
  // Status Bot
  StatusBar.Panels.Items[3].Text:=' Telegram Bot ['+getStatusBot(IntToStr(1))+']';
  // SMS Masuk Auto Respon
  cekSMSMasuk;
  // Chat Masuk Auto Respon
  cekChatMasuk;
end;

procedure TFUtama.UkuranForm;
begin
  // Identitas Caleg
  FUtama.PProfile.Left:=FUtama.Width-86;
  FUtama.PNC.Left:=FUtama.Width-255;
  FUtama.PQS.Left:=FUtama.Width-255;
  // Form Partai
  fpartai.ParentWindow:=PanelTengah.Handle;
  fpartai.WindowState:=wsMaximized;
  fpartai.Width:=FUtama.Width;
  fpartai.Height:=PanelTengah.Height;
  fpartai.BTutup.Left:=FUtama.Width-83;
  fpartai.GridPartai.Columns[0].Width:=100;
  fpartai.GridPartai.Columns[1].Width:=(FUtama.Width-100) div 4;
  fpartai.GridPartai.Columns[2].Width:=(FUtama.Width-100) div 4;
  fpartai.GridPartai.Columns[3].Width:=(FUtama.Width-100) div 4;
  fpartai.GridPartai.Columns[4].Width:=(FUtama.Width-100) div 4;
  fpartai.PImage.Left:=FUtama.Width-125;
  fpartai.PImage.Top:=FUtama.Height-330;
  // Form Provinsi
  fprov.ParentWindow:=PanelTengah.Handle;
  fprov.WindowState:=wsMaximized;
  fprov.Width:=FUtama.Width;
  fprov.Height:=PanelTengah.Height;
  fprov.BTutup.Left:=FUtama.Width-83;
  fprov.GridProv.Columns[0].Width:=100;
  fprov.GridProv.Columns[1].Width:=FUtama.Width-100;
  // Form Kabupaten Kota
  fkabkota.ParentWindow:=PanelTengah.Handle;
  fkabkota.WindowState:=wsMaximized;
  fkabkota.Width:=FUtama.Width;
  fkabkota.Height:=PanelTengah.Height;
  fkabkota.BTutup.Left:=FUtama.Width-83;
  fkabkota.GridKabKota.Columns[0].Width:=100;
  fkabkota.GridKabKota.Columns[1].Width:=(FUtama.Width-100) div 2;
  fkabkota.GridKabKota.Columns[2].Width:=(FUtama.Width-100) div 2;
  // Form Kecamatan
  fkec.ParentWindow:=PanelTengah.Handle;
  fkec.WindowState:=wsMaximized;
  fkec.Width:=FUtama.Width;
  fkec.Height:=PanelTengah.Height;
  fkec.BTutup.Left:=FUtama.Width-83;
  fkec.GridKec.Columns[0].Width:=100;
  fkec.GridKec.Columns[1].Width:=(FUtama.Width-100) div 3;
  fkec.GridKec.Columns[2].Width:=(FUtama.Width-100) div 3;
  fkec.GridKec.Columns[3].Width:=(FUtama.Width-100) div 3;
  // Form Kelurahan Desa
  fkeldes.ParentWindow:=PanelTengah.Handle;
  fkeldes.WindowState:=wsMaximized;
  fkeldes.Width:=FUtama.Width;
  fkeldes.Height:=PanelTengah.Height;
  fkeldes.BTutup.Left:=FUtama.Width-83;
  fkeldes.GridKelDesa.Columns[0].Width:=100;
  fkeldes.GridKelDesa.Columns[1].Width:=(FUtama.Width-100) div 4;
  fkeldes.GridKelDesa.Columns[2].Width:=(FUtama.Width-100) div 4;
  fkeldes.GridKelDesa.Columns[3].Width:=(FUtama.Width-100) div 4;
  fkeldes.GridKelDesa.Columns[4].Width:=(FUtama.Width-100) div 4;
  // Form TPS
  ftps.ParentWindow:=PanelTengah.Handle;
  ftps.WindowState:=wsMaximized;
  ftps.Width:=FUtama.Width;
  ftps.Height:=PanelTengah.Height;
  ftps.BTutup.Left:=FUtama.Width-83;
  ftps.GridTPS.Columns[0].Width:=100;
  ftps.GridTPS.Columns[1].Width:=(FUtama.Width-100) div 5;
  ftps.GridTPS.Columns[2].Width:=(FUtama.Width-100) div 5;
  ftps.GridTPS.Columns[3].Width:=(FUtama.Width-100) div 5;
  ftps.GridTPS.Columns[4].Width:=(FUtama.Width-100) div 5;
  ftps.GridTPS.Columns[5].Width:=(FUtama.Width-100) div 5;
  // Form DPT
  fdpt.ParentWindow:=PanelTengah.Handle;
  fdpt.WindowState:=wsMaximized;
  fdpt.Width:=FUtama.Width;
  fdpt.Height:=PanelTengah.Height;
  fdpt.BTutup.Left:=FUtama.Width-83;
  fdpt.GridDPT.Columns[0].Width:=100;
  fdpt.GridDPT.Columns[1].Width:=(FUtama.Width-100) div 7;
  fdpt.GridDPT.Columns[2].Width:=(FUtama.Width-100) div 7;
  fdpt.GridDPT.Columns[3].Width:=(FUtama.Width-100) div 7;
  fdpt.GridDPT.Columns[4].Width:=(FUtama.Width-100) div 7;
  fdpt.GridDPT.Columns[5].Width:=(FUtama.Width-100) div 7;
  fdpt.GridDPT.Columns[6].Width:=(FUtama.Width-100) div 7;
  fdpt.GridDPT.Columns[7].Width:=(FUtama.Width-100) div 7;
  // Form Capres
  fcapres.ParentWindow:=PanelTengah.Handle;
  fcapres.WindowState:=wsMaximized;
  fcapres.Width:=FUtama.Width;
  fcapres.Height:=PanelTengah.Height;
  fcapres.BTutup.Left:=FUtama.Width-83;
  fcapres.PImage.Left:=FUtama.Width-125;
  fcapres.PImage.Top:=FUtama.Height-330;
  fcapres.GridCapres.Columns[0].Width:=100;
  fcapres.GridCapres.Columns[1].Width:=(FUtama.Width-100) div 5;
  fcapres.GridCapres.Columns[2].Width:=(FUtama.Width-100) div 5;
  fcapres.GridCapres.Columns[3].Width:=(FUtama.Width-100) div 5;
  fcapres.GridCapres.Columns[4].Width:=(FUtama.Width-100) div 5;
  fcapres.GridCapres.Columns[5].Width:=(FUtama.Width-100) div 5;
  // Form Calon Kades
  fckades.ParentWindow:=PanelTengah.Handle;
  fckades.WindowState:=wsMaximized;
  fckades.Width:=FUtama.Width;
  fckades.Height:=PanelTengah.Height;
  fckades.BTutup.Left:=FUtama.Width-83;
  fckades.GridCalonKades.Columns[0].Width:=FUtama.Width div 5;
  fckades.GridCalonKades.Columns[1].Width:=FUtama.Width div 5;
  fckades.GridCalonKades.Columns[2].Width:=FUtama.Width div 5;
  fckades.GridCalonKades.Columns[3].Width:=FUtama.Width div 5;
  fckades.GridCalonKades.Columns[4].Width:=FUtama.Width div 5;
  fckades.PImage.Left:=FUtama.Width-125;
  fckades.PImage.Top:=FUtama.Height-330;
  // Form Cagub
  fcagub.ParentWindow:=PanelTengah.Handle;
  fcagub.WindowState:=wsMaximized;
  fcagub.Width:=FUtama.Width;
  fcagub.Height:=PanelTengah.Height;
  fcagub.BTutup.Left:=FUtama.Width-83;
  fcagub.PImage.Left:=FUtama.Width-125;
  fcagub.PImage.Top:=FUtama.Height-330;
  fcagub.GridCagub.Columns[0].Width:=100;
  fcagub.GridCagub.Columns[1].Width:=(FUtama.Width-100) div 6;
  fcagub.GridCagub.Columns[2].Width:=(FUtama.Width-100) div 6;
  fcagub.GridCagub.Columns[3].Width:=(FUtama.Width-100) div 6;
  fcagub.GridCagub.Columns[4].Width:=(FUtama.Width-100) div 6;
  fcagub.GridCagub.Columns[5].Width:=(FUtama.Width-100) div 6;
  fcagub.GridCagub.Columns[6].Width:=(FUtama.Width-100) div 6;
  // Form CabupKota
  fcabupkota.ParentWindow:=PanelTengah.Handle;
  fcabupkota.WindowState:=wsMaximized;
  fcabupkota.Width:=FUtama.Width;
  fcabupkota.Height:=PanelTengah.Height;
  fcabupkota.BTutup.Left:=FUtama.Width-83;
  fcabupkota.PImage.Left:=FUtama.Width-125;
  fcabupkota.PImage.Top:=FUtama.Height-330;
  fcabupkota.GridCabupKota.Columns[0].Width:=100;
  fcabupkota.GridCabupKota.Columns[1].Width:=(FUtama.Width-100) div 6;
  fcabupkota.GridCabupKota.Columns[2].Width:=(FUtama.Width-100) div 6;
  fcabupkota.GridCabupKota.Columns[3].Width:=(FUtama.Width-100) div 6;
  fcabupkota.GridCabupKota.Columns[4].Width:=(FUtama.Width-100) div 6;
  fcabupkota.GridCabupKota.Columns[5].Width:=(FUtama.Width-100) div 6;
  fcabupkota.GridCabupKota.Columns[6].Width:=(FUtama.Width-100) div 6;
  // Form Dapil
  fdapil.ParentWindow:=PanelTengah.Handle;
  fdapil.WindowState:=wsMaximized;
  fdapil.Width:=FUtama.Width;
  fdapil.Height:=PanelTengah.Height;
  fdapil.BTutup.Left:=FUtama.Width-83;
  fdapil.GridDAPIL.Columns[0].Width:=100;
  fdapil.GridDAPIL.Columns[1].Width:=(FUtama.Width-100) div 2;
  fdapil.GridDAPIL.Columns[2].Width:=(FUtama.Width-100) div 2;
  // Form Dapil RI
  fdapilri.ParentWindow:=PanelTengah.Handle;
  fdapilri.WindowState:=wsMaximized;
  fdapilri.Width:=FUtama.Width;
  fdapilri.Height:=PanelTengah.Height;
  fdapilri.BTutup.Left:=FUtama.Width-83;
  fdapilri.TreeDapil.Header.Columns[0].Width:=50;
  fdapilri.TreeDapil.Header.Columns[1].Width:=FUtama.Width-50;
  // Form Dapil Provinsi
  fdapilprov.ParentWindow:=PanelTengah.Handle;
  fdapilprov.WindowState:=wsMaximized;
  fdapilprov.Width:=FUtama.Width;
  fdapilprov.Height:=PanelTengah.Height;
  fdapilprov.BTutup.Left:=FUtama.Width-83;
  fdapilprov.TreeDapil.Header.Columns[0].Width:=50;
  fdapilprov.TreeDapil.Header.Columns[1].Width:=FUtama.Width-50;
  // Form Dapil Kab Kota
  fdapilkabkota.ParentWindow:=PanelTengah.Handle;
  fdapilkabkota.WindowState:=wsMaximized;
  fdapilkabkota.Width:=FUtama.Width;
  fdapilkabkota.Height:=PanelTengah.Height;
  fdapilkabkota.BTutup.Left:=FUtama.Width-83;
  fdapilkabkota.TreeDapil.Header.Columns[0].Width:=50;
  fdapilkabkota.TreeDapil.Header.Columns[1].Width:=FUtama.Width-50;
  // Form Caleg DPD RI
  fcalegdpd.ParentWindow:=PanelTengah.Handle;
  fcalegdpd.WindowState:=wsMaximized;
  fcalegdpd.Width:=FUtama.Width;
  fcalegdpd.Height:=PanelTengah.Height;
  fcalegdpd.BTutup.Left:=FUtama.Width-83;
  fcalegdpd.PImage.Left:=FUtama.Width-125;
  fcalegdpd.PImage.Top:=FUtama.Height-330;
  fcalegdpd.GridCaleg.Columns[0].Width:=100;
  fcalegdpd.GridCaleg.Columns[1].Width:=(FUtama.Width-100) div 4;
  fcalegdpd.GridCaleg.Columns[2].Width:=(FUtama.Width-100) div 4;
  fcalegdpd.GridCaleg.Columns[3].Width:=(FUtama.Width-100) div 4;
  fcalegdpd.GridCaleg.Columns[4].Width:=(FUtama.Width-100) div 4;
  // Form Caleg DPR RI
  fcalegdpr.ParentWindow:=PanelTengah.Handle;
  fcalegdpr.WindowState:=wsMaximized;
  fcalegdpr.Width:=FUtama.Width;
  fcalegdpr.Height:=PanelTengah.Height;
  fcalegdpr.BTutup.Left:=FUtama.Width-83;
  fcalegdpr.PImage.Left:=FUtama.Width-125;
  fcalegdpr.PImage.Top:=FUtama.Height-330;
  fcalegdpr.GridCaleg.Columns[0].Width:=100;
  fcalegdpr.GridCaleg.Columns[1].Width:=(FUtama.Width-100) div 6;
  fcalegdpr.GridCaleg.Columns[2].Width:=(FUtama.Width-100) div 6;
  fcalegdpr.GridCaleg.Columns[3].Width:=(FUtama.Width-100) div 6;
  fcalegdpr.GridCaleg.Columns[4].Width:=(FUtama.Width-100) div 6;
  fcalegdpr.GridCaleg.Columns[5].Width:=(FUtama.Width-100) div 6;
  fcalegdpr.GridCaleg.Columns[6].Width:=(FUtama.Width-100) div 6;
  // Form Caleg DPRD Prov
  fcalegprov.ParentWindow:=PanelTengah.Handle;
  fcalegprov.WindowState:=wsMaximized;
  fcalegprov.Width:=FUtama.Width;
  fcalegprov.Height:=PanelTengah.Height;
  fcalegprov.BTutup.Left:=FUtama.Width-83;
  fcalegprov.PImage.Left:=FUtama.Width-125;
  fcalegprov.PImage.Top:=FUtama.Height-330;
  fcalegprov.GridCaleg.Columns[0].Width:=100;
  fcalegprov.GridCaleg.Columns[1].Width:=(FUtama.Width-100) div 7;
  fcalegprov.GridCaleg.Columns[2].Width:=(FUtama.Width-100) div 7;
  fcalegprov.GridCaleg.Columns[3].Width:=(FUtama.Width-100) div 7;
  fcalegprov.GridCaleg.Columns[4].Width:=(FUtama.Width-100) div 7;
  fcalegprov.GridCaleg.Columns[5].Width:=(FUtama.Width-100) div 7;
  fcalegprov.GridCaleg.Columns[6].Width:=(FUtama.Width-100) div 7;
  fcalegprov.GridCaleg.Columns[7].Width:=(FUtama.Width-100) div 7;
  // Form Caleg DPRD Kab Kota
  fcalegkab.ParentWindow:=PanelTengah.Handle;
  fcalegkab.WindowState:=wsMaximized;
  fcalegkab.Width:=FUtama.Width;
  fcalegkab.Height:=PanelTengah.Height;
  fcalegkab.BTutup.Left:=FUtama.Width-83;
  fcalegkab.PImage.Left:=FUtama.Width-125;
  fcalegkab.PImage.Top:=FUtama.Height-330;
  fcalegkab.GridCaleg.Columns[0].Width:=100;
  fcalegkab.GridCaleg.Columns[1].Width:=(FUtama.Width-100) div 7;
  fcalegkab.GridCaleg.Columns[2].Width:=(FUtama.Width-100) div 7;
  fcalegkab.GridCaleg.Columns[3].Width:=(FUtama.Width-100) div 7;
  fcalegkab.GridCaleg.Columns[4].Width:=(FUtama.Width-100) div 7;
  fcalegkab.GridCaleg.Columns[5].Width:=(FUtama.Width-100) div 7;
  fcalegkab.GridCaleg.Columns[6].Width:=(FUtama.Width-100) div 7;
  fcalegkab.GridCaleg.Columns[7].Width:=(FUtama.Width-100) div 7;
  // Form TIMSES
  ftimses.ParentWindow:=PanelTengah.Handle;
  ftimses.WindowState:=wsMaximized;
  ftimses.Width:=FUtama.Width;
  ftimses.Height:=PanelTengah.Height;
  ftimses.BTutup.Left:=FUtama.Width-83;
  ftimses.GridTimses.Columns[0].Width:=100;
  ftimses.GridTimses.Columns[1].Width:=(FUtama.Width-100) div 4;
  ftimses.GridTimses.Columns[2].Width:=(FUtama.Width-100) div 4;
  ftimses.GridTimses.Columns[3].Width:=(FUtama.Width-100) div 4;
  ftimses.GridTimses.Columns[4].Width:=(FUtama.Width-100) div 4;
  // Form Saksi
  fsaksi.ParentWindow:=PanelTengah.Handle;
  fsaksi.WindowState:=wsMaximized;
  fsaksi.Width:=FUtama.Width;
  fsaksi.Height:=PanelTengah.Height;
  fsaksi.BTutup.Left:=FUtama.Width-83;
  fsaksi.GridSaksi.Columns[0].Width:=100;
  fsaksi.GridSaksi.Columns[1].Width:=(FUtama.Width-100) div 5;
  fsaksi.GridSaksi.Columns[2].Width:=(FUtama.Width-100) div 5;
  fsaksi.GridSaksi.Columns[3].Width:=(FUtama.Width-100) div 5;
  fsaksi.GridSaksi.Columns[4].Width:=(FUtama.Width-100) div 5;
  fsaksi.GridSaksi.Columns[5].Width:=(FUtama.Width-100) div 5;
  // Form Usulsan TIMSES
  fusultimses.ParentWindow:=PanelTengah.Handle;
  fusultimses.WindowState:=wsMaximized;
  fusultimses.Width:=FUtama.Width;
  fusultimses.Height:=PanelTengah.Height;
  fusultimses.BTutup.Left:=FUtama.Width-83;
  fusultimses.GridUsulanRelawan.Columns[0].Width:=100;
  fusultimses.GridUsulanRelawan.Columns[1].Width:=(FUtama.Width-100) div 4;
  fusultimses.GridUsulanRelawan.Columns[2].Width:=(FUtama.Width-100) div 4;
  fusultimses.GridUsulanRelawan.Columns[3].Width:=(FUtama.Width-100) div 4;
  fusultimses.GridUsulanRelawan.Columns[4].Width:=(FUtama.Width-100) div 4;
  // Form Dukungan Independen
  fdukungindie.ParentWindow:=PanelTengah.Handle;
  fdukungindie.WindowState:=wsMaximized;
  fdukungindie.Width:=FUtama.Width;
  fdukungindie.Height:=PanelTengah.Height;
  fdukungindie.BTutup.Left:=FUtama.Width-83;
  fdukungindie.GridDukunganIndie.Columns[0].Width:=100;
  fdukungindie.GridDukunganIndie.Columns[1].Width:=(FUtama.Width-100) div 5;
  fdukungindie.GridDukunganIndie.Columns[2].Width:=(FUtama.Width-100) div 5;
  fdukungindie.GridDukunganIndie.Columns[3].Width:=(FUtama.Width-100) div 5;
  fdukungindie.GridDukunganIndie.Columns[4].Width:=(FUtama.Width-100) div 5;
  fdukungindie.GridDukunganIndie.Columns[5].Width:=(FUtama.Width-100) div 5;
  // Form Polling
  fpolling.ParentWindow:=PanelTengah.Handle;
  fpolling.WindowState:=wsMaximized;
  fpolling.Width:=FUtama.Width;
  fpolling.Height:=PanelTengah.Height;
  fpolling.BTutup.Left:=FUtama.Width-83;
  fpolling.GridPolling.Columns[0].Width:=100;
  fpolling.GridPolling.Columns[1].Width:=(FUtama.Width-100) div 5;
  fpolling.GridPolling.Columns[2].Width:=(FUtama.Width-100) div 5;
  fpolling.GridPolling.Columns[3].Width:=(FUtama.Width-100) div 5;
  fpolling.GridPolling.Columns[4].Width:=(FUtama.Width-100) div 5;
  fpolling.GridPolling.Columns[5].Width:=(FUtama.Width-100) div 5;
  // Form Usul Saran
  fusulsaran.ParentWindow:=PanelTengah.Handle;
  fusulsaran.WindowState:=wsMaximized;
  fusulsaran.Width:=FUtama.Width;
  fusulsaran.Height:=PanelTengah.Height;
  fusulsaran.BTutup.Left:=FUtama.Width-83;
  fusulsaran.GridUsulSaran.Columns[0].Width:=100;
  fusulsaran.GridUsulSaran.Columns[1].Width:=(FUtama.Width-100) div 6;
  fusulsaran.GridUsulSaran.Columns[2].Width:=(FUtama.Width-100) div 6;
  fusulsaran.GridUsulSaran.Columns[3].Width:=(FUtama.Width-100) div 6;
  fusulsaran.GridUsulSaran.Columns[4].Width:=(FUtama.Width-100) div 6;
  fusulsaran.GridUsulSaran.Columns[5].Width:=(FUtama.Width-100) div 6;
  fusulsaran.GridUsulSaran.Columns[6].Width:=(FUtama.Width-100) div 6;
  // Form Hitung Capres
  fhcapres.ParentWindow:=PanelTengah.Handle;
  fhcapres.WindowState:=wsMaximized;
  fhcapres.Width:=FUtama.Width;
  fhcapres.Height:=PanelTengah.Height;
  fhcapres.BTutup.Left:=FUtama.Width-83;
  fhcapres.GridHitungCapres.Columns[0].Width:=50;
  fhcapres.GridHitungCapres.Columns[1].Width:=(FUtama.Width-50) div 10;
  fhcapres.GridHitungCapres.Columns[2].Width:=(FUtama.Width-50) div 10;
  fhcapres.GridHitungCapres.Columns[3].Width:=(FUtama.Width-50) div 10;
  fhcapres.GridHitungCapres.Columns[4].Width:=(FUtama.Width-50) div 10;
  fhcapres.GridHitungCapres.Columns[5].Width:=(FUtama.Width-50) div 10;
  fhcapres.GridHitungCapres.Columns[6].Width:=(FUtama.Width-50) div 10;
  fhcapres.GridHitungCapres.Columns[7].Width:=(FUtama.Width-50) div 10;
  fhcapres.GridHitungCapres.Columns[8].Width:=(FUtama.Width-50) div 10;
  fhcapres.GridHitungCapres.Columns[9].Width:=(FUtama.Width-50) div 10;
  fhcapres.GridHitungCapres.Columns[10].Width:=(FUtama.Width-50) div 10;
  // Form Hitung Cagub
  fhcagub.ParentWindow:=PanelTengah.Handle;
  fhcagub.WindowState:=wsMaximized;
  fhcagub.Width:=FUtama.Width;
  fhcagub.Height:=PanelTengah.Height;
  fhcagub.BTutup.Left:=FUtama.Width-83;
  fhcagub.GridHitungCagub.Columns[0].Width:=50;
  fhcagub.GridHitungCagub.Columns[1].Width:=(FUtama.Width-50) div 10;
  fhcagub.GridHitungCagub.Columns[2].Width:=(FUtama.Width-50) div 10;
  fhcagub.GridHitungCagub.Columns[3].Width:=(FUtama.Width-50) div 10;
  fhcagub.GridHitungCagub.Columns[4].Width:=(FUtama.Width-50) div 10;
  fhcagub.GridHitungCagub.Columns[5].Width:=(FUtama.Width-50) div 10;
  fhcagub.GridHitungCagub.Columns[6].Width:=(FUtama.Width-50) div 10;
  fhcagub.GridHitungCagub.Columns[7].Width:=(FUtama.Width-50) div 10;
  fhcagub.GridHitungCagub.Columns[8].Width:=(FUtama.Width-50) div 10;
  fhcagub.GridHitungCagub.Columns[9].Width:=(FUtama.Width-50) div 10;
  fhcagub.GridHitungCagub.Columns[10].Width:=(FUtama.Width-50) div 10;
  // Form Hitung Calon Kades
  fhkades.ParentWindow:=PanelTengah.Handle;
  fhkades.WindowState:=wsMaximized;
  fhkades.Width:=FUtama.Width;
  fhkades.Height:=PanelTengah.Height;
  fhkades.BTutup.Left:=FUtama.Width-83;
  fhkades.GridHitungKades.Columns[0].Width:=50;
  fhkades.GridHitungKades.Columns[1].Width:=(FUtama.Width-50) div 10;
  fhkades.GridHitungKades.Columns[2].Width:=(FUtama.Width-50) div 10;
  fhkades.GridHitungKades.Columns[3].Width:=(FUtama.Width-50) div 10;
  fhkades.GridHitungKades.Columns[4].Width:=(FUtama.Width-50) div 10;
  fhkades.GridHitungKades.Columns[5].Width:=(FUtama.Width-50) div 10;
  fhkades.GridHitungKades.Columns[6].Width:=(FUtama.Width-50) div 10;
  fhkades.GridHitungKades.Columns[7].Width:=(FUtama.Width-50) div 10;
  fhkades.GridHitungKades.Columns[8].Width:=(FUtama.Width-50) div 10;
  fhkades.GridHitungKades.Columns[9].Width:=(FUtama.Width-50) div 10;
  fhkades.GridHitungKades.Columns[10].Width:=(FUtama.Width-50) div 10;
  // Form Peta Suara
  fpeta.ParentWindow:=PanelTengah.Handle;
  fpeta.WindowState:=wsMaximized;
  fpeta.Width:=FUtama.Width;
  fpeta.Height:=PanelTengah.Height;
  fpeta.BTutup.Left:=FUtama.Width-83;
  fpeta.GridPeta.Columns[0].Width:=50;
  fpeta.GridPeta.Columns[1].Width:=(FUtama.Width-50) div 9;
  fpeta.GridPeta.Columns[2].Width:=(FUtama.Width-50) div 9;
  fpeta.GridPeta.Columns[3].Width:=(FUtama.Width-50) div 9;
  fpeta.GridPeta.Columns[4].Width:=(FUtama.Width-50) div 9;
  fpeta.GridPeta.Columns[5].Width:=(FUtama.Width-50) div 9;
  fpeta.GridPeta.Columns[6].Width:=(FUtama.Width-50) div 9;
  fpeta.GridPeta.Columns[7].Width:=(FUtama.Width-50) div 9;
  fpeta.GridPeta.Columns[8].Width:=(FUtama.Width-50) div 9;
  fpeta.GridPeta.Columns[9].Width:=(FUtama.Width-50) div 9;
  // Form Hitung Cabup/Kota
  fhcabup.ParentWindow:=PanelTengah.Handle;
  fhcabup.WindowState:=wsMaximized;
  fhcabup.Width:=FUtama.Width;
  fhcabup.Height:=PanelTengah.Height;
  fhcabup.BTutup.Left:=FUtama.Width-83;
  fhcabup.GridHitungCabup.Columns[0].Width:=50;
  fhcabup.GridHitungCabup.Columns[1].Width:=(FUtama.Width-50) div 10;
  fhcabup.GridHitungCabup.Columns[2].Width:=(FUtama.Width-50) div 10;
  fhcabup.GridHitungCabup.Columns[3].Width:=(FUtama.Width-50) div 10;
  fhcabup.GridHitungCabup.Columns[4].Width:=(FUtama.Width-50) div 10;
  fhcabup.GridHitungCabup.Columns[5].Width:=(FUtama.Width-50) div 10;
  fhcabup.GridHitungCabup.Columns[6].Width:=(FUtama.Width-50) div 10;
  fhcabup.GridHitungCabup.Columns[7].Width:=(FUtama.Width-50) div 10;
  fhcabup.GridHitungCabup.Columns[8].Width:=(FUtama.Width-50) div 10;
  fhcabup.GridHitungCabup.Columns[9].Width:=(FUtama.Width-50) div 10;
  fhcabup.GridHitungCabup.Columns[10].Width:=(FUtama.Width-50) div 10;
  // Form Hitung Partai
  fhpartai.ParentWindow:=PanelTengah.Handle;
  fhpartai.WindowState:=wsMaximized;
  fhpartai.Width:=FUtama.Width;
  fhpartai.Height:=PanelTengah.Height;
  fhpartai.BTutup.Left:=FUtama.Width-83;
  fhpartai.GridHitungPartai.Columns[0].Width:=50;
  fhpartai.GridHitungPartai.Columns[1].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[2].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[3].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[4].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[5].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[6].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[7].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[8].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[9].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[10].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[11].Width:=(FUtama.Width-50) div 12;
  fhpartai.GridHitungPartai.Columns[12].Width:=(FUtama.Width-50) div 12;
  // Form Hitung DPD RI
  fhdpd.ParentWindow:=PanelTengah.Handle;
  fhdpd.WindowState:=wsMaximized;
  fhdpd.Width:=FUtama.Width;
  fhdpd.Height:=PanelTengah.Height;
  fhdpd.BTutup.Left:=FUtama.Width-83;
  fhdpd.GridHitungDPD.Columns[0].Width:=50;
  fhdpd.GridHitungDPD.Columns[1].Width:=(FUtama.Width-50) div 10;
  fhdpd.GridHitungDPD.Columns[2].Width:=(FUtama.Width-50) div 10;
  fhdpd.GridHitungDPD.Columns[3].Width:=(FUtama.Width-50) div 10;
  fhdpd.GridHitungDPD.Columns[4].Width:=(FUtama.Width-50) div 10;
  fhdpd.GridHitungDPD.Columns[5].Width:=(FUtama.Width-50) div 10;
  fhdpd.GridHitungDPD.Columns[6].Width:=(FUtama.Width-50) div 10;
  fhdpd.GridHitungDPD.Columns[7].Width:=(FUtama.Width-50) div 10;
  fhdpd.GridHitungDPD.Columns[8].Width:=(FUtama.Width-50) div 10;
  fhdpd.GridHitungDPD.Columns[9].Width:=(FUtama.Width-50) div 10;
  fhdpd.GridHitungDPD.Columns[10].Width:=(FUtama.Width-50) div 10;
  // Form Hitung DPR RI
  fhdpr.ParentWindow:=PanelTengah.Handle;
  fhdpr.WindowState:=wsMaximized;
  fhdpr.Width:=FUtama.Width;
  fhdpr.Height:=PanelTengah.Height;
  fhdpr.BTutup.Left:=FUtama.Width-83;
  fhdpr.GridHitungDPRRI.Columns[0].Width:=50;
  fhdpr.GridHitungDPRRI.Columns[1].Width:=50;
  fhdpr.GridHitungDPRRI.Columns[2].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[3].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[4].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[5].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[6].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[7].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[8].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[9].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[10].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[11].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[12].Width:=(FUtama.Width-100) div 12;
  fhdpr.GridHitungDPRRI.Columns[13].Width:=(FUtama.Width-100) div 12;
  // Form Hitung DPRD Provinsi
  fhdprdprov.ParentWindow:=PanelTengah.Handle;
  fhdprdprov.WindowState:=wsMaximized;
  fhdprdprov.Width:=FUtama.Width;
  fhdprdprov.Height:=PanelTengah.Height;
  fhdprdprov.BTutup.Left:=FUtama.Width-83;
  fhdprdprov.GridHitungDPRDProv.Columns[0].Width:=50;
  fhdprdprov.GridHitungDPRDProv.Columns[1].Width:=50;
  fhdprdprov.GridHitungDPRDProv.Columns[2].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[3].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[4].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[5].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[6].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[7].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[8].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[9].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[10].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[11].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[12].Width:=(FUtama.Width-100) div 12;
  fhdprdprov.GridHitungDPRDProv.Columns[13].Width:=(FUtama.Width-100) div 12;
  // Form Hitung DPRD Kabupaten/Kota
  fhdprdkab.ParentWindow:=PanelTengah.Handle;
  fhdprdkab.WindowState:=wsMaximized;
  fhdprdkab.Width:=FUtama.Width;
  fhdprdkab.Height:=PanelTengah.Height;
  fhdprdkab.BTutup.Left:=FUtama.Width-83;
  fhdprdkab.GridHitungDPRDKab.Columns[0].Width:=50;
  fhdprdkab.GridHitungDPRDKab.Columns[1].Width:=50;
  fhdprdkab.GridHitungDPRDKab.Columns[2].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[3].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[4].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[5].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[6].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[7].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[8].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[9].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[10].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[11].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[12].Width:=(FUtama.Width-100) div 12;
  fhdprdkab.GridHitungDPRDKab.Columns[13].Width:=(FUtama.Width-100) div 12;
  // Form Grafik Calon KADES
  fgkades.ParentWindow:=PanelTengah.Handle;
  fgkades.WindowState:=wsMaximized;
  fgkades.Width:=FUtama.Width;
  fgkades.Height:=PanelTengah.Height;
  fgkades.BTutup.Left:=FUtama.Width-83;
  // Form Grafik Calon Presiden
  fgcapres.ParentWindow:=PanelTengah.Handle;
  fgcapres.WindowState:=wsMaximized;
  fgcapres.Width:=FUtama.Width;
  fgcapres.Height:=PanelTengah.Height;
  fgcapres.BTutup.Left:=FUtama.Width-83;
  // Form Grafik Calon Gubernur
  fgcagub.ParentWindow:=PanelTengah.Handle;
  fgcagub.WindowState:=wsMaximized;
  fgcagub.Width:=FUtama.Width;
  fgcagub.Height:=PanelTengah.Height;
  fgcagub.BTutup.Left:=FUtama.Width-83;
  // Form Grafik Calon Bupati/Walikota
  fgcabup.ParentWindow:=PanelTengah.Handle;
  fgcabup.WindowState:=wsMaximized;
  fgcabup.Width:=FUtama.Width;
  fgcabup.Height:=PanelTengah.Height;
  fgcabup.BTutup.Left:=FUtama.Width-83;
  // Form Grafik Calon DPD RI
  fgdpdri.ParentWindow:=PanelTengah.Handle;
  fgdpdri.WindowState:=wsMaximized;
  fgdpdri.Width:=FUtama.Width;
  fgdpdri.Height:=PanelTengah.Height;
  fgdpdri.BTutup.Left:=FUtama.Width-83;
  // Form Grafik Calon DPR RI
  fgdprri.ParentWindow:=PanelTengah.Handle;
  fgdprri.WindowState:=wsMaximized;
  fgdprri.Width:=FUtama.Width;
  fgdprri.Height:=PanelTengah.Height;
  fgdprri.BTutup.Left:=FUtama.Width-83;
  // Form Grafik Calon DPRD Prov
  fgdprdprov.ParentWindow:=PanelTengah.Handle;
  fgdprdprov.WindowState:=wsMaximized;
  fgdprdprov.Width:=FUtama.Width;
  fgdprdprov.Height:=PanelTengah.Height;
  fgdprdprov.BTutup.Left:=FUtama.Width-83;
  // Form Grafik Calon DPRD Kab/kota
  fgdprdkab.ParentWindow:=PanelTengah.Handle;
  fgdprdkab.WindowState:=wsMaximized;
  fgdprdkab.Width:=FUtama.Width;
  fgdprdkab.Height:=PanelTengah.Height;
  fgdprdkab.BTutup.Left:=FUtama.Width-83;
  // Form Grafik Partai
  fgpartai.ParentWindow:=PanelTengah.Handle;
  fgpartai.WindowState:=wsMaximized;
  fgpartai.Width:=FUtama.Width;
  fgpartai.Height:=PanelTengah.Height;
  fgpartai.BTutup.Left:=FUtama.Width-83;
  // Form SMS Masuk
  tfsmsmasuk.ParentWindow:=PanelTengah.Handle;
  tfsmsmasuk.WindowState:=wsMaximized;
  tfsmsmasuk.Width:=FUtama.Width;
  tfsmsmasuk.Height:=PanelTengah.Height;
  tfsmsmasuk.BTutup.Left:=FUtama.Width-83;
  tfsmsmasuk.GridSMSMasuk.Columns[0].Width:=FUtama.Width div 7;
  tfsmsmasuk.GridSMSMasuk.Columns[1].Width:=FUtama.Width div 7;
  tfsmsmasuk.GridSMSMasuk.Columns[2].Width:=FUtama.Width div 7;
  tfsmsmasuk.GridSMSMasuk.Columns[3].Width:=FUtama.Width div 7;
  tfsmsmasuk.GridSMSMasuk.Columns[4].Width:=FUtama.Width div 7;
  tfsmsmasuk.GridSMSMasuk.Columns[5].Width:=FUtama.Width div 7;
  tfsmsmasuk.GridSMSMasuk.Columns[6].Width:=FUtama.Width div 7;
  // Form SMS Terkirim
  tfsmsterkirim.ParentWindow:=PanelTengah.Handle;
  tfsmsterkirim.WindowState:=wsMaximized;
  tfsmsterkirim.Width:=FUtama.Width;
  tfsmsterkirim.Height:=PanelTengah.Height;
  tfsmsterkirim.BTutup.Left:=FUtama.Width-83;
  tfsmsterkirim.GridSMSTerkirim.Columns[0].Width:=FUtama.Width div 7;
  tfsmsterkirim.GridSMSTerkirim.Columns[1].Width:=FUtama.Width div 7;
  tfsmsterkirim.GridSMSTerkirim.Columns[2].Width:=FUtama.Width div 7;
  tfsmsterkirim.GridSMSTerkirim.Columns[3].Width:=FUtama.Width div 7;
  tfsmsterkirim.GridSMSTerkirim.Columns[4].Width:=FUtama.Width div 7;
  tfsmsterkirim.GridSMSTerkirim.Columns[5].Width:=FUtama.Width div 7;
  tfsmsterkirim.GridSMSTerkirim.Columns[6].Width:=FUtama.Width div 7;
  // Form Chat Masuk
  tfchatmasuk.ParentWindow:=PanelTengah.Handle;
  tfchatmasuk.WindowState:=wsMaximized;
  tfchatmasuk.Width:=FUtama.Width;
  tfchatmasuk.Height:=PanelTengah.Height;
  tfchatmasuk.BTutup.Left:=FUtama.Width-83;
  tfchatmasuk.GridChatMasuk.Columns[0].Width:=FUtama.Width div 7;
  tfchatmasuk.GridChatMasuk.Columns[1].Width:=FUtama.Width div 7;
  tfchatmasuk.GridChatMasuk.Columns[2].Width:=FUtama.Width div 7;
  tfchatmasuk.GridChatMasuk.Columns[3].Width:=FUtama.Width div 7;
  tfchatmasuk.GridChatMasuk.Columns[4].Width:=FUtama.Width div 7;
  tfchatmasuk.GridChatMasuk.Columns[5].Width:=FUtama.Width div 7;
  tfchatmasuk.GridChatMasuk.Columns[6].Width:=FUtama.Width div 7;
  // Form Chat Terkirim
  tfchatterkirim.ParentWindow:=PanelTengah.Handle;
  tfchatterkirim.WindowState:=wsMaximized;
  tfchatterkirim.Width:=FUtama.Width;
  tfchatterkirim.Height:=PanelTengah.Height;
  tfchatterkirim.BTutup.Left:=FUtama.Width-83;
  tfchatterkirim.GridChatTerkirim.Columns[0].Width:=FUtama.Width div 7;
  tfchatterkirim.GridChatTerkirim.Columns[1].Width:=FUtama.Width div 7;
  tfchatterkirim.GridChatTerkirim.Columns[2].Width:=FUtama.Width div 7;
  tfchatterkirim.GridChatTerkirim.Columns[3].Width:=FUtama.Width div 7;
  tfchatterkirim.GridChatTerkirim.Columns[4].Width:=FUtama.Width div 7;
  tfchatterkirim.GridChatTerkirim.Columns[5].Width:=FUtama.Width div 7;
  tfchatterkirim.GridChatTerkirim.Columns[6].Width:=FUtama.Width div 7;
  // Form Pengguna
  tfpengguna.ParentWindow:=PanelTengah.Handle;
  tfpengguna.WindowState:=wsMaximized;
  tfpengguna.Width:=FUtama.Width;
  tfpengguna.Height:=PanelTengah.Height;
  tfpengguna.BTutup.Left:=FUtama.Width-83;
  tfpengguna.GridPengguna.Columns[0].Width:=FUtama.Width div 5;
  tfpengguna.GridPengguna.Columns[1].Width:=FUtama.Width div 5;
  tfpengguna.GridPengguna.Columns[2].Width:=FUtama.Width div 5;
  tfpengguna.GridPengguna.Columns[3].Width:=FUtama.Width div 5;
  tfpengguna.GridPengguna.Columns[4].Width:=FUtama.Width div 5;
  // Form Format
  tfformat.ParentWindow:=PanelTengah.Handle;
  tfformat.WindowState:=wsMaximized;
  tfformat.Width:=FUtama.Width;
  tfformat.Height:=PanelTengah.Height;
  tfformat.BTutup.Left:=FUtama.Width-83;
  tfformat.GridFormat.Columns[0].Width:=35;
  tfformat.GridFormat.Columns[1].Width:=(FUtama.Width-35) div 2;
  tfformat.GridFormat.Columns[2].Width:=(FUtama.Width-35) div 2;
  // Form SMS Balasan
  fdsmsb.ParentWindow:=PanelTengah.Handle;
  fdsmsb.WindowState:=wsMaximized;
  fdsmsb.Width:=FUtama.Width;
  fdsmsb.Height:=PanelTengah.Height;
  fdsmsb.BTutup.Left:=FUtama.Width-83;
  fdsmsb.GridSMSB.Columns[0].Width:=100;
  fdsmsb.GridSMSB.Columns[1].Width:=(FUtama.Width-100);
  // Form Grafik Peta
  fgpeta.ParentWindow:=PanelTengah.Handle;
  fgpeta.WindowState:=wsMaximized;
  fgpeta.Width:=FUtama.Width;
  fgpeta.Height:=PanelTengah.Height;
  fgpeta.BTutup.Left:=FUtama.Width-83;
end;

procedure TFUtama.TutupForm;
begin
  ImageBack.Visible:=False;
  fpartai.Close;
  fprov.Close;
  fkabkota.Close;
  fkec.Close;
  fkeldes.Close;
  ftps.Close;
  fcapres.Close;
  fcagub.Close;
  fcabupkota.Close;
  fcalegdpd.Close;
  fcalegdpr.Close;
  fcalegprov.Close;
  fcalegkab.Close;
  fdapilri.Close;
  fdapilprov.Close;
  fdapilkabkota.Close;
  ftimses.Close;
  fsaksi.Close;
  fusultimses.Close;
  fdukungindie.Close;
  fpolling.Close;
  fusulsaran.Close;
  fhcapres.Close;
  fpeta.Close;
  fdpt.Close;
  fhcagub.Close;
  fhkades.Close;
  fckades.Close;
  fhcabup.Close;
  fhdpd.Close;
  fgpeta.Close;
  fhdpr.Close;
  fhdprdprov.Close;
  fhdprdkab.Close;
  fhpartai.Close;
  fdapil.Close;
  fgcapres.Close;
  fgpartai.Close;
  fgcabup.Close;
  fgcagub.Close;
  fgdpdri.Close;
  fgdprri.Close;
  fgdprdprov.Close;
  fgdprdkab.Close;
  fdsmsb.Close;
  fgcapres.TimerRefresh.Enabled:=False;
  fgcapres.CkAutoRefresh.Checked:=False;
  fgcapres.BRefresh.Visible:=True;
  fgcapres.BCetak.Left:=208;
  fgcapres.SInterval.Enabled:=True;
  fgcapres.SInterval.Value:=1;
  fgcagub.TimerRefresh.Enabled:=False;
  fgcagub.CkAutoRefresh.Checked:=False;
  fgcagub.BRefresh.Visible:=True;
  fgcagub.BCetak.Left:=208;
  fgcagub.SInterval.Enabled:=True;
  fgcagub.SInterval.Value:=1;
  fgpartai.TimerRefresh.Enabled:=False;
  fgpartai.CkAutoRefresh.Checked:=False;
  fgpartai.BRefresh.Visible:=True;
  fgpartai.BCetak.Left:=208;
  fgpartai.SInterval.Enabled:=True;
  fgpartai.SInterval.Value:=1;
  fgcabup.TimerRefresh.Enabled:=False;
  fgcabup.CkAutoRefresh.Checked:=False;
  fgcabup.BRefresh.Visible:=True;
  fgcabup.BCetak.Left:=208;
  fgcabup.SInterval.Enabled:=True;
  fgcabup.SInterval.Value:=1;
  fgdpdri.TimerRefresh.Enabled:=False;
  fgdpdri.CkAutoRefresh.Checked:=False;
  fgdpdri.BRefresh.Visible:=True;
  fgdpdri.BCetak.Left:=208;
  fgdpdri.SInterval.Enabled:=True;
  fgdpdri.SInterval.Value:=1;
  fgdprri.TimerRefresh.Enabled:=False;
  fgdprri.CkAutoRefresh.Checked:=False;
  fgdprri.BRefresh.Visible:=True;
  fgdprri.BCetak.Left:=208;
  fgdprri.BFilter.Left:=290;
  fgdprri.SInterval.Enabled:=True;
  fgdprri.SInterval.Value:=1;
  fgdprdkab.TimerRefresh.Enabled:=False;
  fgdprdkab.CkAutoRefresh.Checked:=False;
  fgdprdkab.BRefresh.Visible:=True;
  fgdprdkab.BCetak.Left:=208;
  fgdprdkab.BFilter.Left:=290;
  fgdprdkab.SInterval.Enabled:=True;
  fgdprdkab.SInterval.Value:=1;
  fgdprdprov.TimerRefresh.Enabled:=False;
  fgdprdprov.CkAutoRefresh.Checked:=False;
  fgdprdprov.BRefresh.Visible:=True;
  fgdprdprov.BCetak.Left:=208;
  fgdprdprov.BFilter.Left:=290;
  fgdprdprov.SInterval.Enabled:=True;
  fgdprdprov.SInterval.Value:=1;
  fgkades.Close;
  fgkades.TimerRefresh.Enabled:=False;
  fgkades.CkAutoRefresh.Checked:=False;
  fgkades.BRefresh.Visible:=True;
  fgkades.BCetak.Left:=208;
  fgkades.SInterval.Enabled:=True;
  fgkades.SInterval.Value:=1;
  tfsmsmasuk.Close;
  tfsmsterkirim.Close;
  tfchatmasuk.Close;
  tfchatterkirim.Close;
  tfpengguna.Close;
  tfformat.Close;
end;

function TFUtama.getNamaStatusModem(id: string): string;
begin
  Result := '';
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select nama_modem, status from t_modem where id="'+id+'"';
    Open;
  end;
  Result:= DM.ZQCari.FieldByName('nama_modem').AsString+' ['+DM.ZQCari.FieldByName('status').AsString+']';
end;

function TFUtama.getStatusModem(id: string): string;
begin
  Result := '';
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select status from t_modem where id="'+id+'"';
    Open;
  end;
  Result:= DM.ZQCari.FieldByName('status').AsString;
end;

function TFUtama.getStatusBot(id: string): string;
begin
  Result := '';
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select status from t_telegrambot where id="'+id+'"';
    Open;
  end;
  Result:= DM.ZQCari.FieldByName('status').AsString;
end;

function TFUtama.getNamaStatusBot(id: string): string;
begin
  Result := '';
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select nama_bot, status from t_telegrambot where id="'+id+'"';
    Open;
  end;
  Result:= DM.ZQCari.FieldByName('nama_bot').AsString+' ['+DM.ZQCari.FieldByName('status').AsString+']';
end;

procedure TFUtama.FormCreate(Sender: TObject);
begin
  SetStatusBar;
  fpartai       := TFPartai.Create(nil);
  fprov         := TFProvinsi.Create(nil);
  fkabkota      := TFKabupatenKota.Create(nil);
  fkec          := TFKecamatan.Create(nil);
  fkeldes       := TFKelurahanDesa.Create(nil);
  ftps          := TFTps.Create(nil);
  fcapres       := TFCapres.Create(nil);
  fcagub        := TFCagub.Create(nil);
  fcabupkota    := TFCabupKota.Create(nil);
  fcalegdpd     := TFCalegDPDRI.Create(nil);
  fcalegdpr     := TFCalegDPRRI.Create(nil);
  fcalegprov    := TFCalegDPRDProv.Create(nil);
  fcalegkab     := TFCalegKabKota.Create(nil);
  fdapilri      := TFDapilRI.Create(nil);
  fdapilprov    := TFDapilProvinsi.Create(nil);
  fdapilkabkota := TFDapilKabKota.Create(nil);
  ftimses       := TFTIMSES.Create(nil);
  fsaksi        := TFSaksi.Create(nil);
  fusultimses   := TFUsulanTIMSES.Create(nil);
  fdukungindie  := TFDukunganIndependen.Create(nil);
  fpolling      := TFPolling.Create(nil);
  fusulsaran    := TFUsulSaran.Create(nil);
  fhcapres      := TFHitungCapres.Create(nil);
  fhcagub       := TFHitungCagub.Create(nil);
  fhcabup       := TFHitungCabupKota.Create(nil);
  fhdpd         := TFHitungDPDRI.Create(nil);
  fhdpr         := TFHitungDPRRI.Create(nil);
  fhdprdprov    := TFHitungDPRDProv.Create(nil);
  fhdprdkab     := TFHitungDPRDKabKota.Create(nil);
  fhpartai      := TFHitungPartai.Create(nil);
  fdapil        := TFDataDAPIL.Create(nil);
  fgcapres      := TFGrafikCapres.Create(nil);
  fgcagub       := TFGrafikCagub.Create(nil);
  fgcabup       := TFGrafikCabupKota.Create(nil);
  fgpartai      := TFGrafikPartai.Create(nil);
  fgdpdri       := TFGrafikDPDRI.Create(nil);
  fgdprri       := TFGrafikDPRRI.Create(nil);
  fgdprdkab     := TFGrafikDPRDKabKota.Create(nil);
  fgdprdprov    := TFGrafikDPRDProv.Create(nil);
  tfsmsmasuk    := TFDataSMSMasuk.Create(nil);
  tfsmsterkirim := TFDataSMSTerkirim.Create(nil);
  tfchatmasuk   := TFDataChatMasuk.Create(nil);
  tfchatterkirim:= TFDataChatTerkirim.Create(nil);
  tfpengguna    := TFDataPengguna.Create(nil);
  tfformat      := TFDataFormatSMSChat.Create(nil);
  fdsmsb        := TFDataSMSBalasan.Create(nil);
  fgkades       := TFGrafikKades.Create(nil);
  fhkades       := TFHitungKades.Create(nil);
  fckades       := TFCalonKades.Create(nil);
  fpeta         := TFPetaSuara.Create(nil);
  fdpt          := TFDataDPT.Create(nil);
  fgpeta        := TFGrafikPeta.Create(nil);
end;

procedure TFUtama.BDataPartaiClick(Sender: TObject);
begin
  TutupForm;
  fpartai.ParentWindow:=PanelTengah.Handle;
  fpartai.WindowState:=wsMaximized;
  fpartai.BTutup.Left:=FUtama.Width-83;
  fpartai.PImage.Left:=FUtama.Width-125;
  fpartai.PImage.Top:=FUtama.Height-330;
  DM.ZQPartai.First;
  fpartai.AmbilGambar;
  fpartai.Show;
end;

procedure TFUtama.BDataPenggunaClick(Sender: TObject);
begin
  TutupForm;
  tfpengguna.ParentWindow:=PanelTengah.Handle;
  tfpengguna.WindowState:=wsMaximized;
  tfpengguna.BTutup.Left:=FUtama.Width-83;
  DM.ZQPengguna.First;
  tfpengguna.Show;
end;

procedure TFUtama.BDataPollingClick(Sender: TObject);
begin
  TutupForm;
  fpolling.ParentWindow:=PanelTengah.Handle;
  fpolling.WindowState:=wsMaximized;
  fpolling.BTutup.Left:=FUtama.Width-83;
  DM.ZQPolling.First;
  fpolling.Show;
  fpolling.BCari.SetFocus;
end;

procedure TFUtama.BDataKabKotaClick(Sender: TObject);
begin
  TutupForm;
  fprov.ParentWindow:=PanelTengah.Handle;
  fprov.WindowState:=wsMaximized;
  fprov.BTutup.Left:=FUtama.Width-83;
  DM.ZQKabKota.First;
  fkabkota.Show;
  fkabkota.BCari.SetFocus;;
end;

procedure TFUtama.BDataCAPRESClick(Sender: TObject);
begin
  TutupForm;
  fcapres.ParentWindow:=PanelTengah.Handle;
  fcapres.WindowState:=wsMaximized;
  fcapres.BTutup.Left:=FUtama.Width-83;
  fcapres.PImage.Left:=FUtama.Width-125;
  fcapres.PImage.Top:=FUtama.Height-330;
  DM.ZQCapres.First;
  fcapres.AmbilGambar;
  fcapres.Show;
end;

procedure TFUtama.BDataDukunganIndependenClick(Sender: TObject);
begin
  TutupForm;
  fdukungindie.ParentWindow:=PanelTengah.Handle;
  fdukungindie.WindowState:=wsMaximized;
  fdukungindie.BTutup.Left:=FUtama.Width-83;
  DM.ZQDukIndie.First;
  fdukungindie.Show;
  fdukungindie.BCari.SetFocus;
end;

procedure TFUtama.BDataCAGUBClick(Sender: TObject);
begin
  TutupForm;
  fcagub.ParentWindow:=PanelTengah.Handle;
  fcagub.WindowState:=wsMaximized;
  fcagub.BTutup.Left:=FUtama.Width-83;
  fcagub.PImage.Left:=FUtama.Width-125;
  fcagub.PImage.Top:=FUtama.Height-330;
  DM.ZQCagub.First;
  fcagub.AmbilGambar;
  fcagub.Show;
end;

procedure TFUtama.BDataCaKadesClick(Sender: TObject);
begin
  TutupForm;
  fckades.ParentWindow:=PanelTengah.Handle;
  fckades.WindowState:=wsMaximized;
  fckades.BTutup.Left:=FUtama.Width-83;
  fckades.PImage.Left:=FUtama.Width-125;
  fckades.PImage.Top:=FUtama.Height-330;
  DM.ZQKades.First;
  fckades.AmbilGambar;
  fckades.Show;
  fckades.BTambah.SetFocus;
end;

procedure TFUtama.BDataCALEGDPDClick(Sender: TObject);
begin
  TutupForm;
  fcalegdpd.ParentWindow:=PanelTengah.Handle;
  fcalegdpd.WindowState:=wsMaximized;
  fcalegdpd.BTutup.Left:=FUtama.Width-83;
  fcalegdpd.PImage.Left:=FUtama.Width-125;
  fcalegdpd.PImage.Top:=FUtama.Height-330;
  DM.ZQDPDRI.First;
  fcalegdpd.AmbilGambar;
  fcalegdpd.Show;
  fcalegdpd.BCari.SetFocus;
end;

procedure TFUtama.BDataCALEGDPRClick(Sender: TObject);
begin
  TutupForm;
  fcalegdpr.ParentWindow:=PanelTengah.Handle;
  fcalegdpr.WindowState:=wsMaximized;
  fcalegdpr.BTutup.Left:=FUtama.Width-83;
  fcalegdpr.PImage.Left:=FUtama.Width-125;
  fcalegdpr.PImage.Top:=FUtama.Height-330;
  DM.ZQDPRRI.First;
  fcalegdpr.AmbilGambar;
  fcalegdpr.Show;
  fcalegdpr.BCari.SetFocus;
end;

procedure TFUtama.BDataCALEGDPRDKabKotaClick(Sender: TObject);
begin
  TutupForm;
  fcalegkab.ParentWindow:=PanelTengah.Handle;
  fcalegkab.WindowState:=wsMaximized;
  fcalegkab.BTutup.Left:=FUtama.Width-83;
  fcalegkab.PImage.Left:=FUtama.Width-125;
  fcalegkab.PImage.Top:=FUtama.Height-330;
  DM.ZQDPRDKab.First;
  fcalegkab.AmbilGambar;
  fcalegkab.Show;
  fcalegkab.BCari.SetFocus;
end;

procedure TFUtama.BDataCALEGDPRDProvClick(Sender: TObject);
begin
  TutupForm;
  fcalegprov.ParentWindow:=PanelTengah.Handle;
  fcalegprov.WindowState:=wsMaximized;
  fcalegprov.BTutup.Left:=FUtama.Width-83;
  fcalegprov.PImage.Left:=FUtama.Width-125;
  fcalegprov.PImage.Top:=FUtama.Height-330;
  DM.ZQDPRDProv.First;
  fcalegprov.AmbilGambar;
  fcalegprov.Show;
  fcalegprov.BCari.SetFocus;
end;


procedure TFUtama.BDataCABUPKOTAClick(Sender: TObject);
begin
  TutupForm;
  fcabupkota.ParentWindow:=PanelTengah.Handle;
  fcabupkota.WindowState:=wsMaximized;
  fcabupkota.BTutup.Left:=FUtama.Width-83;
  fcabupkota.PImage.Left:=FUtama.Width-125;
  fcabupkota.PImage.Top:=FUtama.Height-330;
  DM.ZQCabupKota.First;
  fcabupkota.AmbilGambar;
  fcabupkota.Show;
end;

procedure TFUtama.BDapilRIClick(Sender: TObject);
begin
  TutupForm;
  fdapilri.ParentWindow:=PanelTengah.Handle;
  fdapilri.WindowState:=wsMaximized;
  fdapilri.BTutup.Left:=FUtama.Width-83;
  fdapilri.HapusNode;
  fdapilri.BuatNode;
  fdapilri.Show;
  fdapilri.BCari.SetFocus;
end;

procedure TFUtama.BDapilProvinsiClick(Sender: TObject);
begin
  TutupForm;
  fdapilprov.ParentWindow:=PanelTengah.Handle;
  fdapilprov.WindowState:=wsMaximized;
  fdapilprov.BTutup.Left:=FUtama.Width-83;
  fdapilprov.HapusNode;
  fdapilprov.BuatNode;
  fdapilprov.Show;
  fdapilprov.BCari.SetFocus;
end;

procedure TFUtama.BDapilKabKotaClick(Sender: TObject);
begin
  TutupForm;
  fdapilkabkota.ParentWindow:=PanelTengah.Handle;
  fdapilkabkota.WindowState:=wsMaximized;
  fdapilkabkota.BTutup.Left:=FUtama.Width-83;
  fdapilkabkota.HapusNode;
  fdapilkabkota.BuatNode;
  fdapilkabkota.Show;
  fdapilkabkota.BCari.SetFocus;
end;

procedure TFUtama.BBackupDatabaseClick(Sender: TObject);
const
   READ_BYTES = 204800;
var
  command: TProcess;
  s: string;
  output: TStringList;
  BytesRead, n: LongInt;
  m: TMemoryStream;
  lczip: TAbZipper;
begin
  if not (DM.KoneksiDatabase.User = 'root') then begin
    ShowMessage('User Tidak memiliki akses untuk Backup Database');
    Exit
  end;
  SaveBackup.Free;
  SaveBackup := TSaveDialog.Create(Self);
  SaveBackup.Filter:='Backup Files (*.zip)|*.zip';
  if SaveBackup.Execute then begin
      s := ExtractFilePath(Application.ExeName)+'img\EQSBackup.bfl';
    if not (copy(s,Length(s)-3,Length(s)-1) = '.bfl') then
    s := s + '.bfl';
    command := TProcess.Create(Nil);
    output := TStringList.Create;
    M := TMemoryStream.Create;
    BytesRead := 0;
    command.CommandLine := ExtractFilePath(Application.ExeName)+'mysql\bin\mysqldump.exe -uroot -p'+DM.KoneksiDatabase.Password+' -h '+DM.KoneksiDatabase.HostName+' eqsquickcount t_cabupkota t_cagub t_calegdpdri t_calegdprdkabkota t_calegdprdprov t_calegdprri t_capres t_config t_dapil t_dapilkabkota t_dapilprovinsi t_dapilri t_dukunganindie t_format t_hak_akses t_hitungcabup t_hitungcagub t_hitungcapres t_hitungdpdri t_hitungdprdkab t_hitungdprdprov t_hitungdprri t_hitungpartai t_identitaslembaga t_inboxchat t_inboxsms t_kabkota t_kecamatan t_kelurahan t_modem t_outboxchat t_outboxsms t_partai t_pengguna t_polling t_provinsi t_saksi t_telegrambot t_timses t_tps t_usulantimses t_usulsaran t_smsbalasan t_cakades t_hitungkades t_petasuara t_dpt t_caleginfo t_totpartai t_perolehankursi t_totcaleg';
    command.Options := command.Options + [poUsePipes];
    command.Execute;
    while command.Running do begin
      // ensure the space
      M.SetSize(BytesRead + READ_BYTES);
      // we try to read
      n := command.Output.Read((M.Memory + BytesRead)^, READ_BYTES);
      if n > 0 then
        Inc(BytesRead, n)
      else
        // whitout data, wait 100 ms
        Sleep(100);
    end;
    // we read the last part
    repeat
      // ensure the space
      M.SetSize(BytesRead + READ_BYTES);
      // we try to read
      n := command.Output.Read((M.Memory + BytesRead)^, READ_BYTES);
      if n > 0 then
       Inc(BytesRead, n);
    until n <= 0;
    M.SetSize(BytesRead);
    output.LoadFromStream(M);
    output.SaveToFile(s);
    output.Free;
    command.Free;
    M.Free;
    // Jadikan Zip
    lczip := TAbZipper.Create(nil);
      try
      lczip.ArchiveType:= atZip;
      lczip.ForceType:=True;
      lczip.FileName:=SaveBackup.FileName;
      lczip.StoreOptions:= [soRecurse];
      lczip.BaseDirectory:=ExtractFilePath(Application.ExeName)+'img';
      lczip.AddFiles('*.*',faAnyFile);
      lczip.Save;
      lczip.CloseArchive;
    finally
      lczip.Free;
    end;
    MessageDlg('Database Berhasil Dibackup "'+SaveBackup.FileName+'"', mtInformation, [mbOK], 0)
  end else
    MessageDlg('Backup GAGAL!', mtWarning, [mbOK], 0);
end;

procedure TFUtama.BBantuanClick(Sender: TObject);
begin
 OpenURL('https://www.eqsquickcount.com/search/label/Tutorial');
end;

procedure TFUtama.BBotTelegramClick(Sender: TObject);
var
 filename : string;
begin
 filename:=ExtractFilePath(Application.ExeName)+'BotEngine.exe';
 ShellExecute(handle,'open',PChar(filename), '','',SW_NORMAL);
end;

procedure TFUtama.BChatMasukClick(Sender: TObject);
begin
  TutupForm;
  tfchatmasuk.ParentWindow:=PanelTengah.Handle;
  tfchatmasuk.WindowState:=wsMaximized;
  tfchatmasuk.BTutup.Left:=FUtama.Width-83;
  DM.ZQChatMasuk.First;
  tfchatmasuk.Show;
end;

procedure TFUtama.BChatTerkirimClick(Sender: TObject);
begin
  TutupForm;
  tfchatterkirim.ParentWindow:=PanelTengah.Handle;
  tfchatterkirim.WindowState:=wsMaximized;
  tfchatterkirim.BTutup.Left:=FUtama.Width-83;
  DM.ZQChatTerkirim.First;
  tfchatterkirim.Show;
end;

procedure TFUtama.BChattingClick(Sender: TObject);
begin
  with FKirimChat do
  begin
    Caption:='Kirim Pesan Telegram';
    hapus;
    ShowModal;
  end;
end;

procedure TFUtama.BDataKecamatanClick(Sender: TObject);
begin
  TutupForm;
  fkec.ParentWindow:=PanelTengah.Handle;
  fkec.WindowState:=wsMaximized;
  fkec.BTutup.Left:=FUtama.Width-83;
  DM.ZQKec.First;
  fkec.Show;
  fkec.BCari.SetFocus;
end;

procedure TFUtama.BDataKelDesaClick(Sender: TObject);
begin
  TutupForm;
  fkeldes.ParentWindow:=PanelTengah.Handle;
  fkeldes.WindowState:=wsMaximized;
  fkeldes.BTutup.Left:=FUtama.Width-83;
  DM.ZQKelDesa.First;
  fkeldes.Show;
  fkeldes.BCari.SetFocus;
end;

procedure TFUtama.BDataProvClick(Sender: TObject);
begin
  TutupForm;
  fprov.ParentWindow:=PanelTengah.Handle;
  fprov.WindowState:=wsMaximized;
  fprov.BTutup.Left:=FUtama.Width-83;
  DM.ZQProv.First;
  fprov.Show;
  fprov.BCari.SetFocus;
end;

procedure TFUtama.BDataSaksiClick(Sender: TObject);
begin
  TutupForm;
  fsaksi.ParentWindow:=PanelTengah.Handle;
  fsaksi.WindowState:=wsMaximized;
  fsaksi.BTutup.Left:=FUtama.Width-83;
  DM.ZQSaksi.First;
  fsaksi.Show;
  fsaksi.BCari.SetFocus;
end;

procedure TFUtama.BDataSMSBalasanClick(Sender: TObject);
begin
  TutupForm;
  fdsmsb.ParentWindow:=PanelTengah.Handle;
  fdsmsb.WindowState:=wsMaximized;
  fdsmsb.BTutup.Left:=FUtama.Width-83;
  DM.ZQBalasan.First;
  fdsmsb.Show;
end;

procedure TFUtama.BDataTimsesRelawanClick(Sender: TObject);
begin
  TutupForm;
  ftimses.ParentWindow:=PanelTengah.Handle;
  ftimses.WindowState:=wsMaximized;
  ftimses.BTutup.Left:=FUtama.Width-83;
  DM.ZQTimses.First;
  ftimses.Show;
  ftimses.BCari.SetFocus;
end;

procedure TFUtama.BDataTPSClick(Sender: TObject);
begin
  TutupForm;
  ftps.ParentWindow:=PanelTengah.Handle;
  ftps.WindowState:=wsMaximized;
  ftps.BTutup.Left:=FUtama.Width-83;
  DM.ZQTPS.First;
  ftps.Show;
  ftps.BCari.SetFocus;
end;

procedure TFUtama.BDataUsulanTimsesRelawanClick(Sender: TObject);
begin
  TutupForm;
  fusultimses.ParentWindow:=PanelTengah.Handle;
  fusultimses.WindowState:=wsMaximized;
  fusultimses.BTutup.Left:=FUtama.Width-83;
  DM.ZQUsulTimses.First;
  fusultimses.Show;
  fusultimses.BCari.SetFocus;
end;

procedure TFUtama.BDataUsulSaranClick(Sender: TObject);
begin
  TutupForm;
  fusulsaran.ParentWindow:=PanelTengah.Handle;
  fusulsaran.WindowState:=wsMaximized;
  fusulsaran.BTutup.Left:=FUtama.Width-83;
  DM.ZQUsulSaran.First;
  fusulsaran.Show;
  fusulsaran.BCari.SetFocus;
end;

procedure TFUtama.BGrafikCABUPKOTAClick(Sender: TObject);
begin
  TutupForm;
  fgcabup.ParentWindow:=PanelTengah.Handle;
  fgcabup.WindowState:=wsMaximized;
  fgcabup.BTutup.Left:=FUtama.Width-83;
  fgcabup.HapusGrafik;
  fgcabup.BuatGrafik;
  fgcabup.Persentase;
  fgcabup.Show;
end;

procedure TFUtama.BGrafikCAGUBClick(Sender: TObject);
begin
  TutupForm;
  fgcagub.ParentWindow:=PanelTengah.Handle;
  fgcagub.WindowState:=wsMaximized;
  fgcagub.BTutup.Left:=FUtama.Width-83;
  fgcagub.HapusGrafik;
  fgcagub.BuatGrafik;
  fgcagub.Persentase;
  fgcagub.Show;
end;

procedure TFUtama.BGrafikCALEGDPDClick(Sender: TObject);
begin
  TutupForm;
  fgdpdri.ParentWindow:=PanelTengah.Handle;
  fgdpdri.WindowState:=wsMaximized;
  fgdpdri.BTutup.Left:=FUtama.Width-83;
  fgdpdri.HapusGrafik;
  fgdpdri.BuatGrafik;
  fgdpdri.Persentase;
  fgdpdri.Show;
end;

procedure TFUtama.BGrafikCalegDPRClick(Sender: TObject);
begin
  with FPilihPartai do
  begin
    Caption:='Form Filter Grafik';
    LMode.Caption:='DPR';
    ShowModal;
  end;
  TutupForm;
  fgdprri.ParentWindow:=PanelTengah.Handle;
  fgdprri.WindowState:=wsMaximized;
  fgdprri.BTutup.Left:=FUtama.Width-83;
  fgdprri.HapusGrafik;
  fgdprri.BuatGrafik;
  fgdprri.Persentase;
  fgdprri.Show;
end;

procedure TFUtama.BGrafikCalegDPRDKabKotaClick(Sender: TObject);
begin
  with FPilihPartai do
  begin
    Caption:='Form Filter Grafik';
    LMode.Caption:='DPRDKab';
    ShowModal;
  end;
  TutupForm;
  fgdprdkab.ParentWindow:=PanelTengah.Handle;
  fgdprdkab.WindowState:=wsMaximized;
  fgdprdkab.BTutup.Left:=FUtama.Width-83;
  fgdprdkab.HapusGrafik;
  fgdprdkab.BuatGrafik;
  fgdprdkab.Persentase;
  fgdprdkab.Show;
end;

procedure TFUtama.BGrafikCalegDPRDProvClick(Sender: TObject);
begin
  with FPilihPartai do
  begin
    Caption:='Form Filter Grafik';
    LMode.Caption:='DPRDProv';
    ShowModal;
  end;
  TutupForm;
  fgdprdprov.ParentWindow:=PanelTengah.Handle;
  fgdprdprov.WindowState:=wsMaximized;
  fgdprdprov.BTutup.Left:=FUtama.Width-83;
  fgdprdprov.HapusGrafik;
  fgdprdprov.BuatGrafik;
  fgdprdprov.Persentase;
  fgdprdprov.Show;
end;

procedure TFUtama.BGrafikCapresClick(Sender: TObject);
begin
  TutupForm;
  fgcapres.ParentWindow:=PanelTengah.Handle;
  fgcapres.WindowState:=wsMaximized;
  fgcapres.BTutup.Left:=FUtama.Width-83;
  fgcapres.HapusGrafik;
  fgcapres.BuatGrafik;
  fgcapres.Persentase;
  fgcapres.Show;
end;

procedure TFUtama.BGrafikKadesClick(Sender: TObject);
begin
  TutupForm;
  fgkades.ParentWindow:=PanelTengah.Handle;
  fgkades.WindowState:=wsMaximized;
  fgkades.BTutup.Left:=FUtama.Width-83;
  fgkades.HapusGrafik;
  fgkades.BuatGrafik;
  fgkades.Persentase;
  fgkades.Show;
end;

procedure TFUtama.BGrafikPartaiClick(Sender: TObject);
begin
  TutupForm;
  fgpartai.ParentWindow:=PanelTengah.Handle;
  fgpartai.WindowState:=wsMaximized;
  fgpartai.BTutup.Left:=FUtama.Width-83;
  fgpartai.HapusGrafik;
  fgpartai.BuatGrafik;
  fgpartai.Persentase;
  fgpartai.Show;
end;

procedure TFUtama.BGRafikPetaClick(Sender: TObject);
begin
  with FFilterPeta do
  begin
    Caption:='Filter Grafik Peta Suara';
        SetCB;
        Hapus;
        LStatus.Caption:='Grafik';
        CBKelDesa.Visible:=False;
        Label6.Visible:=False;
        Height:=235;
        ShowModal;
  end;
  TutupForm;
  fgpeta.ParentWindow:=PanelTengah.Handle;
  fgpeta.WindowState:=wsMaximized;
  fgpeta.BTutup.Left:=FUtama.Width-83;
  fgpeta.HapusGrafik;
  fgpeta.BuatGrafik;
  fgpeta.Show;
end;

procedure TFUtama.BHitungSainteClick(Sender: TObject);
begin
  with FSainteLague do
  begin
    Caption:='Perhitungan Sainte Lague';
    hapus;
    setData;
    ShowModal;
  end;
end;

procedure TFUtama.BIdentitasLembagaClick(Sender: TObject);
begin
    with FIdentitas do
  begin
    Caption:='Identitas Lembaga';
    hapus;
    setData;
    ShowModal;
  end;
end;

procedure TFUtama.BKirimSMSClick(Sender: TObject);
begin
  with FSMS do
  begin
    Caption:='Kirim SMS';
    hapus;
    setCB;
    ShowModal;
  end;
end;

procedure TFUtama.BModem1Click(Sender: TObject);
var
 filename : string;
begin
 filename:=ExtractFilePath(Application.ExeName)+'ModemEngine-1.exe';
 ShellExecute(handle,'open',PChar(filename), '','',SW_NORMAL);
end;

procedure TFUtama.BModem2Click(Sender: TObject);
var
 filename : string;
begin
 filename:=ExtractFilePath(Application.ExeName)+'ModemEngine-2.exe';
 ShellExecute(handle,'open',PChar(filename), '','',SW_NORMAL);
end;

procedure TFUtama.BModem3Click(Sender: TObject);
var
 filename : string;
begin
 filename:=ExtractFilePath(Application.ExeName)+'ModemEngine-3.exe';
 ShellExecute(handle,'open',PChar(filename), '','',SW_NORMAL);
end;

procedure TFUtama.BModem4Click(Sender: TObject);
var
 filename : string;
begin
 filename:=ExtractFilePath(Application.ExeName)+'ModemEngine-4.exe';
 ShellExecute(handle,'open',PChar(filename), '','',SW_NORMAL);
end;

procedure TFUtama.BModem5Click(Sender: TObject);
var
 filename : string;
begin
 filename:=ExtractFilePath(Application.ExeName)+'ModemEngine-5.exe';
 ShellExecute(handle,'open',PChar(filename), '','',SW_NORMAL);
end;

procedure TFUtama.BModem6Click(Sender: TObject);
var
 filename : string;
begin
 filename:=ExtractFilePath(Application.ExeName)+'ModemEngine-6.exe';
 ShellExecute(handle,'open',PChar(filename), '','',SW_NORMAL);
end;

procedure TFUtama.BModem7Click(Sender: TObject);
var
 filename : string;
begin
 filename:=ExtractFilePath(Application.ExeName)+'ModemEngine-7.exe';
 ShellExecute(handle,'open',PChar(filename), '','',SW_NORMAL);
end;

procedure TFUtama.BModem8Click(Sender: TObject);
var
 filename : string;
begin
 filename:=ExtractFilePath(Application.ExeName)+'ModemEngine-8.exe';
 ShellExecute(handle,'open',PChar(filename), '','',SW_NORMAL);
end;

procedure TFUtama.BPemilihClick(Sender: TObject);
begin
  TutupForm;
  fdpt.ParentWindow:=PanelTengah.Handle;
  fdpt.WindowState:=wsMaximized;
  fdpt.BTutup.Left:=FUtama.Width-83;
  DM.ZQDPT.First;
  fdpt.Show;
  fdpt.BCari.SetFocus;
end;

procedure TFUtama.BPengaturanAplikasiClick(Sender: TObject);
begin
  with FPengaturan do
  begin
    Caption:='Pengaturan Aplikasi';
    setData;
    ShowModal;
  end;
end;

procedure TFUtama.BPerhitunganCABUPKOTAClick(Sender: TObject);
begin
  TutupForm;
  fhcabup.ParentWindow:=PanelTengah.Handle;
  fhcabup.WindowState:=wsMaximized;
  fhcabup.BTutup.Left:=FUtama.Width-83;
  fhcabup.Show;
end;

procedure TFUtama.BPerhitunganCAGUBClick(Sender: TObject);
begin
  TutupForm;
  fhcagub.ParentWindow:=PanelTengah.Handle;
  fhcagub.WindowState:=wsMaximized;
  fhcagub.BTutup.Left:=FUtama.Width-83;
  fhcagub.Show;
end;

procedure TFUtama.BPerhitunganCALEGDPDClick(Sender: TObject);
begin
  TutupForm;
  fhdpd.ParentWindow:=PanelTengah.Handle;
  fhdpd.WindowState:=wsMaximized;
  fhdpd.BTutup.Left:=FUtama.Width-83;
  fhdpd.Show;
end;

procedure TFUtama.BPerhitunganCALEGDPRClick(Sender: TObject);
begin
  TutupForm;
  fhdpr.ParentWindow:=PanelTengah.Handle;
  fhdpr.WindowState:=wsMaximized;
  fhdpr.BTutup.Left:=FUtama.Width-83;
  fhdpr.Show;
end;

procedure TFUtama.BPerhitunganCALEGDPRDKabKotaClick(Sender: TObject);
begin
  TutupForm;
  fhdprdkab.ParentWindow:=PanelTengah.Handle;
  fhdprdkab.WindowState:=wsMaximized;
  fhdprdkab.BTutup.Left:=FUtama.Width-83;
  fhdprdkab.Show;
end;

procedure TFUtama.BPerhitunganCALEGDPRDProvClick(Sender: TObject);
begin
  TutupForm;
  fhdprdprov.ParentWindow:=PanelTengah.Handle;
  fhdprdprov.WindowState:=wsMaximized;
  fhdprdprov.BTutup.Left:=FUtama.Width-83;
  fhdprdprov.Show;
end;

procedure TFUtama.BPerhitunganCAPRESClick(Sender: TObject);
begin
  TutupForm;
  fhcapres.ParentWindow:=PanelTengah.Handle;
  fhcapres.WindowState:=wsMaximized;
  fhcapres.BTutup.Left:=FUtama.Width-83;
  fhcapres.Show;
end;

procedure TFUtama.BPerhitunganKadesClick(Sender: TObject);
begin
  TutupForm;
  fhkades.ParentWindow:=PanelTengah.Handle;
  fhkades.WindowState:=wsMaximized;
  fhkades.BTutup.Left:=FUtama.Width-83;
  fhkades.Show;
end;

procedure TFUtama.BPerhitunganPartaiClick(Sender: TObject);
begin
  TutupForm;
  fhpartai.ParentWindow:=PanelTengah.Handle;
  fhpartai.WindowState:=wsMaximized;
  fhpartai.BTutup.Left:=FUtama.Width-83;
  fhpartai.Show;
end;

procedure TFUtama.BPerkiraanClick(Sender: TObject);
begin
  TutupForm;
  fpeta.ParentWindow:=PanelTengah.Handle;
  fpeta.WindowState:=wsMaximized;
  fpeta.BTutup.Left:=FUtama.Width-83;
  fpeta.Show;
  fpeta.BCari.SetFocus;
end;

procedure TFUtama.BRegisterClick(Sender: TObject);
begin
  with FRegister do begin
    Caption:='Form Registrasi';
    hapus;
    setNilai;
    ShowModal;
  end;
end;

procedure TFUtama.BResetDBClick(Sender: TObject);
begin
  if MessageDlg('Apakah anda yakin akan mereset Database?',mtConfirmation,[mbyes,mbno],0)=mrYes then
     begin
       ResetDatabase;
     end;
end;

procedure TFUtama.BRestoreDatabaseClick(Sender: TObject);
var
  UnZipper: TUnZipper;
    s: string;
  tfFile: TextFile;
begin
if (cekSerial()=True) then
  begin
if OpenRestore.Execute then
begin
  UnZipper := TUnZipper.Create;
  try
    UnZipper.FileName   := OpenRestore.FileName;
    UnZipper.OutputPath := ExtractFilePath(Application.ExeName)+'img';
    UnZipper.Examine;
    UnZipper.UnZipAllFiles;
  finally
    UnZipper.Free;
  end;
  if not (DM.KoneksiDatabase.User = 'root') then begin
    ShowMessage('User tidak memiliki akses restore');
    Exit
  end;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\EQSBackup.bfl') then
    begin
    AssignFile(tfFile, ExtractFilePath(Application.ExeName)+'img\EQSBackup.bfl');
    reset(tfFile);
    DM.ZQCari5.SQL.Clear;
    readln(tfFile,s);
    While not eof(tfFile) do begin
      Readln(tfFile,s);
      if length(s) > 0 then begin
        s := StringReplace(s, #10, '', [rfReplaceAll]);
        s := StringReplace(s, #13, '', [rfReplaceAll]);
        s := StringReplace(s, #9, ' ', [rfReplaceAll]);
        if not ((s[1]+s[2]) = '--') then begin
          DM.ZQCari5.SQL.Add(s);
          if s[length(s)] = ';' then begin
            DM.ZQCari5.ExecSQL;
            DM.ZQCari5.SQL.Clear
          end
        end
      end
    end;
    CloseFile(tfFile);
  MessageDlg('Database Berhasil Direstore '+sLineBreak+'Aplikasi Akan Ditutup... '+sLineBreak+'Tunggu Beberapa Detik Kemudian Jalankan Ulang Aplikasi', mtInformation, [mbOK], 0);
  Application.Terminate;
  end else
    MessageDlg('Proses Restore Database GAGAL!',mtWarning,[mbok],0);
end;
  end else MessageDlg('Fitur Restore Tidak Bisa Digunakan Karena Software Belum Diaktivasi!',mtWarning,[mbok],0);
end;

procedure TFUtama.BSMSChatAutoRespondClick(Sender: TObject);
begin
  TutupForm;
  tfformat.ParentWindow:=PanelTengah.Handle;
  tfformat.WindowState:=wsMaximized;
  tfformat.BTutup.Left:=FUtama.Width-83;
  DM.ZQFormat.First;
  tfformat.Show;
end;

procedure TFUtama.BSMSMasukClick(Sender: TObject);
begin
  TutupForm;
  tfsmsmasuk.ParentWindow:=PanelTengah.Handle;
  tfsmsmasuk.WindowState:=wsMaximized;
  tfsmsmasuk.BTutup.Left:=FUtama.Width-83;
  DM.ZQSMSMasuk.First;
  tfsmsmasuk.Show;
end;

procedure TFUtama.BSMSTerkirimClick(Sender: TObject);
begin
  TutupForm;
  tfsmsterkirim.ParentWindow:=PanelTengah.Handle;
  tfsmsterkirim.WindowState:=wsMaximized;
  tfsmsterkirim.BTutup.Left:=FUtama.Width-83;
  DM.ZQSMSTerkirim.First;
  tfsmsterkirim.Show;
end;

procedure TFUtama.BtDataDapilClick(Sender: TObject);
begin
  TutupForm;
  fdapil.ParentWindow:=PanelTengah.Handle;
  fdapil.WindowState:=wsMaximized;
  fdapil.BTutup.Left:=FUtama.Width-83;
  DM.ZQDapil.First;
  fdapil.Show;
  fdapil.BCari.SetFocus;
end;

procedure TFUtama.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  BE,ME1,ME2,ME3,ME4,ME5,ME6,ME7,ME8,BNT: HWND;
begin
  BE  := FindWindow(nil, 'BotEngine');
  ME1 := FindWindow(nil, 'ModemEngine-1');
  ME2 := FindWindow(nil, 'ModemEngine-2');
  ME3 := FindWindow(nil, 'ModemEngine-3');
  ME4 := FindWindow(nil, 'ModemEngine-4');
  ME5 := FindWindow(nil, 'ModemEngine-5');
  ME6 := FindWindow(nil, 'ModemEngine-6');
  ME7 := FindWindow(nil, 'ModemEngine-7');
  ME8 := FindWindow(nil, 'ModemEngine-8');
  BNT := FindWindow(nil, 'HTML Help');
  if BE  <> 0 then PostMessage(BE,  WM_CLOSE, 0, 0);
  if ME1 <> 0 then PostMessage(ME1, WM_CLOSE, 0, 0);
  if ME2 <> 0 then PostMessage(ME2, WM_CLOSE, 0, 0);
  if ME3 <> 0 then PostMessage(ME3, WM_CLOSE, 0, 0);
  if ME4 <> 0 then PostMessage(ME4, WM_CLOSE, 0, 0);
  if ME5 <> 0 then PostMessage(ME5, WM_CLOSE, 0, 0);
  if ME6 <> 0 then PostMessage(ME6, WM_CLOSE, 0, 0);
  if ME7 <> 0 then PostMessage(ME7, WM_CLOSE, 0, 0);
  if ME8 <> 0 then PostMessage(ME8, WM_CLOSE, 0, 0);
  if BNT <> 0 then PostMessage(BNT, WM_CLOSE, 0, 0);
  Application.Terminate;
end;

function TFUtama.SaveGrafik(AFileName, titel, namaimage, sah, tidaksah, tps, masuk, pemilih, persen: string): Boolean;
var
JPFpdf1 : TJPFpdf;
begin
   Result := False;
  try
  JPFpdf1 := TJPFpdf.Create;
  with JPFpdf1 do begin
   // AddPage;
    AddPage(TPDFOrientation.poLandscape);

    SetFont(ffTimes,fsBold,14);
    SetLineWidth(0.3);
    Cell(0, 10, titel,'1',0,'C',0);
    Ln(10);                               //Samping Kiri // Atas // Lebar // Tinggi
    Image(ExtractFilePath(Application.ExeName)+'tmp/'+namaimage,10,25,277,100);

    Text(10,140,sah);
    Text(10,145,tidaksah);
    Text(10,150,tps);
    Text(10,155,masuk);
    Text(10,160,pemilih);
    if not (sah='') then Text(10,165,'Persentase Suara Masuk : '+persen);

    SetAuthor('EQSQuickCount-2.72.1');
    SaveToFile(AFileName);
    Result := True;
    end;
    finally
    JPFpdf1.Free;
  end;
end;

procedure TFUtama.Identitas;
var
nama : string;
begin
  // Identitas Caleg
  DM.ZQCalegInfo.First;
  nama := DM.ZQCalegInfo.FieldByName('nama').AsString;
  if (nama='') then nama := 'Administrator';
  PNC.Caption:=nama;
  ImgProfile.Picture.Clear;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\'+DM.ZQCalegInfo.FieldByName('foto').AsString) then
  ImgProfile.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\'+DM.ZQCalegInfo.FieldByName('foto').AsString) else
  ImgProfile.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\img\noimage.jpg');
end;

end.

