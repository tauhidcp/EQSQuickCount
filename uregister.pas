unit uregister;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule, encode_decode, cHash;

type

  { TFRegister }

  TFRegister = class(TForm)
    BSimpan: TBitBtn;
    EAKey: TEdit;
    EKey1: TEdit;
    EKey4: TEdit;
    EKey2: TEdit;
    EKey3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BSimpanClick(Sender: TObject);
    procedure EKey1KeyPress(Sender: TObject; var Key: char);
    procedure EKey2KeyPress(Sender: TObject; var Key: char);
    procedure EKey3KeyPress(Sender: TObject; var Key: char);
    procedure EKey4KeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure hapus;
    procedure setNilai;

  end;

var
  FRegister: TFRegister;

implementation

{$R *.lfm}

{ TFRegister }

procedure TFRegister.BSimpanClick(Sender: TObject);
var
  ikey,akey : string;
begin
  if not (EAKey.Text='') then
  begin
  ikey := GSMEncode7Bit(SHA1DigestToHex(CalcSHA1(MD5DigestToHex(CalcMD5(GSMDecode7Bit(EKey1.Text)+'-'+GSMDecode7Bit(EKey2.Text)+'-'+GSMDecode7Bit(EKey3.Text)+'-'+GSMDecode7Bit(EKey4.Text))))));
  akey := Trim(EAKey.Text);
  if (ikey=akey) then
    begin
    with DM.ZQCari3 do begin
    Close;
    SQL.Clear;
    SQL.Text:='update t_activationkey set kunci="'+akey+'" where id="1"';
    ExecSQL;
    end;
    MessageDlg('Registrasi Berhasil!'+sLineBreak+'Aplikasi Akan Ditutup. Silahkan Jalankan Ulang Aplikasi!',mtInformation,[mbok],0);
    Application.Terminate;
    end else MessageDlg('Registrasi Gagal! Activation Key Salah! '+sLineBreak+'Buka File Bantuan Untuk Melihat Panduan Registrasi!',mtWarning,[mbok],0);
  end;
end;

procedure TFRegister.EKey1KeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFRegister.EKey2KeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFRegister.EKey3KeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFRegister.EKey4KeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFRegister.FormShow(Sender: TObject);
begin
   EAKey.SetFocus;
end;

procedure TFRegister.hapus;
begin
  EKey1.Text:='';
  EKey2.Text:='';
  EKey3.Text:='';
  EKey4.Text:='';
  EAKey.Text:='';
end;

procedure TFRegister.setNilai;
begin
 with DM.ZQRegister do begin
 First;
 EKey1.Text:=FieldByName('kunci1').AsString;
 EKey2.Text:=FieldByName('kunci2').AsString;
 EKey3.Text:=FieldByName('kunci3').AsString;
 EKey4.Text:=FieldByName('kunci4').AsString;
 end;
end;

end.

