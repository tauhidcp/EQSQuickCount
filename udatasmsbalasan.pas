unit UdataSMSBalasan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, rxdbgrid, udatamodule, uubahbalasan, Grids, DBGrids;

type

  { TFDataSMSBalasan }

  TFDataSMSBalasan = class(TForm)
    BUbah: TBitBtn;
    BTutup: TBitBtn;
    GridSMSB: TRxDBGrid;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    procedure BTutupClick(Sender: TObject);
    procedure BUbahClick(Sender: TObject);
    procedure GridSMSBPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private

  public

  end;

var
  FDataSMSBalasan: TFDataSMSBalasan;

implementation

uses uutama;

{$R *.lfm}

{ TFDataSMSBalasan }

procedure TFDataSMSBalasan.BTutupClick(Sender: TObject);
begin
  FUtama.ImageBack.Visible:=True;
  Close;
end;

procedure TFDataSMSBalasan.BUbahClick(Sender: TObject);
begin
  with FUbahBalasan do
  begin
  MBalasan.Text:=GridSMSB.DataSource.DataSet.Fields[1].Value;
  LID.Caption  :=GridSMSB.DataSource.DataSet.Fields[0].Value;
  ShowModal;
  end;
end;

procedure TFDataSMSBalasan.GridSMSBPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
with TStringGrid(GridSMSB) do
  begin
      Options := Options + [goRowSelect];
  end;
end;

end.

