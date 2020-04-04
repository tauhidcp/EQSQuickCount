unit ucekserial;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, udatamodule, chash, encode_decode;

function cekSerial():Boolean;
function cekData(nama_tabel:string;jml_data:integer):Boolean;

implementation

function cekSerial: Boolean;
var
  ikey,akey : string;
begin
  Result:=False;
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from t_activationkey';
  Open;
  First;
  end;
  DM.ZQRegister.First;
  ikey := GSMEncode7Bit(SHA1DigestToHex(CalcSHA1(MD5DigestToHex(CalcMD5(GSMDecode7Bit(DM.ZQRegister.FieldByName('kunci1').AsString)+'-'+GSMDecode7Bit(DM.ZQRegister.FieldByName('kunci2').AsString)+'-'+GSMDecode7Bit(DM.ZQRegister.FieldByName('kunci3').AsString)+'-'+GSMDecode7Bit(DM.ZQRegister.FieldByName('kunci4').AsString))))));
  akey :=  DM.ZQCari.FieldByName('kunci').AsString;
  if (ikey=akey) then Result:=True else Result:=False;
end;

function cekData(nama_tabel: string; jml_data: integer): Boolean;
begin
  Result := False;
  with DM.ZQCari do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='select * from '+nama_tabel;
  Open;
  end;
  if DM.ZQCari.RecordCount>=jml_data then Result:=True else Result:=False;
end;

end.

