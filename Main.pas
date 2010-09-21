unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Simplex, Grids, Buttons, Menus, ActnList;

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ts: TTabSheet;
    StringGrid1: TStringGrid;
    reOutput: TRichEdit;
    bIterate: TButton;
    bPrint: TButton;
    bInit: TButton;
    bClear: TButton;
    sgLimitParams: TStringGrid;
    eLimit: TEdit;
    eVar: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    sgLimitSigns: TStringGrid;
    sgLimitRight: TStringGrid;
    bbSave: TBitBtn;
    bbLoad: TBitBtn;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    ActionList: TActionList;
    ActionSave: TAction;
    ActionLoad: TAction;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    cbTaskType: TComboBoxEx;
    Label4: TLabel;
    Label3: TLabel;
    sgFunc: TStringGrid;
    ActionShowAbout: TAction;
    ActionHelp: TAction;
    ActionCalcRun: TAction;
    procedure bPrintClick(Sender: TObject);
    procedure bInitClick(Sender: TObject);
    procedure bClearClick(Sender: TObject);
    procedure bIterateClick(Sender: TObject);
    procedure eLimitKeyPress(Sender: TObject; var Key: Char);
    procedure eLimitChange(Sender: TObject);
    procedure ActionLoadExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionShowAboutExecute(Sender: TObject);
    procedure ActionCalcRunExecute(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  About;

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

procedure TMainForm.eLimitKeyPress(Sender: TObject; var Key: Char);
begin
  if not ((Key in ['0'..'9']) or (Key = #8)) then
    Key := #0;
end;

procedure TMainForm.eLimitChange(Sender: TObject);
begin
  sgLimitParams.RowCount := StrToInt(eLimit.Text);
  sgLimitParams.ColCount := StrToInt(eVar.Text);

  sgFunc.ColCount := StrToInt(eVar.Text);

  sgLimitSigns.RowCount := StrToInt(eLimit.Text);
  sgLimitRight.RowCount := StrToInt(eLimit.Text);
end;

procedure TMainForm.ActionLoadExecute(Sender: TObject);
var
  sl: TStringList;
  SectCount, RowCount, i: integer;
begin
  if OpenDialog.Execute then
  begin
    RowCount := 0;
    SectCount := -2;
    sl := TStringList.Create;
    try
      sl.LoadFromFile(OpenDialog.FileName);
      for i:=0 to sl.Count -1 do
      begin
        if sl[i] = '---------' then
        begin
          RowCount := 0;
          inc(SectCount);
          Continue;
        end;

        case SectCount of
          -2:
            eLimit.Text := sl[i];
          -1:
            eVar.Text := sl[i];
          0:
            sgLimitParams.Cols[RowCount].CommaText := sl[i];
          1:
            sgLimitSigns.Cols[RowCount].CommaText := sl[i];
          2:
            sgLimitRight.Cols[RowCount].CommaText := sl[i];
          4:
            sgFunc.Rows[RowCount].CommaText := sl[i];
          3:
            cbTaskType.Text := sl[i];
        end;
        inc(RowCount);
      end;
    finally
      sl.Free;
    end;
  end;

end;

procedure TMainForm.ActionSaveExecute(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin
  if SaveDialog.Execute then
  begin
    sl := TStringList.Create;
    try
      sl.Add(eLimit.Text);
      sl.Add('---------');
      sl.Add(eVar.Text);
      sl.Add('---------');
      for i:=0 to sgLimitParams.ColCount -1 do
        sl.Add(sgLimitParams.Cols[i].CommaText);
      sl.Add('---------');
      for i:=0 to sgLimitSigns.ColCount -1 do
        sl.Add(sgLimitSigns.Cols[i].CommaText);
      sl.Add('---------');
      for i:=0 to sgLimitRight.ColCount -1 do
        sl.Add(sgLimitRight.Cols[i].CommaText);
      sl.Add('---------');
      sl.Add(cbTaskType.Text);
      sl.Add('---------');
      for i:=0 to sgFunc.RowCount -1 do
        sl.Add(sgFunc.Rows[i].CommaText);
      sl.SaveToFile(SaveDialog.FileName);
    finally
      sl.Free;
    end;
  end;
end;

procedure TMainForm.ActionShowAboutExecute(Sender: TObject);
begin
  AboutBox.Visible := True;
end;

procedure TMainForm.ActionCalcRunExecute(Sender: TObject);
var
  i,j: integer;
  ar: array of Double;
  sign: TLimitSign;
begin
  SimplexDataModule.Init(otMin, StrToInt(eLimit.Text), StrToInt(eVar.Text));
  SetLength(ar, StrToInt(eVar.Text)+1);
  for i:=0 to StrToInt(eLimit.Text) -1 do
  begin
    ar[0] := StrToInt(sgLimitRight.Cells[0,i]);
    for j:=0 to StrToInt(eVar.Text) -1 do
      ar[j+1] := StrToInt(sgLimitParams.Cells[j,i]);
    if pos('<', sgLimitSigns.Cells[0,i])>0 then
      sign := tsLess
    else if pos('>', sgLimitSigns.Cells[0,i])>0 then
      sign := tsGreater
    else
      sign := tsEqual;
    SimplexDataModule.SetLimit(ar, sign);
  end;
    for j:=0 to StrToInt(eVar.Text) -1 do
      ar[j] := StrToInt(sgFunc.Cells[j,0]);
  if pos(UpperCase('MIN'), cbTaskType.Text)>0 then
    SimplexDataModule.SetFunc(ar, otMin)
  else
    SimplexDataModule.SetFunc(ar, otMax);

  SimplexDataModule.PreIterate();
  reOutput.Lines.Append('Начальная симплекс-таблица');
  reOutput.Lines.Append(SimplexDataModule.PrintTable);
  SimplexDataModule.PrintTableToStringGrid(StringGrid1);
end;

end.
