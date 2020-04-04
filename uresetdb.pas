unit uresetdb;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ExtDlgs, ColorBox, ucekserial, UdataModule, encode_decode;

procedure ResetDatabase;

implementation

uses uutama;

procedure ResetDatabase;
var
  i : integer;
begin
  FUtama.PBLoading.Position:=0;
  FUtama.PBLoading.Max:=52;
  FUtama.PBLoading.Visible:=True;
  with DM.ZQReset do
  begin
  Close;

  SQL.Clear;
  SQL.Text:='update t_activationkey set kunci="" where id=1';
  ExecSQL;
  FUtama.PBLoading.Position:=1;

  DM.ZQCabupKota.First;
  for i := 1 to DM.ZQCabupKota.RecordCount do
  begin
  SQL.Clear;
  SQL.Text:='delete from t_cabupkota where no_urut="'+DM.ZQCabupKota.FieldByName('no_urut').AsString+'"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\cabup\'+DM.ZQCabupKota.FieldByName('foto').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\cabup\'+DM.ZQCabupKota.FieldByName('foto').AsString);
  DM.ZQCabupKota.Next;
  end;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_cabupkota AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=2;

  DM.ZQCagub.First;
  for i := 1 to DM.ZQCagub.RecordCount do
  begin
  SQL.Clear;
  SQL.Text:='delete from t_cagub where no_urut="'+DM.ZQCagub.FieldByName('no_urut').AsString+'"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\cagub\'+DM.ZQCagub.FieldByName('foto').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\cagub\'+DM.ZQCagub.FieldByName('foto').AsString);
  DM.ZQCagub.Next;
  end;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_cagub AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=3;

  DM.ZQDPDRI.First;
  for i := 1 to DM.ZQDPDRI.RecordCount do
  begin
  SQL.Clear;
  SQL.Text:='delete from t_calegdpdri where no_urut="'+DM.ZQDPDRI.FieldByName('no_urut').AsString+'"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+DM.ZQDPDRI.FieldByName('foto').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dpdri\'+DM.ZQDPDRI.FieldByName('foto').AsString);
  DM.ZQDPDRI.Next;
  end;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_calegdpdri AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=4;

  DM.ZQDPRDKab.First;
  for i := 1 to DM.ZQDPRDKab.RecordCount do
  begin
  SQL.Clear;
  SQL.Text:='delete from t_calegdprdkabkota where id="'+DM.ZQDPRDKab.FieldByName('id').AsString+'"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+DM.ZQDPRDKab.FieldByName('foto').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdkabkota\'+DM.ZQDPRDKab.FieldByName('foto').AsString);
  DM.ZQDPRDKab.Next;
  end;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_calegdprdkabkota AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=5;

  DM.ZQDPRDProv.First;
  for i := 1 to DM.ZQDPRDProv.RecordCount do
  begin
  SQL.Clear;
  SQL.Text:='delete from t_calegdprdprov where id="'+DM.ZQDPRDProv.FieldByName('id').AsString+'"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+DM.ZQDPRDProv.FieldByName('foto').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprdprov\'+DM.ZQDPRDProv.FieldByName('foto').AsString);
  DM.ZQDPRDProv.Next;
  end;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_calegdprdprov AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=6;

  DM.ZQDPRRI.First;
  for i := 1 to DM.ZQDPRRI.RecordCount do
  begin
  SQL.Clear;
  SQL.Text:='delete from t_calegdprri where id="'+DM.ZQDPRRI.FieldByName('id').AsString+'"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+DM.ZQDPRRI.FieldByName('foto').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\caleg\dprri\'+DM.ZQDPRRI.FieldByName('foto').AsString);
  DM.ZQDPRRI.Next;
  end;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_calegdprri AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=7;

  DM.ZQCapres.First;
  for i := 1 to DM.ZQCapres.RecordCount do
  begin
  SQL.Clear;
  SQL.Text:='delete from t_capres where no_urut="'+DM.ZQCapres.FieldByName('no_urut').AsString+'"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\capres\'+DM.ZQCapres.FieldByName('foto').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\capres\'+DM.ZQCapres.FieldByName('foto').AsString);
  DM.ZQCapres.Next;
  end;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_capres AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=8;

  DM.ZQPartai.First;
  for i := 1 to DM.ZQPartai.RecordCount do
  begin
  SQL.Clear;
  SQL.Text:='delete from t_partai where no_urut="'+DM.ZQPartai.FieldByName('no_urut').AsString+'"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\partai\'+DM.ZQPartai.FieldByName('gambar').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\partai\'+DM.ZQPartai.FieldByName('gambar').AsString);
  DM.ZQPartai.Next;
  end;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_partai AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=9;

  SQL.Clear;
  SQL.Text:='update t_config set background="background.png",tgl_pemilu="2019-01-01",pemisah="#",pemilih_capres="0",pemilih_cagub="0",pemilih_cabup="0",pemilih_dpd="0",pemilih_dpr="0",pemilih_dprdprov="0",pemilih_dprdkabkota="0",pemilih_partai="0",pemilih_kades="0" where id=1';
  ExecSQL;
  FUtama.PBLoading.Position:=10;

  SQL.Clear;
  SQL.Text:='truncate t_dapil';
  ExecSQL;
  FUtama.PBLoading.Position:=11;

  SQL.Clear;
  SQL.Text:='truncate t_dapilkabkota';
  ExecSQL;
  FUtama.PBLoading.Position:=12;

  SQL.Clear;
  SQL.Text:='truncate t_dapilprovinsi';
  ExecSQL;
  FUtama.PBLoading.Position:=13;

  SQL.Clear;
  SQL.Text:='truncate t_dapilri';
  ExecSQL;
  FUtama.PBLoading.Position:=14;

  SQL.Clear;
  SQL.Text:='truncate t_dukunganindie';
  ExecSQL;
  FUtama.PBLoading.Position:=15;

  SQL.Clear;
  SQL.Text:='delete from t_hak_akses where id<>1';
  ExecSQL;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_hak_akses AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=16;

  SQL.Clear;
  SQL.Text:='truncate t_hitungcabup';
  ExecSQL;
  FUtama.PBLoading.Position:=17;

  SQL.Clear;
  SQL.Text:='truncate t_hitungcagub';
  ExecSQL;
  FUtama.PBLoading.Position:=18;

  SQL.Clear;
  SQL.Text:='truncate t_hitungcapres';
  ExecSQL;
  FUtama.PBLoading.Position:=19;

  SQL.Clear;
  SQL.Text:='truncate t_hitungdpdri';
  ExecSQL;
  FUtama.PBLoading.Position:=20;

  SQL.Clear;
  SQL.Text:='truncate t_hitungdprdkab';
  ExecSQL;
  FUtama.PBLoading.Position:=21;

  SQL.Clear;
  SQL.Text:='truncate t_hitungdprdprov';
  ExecSQL;
  FUtama.PBLoading.Position:=22;

  SQL.Clear;
  SQL.Text:='truncate t_hitungdprri';
  ExecSQL;
  FUtama.PBLoading.Position:=23;

  SQL.Clear;
  SQL.Text:='truncate t_hitungpartai';
  ExecSQL;
  FUtama.PBLoading.Position:=24;

  SQL.Clear;
  SQL.Text:='update t_identitaslembaga set nama_lembaga="Elections Quick Count System",alamat="Jl. Halmahera RT 06 Rembiga Timur Selaparang Mataram NTB",no_telpon="081907558324",email="eqsquickcount@gmail.com",pimpinan="Ahmad Tauhid, S.Kom",alamat_web="www.eqsquickcount.com" where id=1';
  ExecSQL;
  FUtama.PBLoading.Position:=25;

  SQL.Clear;
  SQL.Text:='truncate t_inboxchat';
  ExecSQL;
  FUtama.PBLoading.Position:=26;

  SQL.Clear;
  SQL.Text:='truncate t_inboxsms';
  ExecSQL;
  FUtama.PBLoading.Position:=27;

  SQL.Clear;
  SQL.Text:='update t_instalationkey set kunci1="",kunci2="",kunci3="",kunci4="" where id=1';
  ExecSQL;
  FUtama.PBLoading.Position:=28;

  SQL.Clear;
  SQL.Text:='truncate t_kabkota';
  ExecSQL;
  FUtama.PBLoading.Position:=29;

  SQL.Clear;
  SQL.Text:='truncate t_kecamatan';
  ExecSQL;
  FUtama.PBLoading.Position:=30;

  SQL.Clear;
  SQL.Text:='truncate t_kelurahan';
  ExecSQL;
  FUtama.PBLoading.Position:=31;

  SQL.Clear;
  SQL.Text:='truncate t_outboxchat';
  ExecSQL;
  FUtama.PBLoading.Position:=32;

  SQL.Clear;
  SQL.Text:='truncate t_outboxsms';
  ExecSQL;
  FUtama.PBLoading.Position:=33;

  SQL.Clear;
  SQL.Text:='delete from t_pengguna where id<>1';
  ExecSQL;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_pengguna AUTO_INCREMENT=1';
  ExecSQL;
  SQL.Clear;
  SQL.Text:='update t_pengguna set password="'+GSMEncode7Bit(GSMEncode7Bit('admin'))+'",no_hp="-" where id=1';
  ExecSQL;
  FUtama.PBLoading.Position:=34;

  SQL.Clear;
  SQL.Text:='truncate t_polling';
  ExecSQL;
  FUtama.PBLoading.Position:=35;

  SQL.Clear;
  SQL.Text:='truncate t_provinsi';
  ExecSQL;
  FUtama.PBLoading.Position:=36;

  SQL.Clear;
  SQL.Text:='truncate t_saksi';
  ExecSQL;
  FUtama.PBLoading.Position:=37;

  SQL.Clear;
  SQL.Text:='truncate t_timses';
  ExecSQL;
  FUtama.PBLoading.Position:=38;

  SQL.Clear;
  SQL.Text:='truncate t_tps';
  ExecSQL;
  FUtama.PBLoading.Position:=39;

  SQL.Clear;
  SQL.Text:='truncate t_usulantimses';
  ExecSQL;
  FUtama.PBLoading.Position:=40;

  SQL.Clear;
  SQL.Text:='truncate t_usulsaran';
  ExecSQL;
  FUtama.PBLoading.Position:=41;

  SQL.Clear;
  SQL.Text:='update t_telegrambot set nama_bot="Bot Engine",token="",offset="0",inboxcount="0",outboxcount="0",inboxnotif="Satu",outboxnotif="Dua",tooltip="Yes",status="Off" where id=1';
  ExecSQL;
  FUtama.PBLoading.Position:=42;

  for i := 1 to 8 do begin
  SQL.Clear;
  SQL.Text:='update t_modem set nama_modem="Modem '+IntToStr(i)+'",port="COM'+IntToStr(i)+'",baud="115200",outboxcount="0",inboxcount="0",indexpesan="0",outboxnotif="Empat",inboxnotif="Tiga",tooltip="Yes",intervalx="6573",status="Off" where id="'+IntToStr(i)+'"';
  ExecSQL;
  end;
  FUtama.PBLoading.Position:=43;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Kelurahan/Desa atau TPS Tidak ditemukan!" where id=1';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Terima Kasih. Anda telah terdaftar sebagai Saksi!" where id=2';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="TPS Sudah Terisi atau Anda Sudah Terdaftar!" where id=3';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Kelurahan/Desa Tidak ditemukan!" where id=4';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Terima Kasih. Anda telah terdaftar sebagai Relawan!" where id=5';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Nomor atau ID Telegram Sudah Digunakan!" where id=6';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Data Anda Telah Tersimpan Sebagai Koordinator TPS!" where id=7';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Terdaftar!" where id=8';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Terima Kasih Atas Dukungan Anda. Data Anda Telah Tersimpan di Database Kami!" where id=9';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Nomor KTP Sudah Terdaftar!" where id=10';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Terima Kasih. Data Usulan Anda Telah Tersimpan di Database Kami!" where id=11';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Nomor Urut CAPRES Tidak Ditemukan!" where id=12';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara CAPRES Berhasil disimpan!" where id=13';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Pernah Mengirimkan Suara CAPRES!" where id=14';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Format Pesan yang anda Kirimkan Kurang Tepat!" where id=15';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Tidak Terdaftar Sebagai Saksi!" where id=16';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Nomor Urut CAGUB Tidak Ditemukan!" where id=17';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara CAGUB Berhasil disimpan!" where id=18';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Pernah Mengirimkan Suara CAGUB!" where id=19';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Nomor Urut CABUP/KOTA dengan Tidak Ditemukan!" where id=20';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara CABUP/KOTA Berhasil disimpan!" where id=21';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Pernah Mengirimkan Suara CABUP/KOTA!" where id=22';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Nomor Urut PARTAI Tidak Ditemukan!" where id=23';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara PARTAI Berhasil disimpan!" where id=24';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Pernah Mengirimkan Suara PARTAI!" where id=25';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Nomor Urut DPD RI Tidak Ditemukan!" where id=26';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPD RI Berhasil disimpan!" where id=27';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Pernah Mengirimkan Suara DPD RI!" where id=28';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="ID DPR RI Tidak Ditemukan!" where id=29';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPR RI Berhasil disimpan!" where id=30';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Pernah Mengirimkan Suara DPR RI!" where id=31';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="ID DPRD Provinsi Tidak Ditemukan!" where id=32';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPRD Provinsi Berhasil disimpan!" where id=33';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Pernah Mengirimkan Suara DPRD Provinsi!" where id=34';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="ID DPRD Kabupaten/Kota Tidak Ditemukan!" where id=35';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPRD Kabupaten/Kota Berhasil disimpan!" where id=36';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Pernah Mengirimkan Suara DPRD Kabupaten/Kota!" where id=37';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara CAPRES Berhasil diperbarui!" where id=38';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara CAPRES Tidak ditemukan!" where id=39';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara CAGUB Berhasil diperbarui!" where id=40';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara CAGUB Tidak ditemukan!" where id=41';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara CABUP/KOTA Berhasil diperbarui!" where id=42';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara CABUP/KOTA Tidak ditemukan!" where id=43';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara PARTAI Berhasil diperbarui!" where id=44';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara PARTAI Tidak ditemukan!" where id=45';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPD RI Berhasil diperbarui!" where id=46';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPD RI Tidak ditemukan!" where id=47';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPR RI Berhasil diperbarui!" where id=48';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPR RI Tidak ditemukan!" where id=49';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPRD Provinsi Berhasil diperbarui!" where id=50';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPRD Provinsi Tidak ditemukan!" where id=51';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPRD Kabupaten/Kota Berhasil diperbarui!" where id=52';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara DPRD Kabupaten/Kota Tidak ditemukan!" where id=53';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Nomor Urut KADES Tidak Ditemukan!" where id=54';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara KADES Berhasil disimpan!" where id=55';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Sudah Pernah Mengirimkan Suara KADES!" where id=56';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara KADES Berhasil diperbarui!" where id=57';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Suara KADES Tidak ditemukan!" where id=58';
  ExecSQL;

  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="Anda Tidak Terdaftar Sebagai Koordinator TPS!" where id=59';
  ExecSQL;

  FUtama.PBLoading.Position:=44;

  SQL.Clear;
  SQL.Text:='truncate t_hitungkades';
  ExecSQL;
  FUtama.PBLoading.Position:=45;

  DM.ZQKades.First;
  for i := 1 to DM.ZQKades.RecordCount do
  begin
  SQL.Clear;
  SQL.Text:='delete from t_cakades where no_urut="'+DM.ZQKades.FieldByName('no_urut').AsString+'"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\cakades\'+DM.ZQKades.FieldByName('foto').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\cakades\'+DM.ZQKades.FieldByName('foto').AsString);
  DM.ZQKades.Next;
  end;
  SQL.Clear;
  SQL.Text:='ALTER TABLE t_cakades AUTO_INCREMENT=1';
  ExecSQL;
  FUtama.PBLoading.Position:=46;

  SQL.Clear;
  SQL.Text:='truncate t_petasuara';
  ExecSQL;
  FUtama.PBLoading.Position:=47;

  SQL.Clear;
  SQL.Text:='truncate t_dpt';
  ExecSQL;
  FUtama.PBLoading.Position:=48;

  SQL.Clear;
  SQL.Text:='update t_caleginfo set nama="",foto="" where id="1"';
  ExecSQL;
  if FileExists(ExtractFilePath(Application.ExeName)+'img\'+DM.ZQCalegInfo.FieldByName('foto').AsString) then
  DeleteFile(ExtractFilePath(Application.ExeName)+'img\'+DM.ZQCalegInfo.FieldByName('foto').AsString);
  FUtama.PBLoading.Position:=49;

  SQL.Clear;
  SQL.Text:='truncate t_totpartai';
  ExecSQL;
  FUtama.PBLoading.Position:=50;

  SQL.Clear;
  SQL.Text:='truncate t_perolehankursi';
  ExecSQL;
  FUtama.PBLoading.Position:=51;

  SQL.Clear;
  SQL.Text:='truncate t_totcaleg';
  ExecSQL;
  FUtama.PBLoading.Position:=52;

  FUtama.PBLoading.Visible:=False;
  MessageDlg('Database berhasil direset!. Aplikasi akan ditutup. Silahkan Jalankan ulang aplikasi!',mtInformation,[mbok],0);
  Application.Terminate;
  end;
end;

end.

