unit ulogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule, encode_decode, uSMBIOS, Windows, ucekserial, upengaturan;

type

  { TFLogin }

  TFLogin = class(TForm)
    BClose: TBitBtn;
    BLogin: TBitBtn;
    CBPilih: TComboBox;
    EPassword: TEdit;
    EUsername: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BCloseClick(Sender: TObject);
    procedure BLoginClick(Sender: TObject);
    procedure CBPilihKeyPress(Sender: TObject; var Key: char);
    procedure EPasswordKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure hakAkses(IdPengguna:string;Pilih:string);
  end;

var
  FLogin: TFLogin;

implementation

uses uutama;

{$R *.lfm}

{ TFLogin }

function GetVolumeID(DriveChar: Char): string;
  var
  MaxFileNameLength, VolFlags, SerNum: DWord;
  begin
  if GetVolumeInformation(PAnsiChar(DriveChar + ':\'), nil, 0, @SerNum, MaxFileNameLength, VolFlags, nil, 0)
  then
  begin
  Result := IntToHex(SerNum,8);
  end
  else
  Result := '';
end;

procedure TFLogin.BCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFLogin.BLoginClick(Sender: TObject);
begin
  if (EUsername.Text='') or (EPassword.Text='') or (CBPilih.Text='-Pilih-') then
  MessageDlg('Jangan kosongkan form input!',mtWarning,[mbok],0) else
  begin
        with DM.ZQCari do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='select * from t_pengguna where username="'+EUsername.Text+'" and password="'+GSMEncode7Bit(GSMEncode7Bit(EPassword.Text))+'"';
          Open;
        end;
        if DM.ZQCari.RecordCount >= 1 then
        begin
        FLogin.Hide;
        DM.ZQCari.First;
        hakAkses(DM.ZQCari.FieldByName('id').AsString,CBPilih.Text);
        FUtama.TimerUtama.Enabled:=True;
        FUtama.StatusBar.Panels[0].Text:=' Userlogin ['+DM.ZQCari.FieldByName('nama_lengkap').AsString+']';
        if cekSerial()=False then
        begin
        FUtama.Caption:='Elections Quick Count System [EQS] ver 2.81.0 - www.eqsquickcount.com - Unregistered';
        FUtama.PanelRegister.Visible:=True;
        FUtama.BRegister.Visible:=True;
        FUtama.PanelRegister.Visible:=True;
        if (FUtama.PanelBantuan.Visible=True) and (FUtama.PanelRegister.Visible=True) then
        FUtama.SubMenuBantuan.Visible:=True;
        MessageDlg('Software Ini Belum Diregistrasi Sehingga Jumlah Data Yang Dapat Tersimpan Terbatas!'+sLineBreak+sLineBreak+
                   'Anda Dapat Menggunakan Software Ini Secara Bebas Tanpa Batasan Waktu'+sLineBreak+sLineBreak+
                   'Jika Tertarik Menggunakan Versi Full, Silahkan Baca Panduannya Melalui Menu Bantuan'+sLineBreak+sLineBreak+
                   'Informasi Lebih Lanjut Tentang Software Ini Dapat Ditemukan di www.eqsquickcount.com'+sLineBreak+sLineBreak+
                   'Terima Kasih.'
                   ,mtInformation,[mbok],0);
        end else
        if cekSerial()=True then
        begin
        FUtama.Caption:='Elections Quick Count System [EQS] ver 2.81.0 - '+DM.ZQIdentitas.FieldByName('nama_lembaga').AsString+' - '+DM.ZQIdentitas.FieldByName('email').AsString;
        FUtama.BRegister.Visible:=False;
        FUtama.PanelRegister.Visible:=False;
        if (FUtama.PanelBantuan.Visible=False) and (FUtama.PanelRegister.Visible=False) then
        FUtama.SubMenuBantuan.Visible:=False;
        end;
        FUtama.Show;
        end else MessageDlg('Username atau Password Kurang Tepat!',mtWarning,[mbok],0);
  end;
end;

procedure TFLogin.CBPilihKeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;

procedure TFLogin.EPasswordKeyPress(Sender: TObject; var Key: char);
begin
 if key=#13 then
 BLogin.Click;
end;

procedure TFLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  BE,ME1,ME2,ME3,ME4,ME5,ME6,ME7,ME8: HWND;
begin
  BE := FindWindow(nil, 'BotEngine');
  ME1 := FindWindow(nil, 'ModemEngine-1');
  ME2 := FindWindow(nil, 'ModemEngine-2');
  ME3 := FindWindow(nil, 'ModemEngine-3');
  ME4 := FindWindow(nil, 'ModemEngine-4');
  ME5 := FindWindow(nil, 'ModemEngine-5');
  ME6 := FindWindow(nil, 'ModemEngine-6');
  ME7 := FindWindow(nil, 'ModemEngine-7');
  ME8 := FindWindow(nil, 'ModemEngine-8');
  if BE  <> 0 then PostMessage(BE,  WM_CLOSE, 0, 0);
  if ME1 <> 0 then PostMessage(ME1, WM_CLOSE, 0, 0);
  if ME2 <> 0 then PostMessage(ME2, WM_CLOSE, 0, 0);
  if ME3 <> 0 then PostMessage(ME3, WM_CLOSE, 0, 0);
  if ME4 <> 0 then PostMessage(ME4, WM_CLOSE, 0, 0);
  if ME5 <> 0 then PostMessage(ME5, WM_CLOSE, 0, 0);
  if ME6 <> 0 then PostMessage(ME6, WM_CLOSE, 0, 0);
  if ME7 <> 0 then PostMessage(ME7, WM_CLOSE, 0, 0);
  if ME8 <> 0 then PostMessage(ME8, WM_CLOSE, 0, 0);
  Application.Terminate;
end;

procedure TFLogin.FormShow(Sender: TObject);
var
  SMBios : TSMBios;
  LSystem: TSystemInformation;
  UUID   : Array[0..31] of AnsiChar;
  key1,key2,key3,key4 : string;

begin
  EUsername.Text:='';
  EPassword.Text:='';
  EUsername.SetFocus;
  // Instalation Key
  SMBios:=TSMBios.Create;
  try
    LSystem:=SMBios.SysInfo;
    BinToHex(@LSystem.RAWSystemInformation^.UUID,UUID,SizeOf(LSystem.RAWSystemInformation^.UUID));
    key1 := copy(LSystem.VersionStr,1,4);
    key2 := copy(LSystem.SerialNumberStr,1,4);
    key3 := copy(UUID,1,4);
    key4 := copy(GetVolumeID('C'),1,4);
    if (Trim(key1)='') then key1 := 'EQ1A';
    if (Trim(key2)='') then key2 := 'QS2B';
    if (Trim(key3)='') then key3 := 'SQ3C';
    if (Trim(key4)='') then key4 := 'QC4D';
    if DM.KoneksiDatabase.Connected=True then
    begin
    with DM.ZQRegister do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='update t_instalationkey set kunci1="'+GSMEncode7Bit(key1)+'",kunci2="'+GSMEncode7Bit(key2)+'",kunci3="'+GSMEncode7Bit(key3)+'",kunci4="'+GSMEncode7Bit(key4)+'" where id="1"';
    ExecSQL;
    SQL.Clear;
    SQL.Text:='select * from t_instalationkey';
    Open;
    end;
    end;
  finally
   SMBios.Free;
  end;
end;

procedure TFLogin.hakAkses(IdPengguna: string;Pilih:string);
begin
  // Cek Hak Akses
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_hak_akses where id_pengguna="'+IdPengguna+'"';
  Open;
  First;

  with FUtama do
  begin
  if FieldByName('dm_capres').AsString='Yes' then BDataCAPRES.Visible:=True else BDataCAPRES.Visible:=False;
  if FieldByName('dm_cagub').AsString='Yes' then BDataCAGUB.Visible:=True else BDataCAGUB.Visible:=False;
  if FieldByName('dm_cabup').AsString='Yes' then BDataCABUPKOTA.Visible:=True else BDataCABUPKOTA.Visible:=False;
  if FieldByName('dm_dpd').AsString='Yes' then BDataCALEGDPD.Visible:=True else BDataCALEGDPD.Visible:=False;
  if FieldByName('dm_dpr').AsString='Yes' then BDataCalegDPR.Visible:=True else BDataCalegDPR.Visible:=False;
  if FieldByName('dm_dprdprov').AsString='Yes' then BDataCalegDPRDProv.Visible:=True else BDataCalegDPRDProv.Visible:=False;
  if FieldByName('dm_dprdkab').AsString='Yes' then BDataCalegDPRDKabKota.Visible:=True else BDataCalegDPRDKabKota.Visible:=False;
  if FieldByName('dm_partai').AsString='Yes' then BDataPartai.Visible:=True else BDataPartai.Visible:=False;
  if FieldByName('dm_prov').AsString='Yes' then BDataProv.Visible:=True else BDataProv.Visible:=False;
  if FieldByName('dm_kab').AsString='Yes' then BDataKabKota.Visible:=True else BDataKabKota.Visible:=False;
  if FieldByName('dm_kec').AsString='Yes' then BDataKecamatan.Visible:=True else BDataKecamatan.Visible:=False;
  if FieldByName('dm_kel').AsString='Yes' then BDataKelDesa.Visible:=True else BDataKelDesa.Visible:=False;
  if FieldByName('dm_tps').AsString='Yes' then BDataTPS.Visible:=True else BDataTPS.Visible:=False;
  if FieldByName('dm_dapil').AsString='Yes' then BtDataDapil.Visible:=True else BtDataDapil.Visible:=False;
  if FieldByName('dm_dapilri').AsString='Yes' then BDapilRI.Visible:=True else BDapilRI.Visible:=False;
  if FieldByName('dm_dapilprov').AsString='Yes' then BDapilProvinsi.Visible:=True else BDapilProvinsi.Visible:=False;
  if FieldByName('dm_dapilkab').AsString='Yes' then BDapilKabKota.Visible:=True else BDapilKabKota.Visible:=False;
  if FieldByName('dk_timses').AsString='Yes' then BDataTimsesRelawan.Visible:=True else BDataTimsesRelawan.Visible:=False;
  if FieldByName('dk_saksi').AsString='Yes' then BDataSaksi.Visible:=True else BDataSaksi.Visible:=False;
  if FieldByName('dk_usulantimses').AsString='Yes' then BDataUsulanTimsesRelawan.Visible:=True else BDataUsulanTimsesRelawan.Visible:=False;
  if FieldByName('dk_dukungindependen').AsString='Yes' then BDataDukunganIndependen.Visible:=True else BDataDukunganIndependen.Visible:=False;
  if FieldByName('dk_polling').AsString='Yes' then BDataPolling.Visible:=True else BDataPolling.Visible:=False;
  if FieldByName('dk_usulsaran').AsString='Yes' then BDataUsulSaran.Visible:=True else BDataUsulSaran.Visible:=False;
  if FieldByName('dp_capres').AsString='Yes' then BPerhitunganCAPRES.Visible:=True else BPerhitunganCAPRES.Visible:=False;
  if FieldByName('dp_cagub').AsString='Yes' then BPerhitunganCAGUB.Visible:=True else BPerhitunganCAGUB.Visible:=False;
  if FieldByName('dp_cabup').AsString='Yes' then BPerhitunganCABUPKOTA.Visible:=True else BPerhitunganCABUPKOTA.Visible:=False;
  if FieldByName('dp_partai').AsString='Yes' then BPerhitunganPartai.Visible:=True else BPerhitunganPartai.Visible:=False;
  if FieldByName('dp_dpd').AsString='Yes' then BPerhitunganCALEGDPD.Visible:=True else BPerhitunganCALEGDPD.Visible:=False;
  if FieldByName('dp_dpr').AsString='Yes' then BPerhitunganCALEGDPR.Visible:=True else BPerhitunganCALEGDPR.Visible:=False;
  if FieldByName('dp_dprdprov').AsString='Yes' then BPerhitunganCALEGDPRDProv.Visible:=True else BPerhitunganCALEGDPRDProv.Visible:=False;
  if FieldByName('dp_dprdkab').AsString='Yes' then BPerhitunganCALEGDPRDKabKota.Visible:=True else BPerhitunganCALEGDPRDKabKota.Visible:=False;
  if FieldByName('gf_capres').AsString='Yes' then BGrafikCapres.Visible:=True else BGrafikCapres.Visible:=False;
  if FieldByName('gf_cagub').AsString='Yes' then BGrafikCAGUB.Visible:=True else BGrafikCAGUB.Visible:=False;
  if FieldByName('gf_cabup').AsString='Yes' then BGrafikCABUPKOTA.Visible:=True else BGrafikCABUPKOTA.Visible:=False;
  if FieldByName('gf_partai').AsString='Yes' then BGrafikPartai.Visible:=True else BGrafikPartai.Visible:=False;
  if FieldByName('gf_dpd').AsString='Yes' then BGrafikCALEGDPD.Visible:=True else BGrafikCALEGDPR.Visible:=False;
  if FieldByName('gf_dpr').AsString='Yes' then BGrafikCALEGDPR.Visible:=True else BGrafikCALEGDPR.Visible:=False;
  if FieldByName('gf_dprdprov').AsString='Yes' then BGrafikCALEGDPRDProv.Visible:=True else BGrafikCALEGDPRDProv.Visible:=False;
  if FieldByName('gf_dprdkab').AsString='Yes' then BGrafikCalegDPRDKabKota.Visible:=True else BGrafikCalegDPRDKabKota.Visible:=False;
  if FieldByName('ms_modem').AsString='Yes' then BSettingModem.Visible:=True else BSettingModem.Visible:=False;
  if FieldByName('ms_kirimsms').AsString='Yes' then BKirimSMS.Visible:=True else BKirimSMS.Visible:=False;
  if FieldByName('ms_smsmasuk').AsString='Yes' then BSMSMasuk.Visible:=True else BSMSMasuk.Visible:=False;
  if FieldByName('ms_smsterkirim').AsString='Yes' then BSMSTerkirim.Visible:=True else BSMSTerkirim.Visible:=False;
  if FieldByName('mt_bot').AsString='Yes' then BBotSetting.Visible:=True else BBotSetting.Visible:=False;
  if FieldByName('mt_kirimpesan').AsString='Yes' then BChatting.Visible:=True else BChatting.Visible:=False;
  if FieldByName('mt_chatmasuk').AsString='Yes' then BChatMasuk.Visible:=True else BChatMasuk.Visible:=False;
  if FieldByName('mt_chatterkirim').AsString='Yes' then BChatTerkirim.Visible:=True else BChatTerkirim.Visible:=False;
  if FieldByName('pg_pengguna').AsString='Yes' then BDataPengguna.Visible:=True else BDataPengguna.Visible:=False;
  if FieldByName('pg_identitas').AsString='Yes' then BIdentitasLembaga.Visible:=True else BIdentitasLembaga.Visible:=False;
  if FieldByName('pg_pengaturan').AsString='Yes' then BPengaturanAplikasi.Visible:=True else BPengaturanAplikasi.Visible:=False;
  if FieldByName('pg_format').AsString='Yes' then BSMSChatAutoRespond.Visible:=True else BSMSChatAutoRespond.Visible:=False;
  if FieldByName('pg_backup').AsString='Yes' then BBackupDatabase.Visible:=True else BBackupDatabase.Visible:=False;
  if FieldByName('pg_restore').AsString='Yes' then BRestoreDatabase.Visible:=True else BRestoreDatabase.Visible:=False;
  if FieldByName('bn_bantuan').AsString='Yes' then BBantuan.Visible:=True else BBantuan.Visible:=False;
  if FieldByName('dm_cakades').AsString='Yes' then BDataCaKades.Visible:=True else BDataCaKades.Visible:=False;
  if FieldByName('dp_cakades').AsString='Yes' then BPerhitunganKades.Visible:=True else BPerhitunganKades.Visible:=False;
  if FieldByName('gf_cakades').AsString='Yes' then BGrafikKades.Visible:=True else BGrafikKades.Visible:=False;

  if FieldByName('dk_dpt').AsString='Yes' then BPemilih.Visible:=True else BPemilih.Checked:=False;
  if FieldByName('dk_peta').AsString='Yes' then BPerkiraan.Visible:=True else BPerkiraan.Checked:=False;
  if FieldByName('dk_gpeta').AsString='Yes' then BGRafikPeta.Visible:=True else BGRafikPeta.Checked:=False;

  // Sembunyikan Panel
  if (BDataCAPRES.Visible=False) and (BDataCAGUB.Visible=False) and (BDataCABUPKOTA.Visible=False) and (BDataCALEGDPD.Visible=False) and
  (BDataCALEGDPR.Visible=False) and (BDataCALEGDPRDProv.Visible=False) and (BDataCALEGDPRDKabKota.Visible=False) and (BDataCaKades.Visible=False)  then
  PanelDataMasterCalon.Visible:=False;
  if (BDataPartai.Visible=False) and (BDataProv.Visible=False) and (BDataKabKota.Visible=False) and (BDataKecamatan.Visible=False) and (BDataKelDesa.Visible=False) and (BDataTPS.Visible=False) then
  PanelDataMaster.Visible:=False;
  if (BtDataDapil.Visible=False) and (BDapilRI.Visible=False) and (BDapilProvinsi.Visible=False) and (BDapilKabKota.Visible=False) then
  PanelDapil.Visible:=False;
  if (BDataTimsesRelawan.Visible=False) and (BDataSaksi.Visible=False) and (BDataUsulanTimsesRelawan.Visible=False) and (BDataDukunganIndependen.Visible=False) and (BDataPolling.Visible=False) and (BDataUsulSaran.Visible=False) then
  PanelDataKampanye.Visible:=False;
  if (BPerhitunganCAPRES.Visible=False) and (BPerhitunganCAGUB.Visible=False) and (BPerhitunganCABUPKOTA.Visible=False) and (BPerhitunganCALEGDPD.Visible=False) and (BPerhitunganPartai.Visible=False) and
     (BPerhitunganCALEGDPR.Visible=False) and (BPerhitunganCALEGDPRDProv.Visible=False) and (BPerhitunganCALEGDPRDKabKota.Visible=False) and (BPerhitunganKades.Visible=False) then
  PanelDataPerhitunganCepat.Visible:=False;
  if (BGrafikCapres.Visible=False) and (BGrafikCAGUB.Visible=False) and (BGrafikCABUPKOTA.Visible=False) and (BGrafikCALEGDPD.Visible=False) and (BGrafikPartai.Visible=False) and
     (BGrafikCalegDPR.Visible=False) and (BGrafikCalegDPRDProv.Visible=False) and (BGrafikCalegDPRDKabKota.Visible=False) and (BGrafikKades.Visible=False) then
  PanelGrafikPerhitungan.Visible:=False;
  if (BSettingModem.Visible=False) and (BKirimSMS.Visible=False) then
  PanelModulSMS.Visible:=False;
  if (BSMSMasuk.Visible=False) and (BSMSTerkirim.Visible=False) then
  PanelDataSMS.Visible:=False;
  if (BBotSetting.Visible=False) and (BChatting.Visible=False) then
  PanelModulTelegram.Visible:=False;
  if (BChatMasuk.Visible=False) and (BChatTerkirim.Visible=False) then
  PanelDataChat.Visible:=False;
  if (BDataPengguna.Visible=False) and (BIdentitasLembaga.Visible=False) and (BPengaturanAplikasi.Visible=False) and (BSMSChatAutoRespond.Visible=False) then
  PanelPengaturan.Visible:=False;
  if (BBackupDatabase.Visible=False) and (BRestoreDatabase.Visible=False) then
  PanelTools.Visible:=False;
  if (BBantuan.Visible=False) then
  PanelBantuan.Visible:=False;
  if (BPemilih.Visible=False) then PanelDPT.Visible:=False;
  if (BPerkiraan.Visible=False) and (BGRafikPeta.Visible=False) then
    PanelPeta.Visible:=False;
  // Sembunyikan Menu
  if (PanelDataMasterCalon.Visible=False) and (PanelDataMaster.Visible=False) and (PanelDapil.Visible=False) then
  SubMenuDataMaster.Visible:=False;
  if (PanelDataKampanye.Visible=False) and (PanelDPT.Visible=False) and (PanelPeta.Visible=False) then
  SubMenuDataKampanye.Visible:=False;
  if (PanelDataPerhitunganCepat.Visible=False) then
  SubMenuDataPerhitungan.Visible:=False;
  if (PanelGrafikPerhitungan.Visible=False) then
  SubMenuGrafikPerhitungan.Visible:=False;
  if (PanelModulSMS.Visible=False) and (PanelDataSMS.Visible=False) then
  SubMenuModulSMS.Visible:=False;
  if (PanelModulTelegram.Visible=False) and (PanelDataChat.Visible=False) then
  SubMenuModulTelegram.Visible:=False;
  if (PanelPengaturan.Visible=False) and (PanelTools.Visible=False) then
  SubMenuPengaturan.Visible:=False;
  // Combobox
  if (Pilih='PILPRES') then
      begin
      BGrafikKades.Visible:=False;
      BPerhitunganKades.Visible:=False;
      BDataCaKades.Visible:=False;
      FPengaturan.EPilkades.Visible:=False;
      FPengaturan.EPartai.Visible:=False;
      FPengaturan.EPilgub.Visible:=False;
      FPengaturan.EPilbupKota.Visible:=False;
      FPengaturan.EPilegDPD.Visible:=False;
      FPengaturan.EPilegDPR.Visible:=False;
      FPengaturan.EPilegKabKota.Visible:=False;
      FPengaturan.EPilegProv.Visible:=False;
      BGrafikCalegDPRDKabKota.Visible:=False;
      BGrafikCalegDPRDProv.Visible:=False;
      BGrafikCalegDPR.Visible:=False;
      BGrafikCALEGDPD.Visible:=False;
      BGrafikCABUPKOTA.Visible:=False;
      BGrafikCAGUB.Visible:=False;
      BGrafikPartai.Visible:=False;
      BPerhitunganCALEGDPR.Visible:=False;
      BPerhitunganCALEGDPD.Visible:=False;
      BPerhitunganCALEGDPRDKabKota.Visible:=False;
      BPerhitunganCALEGDPRDProv.Visible:=False;
      BPerhitunganCABUPKOTA.Visible:=False;
      BPerhitunganCAGUB.Visible:=False;
      BPerhitunganPartai.Visible:=False;
      BDataCAGUB.Visible:=False;
      BDataCABUPKOTA.Visible:=False;
      BDataCALEGDPD.Visible:=False;
      BDataCALEGDPR.Visible:=False;
      BDataCALEGDPRDProv.Visible:=False;
      BDataCALEGDPRDKabKota.Visible:=False;
      BDataPartai.Visible:=False;
      PanelDapil.Visible:=False;
      SubMenuSainte.Visible:=False;
      end;
  if (Pilih='PILGUB') then
     begin
     BGrafikKades.Visible:=False;
     BPerhitunganKades.Visible:=False;
     BDataCaKades.Visible:=False;
     FPengaturan.EPilkades.Visible:=False;
     FPengaturan.EPartai.Visible:=False;
     FPengaturan.EPilpres.Visible:=False;
     FPengaturan.EPilbupKota.Visible:=False;
     FPengaturan.EPilegDPD.Visible:=False;
     FPengaturan.EPilegDPR.Visible:=False;
     FPengaturan.EPilegKabKota.Visible:=False;
     FPengaturan.EPilegProv.Visible:=False;
     BGrafikCalegDPRDKabKota.Visible:=False;
     BGrafikCalegDPRDProv.Visible:=False;
     BGrafikCalegDPR.Visible:=False;
     BGrafikCALEGDPD.Visible:=False;
     BGrafikCABUPKOTA.Visible:=False;
     BGrafikCapres.Visible:=False;
     BGrafikPartai.Visible:=False;
     BPerhitunganCALEGDPR.Visible:=False;
     BPerhitunganCALEGDPD.Visible:=False;
     BPerhitunganCALEGDPRDKabKota.Visible:=False;
     BPerhitunganCALEGDPRDProv.Visible:=False;
     BPerhitunganCABUPKOTA.Visible:=False;
     BPerhitunganCAPRES.Visible:=False;
     BPerhitunganPartai.Visible:=False;
     BDataCAPRES.Visible:=False;
     BDataCABUPKOTA.Visible:=False;
     BDataCALEGDPD.Visible:=False;
     BDataCALEGDPR.Visible:=False;
     BDataCALEGDPRDProv.Visible:=False;
     BDataCALEGDPRDKabKota.Visible:=False;
     BDataPartai.Visible:=False;
     PanelDapil.Visible:=False;
     SubMenuSainte.Visible:=False;
     end;
  if (Pilih='PILBUP/PILWALKOT') then
     begin
     BGrafikKades.Visible:=False;
     BPerhitunganKades.Visible:=False;
     BDataCaKades.Visible:=False;
     FPengaturan.EPilkades.Visible:=False;
     FPengaturan.EPartai.Visible:=False;
     FPengaturan.EPilgub.Visible:=False;
     FPengaturan.EPilpres.Visible:=False;
     FPengaturan.EPilegDPD.Visible:=False;
     FPengaturan.EPilegDPR.Visible:=False;
     FPengaturan.EPilegKabKota.Visible:=False;
     FPengaturan.EPilegProv.Visible:=False;
     BGrafikCalegDPRDKabKota.Visible:=False;
     BGrafikCalegDPRDProv.Visible:=False;
     BGrafikCalegDPR.Visible:=False;
     BGrafikCALEGDPD.Visible:=False;
     BGrafikCapres.Visible:=False;
     BGrafikCAGUB.Visible:=False;
     BGrafikPartai.Visible:=False;
     BPerhitunganCALEGDPR.Visible:=False;
     BPerhitunganCALEGDPD.Visible:=False;
     BPerhitunganCALEGDPRDKabKota.Visible:=False;
     BPerhitunganCALEGDPRDProv.Visible:=False;
     BPerhitunganCAPRES.Visible:=False;
     BPerhitunganCAGUB.Visible:=False;
     BPerhitunganPartai.Visible:=False;
     BDataCAGUB.Visible:=False;
     BDataCAPRES.Visible:=False;
     BDataCALEGDPD.Visible:=False;
     BDataCALEGDPR.Visible:=False;
     BDataCALEGDPRDProv.Visible:=False;
     BDataCALEGDPRDKabKota.Visible:=False;
     BDataPartai.Visible:=False;
     PanelDapil.Visible:=False;
     SubMenuSainte.Visible:=False;
     end;
  if (Pilih='PILEG DPD RI') then
     begin
     BGrafikKades.Visible:=False;
     BPerhitunganKades.Visible:=False;
     BDataCaKades.Visible:=False;
     FPengaturan.EPilkades.Visible:=False;
     FPengaturan.EPartai.Visible:=False;
     FPengaturan.EPilgub.Visible:=False;
     FPengaturan.EPilbupKota.Visible:=False;
     FPengaturan.EPilpres.Visible:=False;
     FPengaturan.EPilegDPR.Visible:=False;
     FPengaturan.EPilegKabKota.Visible:=False;
     FPengaturan.EPilegProv.Visible:=False;
     BGrafikCalegDPRDKabKota.Visible:=False;
     BGrafikCalegDPRDProv.Visible:=False;
     BGrafikCalegDPR.Visible:=False;
     BGrafikCapres.Visible:=False;
     BGrafikCABUPKOTA.Visible:=False;
     BGrafikCAGUB.Visible:=False;
     BGrafikPartai.Visible:=False;
     BPerhitunganCALEGDPR.Visible:=False;
     BPerhitunganCAPRES.Visible:=False;
     BPerhitunganCALEGDPRDKabKota.Visible:=False;
     BPerhitunganCALEGDPRDProv.Visible:=False;
     BPerhitunganCABUPKOTA.Visible:=False;
     BPerhitunganCAGUB.Visible:=False;
     BPerhitunganPartai.Visible:=False;
     BDataCAGUB.Visible:=False;
     BDataCABUPKOTA.Visible:=False;
     BDataCAPRES.Visible:=False;
     BDataCALEGDPR.Visible:=False;
     BDataCALEGDPRDProv.Visible:=False;
     BDataCALEGDPRDKabKota.Visible:=False;
     BDataPartai.Visible:=False;
     BDapilKabKota.Visible:=False;
     BDapilProvinsi.Visible:=False;
     PanelDapil.Visible:=False;
     SubMenuSainte.Visible:=False;
     end;
  if (Pilih='PILEG DPR RI') then
     begin
     LKategori.Caption:='DPR RI';
     BGrafikKades.Visible:=False;
     BPerhitunganKades.Visible:=False;
     BDataCaKades.Visible:=False;
     FPengaturan.EPilkades.Visible:=False;
     FPengaturan.EPartai.Visible:=False;
     FPengaturan.EPilgub.Visible:=False;
     FPengaturan.EPilbupKota.Visible:=False;
     FPengaturan.EPilegDPD.Visible:=False;
     FPengaturan.EPilpres.Visible:=False;
     FPengaturan.EPilegKabKota.Visible:=False;
     FPengaturan.EPilegProv.Visible:=False;
     BGrafikCalegDPRDKabKota.Visible:=False;
     BGrafikCalegDPRDProv.Visible:=False;
     BGrafikCalegDPD.Visible:=False;
     BGrafikCapres.Visible:=False;
     BGrafikCABUPKOTA.Visible:=False;
     BGrafikCAGUB.Visible:=False;
     BPerhitunganCALEGDPD.Visible:=False;
     BPerhitunganCAPRES.Visible:=False;
     BPerhitunganCALEGDPRDKabKota.Visible:=False;
     BPerhitunganCALEGDPRDProv.Visible:=False;
     BPerhitunganCABUPKOTA.Visible:=False;
     BPerhitunganCAGUB.Visible:=False;
     BDataCAGUB.Visible:=False;
     BDataCABUPKOTA.Visible:=False;
     BDataCAPRES.Visible:=False;
     BDataCALEGDPD.Visible:=False;
     BDataCALEGDPRDProv.Visible:=False;
     BDataCALEGDPRDKabKota.Visible:=False;
     BDapilKabKota.Visible:=False;
     BDapilProvinsi.Visible:=False;
     end;
  if (Pilih='PILEG DPRD PROVINSI') then
     begin
     LKategori.Caption:='DPRD Provinsi';
     BGrafikKades.Visible:=False;
     BPerhitunganKades.Visible:=False;
     BDataCaKades.Visible:=False;
     FPengaturan.EPilkades.Visible:=False;
     FPengaturan.EPartai.Visible:=False;
     FPengaturan.EPilgub.Visible:=False;
     FPengaturan.EPilbupKota.Visible:=False;
     FPengaturan.EPilegDPD.Visible:=False;
     FPengaturan.EPilegDPR.Visible:=False;
     FPengaturan.EPilegKabKota.Visible:=False;
     FPengaturan.EPilpres.Visible:=False;
     BGrafikCalegDPRDKabKota.Visible:=False;
     BGrafikCalegDPR.Visible:=False;
     BGrafikCalegDPD.Visible:=False;
     BGrafikCapres.Visible:=False;
     BGrafikCABUPKOTA.Visible:=False;
     BGrafikCAGUB.Visible:=False;
     BPerhitunganCALEGDPD.Visible:=False;
     BPerhitunganCAPRES.Visible:=False;
     BPerhitunganCALEGDPRDKabKota.Visible:=False;
     BPerhitunganCALEGDPR.Visible:=False;
     BPerhitunganCABUPKOTA.Visible:=False;
     BPerhitunganCAGUB.Visible:=False;
     BDataCAGUB.Visible:=False;
     BDataCABUPKOTA.Visible:=False;
     BDataCAPRES.Visible:=False;
     BDataCALEGDPD.Visible:=False;
     BDataCALEGDPR.Visible:=False;
     BDataCALEGDPRDKabKota.Visible:=False;
     BDapilKabKota.Visible:=False;
     BDapilRI.Visible:=False;
     end;
  if (Pilih='PILEG DPRD KABUPATEN/KOTA') then
     begin
     LKategori.Caption:='DPRD Kabupaten/Kota';
     BGrafikKades.Visible:=False;
     BPerhitunganKades.Visible:=False;
     BDataCaKades.Visible:=False;
     FPengaturan.EPilkades.Visible:=False;
     FPengaturan.EPartai.Visible:=False;
     FPengaturan.EPilgub.Visible:=False;
     FPengaturan.EPilbupKota.Visible:=False;
     FPengaturan.EPilegDPD.Visible:=False;
     FPengaturan.EPilegDPR.Visible:=False;
     FPengaturan.EPilpres.Visible:=False;
     FPengaturan.EPilegProv.Visible:=False;
     BGrafikCalegDPR.Visible:=False;
     BGrafikCalegDPRDProv.Visible:=False;
     BGrafikCalegDPD.Visible:=False;
     BGrafikCapres.Visible:=False;
     BGrafikCABUPKOTA.Visible:=False;
     BGrafikCAGUB.Visible:=False;
     BPerhitunganCALEGDPD.Visible:=False;
     BPerhitunganCAPRES.Visible:=False;
     BPerhitunganCALEGDPR.Visible:=False;
     BPerhitunganCALEGDPRDProv.Visible:=False;
     BPerhitunganCABUPKOTA.Visible:=False;
     BPerhitunganCAGUB.Visible:=False;
     BDataCAGUB.Visible:=False;
     BDataCABUPKOTA.Visible:=False;
     BDataCAPRES.Visible:=False;
     BDataCALEGDPD.Visible:=False;
     BDataCALEGDPRDProv.Visible:=False;
     BDataCALEGDPR.Visible:=False;
     BDapilRI.Visible:=False;
     BDapilProvinsi.Visible:=False;
     end;
  if (Pilih='PARTAI') then
     begin
     BGrafikKades.Visible:=False;
     BPerhitunganKades.Visible:=False;
     BDataCaKades.Visible:=False;
     FPengaturan.EPilkades.Visible:=False;
     FPengaturan.EPilpres.Visible:=False;
     FPengaturan.EPilgub.Visible:=False;
     FPengaturan.EPilbupKota.Visible:=False;
     FPengaturan.EPilegDPD.Visible:=False;
     FPengaturan.EPilegDPR.Visible:=False;
     FPengaturan.EPilegKabKota.Visible:=False;
     FPengaturan.EPilegProv.Visible:=False;
     BGrafikCalegDPRDKabKota.Visible:=False;
     BGrafikCalegDPRDProv.Visible:=False;
     BGrafikCalegDPR.Visible:=False;
     BGrafikCALEGDPD.Visible:=False;
     BGrafikCABUPKOTA.Visible:=False;
     BGrafikCAGUB.Visible:=False;
     BGrafikCapres.Visible:=False;
     BPerhitunganCALEGDPR.Visible:=False;
     BPerhitunganCALEGDPD.Visible:=False;
     BPerhitunganCALEGDPRDKabKota.Visible:=False;
     BPerhitunganCALEGDPRDProv.Visible:=False;
     BPerhitunganCABUPKOTA.Visible:=False;
     BPerhitunganCAGUB.Visible:=False;
     BPerhitunganCAPRES.Visible:=False;
     BDataCAGUB.Visible:=False;
     BDataCAPRES.Visible:=False;
     BDataCABUPKOTA.Visible:=False;
     BDataCALEGDPD.Visible:=False;
     BDataCALEGDPR.Visible:=False;
     BDataCALEGDPRDProv.Visible:=False;
     BDataCALEGDPRDKabKota.Visible:=False;
     PanelDapil.Visible:=False;
     PanelDataMasterCalon.Visible:=False;
     end;
  if (Pilih='PILKADES') then
      begin
      BGrafikCapres.Visible:=False;
      BPerhitunganCAPRES.Visible:=False;
      BDataCAPRES.Visible:=False;
      FPengaturan.EPilpres.Visible:=False;
      FPengaturan.EPartai.Visible:=False;
      FPengaturan.EPilgub.Visible:=False;
      FPengaturan.EPilbupKota.Visible:=False;
      FPengaturan.EPilegDPD.Visible:=False;
      FPengaturan.EPilegDPR.Visible:=False;
      FPengaturan.EPilegKabKota.Visible:=False;
      FPengaturan.EPilegProv.Visible:=False;
      BGrafikCalegDPRDKabKota.Visible:=False;
      BGrafikCalegDPRDProv.Visible:=False;
      BGrafikCalegDPR.Visible:=False;
      BGrafikCALEGDPD.Visible:=False;
      BGrafikCABUPKOTA.Visible:=False;
      BGrafikCAGUB.Visible:=False;
      BGrafikPartai.Visible:=False;
      BPerhitunganCALEGDPR.Visible:=False;
      BPerhitunganCALEGDPD.Visible:=False;
      BPerhitunganCALEGDPRDKabKota.Visible:=False;
      BPerhitunganCALEGDPRDProv.Visible:=False;
      BPerhitunganCABUPKOTA.Visible:=False;
      BPerhitunganCAGUB.Visible:=False;
      BPerhitunganPartai.Visible:=False;
      BDataCAGUB.Visible:=False;
      BDataCABUPKOTA.Visible:=False;
      BDataCALEGDPD.Visible:=False;
      BDataCALEGDPR.Visible:=False;
      BDataCALEGDPRDProv.Visible:=False;
      BDataCALEGDPRDKabKota.Visible:=False;
      BDataPartai.Visible:=False;
      PanelDapil.Visible:=False;
      SubMenuSainte.Visible:=False;
      end;
  end; // End FUtama

  end;
end;

end.

