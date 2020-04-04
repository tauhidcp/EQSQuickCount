unit utambahpengguna;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, udatamodule, encode_decode, ucekserial;

type

  { TFTambahPengguna }

  TFTambahPengguna = class(TForm)
    BBaru: TBitBtn;
    BSimpan: TBitBtn;
    EID: TEdit;
    ENoHP: TEdit;
    EPassword: TEdit;
    EPassword2: TEdit;
    ENamaLengkap: TEdit;
    EUsername: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LID: TLabel;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure EIDKeyPress(Sender: TObject; var Key: char);
    procedure ENoHPKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  procedure hapus;
  function getIdPengguna(nama:string):string;
  procedure simpan;
  function noOtomatis(tambah: integer): string;
  end;

var
  FTambahPengguna: TFTambahPengguna;

const
  query = 'select * from t_pengguna order by id asc';

implementation

{$R *.lfm}

{ TFTambahPengguna }

procedure TFTambahPengguna.BBaruClick(Sender: TObject);
begin
  hapus;
end;

procedure TFTambahPengguna.BSimpanClick(Sender: TObject);
begin
      if (EID.Text='') or (ENamaLengkap.Text='') or (EUsername.Text='') or (EPassword.Text='') or (ENoHP.Text='') or (EPassword2.Text='') then
        MessageDlg('Jangan Kosongkan Form Input!',mtWarning,[mbok],0) else
        begin
        if not (EPassword.Text=EPassword2.Text) then MessageDlg('Password Tidak Sama!',mtWarning,[mbok],0) else
          begin
          // Simpan
          if (BSimpan.Caption='Simpan') then
          begin

          if (cekSerial()=True) then
          simpan else
          begin
          if (cekData('t_pengguna',2)=True) then
              MessageDlg('Software Belum Diaktivasi Sehingga Data Yang Dapat Tersimpan Terbatas!',mtWarning,[mbok],0) else
              simpan;
          end;

           end else
           // Update
           if (BSimpan.Caption='Perbarui') then
           begin
                with DM.ZQPengguna do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Text:='update t_pengguna set nama_lengkap="'+ENamaLengkap.Text+'",username="'+EUsername.Text+'",password="'+GSMEncode7Bit(GSMEncode7Bit(EPassword.Text))+'",no_hp="'+ENoHP.Text+'" where id="'+EID.Caption+'"';
                  ExecSQL;
                  SQL.Clear;
                  SQL.Text:=query;
                  Open;
                end;
                MessageDlg('Data Pengguna Berhasil Diperbarui!',mtInformation,[mbok],0);
           end;
        end;
        end;
end;

procedure TFTambahPengguna.EIDKeyPress(Sender: TObject; var Key: char);
begin
if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahPengguna.ENoHPKeyPress(Sender: TObject; var Key: char);
begin
        if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

function TFTambahPengguna.noOtomatis(tambah: integer): string;
begin
  Result := '';
with DM.ZQCari do
 begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_pengguna';
  Open;
 end;
Result := IntToStr(DM.ZQCari.RecordCount+tambah);
end;

procedure TFTambahPengguna.hapus;
begin
  ENamaLengkap.Text:='';
  EPassword2.Text:='';
  EUsername.Text:='';
  EPassword.Text:='';
  ENoHP.Text:='';
  EID.Text:='';
  EID.Text:=noOtomatis(1);
  EID.Enabled:=True;
  BSimpan.Enabled:=True;
end;

function TFTambahPengguna.getIdPengguna(nama: string): string;
begin
  Result:='';
    with DM.ZQCari do begin
  Close;
  SQL.Clear;
  SQL.Text:='select id from t_pengguna where username="'+nama+'"';
  Open;
  First;
  end;
  Result := DM.ZQCari.FieldByName('id').AsString;
end;

procedure TFTambahPengguna.simpan;
begin
  // Cek Apakah No Urut Sudah ada
  with DM.ZQCari do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from t_pengguna where username="'+EUsername.Text+'" or id="'+EID.Text+'"';
    Open;
  end;
  if DM.ZQCari.RecordCount >= 1 then
  MessageDlg('ID atau Username Sudah Digunakan!',mtWarning,[mbok],0) else
  begin

   with DM.ZQPengguna do
    begin
      Close;
      SQL.Clear;

      SQL.Text:='insert into t_pengguna (id,nama_lengkap,username,password,no_hp) values ("'+EID.Text+'","'+ENamaLengkap.Text+'","'+EUsername.Text+'","'+GSMEncode7Bit(GSMEncode7Bit(EPassword.Text))+'","'+ENoHP.Text+'")';
      ExecSQL;

      SQL.Clear;
      SQL.Text:=query;
      Open;
    end;
   with DM.ZQCari3 do
    begin
      Close;
      SQL.Clear;
      SQL.Text:='insert into t_hak_akses ('+
                                        'id_pengguna,'+
                                        'dm_capres,'+
                                        'dm_cagub,'+
                                        'dm_cabup,'+
                                        'dm_dpd,'+
                                        'dm_dpr,'+
                                        'dm_dprdprov,'+
                                        'dm_dprdkab,'+
                                        'dm_partai,'+
                                        'dm_prov,'+
                                        'dm_kab,'+
                                        'dm_kec,'+
                                        'dm_kel,'+
                                        'dm_tps,'+
                                        'dm_dapil,'+
                                        'dm_dapilri,'+
                                        'dm_dapilprov,'+
                                        'dm_dapilkab,'+
                                        'dk_timses,'+
                                        'dk_saksi,'+
                                        'dk_usulantimses,'+
                                        'dk_dukungindependen,'+
                                        'dk_polling,'+
                                        'dk_usulsaran,'+
                                        'dp_capres,'+
                                        'dp_cagub,'+
                                        'dp_cabup,'+
                                        'dp_partai,'+
                                        'dp_dpd,'+
                                        'dp_dpr,'+
                                        'dp_dprdprov,'+
                                        'dp_dprdkab,'+
                                        'gf_capres,'+
                                        'gf_cagub,'+
                                        'gf_cabup,'+
                                        'gf_partai,'+
                                        'gf_dpd,'+
                                        'gf_dpr,'+
                                        'gf_dprdprov,'+
                                        'gf_dprdkab,'+
                                        'ms_modem,'+
                                        'ms_kirimsms,'+
                                        'ms_smsmasuk,'+
                                        'ms_smsterkirim,'+
                                        'mt_bot,'+
                                        'mt_kirimpesan,'+
                                        'mt_chatmasuk,'+
                                        'mt_chatterkirim,'+
                                        'pg_pengguna,'+
                                        'pg_identitas,'+
                                        'pg_pengaturan,'+
                                        'pg_format,'+
                                        'pg_backup,'+
                                        'pg_restore,'+
                                        'bn_bantuan,'+
                                        'bn_update,'+
                                        'dm_cakades,'+
                                        'dp_cakades,'+
                                        'gf_cakades,'+
                                        'dk_dpt,'+
                                        'dk_peta,'+
                                        'dk_gpeta'+
                                        ') values ('+
                                        '"'+getIdPengguna(EUsername.Text)+'",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"No",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes",'+
                                        '"Yes"'+
                                         ')';
      ExecSQL;
    end;
   // BSimpan.Enabled:=False;
    MessageDlg('Data Pengguna Berhasil Disimpan!',mtInformation,[mbok],0);
  end;
end;

end.

