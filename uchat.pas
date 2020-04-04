unit uchat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, udatamodule, ucekserial;

type

  { TFChat }

  TFChat = class(TForm)
    BKirim: TBitBtn;
    EIDChat: TEdit;
    Label1: TLabel;
    LTPS: TLabel;
    LNama: TLabel;
    Label3: TLabel;
    LAlamat: TLabel;
    LSMS: TLabel;
    LStatus: TLabel;
    MPesan: TMemo;
    Panel1: TPanel;
    PAtas: TPanel;
    PBawah: TPanel;
    procedure BKirimClick(Sender: TObject);
    procedure EIDChatKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure LSMSClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  function getChatId(status:string; idx:string):string;
  procedure simpan;
  end;

var
  FChat: TFChat;

implementation

uses uutama;

{$R *.lfm}

{ TFChat }

procedure TFChat.EIDChatKeyPress(Sender: TObject; var Key: char);
begin
 key:=#0;
end;

procedure TFChat.BKirimClick(Sender: TObject);
begin
  if (EIDChat.Text='') or (EIDChat.Text='-') or (MPesan.Text='') then
   MessageDlg('Jangan Kosongkan Form!',mtWarning,[mbok],0) else
     begin

     if (cekSerial()=True) then
     simpan else
     begin
     if (cekData('t_outboxchat',15)=True) then
         MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
         simpan;
     end;

     end;
end;

procedure TFChat.FormShow(Sender: TObject);
begin
  MPesan.SetFocus;
end;

procedure TFChat.LSMSClick(Sender: TObject);
begin
  ShowMessage(fusulsaran.GridUsulSaran.DataSource.DataSet.Fields[7].Value);
end;

procedure TFChat.hapus;
begin
  EIDChat.Text:='';
  MPesan.Lines.Clear;
  LSMS.Hide;
end;

function TFChat.getChatId(status: string; idx: string): string;
begin
  Result := '';
  if (status='Saksi') then
   begin
   with DM.ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select chat_id as id from t_saksi where id_telegram="'+idx+'" and chat_id<>0';
   Open;
   end;
   end else
  if (status='Timses') then
   begin
   with DM.ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select chat_id as id from t_timses where id_telegram="'+idx+'" and chat_id<>0';
   Open;
   end;
   end;
  if (status='Balas') then
   begin
   with DM.ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id_chat as id from t_inboxchat where id_pengirim="'+idx+'" and id_chat<>"-"';
   Open;
   end;
   end;
  if (status='Dukung') then
   begin
   with DM.ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select idchat as id from t_dukunganindie where idtelegram="'+idx+'" and idchat<>"-"';
   Open;
   end;
   end;
  if (status='Polling') then
   begin
   with DM.ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select idchat as id from t_polling where idtelegram="'+idx+'" and idchat<>"-"';
   Open;
   end;
   end;
  if (status='Usul') then
   begin
   with DM.ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select idchat as id from t_usulsaran where idtelegram="'+idx+'" and idchat<>"-"';
   Open;
   end;
   end;
  if (status='KoordinatorTPS') then
   begin
   with DM.ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select idchat as id from t_usulantimses where idtelegram="'+idx+'" and idchat<>"-"';
   Open;
   end;
   end;
  if DM.ZQCari.RecordCount>0 then
  Result:= DM.ZQCari.FieldByName('id').AsString else Result:='-';
end;

procedure TFChat.simpan;
var
  hasil,hasila,hasilx : string;
begin
  if not (getChatId(LStatus.Caption,EIDChat.Text)='-') then
  begin
  hasil  := StringReplace(MPesan.Text,'<NAMA>',LNama.Caption,[rfReplaceAll, rfIgnoreCase]);
  hasila := StringReplace(hasil,'<TPS>',LTPS.Caption,[rfReplaceAll, rfIgnoreCase]);
  hasilx := StringReplace(hasila,'<ALAMAT>',LAlamat.Caption,[rfReplaceAll, rfIgnoreCase]);
  with DM.ZQKirimChat do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='insert into t_outboxchat (tanggal,jam,isipesan,id_chat,id_tujuan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+hasilx+'","'+getChatId(LStatus.Caption,EIDChat.Text)+'","'+EIDChat.Text+'","Pending")';
  ExecSQL;
  end;
  end;
  MessageDlg('Pesan Dalam Antrian Pengiriman!',mtInformation,[mbok],0);
end;

end.

