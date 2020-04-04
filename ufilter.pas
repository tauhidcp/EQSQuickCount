unit ufilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Buttons, ExtCtrls, udatamodule;

type

  { TFFilter }

  TFFilter = class(TForm)
    BFilter: TBitBtn;
    DateAkhir: TDateTimePicker;
    DateAwal: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    LData: TLabel;
    Panel1: TPanel;
    PAtas: TPanel;
    PBawah: TPanel;
    procedure BFilterClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure setup;
  end;

var
  FFilter: TFFilter;

const
  qsmsmasuk     = 'SELECT t_inboxsms.id, t_inboxsms.tanggal, t_inboxsms.jam, t_modem.nama_modem, t_inboxsms.no_pengirim, t_inboxsms.isi_pesan, t_inboxsms.processed FROM (t_inboxsms INNER JOIN t_modem ON t_modem.id=t_inboxsms.id_modem)';
  qsmsterkirim  = 'SELECT t_outboxsms.id, t_outboxsms.tanggal, t_outboxsms.jam, t_modem.nama_modem, t_outboxsms.no_tujuan, t_outboxsms.isi_pesan, t_outboxsms.status FROM (t_outboxsms INNER JOIN t_modem ON t_modem.id=t_outboxsms.id_modem)';
  qchatmasuk    = 'select * from t_inboxchat';
  qchatterkirim = 'select * from t_outboxchat';

implementation

{$R *.lfm}

{ TFFilter }

procedure TFFilter.BFilterClick(Sender: TObject);
begin
  if (LData.Caption='SMSMasuk') then
  begin
    with DM.ZQSMSMasuk do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=qsmsmasuk+' WHERE(((t_inboxsms.tanggal) BETWEEN '''+FormatDateTime('yyyy-mm-dd',DateAwal.Date)+''' AND '''+FormatDateTime('yyyy-mm-dd',DateAkhir.DATE)+''')) order by t_inboxsms.id asc';
      Open;
    end;
  end;
  if (LData.Caption='SMSTerkirim') then
  begin
    with DM.ZQSMSTerkirim do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=qsmsterkirim+' WHERE(((t_outboxsms.tanggal) BETWEEN '''+FormatDateTime('yyyy-mm-dd',DateAwal.Date)+''' AND '''+FormatDateTime('yyyy-mm-dd',DateAkhir.DATE)+''')) order by t_outboxsms.id asc';
      Open;
    end;
  end;
  if (LData.Caption='ChatMasuk') then
  begin
    with DM.ZQChatMasuk do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=qchatmasuk+' WHERE(((t_inboxchat.tanggal) BETWEEN '''+FormatDateTime('yyyy-mm-dd',DateAwal.Date)+''' AND '''+FormatDateTime('yyyy-mm-dd',DateAkhir.DATE)+''')) order by id asc';
      Open;
    end;
  end;
  if (LData.Caption='ChatTerkirim') then
  begin
    with DM.ZQChatTerkirim do
    begin
      Close;
      SQL.Clear;
      SQL.Text:=qchatterkirim+' WHERE(((t_outboxchat.tanggal) BETWEEN '''+FormatDateTime('yyyy-mm-dd',DateAwal.Date)+''' AND '''+FormatDateTime('yyyy-mm-dd',DateAkhir.DATE)+''')) order by id asc';
      Open;
    end;
  end;
end;

procedure TFFilter.setup;
begin
  DateAwal.Date:=Now;
  DateAkhir.Date:=Now;
end;

end.

