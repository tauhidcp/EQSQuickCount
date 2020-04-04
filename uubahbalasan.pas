unit uubahbalasan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, udatamodule;

type

  { TFUbahBalasan }

  TFUbahBalasan = class(TForm)
    BSimpan: TBitBtn;
    GroupBox1: TGroupBox;
    LID: TLabel;
    MBalasan: TMemo;
    Panel1: TPanel;
    procedure BSimpanClick(Sender: TObject);
  private

  public

  end;

var
  FUbahBalasan: TFUbahBalasan;
const
  query = 'select * from t_smsbalasan order by id asc';

implementation

{$R *.lfm}

{ TFUbahBalasan }

procedure TFUbahBalasan.BSimpanClick(Sender: TObject);
begin
  with DM.ZQBalasan do
  begin
  Close;
  SQL.Clear;
  SQL.Text:='update t_smsbalasan set balasan="'+MBalasan.Text+'" where id="'+LID.Caption+'"';
  ExecSQL;
  SQL.Clear;
  SQL.Text:=query;
  Open;
  end;
  MessageDlg('SMS dan Chat Balasan Berhasil diperbarui',mtInformation,[mbok],0);
end;

end.

