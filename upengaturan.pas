unit upengaturan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ExtDlgs, udatamodule;

type

  { TFPengaturan }

  TFPengaturan = class(TForm)
    BSimpan: TBitBtn;
    DateTglPemilu: TDateTimePicker;
    EPilkades: TEdit;
    EPilpres: TEdit;
    EPilgub: TEdit;
    EPilbupKota: TEdit;
    EPartai: TEdit;
    EPilegKabKota: TEdit;
    EPilegProv: TEdit;
    EPilegDPR: TEdit;
    EPilegDPD: TEdit;
    EPemisah: TEdit;
    GroupBox1: TGroupBox;
    ImageBackground: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    OPD: TOpenPictureDialog;
    PAtas: TPanel;
    PBawah: TPanel;
    PTengah: TPanel;
    ShapeGambar: TShape;
    procedure BSimpanClick(Sender: TObject);
    procedure EPartaiChange(Sender: TObject);
    procedure EPartaiKeyPress(Sender: TObject; var Key: char);
    procedure EPilbupKotaChange(Sender: TObject);
    procedure EPilbupKotaKeyPress(Sender: TObject; var Key: char);
    procedure EPilegDPDChange(Sender: TObject);
    procedure EPilegDPDKeyPress(Sender: TObject; var Key: char);
    procedure EPilegDPRChange(Sender: TObject);
    procedure EPilegDPRKeyPress(Sender: TObject; var Key: char);
    procedure EPilegKabKotaChange(Sender: TObject);
    procedure EPilegKabKotaKeyPress(Sender: TObject; var Key: char);
    procedure EPilegProvChange(Sender: TObject);
    procedure EPilegProvKeyPress(Sender: TObject; var Key: char);
    procedure EPilgubChange(Sender: TObject);
    procedure EPilgubKeyPress(Sender: TObject; var Key: char);
    procedure EPilkadesChange(Sender: TObject);
    procedure EPilkadesKeyPress(Sender: TObject; var Key: char);
    procedure EPilpresChange(Sender: TObject);
    procedure EPilpresKeyPress(Sender: TObject; var Key: char);
    procedure ImageBackgroundClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure setData;
  procedure setPartaiData;
  end;

var
  FPengaturan: TFPengaturan;
  pemisahsebelumnya : string;

implementation

uses uutama;

{$R *.lfm}

{ TFPengaturan }

Function Ribuan(Edit : TEdit):String;
var
 NilaiRupiah: string;
 AngkaRupiah: Currency;
begin
if Edit.Text='' then Exit;
 NilaiRupiah := Edit.text;
 NilaiRupiah := StringReplace(NilaiRupiah,',','',[rfReplaceAll,rfIgnoreCase]);
 NilaiRupiah := StringReplace(NilaiRupiah,'.','',[rfReplaceAll,rfIgnoreCase]);
 AngkaRupiah := StrToCurrDef(NilaiRupiah,0);
 Edit.Text := FormatCurr('#,###',AngkaRupiah);
 Edit.SelStart := length(Edit.text);
end;

Function HapusFormat(Nilai:String):String;
var
  Hasil:String;
begin
  Hasil:=Nilai;
  Hasil:=StringReplace(Hasil,',','',[rfReplaceAll,rfIgnoreCase]);
  Hasil:=StringReplace(Hasil,'.','',[rfReplaceAll,rfIgnoreCase]);
  if (Hasil='') then Hasil:='0';
  Result:=Hasil;
end;

procedure TFPengaturan.BSimpanClick(Sender: TObject);
var
  i : integer;
  namagb, format : string;
begin
 if not (OPD.FileName='') then
 begin
 if not (ExtractFileName(OPD.FileName)=DM.ZQPengaturan.FieldByName('background').AsString) then DeleteFile(ExtractFilePath(Application.ExeName)+DM.ZQPengaturan.FieldByName('background').AsString);
 CopyFile(OPD.FileName,ExtractFilePath(Application.ExeName)+ExtractFileName(OPD.FileName));
 RenameFile(ExtractFilePath(Application.ExeName)+ExtractFileName(OPD.FileName),ExtractFilePath(Application.ExeName)+'background'+ExtractFileExt(OPD.FileName));
 namagb:='background'+ExtractFileExt(OPD.FileName);
 end else namagb:='background.png';
 if not (EPemisah.Text='') then
 begin
 setPartaiData;
 with DM.ZQPengaturan do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='update t_config set background="'+namagb+'",tgl_pemilu="'+FormatDateTime('yyyy-mm-dd',DateTglPemilu.Date)+'",pemisah="'+EPemisah.Text+'",pemilih_capres="'+HapusFormat(EPilpres.Text)+'",pemilih_cagub="'+HapusFormat(EPilgub.Text)+'",pemilih_cabup="'+HapusFormat(EPilbupKota.Text)+'",pemilih_dpd="'+HapusFormat(EPilegDPD.Text)+'",pemilih_dpr="'+HapusFormat(EPilegDPR.Text)+'",pemilih_dprdprov="'+HapusFormat(EPilegProv.Text)+'",pemilih_dprdkabkota="'+HapusFormat(EPilegKabKota.Text)+'",pemilih_partai="'+HapusFormat(EPartai.Text)+'",pemilih_kades="'+HapusFormat(EPilkades.Text)+'" where id="1"';
    ExecSQL;
    SQL.Clear;
    SQL.Text:='select * from t_config';
    Open;
    First;
    end;
 FUtama.ImageBack.Picture.Clear;
 FUtama.ImageBack.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+namagb);
 DM.ZQFormat.First;
 for i := 1 to DM.ZQFormat.RecordCount do begin
 format  := stringreplace(DM.ZQFormat.FieldByName('format').AsString,pemisahsebelumnya,EPemisah.Text,[rfReplaceAll, rfIgnoreCase]);
 with DM.ZQCari do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='update t_format set format="'+format+'" where id="'+DM.ZQFormat.FieldByName('id').AsString+'"';
    ExecSQL;
    end;
 DM.ZQFormat.Next;
 end;
 pemisahsebelumnya:=EPemisah.Text;
 DM.ZQFormat.Active:=False;
 DM.ZQFormat.Active:=True;
 MessageDlg('Data Pengaturan Aplikasi Berhasil Disimpan!',mtInformation,[mbok],0);
 end;
end;

procedure TFPengaturan.EPartaiChange(Sender: TObject);
begin
  Ribuan(EPartai);
end;

procedure TFPengaturan.EPartaiKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFPengaturan.EPilbupKotaChange(Sender: TObject);
begin
  Ribuan(EPilbupKota);
end;

procedure TFPengaturan.EPilbupKotaKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFPengaturan.EPilegDPDChange(Sender: TObject);
begin
  Ribuan(EPilegDPD);
end;

procedure TFPengaturan.EPilegDPDKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFPengaturan.EPilegDPRChange(Sender: TObject);
begin
  Ribuan(EPilegDPR);
end;

procedure TFPengaturan.EPilegDPRKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFPengaturan.EPilegKabKotaChange(Sender: TObject);
begin
  Ribuan(EPilegKabKota);
end;

procedure TFPengaturan.EPilegKabKotaKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFPengaturan.EPilegProvChange(Sender: TObject);
begin
  Ribuan(EPilegProv);
end;

procedure TFPengaturan.EPilegProvKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFPengaturan.EPilgubChange(Sender: TObject);
begin
  Ribuan(EPilgub);
end;

procedure TFPengaturan.EPilgubKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFPengaturan.EPilkadesChange(Sender: TObject);
begin
  Ribuan(EPilkades);
end;

procedure TFPengaturan.EPilkadesKeyPress(Sender: TObject; var Key: char);
begin
if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFPengaturan.EPilpresChange(Sender: TObject);
begin
  Ribuan(EPilpres);
end;

procedure TFPengaturan.EPilpresKeyPress(Sender: TObject; var Key: char);
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFPengaturan.ImageBackgroundClick(Sender: TObject);
begin
  if OPD.Execute then
     begin
       ImageBackground.Picture.Clear;
       ImageBackground.Picture.LoadFromFile(OPD.FileName);
     end;
end;

procedure TFPengaturan.setData;
begin
 DM.ZQPengaturan.First;
 pemisahsebelumnya:=DM.ZQPengaturan.FieldByName('pemisah').AsString;
 DateTglPemilu.Date:=DM.ZQPengaturan.FieldByName('tgl_pemilu').AsDateTime;
 EPemisah.Text:=DM.ZQPengaturan.FieldByName('pemisah').AsString;
 EPilpres.Text:=DM.ZQPengaturan.FieldByName('pemilih_capres').AsString;
 EPilgub.Text:=DM.ZQPengaturan.FieldByName('pemilih_cagub').AsString;
 EPilbupKota.Text:=DM.ZQPengaturan.FieldByName('pemilih_cabup').AsString;
 EPartai.Text:=DM.ZQPengaturan.FieldByName('pemilih_partai').AsString;
 EPilegDPD.Text:=DM.ZQPengaturan.FieldByName('pemilih_dpd').AsString;
 EPilegDPR.Text:=DM.ZQPengaturan.FieldByName('pemilih_dpr').AsString;
 EPilegProv.Text:=DM.ZQPengaturan.FieldByName('pemilih_dprdprov').AsString;
 EPilegKabKota.Text:=DM.ZQPengaturan.FieldByName('pemilih_dprdkabkota').AsString;
 EPilkades.Text:=DM.ZQPengaturan.FieldByName('pemilih_kades').AsString;
 if FileExists(ExtractFilePath(Application.ExeName)+DM.ZQPengaturan.FieldByName('background').AsString) then
 ImageBackground.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+DM.ZQPengaturan.FieldByName('background').AsString);
end;

procedure TFPengaturan.setPartaiData;
begin
  if FUtama.LKategori.Caption='DPR RI' then EPartai.Text:=EPilegDPR.Text;
  if FUtama.LKategori.Caption='DPRD Provinsi' then EPartai.Text:=EPilegProv.Text;
  if FUtama.LKategori.Caption='DPRD Kabupaten/Kota' then EPartai.Text:=EPilegKabKota.Text;
end;

end.

