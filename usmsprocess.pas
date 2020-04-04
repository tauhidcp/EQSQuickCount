unit usmsprocess;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, udatamodule, strutils;

 procedure cekSMSMasuk;
 function getIdKelurahan(nama:string):string;
 function getIdTPS(no:string;kelurahan:string):string;
 function cekSaksiD(nohp:string;idtelegram:string;idtps:string):integer;
 function cekSaksi(nohp:string):integer;
 function cekKoor(nohp:string):integer;
 function cekRelawan(nohp:string;idtelegram:string):integer;
 function cekRelawanAda(nohp:string):integer;
 function cekUsulanAda(nohp:string):integer;
 function cekKTP(noktp:string;status:string):integer;
 function IsNumber(N : String) : Boolean;
 function hitungHasil(status:string):string;
 function cekCalon(status:string;idno:string):integer;
 function cekPolling(nohp:string):integer;
 function ReplaceNol(n:string): string;
 procedure kirimSMS(modem:string;nohp:string;isi:string);
 function getIdTPSSaksi(nohp:string):string;
 function cekSuara(status:string;idtps:string;idcalon:string):integer;
 function getIdHitung(status:string;idtps:string;idcalon:string):string;
 function getIdCagub(idx:string):string;
 function getIdKades(idx:string):string;
 function getIdCabup(idx:string):string;
 function getIdDapil(status:string;idx:string):string;
 function getBalasan(idx:integer):string;
 function getIdDapilX(nama:string):string;

implementation

uses uutama;

procedure cekSMSMasuk;
var
kar_x,kar_awal,kar_akhir,i,j,k,count : integer;
pesan, nohp, pemisah, tglsms, tglpemilu, ssah, stsah, nmkel, notps, dpt, modem, aksi, hasil, hasil1, hasil2, hasil3, hasil4, hasil5, hasil6, hasil7, hasil8, hasil9 : string;
begin
  DM.ZQPengaturan.First;
  tglpemilu := DM.ZQPengaturan.FieldByName('tgl_pemilu').AsString;
  pemisah := DM.ZQPengaturan.FieldByName('pemisah').AsString;
  with DM.ZQCariSMS do begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_inboxsms where processed="False" order by id asc limit 1';
   Open;
     if RecordCount>0 then
     begin
     First;
    // for i := 1 to RecordCount do begin
     pesan := FieldByName('isi_pesan').AsString;
     nohp  := FieldByName('no_pengirim').AsString;
     modem := FieldByName('id_modem').AsString;
     tglsms:= FieldByName('tanggal').AsString;
     kar_x := posex(' ',pesan,1);
     aksi  := Trim(AnsiUpperCase(copy(pesan,1,kar_x)));

         // Daftar SAKSI & RELAWAN
         if (aksi='DAFTAR') then
            begin

            kar_awal := posex(' ',pesan);
            kar_akhir:= posex(pemisah,pesan,kar_awal);
            hasil1   := AnsiUpperCase(copy(pesan,kar_awal+1,kar_akhir-kar_awal-1));

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            if (hasil1='KOORTPS') then
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil4   := copy(pesan,kar_awal+1);
            end else
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
            end;

            if (hasil1='SAKSI') then
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil4   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil5   := copy(pesan,kar_awal+1);
            end;

            if (hasil1='RELAWAN') then
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil4   := copy(pesan,kar_awal+1);
            end;

              if (hasil1='SAKSI') then
              begin
                if (getIdKelurahan(hasil3)='') or (getIdTPS(hasil4,hasil3)='') then
                // Kelurahan/Desa/TPS Salah
                kirimSMS(modem,nohp,getBalasan(1))
                else begin
                // Data Benar
                if cekSaksiD(nohp,hasil5,getIdTPS(hasil4,hasil3))<=0 then
                begin
                with DM.ZQSimpan do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Text:='insert into t_saksi (nama_saksi,desa_kelurahan,tps,nohp,id_telegram) values ("'+hasil2+'","'+getIdKelurahan(hasil3)+'","'+getIdTPS(hasil4,hasil3)+'","'+ReplaceNol(nohp)+'","'+hasil5+'")';
                  ExecSQL;
                end;
                // Saksi Tersimpan
                kirimSMS(modem,nohp,getBalasan(2));
                end else
                // Nomor Sudah digunakan
                kirimSMS(modem,nohp,getBalasan(3));
                end;
              end else
              if (hasil1='RELAWAN') then
              begin
                if (getIdKelurahan(hasil3)='') then
                kirimSMS(modem,nohp,getBalasan(4))
                else begin
                if cekRelawan(nohp,hasil4)<=0 then begin
                // Data Benar
                with DM.ZQSimpan do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Text:='insert into t_timses (nama_timses,desa_kelurahan,nohp,id_telegram) values ("'+hasil2+'","'+getIdKelurahan(hasil3)+'","'+ReplaceNol(nohp)+'","'+hasil4+'")';
                  ExecSQL;
                end;
                // Relawan Tersimpan
                kirimSMS(modem,nohp,getBalasan(5));
                end else
                // Nomor Sudah digunakan
                kirimSMS(modem,nohp,getBalasan(6));
                end;
              end else
            // KOORTPS
            if (hasil1='KOORTPS') then
            begin

            if (getIdKelurahan(hasil3)='') then
                // Kelurahan/Desa Salah
                kirimSMS(modem,nohp,getBalasan(4))
                else begin
                // Data Benar
                if (cekUsulanAda(nohp)<=0) then
                begin
                with DM.ZQSimpan do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Text:='insert into t_usulantimses (nama,desa_kelurahan,nohp,idchat,idtelegram) values ("'+hasil2+'","'+getIdKelurahan(hasil3)+'","'+ReplaceNol(nohp)+'","-","'+hasil4+'")';
                  ExecSQL;
                end;
                // Usulan Relawan Tersimpan
                kirimSMS(modem,nohp,getBalasan(7));
                end else
                kirimSMS(modem,nohp,getBalasan(8));
                end;
            end;  // End Simpatisan
            end;  // End Daftar Saksi Relawan

         // DUKUNGAN INDEPENDEN
         if (aksi='DUKUNG') then
            begin
            kar_awal := posex(' ',pesan);
            kar_akhir:= posex(pemisah,pesan,kar_awal);
            hasil1   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil3   := copy(pesan,kar_awal+1);

            if (getIdKelurahan(hasil3)='') then
                // Kelurahan/Desa Salah
                kirimSMS(modem,nohp,getBalasan(4))
                else begin
                // Data Benar
                if (cekKTP(hasil1,'DUKUNG')<=0) then
                begin
                with DM.ZQSimpan do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Text:='insert into t_dukunganindie (noktp,nama,desa_kelurahan,nohp,idtelegram,idchat) values ("'+hasil1+'","'+hasil2+'","'+getIdKelurahan(hasil3)+'","'+ReplaceNol(nohp)+'","-","-")';
                  ExecSQL;
                end;
                // Dukungan Independen Tersimpan
                kirimSMS(modem,nohp,getBalasan(9));
                end else
                // KTP Sudah Terdaftar
                kirimSMS(modem,nohp,getBalasan(10));
                end;
            end;  // End Dukungan Independen

         // PILIH POLLING
         if (aksi='PILIH') then
            begin
            kar_awal := posex(' ',pesan);
            kar_akhir:= posex(pemisah,pesan,kar_awal);
            hasil1   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil3   := copy(pesan,kar_awal+1);

            if (getIdKelurahan(hasil2)='') then
                // Kelurahan/Desa Salah
                kirimSMS(modem,nohp,getBalasan(4))
                else begin
                // Data Benar
                if (cekPolling(nohp)<=0) then
                begin
                with DM.ZQSimpan do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Text:='insert into t_polling (nama,desa_kelurahan,nohp,idtelegram,idchat,pekerjaan) values ("'+hasil1+'","'+getIdKelurahan(hasil2)+'","'+ReplaceNol(nohp)+'","-","-","'+hasil3+'")';
                  ExecSQL;
                end;
                // Polling Tersimpan
                kirimSMS(modem,nohp,getBalasan(9));
                end else
                // Nomor HP Sudah Terdaftar
                kirimSMS(modem,nohp,getBalasan(8));
                end;
            end;  // End Pilih Polling

         // USUL SARAN
         if (aksi='SARAN') then
            begin
            kar_awal := posex(' ',pesan);
            kar_akhir:= posex(pemisah,pesan,kar_awal);
            hasil1   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

	    kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil4   := copy(pesan,kar_awal+1);

            if (getIdKelurahan(hasil2)='') then
                // Kelurahan/Desa Salah
                kirimSMS(modem,nohp,getBalasan(4))
                else begin
                // Data Benar
                with DM.ZQSimpan do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Text:='insert into t_usulsaran (nama,desa_kelurahan,nohp,idtelegram,idchat,pekerjaan,usulan) values ("'+hasil1+'","'+getIdKelurahan(hasil2)+'","'+ReplaceNol(nohp)+'","-","-","'+hasil3+'","'+hasil4+'")';
                  ExecSQL;
                end;
                // Usul Saran Tersimpan
                kirimSMS(modem,nohp,getBalasan(11));
                end;
            end;  // End Usul Saran

         // HASIL PERHITUNGAN
         if (aksi='HASIL') then
            begin
            kar_awal := posex(' ',pesan);
            hasil1   := AnsiUpperCase(copy(pesan,kar_awal+1));
                // Kirim Informasi Perhitungan
                kirimSMS(modem,nohp,hitungHasil(hasil1));
            end;  // End Hasil Perhitungan

         // SUARA CALON
         if (aksi='SUARA') then
            begin

            kar_awal := posex(' ',pesan);
            kar_akhir:= posex(pemisah,pesan,kar_awal);
            hasil1   := AnsiUpperCase(copy(pesan,kar_awal+1,kar_akhir-kar_awal-1));

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil4   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil5   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            if not (hasil1='PARTAI') then
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil6   := copy(pesan,kar_awal+1);
            end else
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil6   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil7   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            {kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil8   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);}

            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil8   := copy(pesan,kar_awal+1);
            end;

            if (hasil1='CAPRES') then
              begin

                if cekCalon(hasil1,hasil2)<=0 then
                kirimSMS(modem,nohp,getBalasan(12))
                else begin
                  // Cek Apakah Saksi Terdaftar
                  if cekSaksi(nohp)>=1 then
                  begin
		    // Cek Apakah Nomor
                    if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                    begin
                      if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)<=0 then
                      begin
                        if (tglpemilu=tglsms) then
                        begin
                        with DM.ZQSimpan do
                        begin
                          Close;
                          SQL.Clear;
                          SQL.Text:='insert into t_hitungcapres (no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+hasil2+'","'+getIdTPSSaksi(nohp)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                          ExecSQL;
                        end;
                      // Suara Tersimpan
                      kirimSMS(modem,nohp,getBalasan(13));
                      // Suara Sudah Ada
                      end;
                      end else
                      kirimSMS(modem,nohp,getBalasan(14))
		    // Bukan Nomor
                    end else
                    kirimSMS(modem,nohp,getBalasan(15))
                  // Saksi Tidak Terdaftar
                  end else
                  kirimSMS(modem,nohp,getBalasan(16));
                end;
              end;

              if (hasil1='KADES') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(54))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)<=0 then
                        begin
                          if (tglpemilu=tglsms) then
                          begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungkades (keldesa,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdKades(hasil2)+'","'+hasil2+'","'+getIdTPSSaksi(nohp)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(55));
                        // Suara Sudah Ada
                        end;
                        end else
                        kirimSMS(modem,nohp,getBalasan(56))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='CAGUB') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(17))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungcagub (provinsi,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdCagub(hasil2)+'","'+hasil2+'","'+getIdTPSSaksi(nohp)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(18));
                        // Suara Sudah Ada
                        end;
                        end else
                        kirimSMS(modem,nohp,getBalasan(19))
  		       // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='CABUPKOTA') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(20))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungcabup (kabkota,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdCabup(hasil2)+'","'+hasil2+'","'+getIdTPSSaksi(nohp)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(21));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(22))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='PARTAI') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(23))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) and (IsNumber(hasil7)=True) and (IsNumber(hasil8)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungpartai (no_urut,tps,suara_dprri,suara_dprdprov,suara_dprdkab,suara_sah,suara_tidaksah,dpt) values ("'+hasil2+'","'+getIdTPSSaksi(nohp)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'","'+hasil7+'","'+hasil8+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(24));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(25))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='DPD') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(26))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungdpdri (dapil,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,hasil2)+'","'+hasil2+'","'+getIdTPSSaksi(nohp)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(27));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(28))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='DPR') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(29))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungdprri (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,hasil2)+'","'+hasil2+'","'+getIdTPSSaksi(nohp)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(30));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(31))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='DPRDPROV') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(32))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungdprdprov (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,hasil2)+'","'+hasil2+'","'+getIdTPSSaksi(nohp)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(33));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(34))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='DPRDKABKOTA') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(35))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungdprdkab (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,hasil2)+'","'+hasil2+'","'+getIdTPSSaksi(nohp)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(36));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(37))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

            end;  // End SUARA CALON

         // UBAH
         if (aksi='UBAH') then
            begin

            kar_awal := posex(' ',pesan);
            kar_akhir:= posex(pemisah,pesan,kar_awal);
            hasil1   := AnsiUpperCase(copy(pesan,kar_awal+1,kar_akhir-kar_awal-1));

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil4   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil5   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            if not (hasil1='PARTAI') then
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil6   := copy(pesan,kar_awal+1);
            end else
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil6   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil7   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            {kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil8   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);   }

            kar_awal := posex(pemisah,pesan,kar_akhir);
            hasil8   := copy(pesan,kar_awal+1);
            end;

            if (hasil1='CAPRES') then
              begin

                if cekCalon(hasil1,hasil2)<=0 then
                kirimSMS(modem,nohp,getBalasan(12))
                else begin
                  // Cek Apakah Saksi Terdaftar
                  if cekSaksi(nohp)>=1 then
                  begin
		    // Cek Apakah Nomor
                    if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                    begin
                      if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)>=1 then
                      begin
                        if (tglpemilu=tglsms) then
                        begin
                        with DM.ZQSimpan do
                        begin
                          Close;
                          SQL.Clear;
                          SQL.Text:='update t_hitungcapres set no_urut="'+hasil2+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),hasil2)+'"';
                          ExecSQL;
                        end;
                      // Suara Tersimpan
                      kirimSMS(modem,nohp,getBalasan(38));
                      // Suara Sudah Ada
                      end;
                      end else
                      kirimSMS(modem,nohp,getBalasan(39))
		    // Bukan Nomor
                    end else
                    kirimSMS(modem,nohp,getBalasan(15))
                  // Saksi Tidak Terdaftar
                  end else
                  kirimSMS(modem,nohp,getBalasan(16));
                end;
              end;

              if (hasil1='KADES') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(54))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)>=1 then
                        begin
                          if (tglpemilu=tglsms) then
                          begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungkades set keldesa="'+getIdKades(hasil2)+'",no_urut="'+hasil2+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(57));
                        // Suara Sudah Ada
                        end;
                        end else
                        kirimSMS(modem,nohp,getBalasan(58))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='CAGUB') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(17))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungcagub set provinsi="'+getIdCagub(hasil2)+'",no_urut="'+hasil2+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(40));
                        // Suara Sudah Ada
                        end;
                        end else
                        kirimSMS(modem,nohp,getBalasan(41))
  		       // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='CABUPKOTA') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(20))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungcabup set kabkota="'+getIdCabup(hasil2)+'",no_urut="'+hasil2+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(42));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(43))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='PARTAI') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(23))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) and (IsNumber(hasil7)=True) and (IsNumber(hasil8)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungpartai set no_urut="'+hasil2+'",tps="'+getIdTPSSaksi(nohp)+'",suara_dprri="'+hasil3+'",suara_dprdprov="'+hasil4+'",suara_dprdkab="'+hasil5+'",suara_sah="'+hasil6+'",suara_tidaksah="'+hasil7+'",dpt="'+hasil8+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(44));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(45))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='DPD') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(26))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungdpdri set dapil="'+getIdDapil(hasil1,hasil2)+'",no_urut="'+hasil2+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(46));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(47))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='DPR') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(29))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungdprri set dapil="'+getIdDapil(hasil1,hasil2)+'",id_caleg="'+hasil2+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(48));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(49))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='DPRDPROV') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(32))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungdprdprov set dapil="'+getIdDapil(hasil1,hasil2)+'",id_caleg="'+hasil2+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(50));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(51))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

              if (hasil1='DPRDKABKOTA') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(35))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekSaksi(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPSSaksi(nohp),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungdprdkab set dapil="'+getIdDapil(hasil1,hasil2)+'",id_caleg="'+hasil2+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(52));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(53))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(16));
                  end;
                end;

            end;  // End UBAH

            // INPUT
                  if (aksi='INPUT') then
                     begin

                     kar_awal := posex(' ',pesan);
                     kar_akhir:= posex(pemisah,pesan,kar_awal);
                     hasil1   := AnsiUpperCase(copy(pesan,kar_awal+1,kar_akhir-kar_awal-1));

                         if (hasil1='DPD') then
                         begin
                         // DAPIL
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         with DM.ZQCari5 do
                         begin
                         Close;
                         SQL.Clear;
                         SQL.Text:='select * from t_calegdpdri where dapil="'+getIdDapilX(hasil3)+'"';
                         Open;
                         First;
                         end;
                         count := DM.ZQCari5.RecordCount;
                         //j:=1;
                        //count := DM.ZQDPDRI.RecordCount;
                         DM.ZQCari5.First;
                         while not DM.ZQCari5.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                           // Cek Apakah Saksi Terdaftar
                           if cekSaksi(nohp)>=1 then
                           begin
               		  // Cek Apakah Nomor
                           if (IsNumber(hasil)=True) then
                             begin
                               if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('no_urut').AsString)<=0 then
                               begin
                               if (tglpemilu=tglsms) then
                               begin
                              // if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil6))then
                             //  begin
               		      with DM.ZQSimpan do
               		      begin
               		      Close;
               		      SQL.Clear;
               		      SQL.Text:='insert into t_hitungdpdri (dapil,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,DM.ZQCari5.FieldByName('no_urut').AsString)+'","'+DM.ZQCari5.FieldByName('no_urut').AsString+'","'+getIdTPSSaksi(nohp)+'","'+hasil+'","'+ssah+'","'+stsah+'","'+dpt+'")';
               		      ExecSQL;
               		      end;
                               // Suara Tersimpan
                               kirimSMS(modem,nohp,getBalasan(27));
                              // end else
                             //  kirimSMS(modem,nohp,getBalasan(59));
                               end;
                               // Suara Sudah Ada
                               end else
                               kirimSMS(modem,nohp,getBalasan(28))
               		    // Bukan Nomor
                             end else
                             kirimSMS(modem,nohp,getBalasan(15))
                           // Saksi Tidak Terdaftar
                           end else
                           kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQCari5.Next;
                         end;
                         end; // End DPD

                         if (hasil1='DPR') then
                         begin
                          // No Urut Partai
         	         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // DAPIL
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         with DM.ZQCari5 do
                         begin
                         Close;
                         SQL.Clear;
                         SQL.Text:='select * from t_calegdprri where partai="'+hasil2+'" and dapil="'+getIdDapilX(hasil3)+'"';
                         Open;
                         First;
                         end;
                         count := DM.ZQCari5.RecordCount;
                         while not DM.ZQCari5.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                           // Cek Apakah Saksi Terdaftar
                             if cekSaksi(nohp)>=1 then
                             begin
         		    // Cek Apakah Nomor
                               if (IsNumber(hasil)=True) then
                               begin
                                 if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('id').AsString)<=0 then
                                 begin
                                 if (tglpemilu=tglsms) then
                                 begin
                                // if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil6))then
                               //  begin
                                   with DM.ZQSimpan do
                                   begin
                                     Close;
                                     SQL.Clear;
                                     SQL.Text:='insert into t_hitungdprri (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,DM.ZQCari5.FieldByName('id').AsString)+'","'+DM.ZQCari5.FieldByName('id').AsString+'","'+getIdTPSSaksi(nohp)+'","'+hasil+'","'+ssah+'","'+stsah+'","'+dpt+'")';
                                     ExecSQL;
                                   end;
                                 // Suara Tersimpan
                                 kirimSMS(modem,nohp,getBalasan(30));
                               //  end else
                               //  kirimSMS(modem,nohp,getBalasan(59));
                                 end;
                                 // Suara Sudah Ada
                                 end else
                                 kirimSMS(modem,nohp,getBalasan(31))
         			// Bukan Nomor
                               end else
                               kirimSMS(modem,nohp,getBalasan(15))
                             // Saksi Tidak Terdaftar
                             end else
                             kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQCari5.Next;
                         end;
                         end; // End DPR

                         if (hasil1='DPRDPROV') then
                         begin
                         // No Urut Partai
         	         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // DAPIL
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         with DM.ZQCari5 do
                         begin
                         Close;
                         SQL.Clear;
                         SQL.Text:='select * from t_calegdprdprov where partai="'+hasil2+'" and dapil="'+getIdDapilX(hasil3)+'"';
                         Open;
                         First;
                         end;
                         count := DM.ZQCari5.RecordCount;
                         while not DM.ZQCari5.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                           // Cek Apakah Saksi Terdaftar
                             if cekSaksi(nohp)>=1 then
                             begin
           		    // Cek Apakah Nomor
                               if (IsNumber(hasil)=True) then
                               begin
                                 if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('id').AsString)<=0 then
                                 begin
                                 if (tglpemilu=tglsms) then
                                 begin
                               //  if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil6))then
                              //   begin
                                   with DM.ZQSimpan do
                                   begin
                                     Close;
                                     SQL.Clear;
                                     SQL.Text:='insert into t_hitungdprdprov (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,DM.ZQCari5.FieldByName('id').AsString)+'","'+DM.ZQCari5.FieldByName('id').AsString+'","'+getIdTPSSaksi(nohp)+'","'+hasil+'","'+ssah+'","'+stsah+'","'+dpt+'")';
                                     ExecSQL;
                                   end;
                                 // Suara Tersimpan
                                 kirimSMS(modem,nohp,getBalasan(33));
                               //  end else
                              //   kirimSMS(modem,nohp,getBalasan(59));
                                 end;
                                 // Suara Sudah Ada
                                 end else
                                 kirimSMS(modem,nohp,getBalasan(34))
           		    // Bukan Nomor
                               end else
                               kirimSMS(modem,nohp,getBalasan(15))
                             // Saksi Tidak Terdaftar
                             end else
                             kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQCari5.Next;
                         end;
                         end; // End DPRD Prov

                         if (hasil1='DPRDKABKOTA') then
                         begin
                         // No Urut Partai
         	         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // DAPIL
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         with DM.ZQCari5 do
                         begin
                         Close;
                         SQL.Clear;
                         SQL.Text:='select * from t_calegdprdkabkota where partai="'+hasil2+'" and dapil="'+getIdDapilX(hasil3)+'"';
                         Open;
                         First;
                         end;
                         count := DM.ZQCari5.RecordCount;
                         while not DM.ZQCari5.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                              // Cek Apakah Saksi Terdaftar
                             if cekSaksi(nohp)>=1 then
                             begin
         		    // Cek Apakah Nomor
                               if (IsNumber(hasil)=True) then
                               begin
                                 if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('id').AsString)<=0 then
                                 begin
                                 if (tglpemilu=tglsms) then
                                 begin
                              //   if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil6))then
         		     //    begin
                                   with DM.ZQSimpan do
                                   begin
                                     Close;
                                     SQL.Clear;
                                     SQL.Text:='insert into t_hitungdprdkab (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,DM.ZQCari5.FieldByName('id').AsString)+'","'+DM.ZQCari5.FieldByName('id').AsString+'","'+getIdTPSSaksi(nohp)+'","'+hasil+'","'+ssah+'","'+stsah+'","'+dpt+'")';
                                     ExecSQL;
                                   end;
                                 // Suara Tersimpan
                                 kirimSMS(modem,nohp,getBalasan(36));
                             //    end else
                              //   kirimSMS(modem,nohp,getBalasan(59));
                                 end;
                                 // Suara Sudah Ada
                                 end else
                                 kirimSMS(modem,nohp,getBalasan(37))
         					// Bukan Nomor
                               end else
                               kirimSMS(modem,nohp,getBalasan(15))
                             // Saksi Tidak Terdaftar
                             end else
                             kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQCari5.Next;
                         end;
                         end; // End DPRD Kab Kota

                         if (hasil1='PARTAI') then
                         begin
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         count := DM.ZQPartai.RecordCount;
                         DM.ZQPartai.First;
                         while not DM.ZQPartai.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                           // Cek Apakah Saksi Terdaftar
                           if cekSaksi(nohp)>=1 then
                           begin
               		  // Cek Apakah Nomor
                           if (IsNumber(hasil)=True) then
                             begin
                               if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQPartai.FieldByName('no_urut').AsString)<=0 then
                               begin
                               if (tglpemilu=tglsms) then
                               begin
                              // if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil9))then
                              // begin
                                 with DM.ZQSimpan do
                                 begin
                                   Close;
                                   SQL.Clear;
                                   if FUtama.LKategori.Caption='DPR RI' then
                                   SQL.Text:='insert into t_hitungpartai (no_urut,tps,suara_dprdkab,suara_dprdprov,suara_dprri,suara_sah,suara_tidaksah,dpt) values ("'+DM.ZQPartai.FieldByName('no_urut').AsString+'","'+getIdTPSSaksi(nohp)+'","0","0","'+hasil+'","'+ssah+'","'+stsah+'","'+dpt+'")';
                                   if FUtama.LKategori.Caption='DPRD Provinsi' then
                                   SQL.Text:='insert into t_hitungpartai (no_urut,tps,suara_dprdkab,suara_dprdprov,suara_dprri,suara_sah,suara_tidaksah,dpt) values ("'+DM.ZQPartai.FieldByName('no_urut').AsString+'","'+getIdTPSSaksi(nohp)+'","0","'+hasil+'","0","'+ssah+'","'+stsah+'","'+dpt+'")';
                                   if FUtama.LKategori.Caption='DPRD Kabupaten/Kota' then
                                   SQL.Text:='insert into t_hitungpartai (no_urut,tps,suara_dprdkab,suara_dprdprov,suara_dprri,suara_sah,suara_tidaksah,dpt) values ("'+DM.ZQPartai.FieldByName('no_urut').AsString+'","'+getIdTPSSaksi(nohp)+'","'+hasil+'","0","0","'+ssah+'","'+stsah+'","'+dpt+'")';
                                   ExecSQL;
                                 end;
                               // Suara Tersimpan
                               kirimSMS(modem,nohp,getBalasan(24));
                               // end else
                               // kirimSMS(modem,nohp,getBalasan(59));
                               end;
                               // Suara Sudah Ada
                               end else
                               kirimSMS(modem,nohp,getBalasan(25))
               		    // Bukan Nomor
                             end else
                             kirimSMS(modem,nohp,getBalasan(15))
                           // Saksi Tidak Terdaftar
                           end else
                           kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQPartai.Next;
                         end;
                         end; // End Partai

                     end; // End INPUT

                  // UPDATE
                  if (aksi='UPDATE') then
                     begin

                     kar_awal := posex(' ',pesan);
                     kar_akhir:= posex(pemisah,pesan,kar_awal);
                     hasil1   := AnsiUpperCase(copy(pesan,kar_awal+1,kar_akhir-kar_awal-1));

                         if (hasil1='DPD') then
                         begin
                         // DAPIL
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         with DM.ZQCari5 do
                         begin
                         Close;
                         SQL.Clear;
                         SQL.Text:='select * from t_calegdpdri where dapil="'+getIdDapilX(hasil3)+'"';
                         Open;
                         First;
                         end;
                         count := DM.ZQCari5.RecordCount;
                         //j:=1;
                        //count := DM.ZQDPDRI.RecordCount;
                         DM.ZQCari5.First;
                         while not DM.ZQCari5.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                           // Cek Apakah Saksi Terdaftar
                           if cekSaksi(nohp)>=1 then
                           begin
               		  // Cek Apakah Nomor
                           if (IsNumber(hasil)=True) then
                             begin
                               if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('no_urut').AsString)>=1 then
                               begin
                               if (tglpemilu=tglsms) then
                               begin
                              // if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil6))then
                             //  begin
               		      with DM.ZQSimpan do
               		      begin
               		      Close;
               		      SQL.Clear;
                               SQL.Text:='update t_hitungdpdri set dapil="'+getIdDapil(hasil1,DM.ZQCari5.FieldByName('no_urut').AsString)+'",no_urut="'+DM.ZQCari5.FieldByName('no_urut').AsString+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil+'",suara_sah="'+ssah+'",suara_tidaksah="'+stsah+'",dpt="'+dpt+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('no_urut').AsString)+'"';
               		      ExecSQL;
               		      end;
                               // Suara Tersimpan
                               kirimSMS(modem,nohp,getBalasan(46));
                            //   end else
                            //   kirimSMS(modem,nohp,getBalasan(59));
                               end;
                               // Suara Sudah Ada
                               end else
                               kirimSMS(modem,nohp,getBalasan(47))
         		    // Bukan Nomor
                             end else
                             kirimSMS(modem,nohp,getBalasan(15))
                           // Saksi Tidak Terdaftar
                           end else
                           kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQCari5.Next;
                         end;
                         end; // End DPD

                         if (hasil1='DPR') then
                         begin
                           // No Urut Partai
         	         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // DAPIL
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         with DM.ZQCari5 do
                         begin
                         Close;
                         SQL.Clear;
                         SQL.Text:='select * from t_calegdprri where partai="'+hasil2+'" and dapil="'+getIdDapilX(hasil3)+'"';
                         Open;
                         First;
                         end;
                         count := DM.ZQCari5.RecordCount;
                         while not DM.ZQCari5.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                           // Cek Apakah Saksi Terdaftar
                             if cekSaksi(nohp)>=1 then
                             begin
         		    // Cek Apakah Nomor
                               if (IsNumber(hasil)=True) then
                               begin
                                 if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('id').AsString)>=1 then
                                 begin
                                 if (tglpemilu=tglsms) then
                                 begin
                                // if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil6))then
                               //  begin
                                   with DM.ZQSimpan do
                                   begin
                                     Close;
                                     SQL.Clear;
                                     SQL.Text:='update t_hitungdprri set dapil="'+getIdDapil(hasil1,DM.ZQCari5.FieldByName('id').AsString)+'",id_caleg="'+DM.ZQCari5.FieldByName('id').AsString+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil+'",suara_sah="'+ssah+'",suara_tidaksah="'+stsah+'",dpt="'+dpt+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('id').AsString)+'"';
                                     ExecSQL;
                                   end;
                                   // Suara Tersimpan
                                   kirimSMS(modem,nohp,getBalasan(48));
                                 //  end else
                                 //  kirimSMS(modem,nohp,getBalasan(59));
                                   end;
                                   // Suara Sudah Ada
                                   end else
                                   kirimSMS(modem,nohp,getBalasan(49))
             		    // Bukan Nomor
                                 end else
                                 kirimSMS(modem,nohp,getBalasan(15))
                               // Saksi Tidak Terdaftar
                               end else
                               kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQCari5.Next;
                         end;
                         end; // End DPR

                         if (hasil1='DPRDPROV') then
                         begin
                         // No Urut Partai
         	         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // DAPIL
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         with DM.ZQCari5 do
                         begin
                         Close;
                         SQL.Clear;
                         SQL.Text:='select * from t_calegdprdprov where partai="'+hasil2+'" and dapil="'+getIdDapilX(hasil3)+'"';
                         Open;
                         First;
                         end;
                         count := DM.ZQCari5.RecordCount;
                         while not DM.ZQCari5.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                           // Cek Apakah Saksi Terdaftar
                             if cekSaksi(nohp)>=1 then
                             begin
           		    // Cek Apakah Nomor
                               if (IsNumber(hasil)=True) then
                               begin
                                 if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('id').AsString)>=1 then
                                 begin
                                 if (tglpemilu=tglsms) then
                                 begin
                               //  if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil6))then
                              //   begin
                                   with DM.ZQSimpan do
                                   begin
                                     Close;
                                     SQL.Clear;
                                     SQL.Text:='update t_hitungdprdprov set dapil="'+getIdDapil(hasil1,DM.ZQCari5.FieldByName('id').AsString)+'",id_caleg="'+DM.ZQCari5.FieldByName('id').AsString+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil+'",suara_sah="'+ssah+'",suara_tidaksah="'+stsah+'",dpt="'+dpt+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('id').AsString)+'"';
                                     ExecSQL;
                                   end;
                                   // Suara Tersimpan
                                   kirimSMS(modem,nohp,getBalasan(50));
                                 //  end else
                                 //  kirimSMS(modem,nohp,getBalasan(59));
                                   end;
                                   // Suara Sudah Ada
                                   end else
                                   kirimSMS(modem,nohp,getBalasan(51))
             		    // Bukan Nomor
                                 end else
                                 kirimSMS(modem,nohp,getBalasan(15))
                               // Saksi Tidak Terdaftar
                               end else
                               kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQCari5.Next;
                         end;
                         end; // End DPRD Prov

                         if (hasil1='DPRDKABKOTA') then
                         begin
                         // No Urut Partai
         	         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // DAPIL
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         with DM.ZQCari5 do
                         begin
                         Close;
                         SQL.Clear;
                         SQL.Text:='select * from t_calegdprdkabkota where partai="'+hasil2+'" and dapil="'+getIdDapilX(hasil3)+'"';
                         Open;
                         First;
                         end;
                         count := DM.ZQCari5.RecordCount;
                         while not DM.ZQCari5.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                              // Cek Apakah Saksi Terdaftar
                             if cekSaksi(nohp)>=1 then
                             begin
         		    // Cek Apakah Nomor
                               if (IsNumber(hasil)=True) then
                               begin
                                 if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('id').AsString)>=1 then
                                 begin
                                 if (tglpemilu=tglsms) then
                                 begin
                              //   if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil6))then
         		     //    begin
                                   with DM.ZQSimpan do
                                   begin
                                     Close;
                                     SQL.Clear;
                                     SQL.Text:='update t_hitungdprdkab set dapil="'+getIdDapil(hasil1,DM.ZQCari5.FieldByName('id').AsString)+'",id_caleg="'+DM.ZQCari5.FieldByName('id').AsString+'",tps="'+getIdTPSSaksi(nohp)+'",perolehan="'+hasil+'",suara_sah="'+ssah+'",suara_tidaksah="'+stsah+'",dpt="'+dpt+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),DM.ZQCari5.FieldByName('id').AsString)+'"';
                                     ExecSQL;
                                   end;
                                   // Suara Tersimpan
                                   kirimSMS(modem,nohp,getBalasan(52));
                                 //  end else
                                 //  kirimSMS(modem,nohp,getBalasan(59));
                                   end;
                                   // Suara Sudah Ada
                                   end else
                                   kirimSMS(modem,nohp,getBalasan(53))
             		    // Bukan Nomor
                                 end else
                                 kirimSMS(modem,nohp,getBalasan(15))
                               // Saksi Tidak Terdaftar
                               end else
                               kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQCari5.Next;
                         end;
                         end; // End DPRD Kab Kota

                         if (hasil1='PARTAI') then
                         begin
                         // Suara Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         ssah     := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Suara Tidak Sah
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         stsah    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         // Jumlah DPT
                         kar_awal := posex(pemisah,pesan,kar_akhir);
                         kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                         dpt      := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                         j:=1;
                         count := DM.ZQPartai.RecordCount;
                         DM.ZQPartai.First;
                         while not DM.ZQPartai.EOF do begin
                           if (j = count) then
                           begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           hasil := copy(pesan,kar_awal+1);
                           end else begin
                           kar_awal := posex(pemisah,pesan,kar_akhir);
                           kar_akhir:= posex(pemisah,pesan,kar_awal+1);
                           hasil := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);
                           end;
                           // VALIDASI
                           // Cek Apakah Saksi Terdaftar
                           if cekSaksi(nohp)>=1 then
                           begin
               		  // Cek Apakah Nomor
                           if (IsNumber(hasil)=True) then
                             begin
                               if cekSuara(hasil1,getIdTPSSaksi(nohp),DM.ZQPartai.FieldByName('no_urut').AsString)>=1 then
                               begin
                               if (tglpemilu=tglsms) then
                               begin
                              // if (getTotDPT(getIdTPSSaksi(nohp))=Trim(hasil9))then
                              // begin
                                 with DM.ZQSimpan do
                                 begin
                                   Close;
                                   SQL.Clear;
                                   if FUtama.LKategori.Caption='DPR RI' then
                                   SQL.Text:='update t_hitungpartai set no_urut="'+DM.ZQPartai.FieldByName('no_urut').AsString+'",tps="'+getIdTPSSaksi(nohp)+'",suara_dprdkab="0",suara_dprdprov="0",suara_dprri="'+hasil+'",suara_sah="'+ssah+'",suara_tidaksah="'+stsah+'",dpt="'+dpt+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),DM.ZQPartai.FieldByName('no_urut').AsString)+'"';
                                   if FUtama.LKategori.Caption='DPRD Provinsi' then
                                   SQL.Text:='update t_hitungpartai set no_urut="'+DM.ZQPartai.FieldByName('no_urut').AsString+'",tps="'+getIdTPSSaksi(nohp)+'",suara_dprdkab="0",suara_dprdprov="'+hasil+'",suara_dprri="0",suara_sah="'+ssah+'",suara_tidaksah="'+stsah+'",dpt="'+dpt+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),DM.ZQPartai.FieldByName('no_urut').AsString)+'"';
                                   if FUtama.LKategori.Caption='DPRD Kabupaten/Kota' then
                                   SQL.Text:='update t_hitungpartai set no_urut="'+DM.ZQPartai.FieldByName('no_urut').AsString+'",tps="'+getIdTPSSaksi(nohp)+'",suara_dprdkab="'+hasil+'",suara_dprdprov="0",suara_dprri="0",suara_sah="'+ssah+'",suara_tidaksah="'+stsah+'",dpt="'+dpt+'" where id="'+getIdHitung(hasil1,getIdTPSSaksi(nohp),DM.ZQPartai.FieldByName('no_urut').AsString)+'"';
                                   ExecSQL;
                                 end;
                                 // Suara Tersimpan
                                 kirimSMS(modem,nohp,getBalasan(44));
                               //  end else
                              //   kirimSMS(modem,nohp,getBalasan(59));
                                 end;
                                 // Suara Sudah Ada
                                 end else
                                 kirimSMS(modem,nohp,getBalasan(45))
           		    // Bukan Nomor
                               end else
                               kirimSMS(modem,nohp,getBalasan(15))
                             // Saksi Tidak Terdaftar
                             end else
                             kirimSMS(modem,nohp,getBalasan(16));
                           // END VALIDASI
                           j := j + 1;
                           hasil := '';
                           DM.ZQPartai.Next;
                         end;
                         end; // End Partai
                     end; // End UPDATE

         // KIRIM CALON
         if (aksi='KIRIM') then
            begin

            kar_awal := posex(' ',pesan);
            kar_akhir:= posex(pemisah,pesan,kar_awal);
            hasil1   := AnsiUpperCase(copy(pesan,kar_awal+1,kar_akhir-kar_awal-1));

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil4   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil5   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            if not (hasil1='PARTAI') then
            begin

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil6   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            nmkel    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            notps    := copy(pesan,kar_awal+1);

            end else
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil6   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil7   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil8   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

	    {kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil9   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1); }

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            nmkel    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            notps    := copy(pesan,kar_awal+1);
            end;

            if (hasil1='CAPRES') then
              begin

                if cekCalon(hasil1,hasil2)<=0 then
                kirimSMS(modem,nohp,getBalasan(12))
                else begin
                  // Cek Apakah Saksi Terdaftar
                  if cekKoor(nohp)>=1 then
                  begin
		    // Cek Apakah Nomor
                    if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                    begin
                      if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)<=0 then
                      begin
                        if (tglpemilu=tglsms) then
                        begin
                        with DM.ZQSimpan do
                        begin
                          Close;
                          SQL.Clear;
                          SQL.Text:='insert into t_hitungcapres (no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+hasil2+'","'+getIdTPS(notps,nmkel)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                          ExecSQL;
                        end;
                      // Suara Tersimpan
                      kirimSMS(modem,nohp,getBalasan(13));
                      // Suara Sudah Ada
                      end;
                      end else
                      kirimSMS(modem,nohp,getBalasan(14))
		    // Bukan Nomor
                    end else
                    kirimSMS(modem,nohp,getBalasan(15))
                  // Saksi Tidak Terdaftar
                  end else
                  kirimSMS(modem,nohp,getBalasan(59));
                end;
              end;

              if (hasil1='CAGUB') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(17))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungcagub (provinsi,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdCagub(hasil2)+'","'+hasil2+'","'+getIdTPS(notps,nmkel)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(18));
                        // Suara Sudah Ada
                        end;
                        end else
                        kirimSMS(modem,nohp,getBalasan(19))
  		       // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='CABUPKOTA') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(20))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungcabup (kabkota,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdCabup(hasil2)+'","'+hasil2+'","'+getIdTPS(notps,nmkel)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(21));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(22))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='PARTAI') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(23))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) and (IsNumber(hasil7)=True) and (IsNumber(hasil8)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungpartai (no_urut,tps,suara_dprri,suara_dprdprov,suara_dprdkab,suara_sah,suara_tidaksah,dpt) values ("'+hasil2+'","'+getIdTPS(notps,nmkel)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'","'+hasil7+'","'+hasil8+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(24));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(25))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='DPD') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(26))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungdpdri (dapil,no_urut,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,hasil2)+'","'+hasil2+'","'+getIdTPS(notps,nmkel)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(27));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(28))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='DPR') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(29))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungdprri (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,hasil2)+'","'+hasil2+'","'+getIdTPS(notps,nmkel)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(30));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(31))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='DPRDPROV') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(32))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungdprdprov (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,hasil2)+'","'+hasil2+'","'+getIdTPS(notps,nmkel)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(33));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(34))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='DPRDKABKOTA') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(35))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)<=0 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='insert into t_hitungdprdkab (dapil,id_caleg,tps,perolehan,suara_sah,suara_tidaksah,dpt) values ("'+getIdDapil(hasil1,hasil2)+'","'+hasil2+'","'+getIdTPS(notps,nmkel)+'","'+hasil3+'","'+hasil4+'","'+hasil5+'","'+hasil6+'")';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(36));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(37))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

            end;  // End KIRIM

         // PERBARUI
         if (aksi='PERBARUI') then
            begin

            kar_awal := posex(' ',pesan);
            kar_akhir:= posex(pemisah,pesan,kar_awal);
            hasil1   := AnsiUpperCase(copy(pesan,kar_awal+1,kar_akhir-kar_awal-1));

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil2   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil3   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil4   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil5   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            if not (hasil1='PARTAI') then
            begin
			kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil6   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            nmkel    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            notps    := copy(pesan,kar_awal+1);
            end else
            begin
            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil6   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil7   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil8   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

	    {kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            hasil9   := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1); }

            kar_awal := posex(pemisah,pesan,kar_akhir);
            kar_akhir:= posex(pemisah,pesan,kar_awal+1);
            nmkel    := copy(pesan,kar_awal+1,kar_akhir-kar_awal-1);

            kar_awal := posex(pemisah,pesan,kar_akhir);
            notps    := copy(pesan,kar_awal+1);
            end;

            if (hasil1='CAPRES') then
              begin

                if cekCalon(hasil1,hasil2)<=0 then
                kirimSMS(modem,nohp,getBalasan(12))
                else begin
                  // Cek Apakah Saksi Terdaftar
                  if cekKoor(nohp)>=1 then
                  begin
		    // Cek Apakah Nomor
                    if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                    begin
                      if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)>=1 then
                      begin
                        if (tglpemilu=tglsms) then
                        begin
                        with DM.ZQSimpan do
                        begin
                          Close;
                          SQL.Clear;
                          SQL.Text:='update t_hitungcapres set no_urut="'+hasil2+'",tps="'+getIdTPS(notps,nmkel)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPS(notps,nmkel),hasil2)+'"';
                          ExecSQL;
                        end;
                      // Suara Tersimpan
                      kirimSMS(modem,nohp,getBalasan(38));
                      // Suara Sudah Ada
                      end;
                      end else
                      kirimSMS(modem,nohp,getBalasan(39))
		    // Bukan Nomor
                    end else
                    kirimSMS(modem,nohp,getBalasan(15))
                  // Saksi Tidak Terdaftar
                  end else
                  kirimSMS(modem,nohp,getBalasan(59));
                end;
              end;

              if (hasil1='CAGUB') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(17))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungcagub set provinsi="'+getIdCagub(hasil2)+'",no_urut="'+hasil2+'",tps="'+getIdTPS(notps,nmkel)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPS(notps,nmkel),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(40));
                        // Suara Sudah Ada
                        end;
                        end else
                        kirimSMS(modem,nohp,getBalasan(41))
  		       // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='CABUPKOTA') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(20))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungcabup set kabkota="'+getIdCabup(hasil2)+'",no_urut="'+hasil2+'",tps="'+getIdTPS(notps,nmkel)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPS(notps,nmkel),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(42));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(43))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='PARTAI') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(23))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) and (IsNumber(hasil7)=True) and (IsNumber(hasil8)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungpartai set no_urut="'+hasil2+'",tps="'+getIdTPS(notps,nmkel)+'",suara_dprri="'+hasil3+'",suara_dprdprov="'+hasil4+'",suara_dprdkab="'+hasil5+'",suara_sah="'+hasil6+'",suara_tidaksah="'+hasil7+'",dpt="'+hasil8+'" where id="'+getIdHitung(hasil1,getIdTPS(notps,nmkel),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(44));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(45))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='DPD') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(26))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungdpdri set dapil="'+getIdDapil(hasil1,hasil2)+'",no_urut="'+hasil2+'",tps="'+getIdTPS(notps,nmkel)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPS(notps,nmkel),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(46));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(47))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='DPR') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(29))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungdprri set dapil="'+getIdDapil(hasil1,hasil2)+'",id_caleg="'+hasil2+'",tps="'+getIdTPS(notps,nmkel)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPS(notps,nmkel),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(48));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(49))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='DPRDPROV') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(32))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungdprdprov set dapil="'+getIdDapil(hasil1,hasil2)+'",id_caleg="'+hasil2+'",tps="'+getIdTPS(notps,nmkel)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPS(notps,nmkel),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(50));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(51))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

              if (hasil1='DPRDKABKOTA') then
                begin

                  if cekCalon(hasil1,hasil2)<=0 then
                  kirimSMS(modem,nohp,getBalasan(35))
                  else begin
                    // Cek Apakah Saksi Terdaftar
                    if cekKoor(nohp)>=1 then
                    begin
  		    // Cek Apakah Nomor
                      if (IsNumber(hasil3)=True) and (IsNumber(hasil4)=True) and (IsNumber(hasil5)=True) and (IsNumber(hasil6)=True) then
                      begin
                        if cekSuara(hasil1,getIdTPS(notps,nmkel),hasil2)>=1 then
                        begin
                        if (tglpemilu=tglsms) then
                        begin
                          with DM.ZQSimpan do
                          begin
                            Close;
                            SQL.Clear;
                            SQL.Text:='update t_hitungdprdkab set dapil="'+getIdDapil(hasil1,hasil2)+'",id_caleg="'+hasil2+'",tps="'+getIdTPS(notps,nmkel)+'",perolehan="'+hasil3+'",suara_sah="'+hasil4+'",suara_tidaksah="'+hasil5+'",dpt="'+hasil6+'" where id="'+getIdHitung(hasil1,getIdTPS(notps,nmkel),hasil2)+'"';
                            ExecSQL;
                          end;
                        // Suara Tersimpan
                        kirimSMS(modem,nohp,getBalasan(52));
                        end;
                        // Suara Sudah Ada
                        end else
                        kirimSMS(modem,nohp,getBalasan(53))
  		    // Bukan Nomor
                      end else
                      kirimSMS(modem,nohp,getBalasan(15))
                    // Saksi Tidak Terdaftar
                    end else
                    kirimSMS(modem,nohp,getBalasan(59));
                  end;
                end;

            end;  // End PERBARUI

     // Update Inbox Jadi True
     with DM.ZQCari2 do
     begin
     Close;
     SQL.Clear;
     SQL.Text:='update t_inboxsms set processed="True" where id="'+DM.ZQCariSMS.FieldByName('id').AsString+'"';
     ExecSQL;
     end;
     //Next;
     //end; // End Looping
     end; // End Cek Ada Data
  end; // End ZQCariSMS
end;

function getIdKelurahan(nama: string): string;
begin
 Result:='';
  with DM.ZQTimerCari do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_kelurahan as id from t_kelurahan where nama_kelurahan="'+nama+'"';
   Open;
  end;
  if DM.ZQTimerCari.RecordCount>=1 then
  Result:=DM.ZQTimerCari.FieldByName('id').AsString;
end;

function getIdTPS(no: string;kelurahan:string): string;
begin
 Result:='';
 with DM.ZQTimerCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select id_tps as id from t_tps where no_tps="'+no+'" and id_kelurahan="'+getIdKelurahan(kelurahan)+'"';
  Open;
 end;
 if DM.ZQTimerCari.RecordCount>=1 then
 Result:=DM.ZQTimerCari.FieldByName('id').AsString;
end;

function cekSaksiD(nohp: string; idtelegram:string; idtps:string): integer;
begin
Result:=0;
 with DM.ZQTimerCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_saksi where nohp="'+nohp+'" or id_telegram="'+idtelegram+'" or tps="'+idtps+'"';
  Open;
 end;
 Result:=DM.ZQTimerCari.RecordCount;
end;

function cekSaksi(nohp: string): integer;
begin
Result:=0;
 with DM.ZQTimerCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_saksi where nohp="'+nohp+'"';
  Open;
 end;
 Result:=DM.ZQTimerCari.RecordCount;
end;

function cekKoor(nohp: string): integer;
begin
    Result:=0;
   with DM.ZQTimerCari do
   begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_usulantimses where nohp="'+nohp+'"';
    Open;
   end;
   Result:=DM.ZQTimerCari.RecordCount;
end;

function cekRelawan(nohp: string; idtelegram:string): integer;
begin
  Result:=0;
 with DM.ZQTimerCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_timses where nohp="'+nohp+'" or id_telegram="'+idtelegram+'"';
  Open;
 end;
 Result:=DM.ZQTimerCari.RecordCount;
end;

function cekRelawanAda(nohp: string): integer;
begin
Result:=0;
with DM.ZQTimerCari do
begin
Close;
SQL.Clear;
SQL.Text:='select * from t_timses where nohp="'+nohp+'"';
Open;
end;
Result:=DM.ZQTimerCari.RecordCount;
end;

function cekUsulanAda(nohp: string): integer;
begin
  Result:=0;
  with DM.ZQTimerCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_usulantimses where nohp="'+nohp+'"';
  Open;
  end;
  Result:=DM.ZQTimerCari.RecordCount;
end;

function cekKTP(noktp: string; status: string): integer;
begin
  Result:=0;
  if (status='USUL') then
  begin
  with DM.ZQTimerCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_usulantimses where noktp="'+noktp+'"';
  Open;
  end;
  end else
  if (status='DUKUNG') then
  begin
  with DM.ZQTimerCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_dukunganindie where noktp="'+noktp+'"';
  Open;
  end;
  end;
  Result:=DM.ZQTimerCari.RecordCount;
end;

function cekPolling(nohp: string): integer;
begin
 Result:=0;
  with DM.ZQTimerCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_polling where nohp="'+nohp+'"';
  Open;
  end;
  Result:=DM.ZQTimerCari.RecordCount;
end;

function ReplaceNol(n:string): string;
var
i : integer;
hasil : string;
begin
Result:='';
if (Length(Trim(n))>=10) and (Trim(n)[1]='0') then
   begin
    hasil := '+62';
    for i := 2 to Length(n) do hasil := hasil + n[i];
    Result:=hasil;
   end else
   if (copy(Trim(n),1,3)='+62') and (Length(Trim(n))>=10)
   then Result:=n;
end;

procedure kirimSMS(modem: string; nohp: string; isi: string);
begin
  with DM.ZQTimerKirimSMS do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+modem+'","'+nohp+'","'+isi+'","Pending")';
  ExecSQL;
  end;
end;

function getIdTPSSaksi(nohp: string): string;
begin
Result:='';
 with DM.ZQTimerCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select tps from t_saksi where nohp="'+nohp+'"';
 Open;
 end;
 Result:=DM.ZQTimerCari.FieldByName('tps').AsString;
end;

function cekSuara(status:string; idtps: string; idcalon: string): integer;
begin
Result:=0;

  if (status='CAPRES') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hitungcapres where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='KADES') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hitungkades where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='CAGUB') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hitungcagub where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='CABUPKOTA') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hitungcabup where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='PARTAI') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hitungpartai where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='DPD') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hitungdpdri where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='DPR') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hitungdprri where id_caleg="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='DPRDPROV') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hitungdprdprov where id_caleg="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='DPRDKABKOTA') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select * from t_hitungdprdkab where id_caleg="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

 Result:=DM.ZQTimerCari.RecordCount;
end;

function getIdHitung(status: string; idtps: string; idcalon: string): string;
begin
Result:='';

  if (status='CAPRES') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id from t_hitungcapres where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

    if (status='KADES') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id from t_hitungkades where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='CAGUB') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id from t_hitungcagub where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='CABUPKOTA') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id from t_hitungcabup where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='PARTAI') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id from t_hitungpartai where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='DPD') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id from t_hitungdpdri where no_urut="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='DPR') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id from t_hitungdprri where id_caleg="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='DPRDPROV') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id from t_hitungdprdprov where id_caleg="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

  if (status='DPRDKABKOTA') then
  begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id from t_hitungdprdkab where id_caleg="'+idcalon+'" and tps="'+idtps+'"';
   Open;
   end;
  end;

 Result:=DM.ZQTimerCari.FieldByName('id').AsString;
end;

function getIdCagub(idx: string): string;
begin
Result:='';
 with DM.ZQTimerCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select daerah from t_cagub where no_urut="'+idx+'"';
 Open;
 end;
 Result:=DM.ZQTimerCari.FieldByName('daerah').AsString;
end;

function getIdKades(idx: string): string;
begin
  Result:='';
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select daerah from t_cakades where no_urut="'+idx+'"';
   Open;
   end;
   Result:=DM.ZQTimerCari.FieldByName('daerah').AsString;
end;

function getIdCabup(idx: string): string;
begin
Result:='';
 with DM.ZQTimerCari do
 begin
 Close;
 SQL.Clear;
 SQL.Text:='select daerah from t_cabupkota where no_urut="'+idx+'"';
 Open;
 end;
 Result:=DM.ZQTimerCari.FieldByName('daerah').AsString;
end;

function getIdDapil(status:string;idx: string): string;
begin
Result:='';

   if (status='DPD') then
   begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select dapil from t_calegdpdri where no_urut="'+idx+'"';
   Open;
   end;
   end;

   if (status='DPR') then
   begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select dapil from t_calegdprri where id="'+idx+'"';
   Open;
   end;
   end;

   if (status='DPRDPROV') then
   begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select dapil from t_calegdprdprov where id="'+idx+'"';
   Open;
   end;
   end;

   if (status='DPRDKABKOTA') then
   begin
   with DM.ZQTimerCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select dapil from t_calegdprdkabkota where id="'+idx+'"';
   Open;
   end;
   end;

 Result:=DM.ZQTimerCari.FieldByName('dapil').AsString;
end;

function getBalasan(idx: integer): string;
begin
    Result:='';
  with DM.ZQTimerCari do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='select balasan from t_smsbalasan where id="'+IntToStr(idx)+'"';
    Open;
    end;
  Result:=DM.ZQTimerCari.FieldByName('balasan').AsString;
end;

function getIdDapilX(nama: string): string;
begin
    Result:='';
  with DM.ZQTimerCari do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='select id_dapil as id from t_dapil where nama_dapil="'+Trim(nama)+'"';
    Open;
    end;
  Result:=DM.ZQTimerCari.FieldByName('id').AsString;
end;

function IsNumber(N : String) : Boolean;
  var
  I : Integer;
  begin
  Result := True;
  if Trim(N) = '' then
   Exit(False);

  if (Length(Trim(N)) > 1) and (Trim(N)[1] = '0') then
  Exit(False);

  for I := 1 to Length(N) do
  begin
   if not (N[I] in ['0'..'9']) then
    begin
     Result := False;
     Break;
   end;
  end;
end;

function NilaiUnik(NamaTabel: String; NamaField: String): Integer;
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

function hitungHasil(status: string): string;
var
i : integer;
hasil : string;
persen : Real;
suara,jumlah : LongInt;
begin
  Result := 'Format Salah';
  hasil  := 'Jumlah perolehan suara '+status+' adalah sbb : '+sLineBreak;

  if (status='CAPRES') then
  begin
  DM.ZQCapres.First;
  for i := 1 to DM.ZQCapres.RecordCount do begin
    with DM.ZQCari2 do begin
    Close;
    SQL.Clear;
    SQL.Text:='select sum(perolehan) as hasil from t_hitungcapres where no_urut="'+DM.ZQCapres.FieldByName('no_urut').AsString+'"';
    Open;
    end;
    // Persentase
    if (NilaiUnik('t_hitungcapres','suara_sah') > 0) and (DM.ZQCari2.FieldByName('hasil').AsInteger > 0) then
    persen := StrToFloat(FormatFloat('0.##',(DM.ZQCari2.FieldByName('hasil').AsInteger/NilaiUnik('t_hitungcapres','suara_sah'))*100)) else
    persen := 0;
    hasil := hasil + DM.ZQCapres.FieldByName('nama_akronim').AsString +' : '+FormatCurr('#,###',DM.ZQCari2.FieldByName('hasil').AsInteger)+' ('+FloatToStr(persen)+'%)'+sLineBreak;
    DM.ZQCapres.Next;
  end;
  // Suara Masuk
  suara := NilaiUnik('t_hitungcapres','dpt');
  // Jumlah Pemilih
  with DM.ZQCari3 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select pemilih_capres as jml from t_config';
  Open;
  jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
  // Jumlah Pemilih Belum Diatur
  if (jumlah<=0) then hasil := hasil + 'Jumlah Suara Masuk (Jumlah Pemilih Belum Diatur)' else
  // Persentase
  if (suara>0) then hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' ('+FormatFloat('0.##',((suara/jumlah)*100))+'%)' else hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' (0%)';
  end;
  Result := hasil;
  end;

  if (status='CAGUB') then
  begin
  DM.ZQCagub.First;
  for i := 1 to DM.ZQCagub.RecordCount do begin
    with DM.ZQCari2 do begin
    Close;
    SQL.Clear;
    SQL.Text:='select sum(perolehan) as hasil from t_hitungcagub where no_urut="'+DM.ZQCagub.FieldByName('no_urut').AsString+'"';
    Open;
    end;
    // Persentase
    if (NilaiUnik('t_hitungcagub','suara_sah') > 0) and (DM.ZQCari2.FieldByName('hasil').AsInteger > 0) then
    persen := StrToFloat(FormatFloat('0.##',(DM.ZQCari2.FieldByName('hasil').AsInteger/NilaiUnik('t_hitungcagub','suara_sah'))*100)) else
    persen := 0;

    hasil := hasil + DM.ZQCagub.FieldByName('nama_akronim').AsString +' : '+FormatCurr('#,###',DM.ZQCari2.FieldByName('hasil').AsInteger)+' ('+FloatToStr(persen)+'%)'+sLineBreak;
    DM.ZQCagub.Next;
  end;
  // Suara Masuk
  suara := NilaiUnik('t_hitungcagub','dpt');
  // Jumlah Pemilih
  with DM.ZQCari3 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select pemilih_cagub as jml from t_config';
  Open;
  jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
  // Jumlah Pemilih Belum Diatur
  if (jumlah<=0) then hasil := hasil + 'Jumlah Suara Masuk (Jumlah Pemilih Belum Diatur)' else
  // Persentase
  if (suara>0) then hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' ('+FormatFloat('0.##',((suara/jumlah)*100))+'%)' else hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' (0%)';
  end;
  Result := hasil;
  end;

  if (status='CABUPKOTA') then
  begin
  DM.ZQCabupKota.First;
  for i := 1 to DM.ZQCabupKota.RecordCount do begin
    with DM.ZQCari2 do begin
    Close;
    SQL.Clear;
    SQL.Text:='select sum(perolehan) as hasil from t_hitungcabup where no_urut="'+DM.ZQCabupKota.FieldByName('no_urut').AsString+'"';
    Open;
    end;
    // Persentase
    if (NilaiUnik('t_hitungcabup','suara_sah') > 0) and (DM.ZQCari2.FieldByName('hasil').AsInteger > 0) then
    persen := StrToFloat(FormatFloat('0.##',(DM.ZQCari2.FieldByName('hasil').AsInteger/NilaiUnik('t_hitungcabup','suara_sah'))*100)) else
    persen := 0;

    hasil := hasil + DM.ZQCabupKota.FieldByName('nama_akronim').AsString +' : '+FormatCurr('#,###',DM.ZQCari2.FieldByName('hasil').AsInteger)+' ('+FloatToStr(persen)+'%)'+sLineBreak;
    DM.ZQCabupKota.Next;
  end;
  // Suara Masuk
  suara := NilaiUnik('t_hitungcabup','dpt');
  // Jumlah Pemilih
  with DM.ZQCari3 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select pemilih_cabup as jml from t_config';
  Open;
  jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
  // Jumlah Pemilih Belum Diatur
  if (jumlah<=0) then hasil := hasil + 'Jumlah Suara Masuk (Jumlah Pemilih Belum Diatur)' else
  // Persentase
  if (suara>0) then hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' ('+FormatFloat('0.##',((suara/jumlah)*100))+'%)' else hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' (0%)';
  end;
  Result := hasil;
  end;

  if (status='PARTAI') then
    begin
    DM.ZQPartai.First;
    for i := 1 to DM.ZQPartai.RecordCount do begin
      with DM.ZQCari2 do begin
      Close;
      SQL.Clear;
      SQL.Text:='select sum(total_suara) as hasil from t_hitungpartai where no_urut="'+DM.ZQPartai.FieldByName('no_urut').AsString+'"';
      Open;
      end;
      // Persentase
      if (NilaiUnik('t_hitungpartai','suara_sah') > 0) and (DM.ZQCari2.FieldByName('hasil').AsInteger > 0) then
      persen := StrToFloat(FormatFloat('0.##',(DM.ZQCari2.FieldByName('hasil').AsInteger/NilaiUnik('t_hitungpartai','suara_sah'))*100)) else
      persen := 0;

      hasil := hasil + DM.ZQPartai.FieldByName('singkatan').AsString +' : '+FormatCurr('#,###',DM.ZQCari2.FieldByName('hasil').AsInteger)+' ('+FloatToStr(persen)+'%)'+sLineBreak;
      DM.ZQPartai.Next;
    end;
    // Suara Masuk
    suara := NilaiUnik('t_hitungpartai','dpt');
    // Jumlah Pemilih
    with DM.ZQCari3 do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='select pemilih_partai as jml from t_config';
    Open;
    jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
    // Jumlah Pemilih Belum Diatur
    if (jumlah<=0) then hasil := hasil + 'Jumlah Suara Masuk (Jumlah Pemilih Belum Diatur)' else
    // Persentase
    if (suara>0) then hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' ('+FormatFloat('0.##',((suara/jumlah)*100))+'%)' else hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' (0%)';
    end;
    Result := hasil;
  end;

  if (status='DPD') then
    begin
    DM.ZQDPDRI.First;
    for i := 1 to DM.ZQDPDRI.RecordCount do begin
      with DM.ZQCari2 do begin
      Close;
      SQL.Clear;
      SQL.Text:='select sum(perolehan) as hasil from t_hitungdpdri where no_urut="'+DM.ZQDPDRI.FieldByName('no_urut').AsString+'"';
      Open;
      end;
      // Persentase
      if (NilaiUnik('t_hitungdpdri','suara_sah') > 0) and (DM.ZQCari2.FieldByName('hasil').AsInteger > 0) then
      persen := StrToFloat(FormatFloat('0.##',(DM.ZQCari2.FieldByName('hasil').AsInteger/NilaiUnik('t_hitungdpdri','suara_sah'))*100)) else
      persen := 0;

      hasil := hasil + DM.ZQDPDRI.FieldByName('nama_caleg').AsString +' : '+FormatCurr('#,###',DM.ZQCari2.FieldByName('hasil').AsInteger)+' ('+FloatToStr(persen)+'%)'+sLineBreak;
      DM.ZQDPDRI.Next;
    end;
    // Suara Masuk
    suara := NilaiUnik('t_hitungdpdri','dpt');
    // Jumlah Pemilih
    with DM.ZQCari3 do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='select pemilih_dpd as jml from t_config';
    Open;
    jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
    // Jumlah Pemilih Belum Diatur
    if (jumlah<=0) then hasil := hasil + 'Jumlah Suara Masuk (Jumlah Pemilih Belum Diatur)' else
    // Persentase
    if (suara>0) then hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' ('+FormatFloat('0.##',((suara/jumlah)*100))+'%)' else hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' (0%)';
    end;
    Result := hasil;
  end;

    if (status='DPR') then
    begin
    DM.ZQDPRRI.First;
    for i := 1 to DM.ZQDPRRI.RecordCount do begin
      with DM.ZQCari2 do begin
      Close;
      SQL.Clear;
      SQL.Text:='select sum(perolehan) as hasil from t_hitungdprri where id_caleg="'+DM.ZQDPRRI.FieldByName('id').AsString+'"';
      Open;
      end;
      // Persentase
      if (NilaiUnik('t_hitungdprri','suara_sah') > 0) and (DM.ZQCari2.FieldByName('hasil').AsInteger > 0) then
      persen := StrToFloat(FormatFloat('0.##',(DM.ZQCari2.FieldByName('hasil').AsInteger/NilaiUnik('t_hitungdprri','suara_sah'))*100)) else
      persen := 0;

      hasil := hasil + DM.ZQDPRRI.FieldByName('nama_caleg').AsString +' : '+FormatCurr('#,###',DM.ZQCari2.FieldByName('hasil').AsInteger)+' ('+FloatToStr(persen)+'%)'+sLineBreak;
      DM.ZQDPRRI.Next;
    end;
    // Suara Masuk
    suara := NilaiUnik('t_hitungdprri','dpt');
    // Jumlah Pemilih
    with DM.ZQCari3 do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='select pemilih_dpr as jml from t_config';
    Open;
    jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
    // Jumlah Pemilih Belum Diatur
    if (jumlah<=0) then hasil := hasil + 'Jumlah Suara Masuk (Jumlah Pemilih Belum Diatur)' else
    // Persentase
    if (suara>0) then hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' ('+FormatFloat('0.##',((suara/jumlah)*100))+'%)' else hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' (0%)';
    end;
    Result := hasil;
  end;

    if (status='DPRDPROV') then
      begin
      DM.ZQDPRDProv.First;
      for i := 1 to DM.ZQDPRDProv.RecordCount do begin
        with DM.ZQCari2 do begin
        Close;
        SQL.Clear;
        SQL.Text:='select sum(perolehan) as hasil from t_hitungdprdprov where id_caleg="'+DM.ZQDPRDProv.FieldByName('id').AsString+'"';
        Open;
        end;
        // Persentase
        if (NilaiUnik('t_hitungdprdprov','suara_sah') > 0) and (DM.ZQCari2.FieldByName('hasil').AsInteger > 0) then
        persen := StrToFloat(FormatFloat('0.##',(DM.ZQCari2.FieldByName('hasil').AsInteger/NilaiUnik('t_hitungdprdprov','suara_sah'))*100)) else
        persen := 0;

        hasil := hasil + DM.ZQDPRDProv.FieldByName('nama_caleg').AsString +' : '+FormatCurr('#,###',DM.ZQCari2.FieldByName('hasil').AsInteger)+' ('+FloatToStr(persen)+'%)'+sLineBreak;
        DM.ZQDPRDProv.Next;
      end;
      // Suara Masuk
      suara := NilaiUnik('t_hitungdprdprov','dpt');
      // Jumlah Pemilih
      with DM.ZQCari3 do
      begin
      Close;
      SQL.Clear;
      SQL.Text:='select pemilih_dprdprov as jml from t_config';
      Open;
      jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
      // Jumlah Pemilih Belum Diatur
      if (jumlah<=0) then hasil := hasil + 'Jumlah Suara Masuk (Jumlah Pemilih Belum Diatur)' else
      // Persentase
      if (suara>0) then hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' ('+FormatFloat('0.##',((suara/jumlah)*100))+'%)' else hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' (0%)';
      end;
      Result := hasil;
    end;

   if (status='DPRDKABKOTA') then
    begin
    DM.ZQDPRDKab.First;
    for i := 1 to DM.ZQDPRDKab.RecordCount do begin
      with DM.ZQCari2 do begin
      Close;
      SQL.Clear;
      SQL.Text:='select sum(perolehan) as hasil from t_hitungdprdkab where id_caleg="'+DM.ZQDPRDKab.FieldByName('id').AsString+'"';
      Open;
      end;
      // Persentase
      if (NilaiUnik('t_hitungdprdkab','suara_sah') > 0) and (DM.ZQCari2.FieldByName('hasil').AsInteger > 0) then
      persen := StrToFloat(FormatFloat('0.##',(DM.ZQCari2.FieldByName('hasil').AsInteger/NilaiUnik('t_hitungdprdkab','suara_sah'))*100)) else
      persen := 0;

      hasil := hasil + DM.ZQDPRDKab.FieldByName('nama_caleg').AsString +' : '+FormatCurr('#,###',DM.ZQCari2.FieldByName('hasil').AsInteger)+' ('+FloatToStr(persen)+'%)'+sLineBreak;
      DM.ZQDPRDKab.Next;
    end;
    // Suara Masuk
    suara := NilaiUnik('t_hitungdprdkab','dpt');
    // Jumlah Pemilih
    with DM.ZQCari3 do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='select pemilih_dprdkabkota as jml from t_config';
    Open;
    jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
    // Jumlah Pemilih Belum Diatur
    if (jumlah<=0) then hasil := hasil + 'Jumlah Suara Masuk (Jumlah Pemilih Belum Diatur)' else
    // Persentase
    if (suara>0) then hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' ('+FormatFloat('0.##',((suara/jumlah)*100))+'%)' else hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' (0%)';
    end;
    Result := hasil;
  end;

   if (status='KADES') then
   begin
   DM.ZQKades.First;
   for i := 1 to DM.ZQKades.RecordCount do begin
     with DM.ZQCari2 do begin
     Close;
     SQL.Clear;
     SQL.Text:='select sum(perolehan) as hasil from t_hitungkades where no_urut="'+DM.ZQKades.FieldByName('no_urut').AsString+'"';
     Open;
     end;
     // Persentase
     if (NilaiUnik('t_hitungkades','suara_sah') > 0) and (DM.ZQCari2.FieldByName('hasil').AsInteger > 0) then
     persen := StrToFloat(FormatFloat('0.##',(DM.ZQCari2.FieldByName('hasil').AsInteger/NilaiUnik('t_hitungkades','suara_sah'))*100)) else
     persen := 0;
     hasil := hasil + DM.ZQKades.FieldByName('nama_kades').AsString +' : '+FormatCurr('#,###',DM.ZQCari2.FieldByName('hasil').AsInteger)+' ('+FloatToStr(persen)+'%)'+sLineBreak;
     DM.ZQKades.Next;
   end;
   // Suara Masuk
   suara := NilaiUnik('t_hitungkades','dpt');
   // Jumlah Pemilih
   with DM.ZQCari3 do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select pemilih_kades as jml from t_config';
   Open;
   jumlah :=StrToIntDef(FieldByName('jml').AsString,0);
   // Jumlah Pemilih Belum Diatur
   if (jumlah<=0) then hasil := hasil + 'Jumlah Suara Masuk (Jumlah Pemilih Belum Diatur)' else
   // Persentase
   if (suara>0) then hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' ('+FormatFloat('0.##',((suara/jumlah)*100))+'%)' else hasil := hasil + 'Jumlah Suara Masuk : '+FormatCurr('#,###',suara)+' (0%)';
   end;
   Result := hasil;
   end;
end;

function cekCalon(status:string;idno: string): integer;
begin
  Result:=0;

  if (status='CAPRES') then
  begin
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_capres where no_urut="'+idno+'"';
  Open;
  end;
  Result:=DM.ZQCari2.RecordCount;
  end;

  if (status='KADES') then
  begin
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_cakades where no_urut="'+idno+'"';
  Open;
  end;
  Result:=DM.ZQCari2.RecordCount;
  end;

  if (status='CAGUB') then
  begin
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_cagub where no_urut="'+idno+'"';
  Open;
  end;
  Result:=DM.ZQCari2.RecordCount;
  end;

  if (status='CABUPKOTA') then
  begin
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_cabupkota where no_urut="'+idno+'"';
  Open;
  end;
  Result:=DM.ZQCari2.RecordCount;
  end;

  if (status='PARTAI') then
  begin
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_partai where no_urut="'+idno+'"';
  Open;
  end;
  Result:=DM.ZQCari2.RecordCount;
  end;

  if (status='DPD') then
  begin
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_calegdpdri where no_urut="'+idno+'"';
  Open;
  end;
  Result:=DM.ZQCari2.RecordCount;
  end;

  if (status='DPR') then
  begin
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_calegdprri where id="'+idno+'"';
  Open;
  end;
  Result:=DM.ZQCari2.RecordCount;
  end;

  if (status='DPRDPROV') then
  begin
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_calegdprdprov where id="'+idno+'"';
  Open;
  end;
  Result:=DM.ZQCari2.RecordCount;
  end;

  if (status='DPRDKABKOTA') then
  begin
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_calegdprdkabkota where id="'+idno+'"';
  Open;
  end;
  Result:=DM.ZQCari2.RecordCount;
  end;
end;

end.

