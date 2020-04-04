program EQSQuickCount;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, printer4lazarus, datetimectrls, rxnew, zcomponent,
  UUtama, upartai, udatamodule, utambahpartai, uprovinsi, utambahprov,
  ukabupatenkota, utambahkabupatenkota, ukecamatan, ukelurahandesa, utps,
  utambahkecamatan, utambahkelurahandesa, utambahtps, ucapres, ucagub,
  utambahcapres, utambahcagub, utambahcabupkota, udapilkabkota, udapilprovinsi,
  udapilri, ucalegdpdri, ucalegdprri, ucalegdprdprov, ucalegkabkota,
  utambahdapilri, utambahdapilprovinsi, utambahdapilkabkota, ucabupkota,
  utambahcalegdpdri, utambahcalegdprri, utambahcalegdprdprov,
  utambahcalegdprdkabkota, utimses, usaksi, uusulantimses, udukunganindependen,
  upolling, uusulsaran, utambahtimses, utambahsaksi, utambahusulantimses,
  ukirimsms, uchat, uhitungcapres, uubahhitungcapres, uhitungcagub,
  uhitungcabupkota, uhitungpartai, uhitungdpdri, uhitungdprri, uhitungdprdprov,
  uhitungdprdkabkota, uubahhitungcagub, uubahhitungcabupkota, uubahhitungpartai,
  uubahhitungdpdri, uubahhitungdprri, uubahhitungdprdprov,
  uubahhitungdprdkabkota, udapil, utambahdapil, ugrafikcapres, ugrafikcagub,
  ugrafikcabupkota, ugrafikpartai, ugrafikdpdri, ugrafikdprri, ugrafikdprdprov,
  ugrafikdprdkabkota, udatasmsmasuk, udatasmsterkirim, udatachatmasuk,
  udatachatterkirim, udatapengguna, udataformatsmschat, ukirimchat, usms,
  ufilter, upengaturan, uidentitas, utambahpengguna, uhakakses, uregister,
  usmsprocess, uchatprocess, ulogin, ucekserial, uresetdb, utambahdukunganindie,
  UdataSMSBalasan, uubahbalasan, ucakades, uhitungkades, ugrafikkades,
  uubahhitungkades, utambahkades, upetasuara, utambahpetasuara, abbrevia, udatadpt,
  utambahdpt, ugrafikpeta, upilihpartai, usaintelague, ufilterpeta, ufilterhitung;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TFLogin, FLogin);
  Application.CreateForm(TFUtama, FUtama);
  Application.CreateForm(TFTambahPartai, FTambahPartai);
  Application.CreateForm(TFTambahProv, FTambahProv);
  Application.CreateForm(TFTambahKabupatenKota, FTambahKabupatenKota);
  Application.CreateForm(TFTambahKecamatan, FTambahKecamatan);
  Application.CreateForm(TFTambahKelurahanDesa, FTambahKelurahanDesa);
  Application.CreateForm(TFTambahTPS, FTambahTPS);
  Application.CreateForm(TFTambahCapres, FTambahCapres);
  Application.CreateForm(TFTambahCagub, FTambahCagub);
  Application.CreateForm(TFTambahCabupKota, FTambahCabupKota);
  Application.CreateForm(TFTambahDapilRI, FTambahDapilRI);
  Application.CreateForm(TFTambahDapilProvinsi, FTambahDapilProvinsi);
  Application.CreateForm(TFTambahDapilKabKota, FTambahDapilKabKota);
  Application.CreateForm(TFTambahCalegDPDRI, FTambahCalegDPDRI);
  Application.CreateForm(TFTambahCalegDPRRI, FTambahCalegDPRRI);
  Application.CreateForm(TFTambahCalegDPRDProvinsi, FTambahCalegDPRDProvinsi);
  Application.CreateForm(TFTambahCalegKabKota, FTambahCalegKabKota);
  Application.CreateForm(TFTambahTimses, FTambahTimses);
  Application.CreateForm(TFTambahSaksi, FTambahSaksi);
  Application.CreateForm(TFTambahUsulanTimses, FTambahUsulanTimses);
  Application.CreateForm(TFKirimSMS, FKirimSMS);
  Application.CreateForm(TFChat, FChat);
  Application.CreateForm(TFUbahHitungCapres, FUbahHitungCapres);
  Application.CreateForm(TFUbahHitungCagub, FUbahHitungCagub);
  Application.CreateForm(TFUbahHitungCabupKota, FUbahHitungCabupKota);
  Application.CreateForm(TFUbahHitungPartai, FUbahHitungPartai);
  Application.CreateForm(TFUbahHitungDPDRI, FUbahHitungDPDRI);
  Application.CreateForm(TFUbahHitungDPRRI, FUbahHitungDPRRI);
  Application.CreateForm(TFUbahHitungDPRDProv, FUbahHitungDPRDProv);
  Application.CreateForm(TFUbahHitungDPRDKab, FUbahHitungDPRDKab);
  Application.CreateForm(TFTambahDapil, FTambahDapil);
  Application.CreateForm(TFKirimChat, FKirimChat);
  Application.CreateForm(TFSMS, FSMS);
  Application.CreateForm(TFFilter, FFilter);
  Application.CreateForm(TFPengaturan, FPengaturan);
  Application.CreateForm(TFIdentitas, FIdentitas);
  Application.CreateForm(TFTambahPengguna, FTambahPengguna);
  Application.CreateForm(TFHakAkses, FHakAkses);
  Application.CreateForm(TFRegister, FRegister);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFTambahDukunganIndependen, FTambahDukunganIndependen);
  Application.CreateForm(TFUbahBalasan, FUbahBalasan);
  Application.CreateForm(TFUbahHitungKades, FUbahHitungKades);
  Application.CreateForm(TFTambahKades, FTambahKades);
  Application.CreateForm(TFTambahPetaSuara, FTambahPetaSuara);
  Application.CreateForm(TFTambahDPT, FTambahDPT);
  Application.CreateForm(TFPilihPartai, FPilihPartai);
  Application.CreateForm(TFSainteLague, FSainteLague);
  Application.CreateForm(TFFilterPeta, FFilterPeta);
  Application.CreateForm(TFFilterHitung, FFilterHitung);
  Application.Run;
end.

