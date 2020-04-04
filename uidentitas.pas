unit uidentitas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule, ucekserial;

type

  { TFIdentitas }

  TFIdentitas = class(TForm)
    BSimpan: TBitBtn;
    EKetua: TEdit;
    EWebsite: TEdit;
    ENomorTelpon: TEdit;
    ENamaLembaga: TEdit;
    EEmail: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MAlamat: TMemo;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BSimpanClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  procedure setData;
  end;

var
  FIdentitas: TFIdentitas;

implementation

{$R *.lfm}

{ TFIdentitas }

procedure TFIdentitas.BSimpanClick(Sender: TObject);
begin
  if (cekSerial()=True) then begin
  if (ENamaLembaga.Text='') or (ENomorTelpon.Text='') or (EEmail.Text='')
     or (EKetua.Text='') or (EWebsite.Text='') or (MAlamat.Text='') then
     MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
       begin
           with DM.ZQIdentitas do
            begin
            Close;
            SQL.Clear;
            SQL.Text:='update t_identitaslembaga set nama_lembaga="'+ENamaLembaga.Text+'",alamat="'+MAlamat.Text+'",no_telpon="'+ENomorTelpon.Text+'",email="'+EEmail.Text+'",pimpinan="'+EKetua.Text+'",alamat_web="'+EWebsite.Text+'" where id="1"';
            ExecSQL;
            SQL.Clear;
            SQL.Text:='select * from t_identitaslembaga';
            Open;
            First;
            end;
         MessageDlg('Data Identitas Lembaga Berhasil Disimpan!',mtInformation,[mbok],0);
       end;
  end else MessageDlg('Fitur Ini Tidak Bisa Digunakan Karena Software Belum Diaktivasi!',mtWarning,[mbok],0);
end;

procedure TFIdentitas.hapus;
begin
  ENamaLembaga.Text:='';
  ENomorTelpon.Text:='';
  EEmail.Text:='';
  EKetua.Text:='';
  EWebsite.Text:='';
  MAlamat.Lines.Clear;
end;

procedure TFIdentitas.setData;
begin
 DM.ZQIdentitas.First;
 ENamaLembaga.Text:=DM.ZQIdentitas.FieldByName('nama_lembaga').AsString;
 MAlamat.Lines.Add(DM.ZQIdentitas.FieldByName('alamat').AsString);
 ENomorTelpon.Text:=DM.ZQIdentitas.FieldByName('no_telpon').AsString;
 EEmail.Text:=DM.ZQIdentitas.FieldByName('email').AsString;
 EKetua.Text:=DM.ZQIdentitas.FieldByName('pimpinan').AsString;
 EWebsite.Text:=DM.ZQIdentitas.FieldByName('alamat_web').AsString;
end;

end.

