unit uhakakses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ComCtrls, udatamodule, Types;

type

  { TFHakAkses }

  TFHakAkses = class(TForm)
    BSimpan: TBitBtn;
    dk_dpt: TCheckBox;
    dk_petasuara: TCheckBox;
    dk_gpeta: TCheckBox;
    dm_kades: TCheckBox;
    dm_capres: TCheckBox;
    dm_dapilprov: TCheckBox;
    dp_kades: TCheckBox;
    gf_kades: TCheckBox;
    dm_kel: TCheckBox;
    dm_tps: TCheckBox;
    dm_prov: TCheckBox;
    dm_partai: TCheckBox;
    dm_cabup: TCheckBox;
    dm_dpd: TCheckBox;
    dm_dpr: TCheckBox;
    dk_timses: TCheckBox;
    dk_usulantimses: TCheckBox;
    dm_dprdprov: TCheckBox;
    dk_polling: TCheckBox;
    dk_usulsaran: TCheckBox;
    dk_saksi: TCheckBox;
    dk_dukungindependen: TCheckBox;
    dp_dpd: TCheckBox;
    dp_dprdprov: TCheckBox;
    dp_dprdkab: TCheckBox;
    dp_dpr: TCheckBox;
    dp_partai: TCheckBox;
    dp_cabup: TCheckBox;
    dm_kab: TCheckBox;
    dp_capres: TCheckBox;
    dp_cagub: TCheckBox;
    gf_dpd: TCheckBox;
    gf_dprdprov: TCheckBox;
    gf_dprdkab: TCheckBox;
    gf_dpr: TCheckBox;
    gf_partai: TCheckBox;
    gf_cabup: TCheckBox;
    gf_capres: TCheckBox;
    gf_cagub: TCheckBox;
    dm_dapil: TCheckBox;
    LID: TLabel;
    ms_smsmasuk: TCheckBox;
    ms_smsterkirim: TCheckBox;
    mt_chatmasuk: TCheckBox;
    mt_chatterkirim: TCheckBox;
    pg_pengguna: TCheckBox;
    ms_kirimsms: TCheckBox;
    ms_modem: TCheckBox;
    mt_bot: TCheckBox;
    mt_kirimpesan: TCheckBox;
    pg_pengaturan: TCheckBox;
    dm_dapilri: TCheckBox;
    pg_backup: TCheckBox;
    pg_restore: TCheckBox;
    pg_format: TCheckBox;
    pg_identitas: TCheckBox;
    bn_bantuan: TCheckBox;
    bn_update: TCheckBox;
    dm_kec: TCheckBox;
    dm_dprdkab: TCheckBox;
    dm_cagub: TCheckBox;
    dm_dapilkab: TCheckBox;
    PageAkses: TPageControl;
    PAtas: TPanel;
    PAtasNama: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    DataMaster: TTabSheet;
    DataKampanye: TTabSheet;
    DataPerhitungan: TTabSheet;
    GrafikPerhitungan: TTabSheet;
    ModulSMS: TTabSheet;
    ModulTelegram: TTabSheet;
    Pengaturan: TTabSheet;
    Bantuan: TTabSheet;
    procedure BSimpanClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure setCheck(idx:integer);
  end;

var
  FHakAkses: TFHakAkses;

implementation

{$R *.lfm}

{ TFHakAkses }

procedure TFHakAkses.BSimpanClick(Sender: TObject);
var
  dm_capres_v : string;
  dm_cagub_v : string;
  dm_cabup_v : string;
  dm_dpd_v : string;
  dm_dpr_v : string;
  dm_dprdprov_v : string;
  dm_dprdkab_v : string;
  dm_partai_v : string;
  dm_prov_v : string;
  dm_kab_v : string;
  dm_kec_v : string;
  dm_kel_v : string;
  dm_tps_v : string;
  dm_dapil_v : string;
  dm_dapilri_v : string;
  dm_dapilprov_v : string;
  dm_dapilkab_v : string;
  dk_timses_v : string;
  dk_saksi_v : string;
  dk_usulantimses_v : string;
  dk_dukungindependen_v : string;
  dk_polling_v : string;
  dk_usulsaran_v : string;
  dp_capres_v : string;
  dp_cagub_v : string;
  dp_cabup_v : string;
  dp_partai_v : string;
  dp_dpd_v : string;
  dp_dpr_v : string;
  dp_dprdprov_v : string;
  dp_dprdkab_v : string;
  gf_capres_v : string;
  gf_cagub_v : string;
  gf_cabup_v : string;
  gf_partai_v : string;
  gf_dpd_v : string;
  gf_dpr_v : string;
  gf_dprdprov_v : string;
  gf_dprdkab_v : string;
  ms_modem_v : string;
  ms_kirimsms_v : string;
  ms_smsmasuk_v : string;
  ms_smsterkirim_v : string;
  mt_bot_v : string;
  mt_kirimpesan_v : string;
  mt_chatmasuk_v : string;
  mt_chatterkirim_v : string;
  pg_pengguna_v : string;
  pg_identitas_v : string;
  pg_pengaturan_v : string;
  pg_format_v : string;
  pg_backup_v : string;
  pg_restore_v : string;
  bn_bantuan_v : string;
  bn_update_v : string;
  dm_kades_v : string;
  dp_kades_v : string;
  gf_kades_v : string;
  dk_dpt_v : string;
  dk_peta_v : string;
  dk_gpeta_v : string;
begin
  if dm_capres.Checked=True then dm_capres_v :='Yes' else dm_capres_v :='No';
  if dm_cagub.Checked=True then dm_cagub_v := 'Yes' else dm_cagub_v:='No';
  if dm_cabup.Checked=True then dm_cabup_v := 'Yes' else dm_cabup_v:='No';
  if dm_dpd.Checked=True then dm_dpd_v := 'Yes' else dm_dpd_v:='No';
  if dm_dpr.Checked=True then dm_dpr_v := 'Yes' else dm_dpr_v:='No';
  if dm_dprdprov.Checked=True then dm_dprdprov_v := 'Yes' else dm_dprdprov_v:='No';
  if dm_dprdkab.Checked=True then dm_dprdkab_v := 'Yes' else dm_dprdkab_v:='No';
  if dm_partai.Checked=True then dm_partai_v := 'Yes' else dm_partai_v:='No';
  if dm_prov.Checked=True then dm_prov_v := 'Yes' else dm_prov_v:='No';
  if dm_kab.Checked=True then dm_kab_v := 'Yes' else dm_kab_v:='No';
  if dm_kec.Checked=True then dm_kec_v := 'Yes' else dm_kec_v:='No';
  if dm_kel.Checked=True then dm_kel_v := 'Yes' else dm_kel_v:='No';
  if dm_tps.Checked=True then dm_tps_v := 'Yes' else dm_tps_v:='No';
  if dm_dapil.Checked=True then dm_dapil_v := 'Yes' else dm_dapil_v:='No';
  if dm_dapilri.Checked=True then dm_dapilri_v := 'Yes' else dm_dapilri_v:='No';
  if dm_dapilprov.Checked=True then dm_dapilprov_v := 'Yes' else dm_dapilprov_v:='No';
  if dm_dapilkab.Checked=True then dm_dapilkab_v := 'Yes' else dm_dapilkab_v:='No';
  if dk_timses.Checked=True then dk_timses_v := 'Yes' else dk_timses_v:='No';
  if dk_saksi.Checked=True then dk_saksi_v := 'Yes' else dk_saksi_v:='No';
  if dk_usulantimses.Checked=True then dk_usulantimses_v := 'Yes' else dk_usulantimses_v:='No';
  if dk_dukungindependen.Checked=True then dk_dukungindependen_v := 'Yes' else dk_dukungindependen_v:='No';
  if dk_polling.Checked=True then dk_polling_v := 'Yes' else dk_polling_v:='No';
  if dk_usulsaran.Checked=True then dk_usulsaran_v := 'Yes' else dk_usulsaran_v:='No';
  if dp_capres.Checked=True then dp_capres_v := 'Yes' else dp_capres_v:='No';
  if dp_cagub.Checked=True then dp_cagub_v := 'Yes' else dp_cagub_v:='No';
  if dp_cabup.Checked=True then dp_cabup_v := 'Yes' else dp_cabup_v:='No';
  if dp_partai.Checked=True then dp_partai_v := 'Yes' else dp_partai_v:='No';
  if dp_dpd.Checked=True then dp_dpd_v := 'Yes' else dp_dpd_v:='No';
  if dp_dpr.Checked=True then dp_dpr_v := 'Yes' else dp_dpr_v:='No';
  if dp_dprdprov.Checked=True then dp_dprdprov_v := 'Yes' else dp_dprdprov_v:='No';
  if dp_dprdkab.Checked=True then dp_dprdkab_v := 'Yes' else dp_dprdkab_v:='No';
  if gf_capres.Checked=True then gf_capres_v := 'Yes' else gf_capres_v:='No';
  if gf_cagub.Checked=True then gf_cagub_v := 'Yes' else gf_cagub_v:='No';
  if gf_cabup.Checked=True then gf_cabup_v := 'Yes' else gf_cabup_v:='No';
  if gf_partai.Checked=True then gf_partai_v := 'Yes' else gf_partai_v:='No';
  if gf_dpd.Checked=True then gf_dpd_v := 'Yes' else gf_dpd_v:='No';
  if gf_dpr.Checked=True then gf_dpr_v := 'Yes' else gf_dpr_v:='No';
  if gf_dprdprov.Checked=True then gf_dprdprov_v := 'Yes' else gf_dprdprov_v:='No';
  if gf_dprdkab.Checked=True then gf_dprdkab_v := 'Yes' else gf_dprdkab_v:='No';
  if ms_modem.Checked=True then ms_modem_v := 'Yes' else ms_modem_v:='No';
  if ms_kirimsms.Checked=True then ms_kirimsms_v := 'Yes' else ms_kirimsms_v:='No';
  if ms_smsmasuk.Checked=True then ms_smsmasuk_v := 'Yes' else ms_smsmasuk_v:='No';
  if ms_smsterkirim.Checked=True then ms_smsterkirim_v := 'Yes' else ms_smsterkirim_v:='No';
  if mt_bot.Checked=True then mt_bot_v := 'Yes' else mt_bot_v:='No';
  if mt_kirimpesan.Checked=True then mt_kirimpesan_v := 'Yes' else mt_kirimpesan_v:='No';
  if mt_chatmasuk.Checked=True then mt_chatmasuk_v := 'Yes' else mt_chatmasuk_v:='No';
  if mt_chatterkirim.Checked=True then mt_chatterkirim_v := 'Yes' else mt_chatterkirim_v:='No';
  if pg_pengguna.Checked=True then pg_pengguna_v := 'Yes' else pg_pengguna_v:='No';
  if pg_identitas.Checked=True then pg_identitas_v := 'Yes' else pg_identitas_v:='No';
  if pg_pengaturan.Checked=True then pg_pengaturan_v := 'Yes' else pg_pengaturan_v:='No';
  if pg_format.Checked=True then pg_format_v := 'Yes' else pg_format_v:='No';
  if pg_backup.Checked=True then pg_backup_v := 'Yes' else pg_backup_v:='No';
  if pg_restore.Checked=True then pg_restore_v := 'Yes' else pg_restore_v:='No';
  if bn_bantuan.Checked=True then bn_bantuan_v := 'Yes' else bn_bantuan_v:='No';
  if bn_update.Checked=True then bn_update_v := 'Yes' else bn_update_v:='No';
  if dm_kades.Checked=True then dm_kades_v := 'Yes' else dm_kades_v:='No';
  if dp_kades.Checked=True then dp_kades_v := 'Yes' else dp_kades_v:='No';
  if gf_kades.Checked=True then gf_kades_v := 'Yes' else gf_kades_v:='No';

  if dk_dpt.Checked=True then dk_dpt_v := 'Yes' else dk_dpt_v:='No';
  if dk_petasuara.Checked=True then dk_peta_v := 'Yes' else dk_peta_v:='No';
  if dk_gpeta.Checked=True then dk_gpeta_v := 'Yes' else dk_gpeta_v:='No';

  with DM.ZQCari3 do
   begin
     Close;
     SQL.Clear;
     SQL.Text:='update t_hak_akses set '+
                                       'dm_capres="'+dm_capres_v+'",'+
                                       'dm_cagub="'+dm_cagub_v+'",'+
                                       'dm_cabup="'+dm_cabup_v+'",'+
                                       'dm_dpd="'+dm_dpd_v+'",'+
                                       'dm_dpr="'+dm_dpr_v+'",'+
                                       'dm_dprdprov="'+dm_dprdprov_v+'",'+
                                       'dm_dprdkab="'+dm_dprdkab_v+'",'+
                                       'dm_partai="'+dm_partai_v+'",'+
                                       'dm_prov="'+dm_prov_v+'",'+
                                       'dm_kab="'+dm_kab_v+'",'+
                                       'dm_kec="'+dm_kec_v+'",'+
                                       'dm_kel="'+dm_kel_v+'",'+
                                       'dm_tps="'+dm_tps_v+'",'+
                                       'dm_dapil="'+dm_dapil_v+'",'+
                                       'dm_dapilri="'+dm_dapilri_v+'",'+
                                       'dm_dapilprov="'+dm_dapilprov_v+'",'+
                                       'dm_dapilkab="'+dm_dapilkab_v+'",'+
                                       'dk_timses="'+dk_timses_v+'",'+
                                       'dk_saksi="'+dk_saksi_v+'",'+
                                       'dk_usulantimses="'+dk_usulantimses_v+'",'+
                                       'dk_dukungindependen="'+dk_dukungindependen_v+'",'+
                                       'dk_polling="'+dk_polling_v+'",'+
                                       'dk_usulsaran="'+dk_usulsaran_v+'",'+
                                       'dp_capres="'+dp_capres_v+'",'+
                                       'dp_cagub="'+dp_cagub_v+'",'+
                                       'dp_cabup="'+dp_cabup_v+'",'+
                                       'dp_partai="'+dp_partai_v+'",'+
                                       'dp_dpd="'+dp_dpd_v+'",'+
                                       'dp_dpr="'+dp_dpr_v+'",'+
                                       'dp_dprdprov="'+dp_dprdprov_v+'",'+
                                       'dp_dprdkab="'+dp_dprdkab_v+'",'+
                                       'gf_capres="'+gf_capres_v+'",'+
                                       'gf_cagub="'+gf_cagub_v+'",'+
                                       'gf_cabup="'+gf_cabup_v+'",'+
                                       'gf_partai="'+gf_partai_v+'",'+
                                       'gf_dpd="'+gf_dpd_v+'",'+
                                       'gf_dpr="'+gf_dpr_v+'",'+
                                       'gf_dprdprov="'+gf_dprdprov_v+'",'+
                                       'gf_dprdkab="'+gf_dprdkab_v+'",'+
                                       'ms_modem="'+ms_modem_v+'",'+
                                       'ms_kirimsms="'+ms_kirimsms_v+'",'+
                                       'ms_smsmasuk="'+ms_smsmasuk_v+'",'+
                                       'ms_smsterkirim="'+ms_smsterkirim_v+'",'+
                                       'mt_bot="'+mt_bot_v+'",'+
                                       'mt_kirimpesan="'+mt_kirimpesan_v+'",'+
                                       'mt_chatmasuk="'+mt_chatmasuk_v+'",'+
                                       'mt_chatterkirim="'+mt_chatterkirim_v+'",'+
                                       'pg_pengguna="'+pg_pengguna_v+'",'+
                                       'pg_identitas="'+pg_identitas_v+'",'+
                                       'pg_pengaturan="'+pg_pengaturan_v+'",'+
                                       'pg_format="'+pg_format_v+'",'+
                                       'pg_backup="'+pg_backup_v+'",'+
                                       'pg_restore="'+pg_restore_v+'",'+
                                       'bn_bantuan="'+bn_bantuan_v+'",'+
                                       'bn_update="'+bn_update_v+'",'+
                                       'dm_cakades="'+dm_kades_v+'",'+
                                       'dp_cakades="'+dp_kades_v+'",'+
                                       'gf_cakades="'+gf_kades_v+'",'+
                                       'dk_dpt="'+dk_dpt_v+'",'+
                                       'dk_peta="'+dk_peta_v+'",'+
                                       'dk_gpeta="'+dk_gpeta_v+'"'+
				       'where id_pengguna="'+LID.Caption+'"';
     ExecSQL;
   end;
  MessageDlg('Hak Akses Pengguna Berhasil Diperbarui!',mtInformation,[mbok],0);
end;

procedure TFHakAkses.setCheck(idx: integer);
begin
  with DM.ZQCari3 do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hak_akses where id_pengguna="'+IntToStr(idx)+'"';
   Open;
   if FieldByName('dm_capres').AsString='Yes' then dm_capres.Checked:=True else dm_capres.Checked:=False;
   if FieldByName('dm_cagub').AsString='Yes' then dm_cagub.Checked:=True else dm_cagub.Checked:=False;
   if FieldByName('dm_cabup').AsString='Yes' then dm_cabup.Checked:=True else dm_cabup.Checked:=False;
   if FieldByName('dm_dpd').AsString='Yes' then dm_dpd.Checked:=True else dm_dpd.Checked:=False;
   if FieldByName('dm_dpr').AsString='Yes' then dm_dpr.Checked:=True else dm_dpr.Checked:=False;
   if FieldByName('dm_dprdprov').AsString='Yes' then dm_dprdprov.Checked:=True else dm_dprdprov.Checked:=False;
   if FieldByName('dm_dprdkab').AsString='Yes' then dm_dprdkab.Checked:=True else dm_dprdkab.Checked:=False;
   if FieldByName('dm_partai').AsString='Yes' then dm_partai.Checked:=True else dm_partai.Checked:=False;
   if FieldByName('dm_prov').AsString='Yes' then dm_prov.Checked:=True else dm_prov.Checked:=False;
   if FieldByName('dm_kab').AsString='Yes' then dm_kab.Checked:=True else dm_kab.Checked:=False;
   if FieldByName('dm_kec').AsString='Yes' then dm_kec.Checked:=True else dm_kec.Checked:=False;
   if FieldByName('dm_kel').AsString='Yes' then dm_kel.Checked:=True else dm_kel.Checked:=False;
   if FieldByName('dm_tps').AsString='Yes' then dm_tps.Checked:=True else dm_tps.Checked:=False;
   if FieldByName('dm_dapil').AsString='Yes' then dm_dapil.Checked:=True else dm_dapil.Checked:=False;
   if FieldByName('dm_dapilri').AsString='Yes' then dm_dapilri.Checked:=True else dm_dapilri.Checked:=False;
   if FieldByName('dm_dapilprov').AsString='Yes' then dm_dapilprov.Checked:=True else dm_dapilprov.Checked:=False;
   if FieldByName('dm_dapilkab').AsString='Yes' then dm_dapilkab.Checked:=True else dm_dapilkab.Checked:=False;
   if FieldByName('dk_timses').AsString='Yes' then dk_timses.Checked:=True else dk_timses.Checked:=False;
   if FieldByName('dk_saksi').AsString='Yes' then dk_saksi.Checked:=True else dk_saksi.Checked:=False;
   if FieldByName('dk_usulantimses').AsString='Yes' then dk_usulantimses.Checked:=True else dk_usulantimses.Checked:=False;
   if FieldByName('dk_dukungindependen').AsString='Yes' then dk_dukungindependen.Checked:=True else dk_dukungindependen.Checked:=False;
   if FieldByName('dk_polling').AsString='Yes' then dk_polling.Checked:=True else dk_polling.Checked:=False;
   if FieldByName('dk_usulsaran').AsString='Yes' then dk_usulsaran.Checked:=True else dk_usulsaran.Checked:=False;
   if FieldByName('dp_capres').AsString='Yes' then dp_capres.Checked:=True else dp_capres.Checked:=False;
   if FieldByName('dp_cagub').AsString='Yes' then dp_cagub.Checked:=True else dp_cagub.Checked:=False;
   if FieldByName('dp_cabup').AsString='Yes' then dp_cabup.Checked:=True else dp_cabup.Checked:=False;
   if FieldByName('dp_partai').AsString='Yes' then dp_partai.Checked:=True else dp_partai.Checked:=False;
   if FieldByName('dp_dpd').AsString='Yes' then dp_dpd.Checked:=True else dp_dpd.Checked:=False;
   if FieldByName('dp_dpr').AsString='Yes' then dp_dpr.Checked:=True else dp_dpr.Checked:=False;
   if FieldByName('dp_dprdprov').AsString='Yes' then dp_dprdprov.Checked:=True else dp_dprdprov.Checked:=False;
   if FieldByName('dp_dprdkab').AsString='Yes' then dp_dprdkab.Checked:=True else dp_dprdkab.Checked:=False;
   if FieldByName('gf_capres').AsString='Yes' then gf_capres.Checked:=True else gf_capres.Checked:=False;
   if FieldByName('gf_cagub').AsString='Yes' then gf_cagub.Checked:=True else gf_cagub.Checked:=False;
   if FieldByName('gf_cabup').AsString='Yes' then gf_cabup.Checked:=True else gf_cabup.Checked:=False;
   if FieldByName('gf_partai').AsString='Yes' then gf_partai.Checked:=True else gf_partai.Checked:=False;
   if FieldByName('gf_dpd').AsString='Yes' then gf_dpd.Checked:=True else gf_dpd.Checked:=False;
   if FieldByName('gf_dpr').AsString='Yes' then gf_dpr.Checked:=True else gf_dpr.Checked:=False;
   if FieldByName('gf_dprdprov').AsString='Yes' then gf_dprdprov.Checked:=True else gf_dprdprov.Checked:=False;
   if FieldByName('gf_dprdkab').AsString='Yes' then gf_dprdkab.Checked:=True else gf_dprdkab.Checked:=False;
   if FieldByName('ms_modem').AsString='Yes' then ms_modem.Checked:=True else ms_modem.Checked:=False;
   if FieldByName('ms_kirimsms').AsString='Yes' then ms_kirimsms.Checked:=True else ms_kirimsms.Checked:=False;
   if FieldByName('ms_smsmasuk').AsString='Yes' then ms_smsmasuk.Checked:=True else ms_smsmasuk.Checked:=False;
   if FieldByName('ms_smsterkirim').AsString='Yes' then ms_smsterkirim.Checked:=True else ms_smsterkirim.Checked:=False;
   if FieldByName('mt_bot').AsString='Yes' then mt_bot.Checked:=True else mt_bot.Checked:=False;
   if FieldByName('mt_kirimpesan').AsString='Yes' then mt_kirimpesan.Checked:=True else mt_kirimpesan.Checked:=False;
   if FieldByName('mt_chatmasuk').AsString='Yes' then mt_chatmasuk.Checked:=True else mt_chatmasuk.Checked:=False;
   if FieldByName('mt_chatterkirim').AsString='Yes' then mt_chatterkirim.Checked:=True else mt_chatterkirim.Checked:=False;
   if FieldByName('pg_pengguna').AsString='Yes' then pg_pengguna.Checked:=True else pg_pengguna.Checked:=False;
   if FieldByName('pg_identitas').AsString='Yes' then pg_identitas.Checked:=True else pg_identitas.Checked:=False;
   if FieldByName('pg_pengaturan').AsString='Yes' then pg_pengaturan.Checked:=True else pg_pengaturan.Checked:=False;
   if FieldByName('pg_format').AsString='Yes' then pg_format.Checked:=True else pg_format.Checked:=False;
   if FieldByName('pg_backup').AsString='Yes' then pg_backup.Checked:=True else pg_backup.Checked:=False;
   if FieldByName('pg_restore').AsString='Yes' then pg_restore.Checked:=True else pg_restore.Checked:=False;
   if FieldByName('bn_bantuan').AsString='Yes' then bn_bantuan.Checked:=True else bn_bantuan.Checked:=False;
   if FieldByName('bn_update').AsString='Yes' then bn_update.Checked:=True else bn_update.Checked:=False;
   if FieldByName('dm_cakades').AsString='Yes' then dm_kades.Checked:=True else dm_kades.Checked:=False;
   if FieldByName('dp_cakades').AsString='Yes' then dp_kades.Checked:=True else dp_kades.Checked:=False;
   if FieldByName('gf_cakades').AsString='Yes' then gf_kades.Checked:=True else gf_kades.Checked:=False;

   if FieldByName('dk_dpt').AsString='Yes' then dk_dpt.Checked:=True else dk_dpt.Checked:=False;
   if FieldByName('dk_peta').AsString='Yes' then dk_petasuara.Checked:=True else dk_petasuara.Checked:=False;
   if FieldByName('dk_gpeta').AsString='Yes' then dk_gpeta.Checked:=True else dk_gpeta.Checked:=False;
  end;

end;
end.

