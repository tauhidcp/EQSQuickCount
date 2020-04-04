unit ukirimsms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Buttons, ExtCtrls, udatamodule, ucekserial;

type

  { TFKirimSMS }

  TFKirimSMS = class(TForm)
    BKirim: TBitBtn;
    CBModem: TComboBox;
    ENoHP: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LTPS: TLabel;
    LNama: TLabel;
    LAlamat: TLabel;
    LLimitChar: TLabel;
    LSMS: TLabel;
    MPesan: TMemo;
    Panel1: TPanel;
    PAtas: TPanel;
    PBawah: TPanel;
    procedure BKirimClick(Sender: TObject);
    procedure CBModemKeyPress(Sender: TObject; var Key: char);
    procedure ENoHPKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure LSMSClick(Sender: TObject);
    procedure MPesanKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  function getIdModem(nama:string):string;
  procedure setCB;
  procedure simpan;
  end;

var
  FKirimSMS: TFKirimSMS;

implementation

uses uutama;

{$R *.lfm}

{ TFKirimSMS }

procedure TFKirimSMS.CBModemKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFKirimSMS.BKirimClick(Sender: TObject);
begin
   if (ENoHP.Text='') or (ENoHP.Text='-') or (MPesan.Text='') or (CBModem.Text='-Pilih-') then
   MessageDlg('Jangan Kosongkan Form!',mtWarning,[mbok],0) else
     begin

      if (cekSerial()=True) then
      simpan else
      begin
      if (cekData('t_outboxsms',15)=True) then
          MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
          simpan;
      end;

     end;
end;

procedure TFKirimSMS.ENoHPKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;


procedure TFKirimSMS.FormShow(Sender: TObject);
begin
  MPesan.SetFocus;
end;

procedure TFKirimSMS.LSMSClick(Sender: TObject);
begin
  ShowMessage(fusulsaran.GridUsulSaran.DataSource.DataSet.Fields[7].Value);
end;

procedure TFKirimSMS.MPesanKeyPress(Sender: TObject; var Key: char);
begin
  with Sender as TMemo do
  begin
  if (Key=#22) or (Key=#3) then Key:=#0 else begin
  if (MPesan.Text<>'') then LLimitChar.Caption:='0 karakter';
   LLimitChar.Caption:=IntToStr(Length(MPesan.Text)+1)+' karakter';
   if (Length(MPesan.Text)+1) = 160 then
       if not (key in[#8]) then Key := #0;
  end;
  end;
end;

procedure TFKirimSMS.hapus;
begin
  ENoHP.Text:='';
  CBModem.Text:='-Pilih-';
  MPesan.Lines.Clear;
  LLimitChar.Caption:='0 karakter';
  LSMS.Hide;
end;

function TFKirimSMS.getIdModem(nama: string): string;
begin
    Result := '';
   with DM.ZQCari do
   begin
   Close;
   SQL.Clear;
   SQL.Text:='select id as id from t_modem where nama_modem="'+nama+'"';
   Open;
   end;
  Result:= DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFKirimSMS.setCB;
var
  i : integer;
begin
  CBModem.Items.Clear;
  with DM.ZQCari2 do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select nama_modem from t_modem where status="On"';
  Open;
  end;
  DM.ZQCari2.First;
  for i := 1 to DM.ZQCari2.RecordCount do begin
  CBModem.Items.Add(DM.ZQCari2.FieldByName('nama_modem').AsString);
  DM.ZQCari2.Next;
  end;
end;

procedure TFKirimSMS.simpan;
var
  hasil,hasila,hasilx : string;
begin
  hasil  := StringReplace(MPesan.Text,'<NAMA>',LNama.Caption,[rfReplaceAll, rfIgnoreCase]);
  hasila := StringReplace(hasil,'<TPS>',LTPS.Caption,[rfReplaceAll, rfIgnoreCase]);
  hasilx := StringReplace(hasila,'<ALAMAT>',LAlamat.Caption,[rfReplaceAll, rfIgnoreCase]);
  with DM.ZQKirimSMS do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='insert into t_outboxsms (tanggal,jam,id_modem,no_tujuan,isi_pesan,status) values ("'+FormatDateTime('yyyy-mm-dd',Now)+'","'+FormatDateTime('hh:mm:ss',Now)+'","'+getIdModem(CBModem.Text)+'","'+ENoHP.Text+'","'+hasilx+'","Pending")';
  ExecSQL;
  end;
  MessageDlg('Pesan Dalam Antrian Pengiriman!',mtInformation,[mbok],0);
end;

end.

