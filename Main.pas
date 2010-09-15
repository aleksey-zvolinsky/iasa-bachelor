unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Simplex;

type
  TMainForm = class(TForm)
    reOutput: TRichEdit;
    bPrint: TButton;
    bInit: TButton;
    bClear: TButton;
    bIterate: TButton;
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
end;

procedure TMainForm.bInitClick(Sender: TObject);
begin
  SimplexDataModule.Init(otMax, 2, 3);
  SimplexDataModule.SetLimit([24,4,6],tsEqual);
  SimplexDataModule.SetLimit([12,3,2],tsEqual);
  SimplexDataModule.SetLimit([ 8,1,1],tsEqual);
  SimplexDataModule.SetFunc ([ 4,5]);
  reOutput.Lines.Append('Начальная симплекс-таблица');
  reOutput.Lines.Append(SimplexDataModule.PrintTable);
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
  end
  else
  begin
    reOutput.Lines.Append('Уже достигнут оптимальный план');
  end;
end;

end.
