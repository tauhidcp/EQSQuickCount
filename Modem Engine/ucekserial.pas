unit ucekserial;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, chash, encode_decode;

function cekSerial():Boolean;
function cekData(nama_tabel:string;jml_data:integer):Boolean;

implementation

uses uutama;

function cekSerial: Boolean;
var
  ikey,akey : string;
begin
  Result:=False;
  with FModemEngine.ZQStatus do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_instalationkey';
  Open;
  First;
  end;
  with FModemEngine.ZQTambahan do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_activationkey';
  Open;
  First;
  end;
  ikey := GSMEncode7Bit(SHA1DigestToHex(CalcSHA1(MD5DigestToHex(CalcMD5(GSMDecode7Bit(FModemEngine.ZQStatus.FieldByName('kunci1').AsString)+'-'+GSMDecode7Bit(FModemEngine.ZQStatus.FieldByName('kunci2').AsString)+'-'+GSMDecode7Bit(FModemEngine.ZQStatus.FieldByName('kunci3').AsString)+'-'+GSMDecode7Bit(FModemEngine.ZQStatus.FieldByName('kunci4').AsString))))));
  akey :=  FModemEngine.ZQTambahan.FieldByName('kunci').AsString;
  if (ikey=akey) then Result:=True else Result:=False;
end;

function cekData(nama_tabel: string; jml_data: integer): Boolean;
begin
  Result := False;
  with FModemEngine.ZQStatus do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from '+nama_tabel;
  Open;
  end;
  if FModemEngine.ZQStatus.RecordCount>=jml_data then Result:=True else Result:=False;
end;

end.

