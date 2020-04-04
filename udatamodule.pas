unit udatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, ZConnection, ZDataset;

type

  { TDM }

  TDM = class(TDataModule)
    DHCagub: TDataSource;
    DHCabup: TDataSource;
    DHKades: TDataSource;
    DHCapres: TDataSource;
    DHDPD: TDataSource;
    DHDPR: TDataSource;
    DHDPRDK: TDataSource;
    DHDPRDP: TDataSource;
    DHPartai: TDataSource;
    DKursi: TDataSource;
    DDPT: TDataSource;
    DKades: TDataSource;
    DBalasan: TDataSource;
    DPetaSuara: TDataSource;
    DSMSTerkirim: TDataSource;
    DSMSMasuk: TDataSource;
    DChatMasuk: TDataSource;
    DChatTerkirim: TDataSource;
    DPengguna: TDataSource;
    DFormat: TDataSource;
    DDapil: TDataSource;
    DTimses: TDataSource;
    DSaksi: TDataSource;
    DUsulTimses: TDataSource;
    DDukIndie: TDataSource;
    DPolling: TDataSource;
    DUsulSaran: TDataSource;
    DDPRRI: TDataSource;
    DDPRDProv: TDataSource;
    DDPRDKab: TDataSource;
    DDAPILRI: TDataSource;
    DDAPILProv: TDataSource;
    DDAPILKabKota: TDataSource;
    DCapres: TDataSource;
    DCagub: TDataSource;
    DCabupKota: TDataSource;
    DDPDRI: TDataSource;
    DKec: TDataSource;
    DKelDesa: TDataSource;
    DTPS: TDataSource;
    DKabKota: TDataSource;
    DProv: TDataSource;
    DPartai: TDataSource;
    KoneksiDatabase: TZConnection;
    ZQCalegInfo: TZQuery;
    ZQChatMasukid: TLongintField;
    ZQChatMasukid_chat: TLongintField;
    ZQChatMasukid_pengirim: TStringField;
    ZQChatMasukisi_pesan: TMemoField;
    ZQChatMasukjam: TTimeField;
    ZQChatMasukprocessed: TStringField;
    ZQChatMasuktanggal: TDateField;
    ZQChatTerkirimid: TLongintField;
    ZQChatTerkirimid_chat: TLongintField;
    ZQChatTerkirimid_tujuan: TStringField;
    ZQChatTerkirimisipesan: TMemoField;
    ZQChatTerkirimjam: TTimeField;
    ZQChatTerkirimstatus: TStringField;
    ZQChatTerkirimtanggal: TDateField;
    ZQFormatformat: TMemoField;
    ZQFormatid: TLongintField;
    ZQFormatketerangan: TMemoField;
    ZQHCapres: TZQuery;
    ZQHDPD: TZQuery;
    ZQHDPR: TZQuery;
    ZQHDPRDK: TZQuery;
    ZQHDPRDP: TZQuery;
    ZQHPartai: TZQuery;
    ZQPartai: TZQuery;
    ZQCari: TZQuery;
    ZQPenggunaid: TLongintField;
    ZQPenggunanama_lengkap: TStringField;
    ZQPenggunano_hp: TStringField;
    ZQPenggunapassword: TMemoField;
    ZQPenggunausername: TStringField;
    ZQPetaSuara: TZQuery;
    ZQProv: TZQuery;
    ZQKabKota: TZQuery;
    ZQKec: TZQuery;
    ZQKelDesa: TZQuery;
    ZQSMSMasukid: TLongintField;
    ZQSMSMasukisi_pesan: TMemoField;
    ZQSMSMasukjam: TTimeField;
    ZQSMSMasuknama_modem: TStringField;
    ZQSMSMasukno_pengirim: TStringField;
    ZQSMSMasukprocessed: TStringField;
    ZQSMSMasuktanggal: TDateField;
    ZQSMSTerkirimid: TLongintField;
    ZQSMSTerkirimisi_pesan: TMemoField;
    ZQSMSTerkirimjam: TTimeField;
    ZQSMSTerkirimnama_modem: TStringField;
    ZQSMSTerkirimno_tujuan: TStringField;
    ZQSMSTerkirimstatus: TStringField;
    ZQSMSTerkirimtanggal: TDateField;
    ZQTPS: TZQuery;
    ZQCapres: TZQuery;
    ZQCagub: TZQuery;
    ZQCabupKota: TZQuery;
    ZQDPDRI: TZQuery;
    ZQDAPILRI: TZQuery;
    ZQDAPILProv: TZQuery;
    ZQDAPILKabKota: TZQuery;
    ZQDPRRI: TZQuery;
    ZQDPRDProv: TZQuery;
    ZQDPRDKab: TZQuery;
    ZQTimses: TZQuery;
    ZQSaksi: TZQuery;
    ZQKirimSMS: TZQuery;
    ZQKirimChat: TZQuery;
    ZQKabCari: TZQuery;
    ZQKecCari: TZQuery;
    ZQKelCari: TZQuery;
    ZQTPSCari: TZQuery;
    ZQTotRoot: TZQuery;
    ZQTotProv: TZQuery;
    ZQTotKabKota: TZQuery;
    ZQTotKecamatan: TZQuery;
    ZQTotKelurahan: TZQuery;
    ZQTotTPS: TZQuery;
    ZQHitungCapres: TZQuery;
    ZQHitungCagub: TZQuery;
    ZQHitungCabupKota: TZQuery;
    ZQHitungPartai: TZQuery;
    ZQProvCari: TZQuery;
    ZQHitungDPDRI: TZQuery;
    ZQHitungDPRRI: TZQuery;
    ZQHitungDPRDProv: TZQuery;
    ZQHitungDPRDKab: TZQuery;
    ZQDapilCari: TZQuery;
    ZQTotDapil: TZQuery;
    ZQDapil: TZQuery;
    ZQCari2: TZQuery;
    ZQCari3: TZQuery;
    ZQGrafikCapres: TZQuery;
    ZQGrafikCagub: TZQuery;
    ZQGrafikCabup: TZQuery;
    ZQGrafikPartai: TZQuery;
    ZQGrafikDPDRI: TZQuery;
    ZQGrafikDPRRI: TZQuery;
    ZQGrafikDPRProv: TZQuery;
    ZQGrafikDPRKab: TZQuery;
    ZQModem: TZQuery;
    ZQTelegramBot: TZQuery;
    ZQSMSTerkirim: TZQuery;
    ZQSMSMasuk: TZQuery;
    ZQChatMasuk: TZQuery;
    ZQChatTerkirim: TZQuery;
    ZQPengguna: TZQuery;
    ZQFormat: TZQuery;
    ZQIdentitas: TZQuery;
    ZQPengaturan: TZQuery;
    ZQRegister: TZQuery;
    ZQCariChat: TZQuery;
    ZQCariSMS: TZQuery;
    ZQTimerKirimSMS: TZQuery;
    ZQTimerChat: TZQuery;
    ZQTimerCari: TZQuery;
    ZQSimpan: TZQuery;
    ZQReset: TZQuery;
    ZQBalasan: TZQuery;
    ZQKades: TZQuery;
    ZQGrafikKades: TZQuery;
    ZQHitungKades: TZQuery;
    ZQPetaCari: TZQuery;
    ZQPeta: TZQuery;
    ZQTreeDapil: TZQuery;
    ZQDPT: TZQuery;
    ZQCari4: TZQuery;
    ZQCari5: TZQuery;
    ZQHasil: TZQuery;
    ZQKursi: TZQuery;
    ZQHCagub: TZQuery;
    ZQHCabup: TZQuery;
    ZQHKades: TZQuery;
    ZQGDPR: TZQuery;
    ZQGDPRDP: TZQuery;
    ZQGDPRDK: TZQuery;
    ZQUsulSaranidchat: TStringField;
    ZQUsulSaranidtelegram: TStringField;
    ZQUsulSaranid_usul: TLongintField;
    ZQUsulSarannama: TStringField;
    ZQUsulSarannama_kelurahan: TStringField;
    ZQUsulSarannohp: TStringField;
    ZQUsulSaranpekerjaan: TStringField;
    ZQUsulSaranusulan: TMemoField;
    ZQUsulTimses: TZQuery;
    ZQDukIndie: TZQuery;
    ZQPolling: TZQuery;
    ZQUsulSaran: TZQuery;
    procedure ZQChatMasukid_pengirimGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQChatMasukisi_pesanGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQChatTerkirimid_tujuanGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQChatTerkirimisipesanGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQFormatformatGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQFormatketeranganGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQPenggunapasswordGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQSMSMasukisi_pesanGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQSMSMasukno_pengirimGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQSMSTerkirimisi_pesanGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQSMSTerkirimno_tujuanGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ZQUsulSaranusulanGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  function getNama(no:string):string;
  function getNamaChat(id:string):string;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

procedure TDM.ZQUsulSaranusulanGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(ZQUsulSaranusulan.AsString, 1, 1500);
end;

function TDM.getNama(no: string): string;
begin
    Result :='';
  // Saksi
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_saksi as id from t_saksi where nohp="'+no+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Relawan
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_timses as id from t_timses where nohp="'+no+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Simpatisan
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama as id from t_usulantimses where nohp="'+no+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Dukungan Indie
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama as id from t_dukunganindie where nohp="'+no+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Polling
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama as id from t_polling where nohp="'+no+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Usul Saran
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama as id from t_usulsaran where nohp="'+no+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else Result:=no;
  end;
  end;
  end;
  end;
  end;
end;

function TDM.getNamaChat(id: string): string;
begin
  Result :='';
  // Saksi
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_saksi as id from t_saksi where id_telegram="'+id+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Relawan
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_timses as id from t_timses where id_telegram="'+id+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Simpatisan
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama as id from t_usulantimses where idtelegram="'+id+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Dukungan Indie
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama as id from t_dukunganindie where idtelegram="'+id+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Polling
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama as id from t_polling where idtelegram="'+id+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else
  begin
  // Usul Saran
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama as id from t_usulsaran where idtelegram="'+id+'"';
  Open;
  end;
  if DM.ZQCari.RecordCount>=1 then
  Result:=DM.ZQCari.FieldByName('id').AsString else Result:=id;
  end;
  end;
  end;
  end;
  end;
end;

procedure TDM.ZQFormatketeranganGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(ZQFormatketerangan.AsString, 1, 1500);
end;

procedure TDM.ZQPenggunapasswordGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(ZQPenggunapassword.AsString, 1, 1500);
end;

procedure TDM.ZQSMSMasukisi_pesanGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(ZQSMSMasukisi_pesan.AsString, 1, 1500);
end;

procedure TDM.ZQSMSMasukno_pengirimGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if ZQSMSMasuk.RecordCount>0 then
  aText:=getNama(ZQSMSMasukno_pengirim.AsString);
end;


procedure TDM.ZQSMSTerkirimisi_pesanGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(ZQSMSTerkirimisi_pesan.AsString, 1, 1500);
end;

procedure TDM.ZQSMSTerkirimno_tujuanGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if ZQSMSTerkirim.RecordCount>0 then
  aText:=getNama(ZQSMSTerkirimno_tujuan.AsString);
end;

procedure TDM.ZQFormatformatGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(ZQFormatformat.AsString, 1, 1500);
end;

procedure TDM.ZQChatTerkirimisipesanGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(ZQChatTerkirimisipesan.AsString, 1, 1500);
end;

procedure TDM.ZQChatMasukisi_pesanGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(ZQChatMasukisi_pesan.AsString, 1, 1500);
end;

procedure TDM.ZQChatTerkirimid_tujuanGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if ZQChatTerkirim.RecordCount>0 then
  aText:=getNamaChat(ZQChatTerkirimid_tujuan.AsString);
end;

procedure TDM.ZQChatMasukid_pengirimGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  if ZQChatMasuk.RecordCount>0 then
  aText:=getNamaChat(ZQChatMasukid_pengirim.AsString);
end;



end.

