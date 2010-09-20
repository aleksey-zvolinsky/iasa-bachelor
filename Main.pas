unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Simplex, Grids;

type
  TMainForm = class(TForm)
    reOutput: TRichEdit;
    bPrint: TButton;
    bInit: TButton;
    bClear: TButton;
    bIterate: TButton;
    StringGrid1: TStringGrid;
    procedure bPrintClick(Sender: TObject);
    procedure bInitClick(Sender: TObject);
    procedure bClearClick(Sender: TObject);
    procedure bIterateClick(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.bPrintClick(Sender: TObject);
begin
  reOutput.Lines.Append('Текущее состояние симлекс-таблицы');
  reOutput.Lines.Append(SimplexDataModule.PrintTable);
  SimplexDataModule.PrintTableToStringGrid(StringGrid1);
end;

procedure TMainForm.bInitClick(Sender: TObject);
begin
{  SimplexDataModule.Init(otMax, 2, 3);
  SimplexDataModule.SetLimit([24,4,6],tsEqual);
  SimplexDataModule.SetLimit([12,3,2],tsEqual);
  SimplexDataModule.SetLimit([ 8,1,1],tsEqual);
  SimplexDataModule.SetFunc ([ 4,5], otMax);  }
  SimplexDataModule.Init(otMin, 4, 7);
  SimplexDataModule.SetLimit([7, 1, 0, 0, 0],tsLess);
  SimplexDataModule.SetLimit([9, 0, 1, 0, 0],tsLess);
  SimplexDataModule.SetLimit([10,0, 0, 1, 0],tsLess);
  SimplexDataModule.SetLimit([15,1, 1, 0, 0],tsLess);
  SimplexDataModule.SetLimit([10,0, 0, 1,20],tsGreater);
  SimplexDataModule.SetLimit([0 ,1, 3, 0,-66],tsLess);
  SimplexDataModule.SetLimit([0 ,1, 1, -1,0],tsEqual);
  SimplexDataModule.SetFunc([0,0,0,1],otMin);

  SimplexDataModule.PreIterate();
  reOutput.Lines.Append('Начальная симплекс-таблица');
  reOutput.Lines.Append(SimplexDataModule.PrintTable);
  SimplexDataModule.PrintTableToStringGrid(StringGrid1);
end;

procedure TMainForm.bClearClick(Sender: TObject);
begin
  reOutput.Clear;
end;

procedure TMainForm.bIterateClick(Sender: TObject);
begin
  if not SimplexDataModule.IsEnd then
  begin
    reOutput.Lines.Append('Итерация симплекс-метода');
    SimplexDataModule.Iterate;
    reOutput.Lines.Append(SimplexDataModule.PrintTable);
    SimplexDataModule.PrintTableToStringGrid(StringGrid1);
  end
  else
  begin
    reOutput.Lines.Append('Уже достигнут оптимальный план');
  end;
end;

end.
