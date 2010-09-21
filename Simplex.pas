{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{
  Модуль содержит клас, в котором формируеться симплекс таблица, и итеративно
  оптимизируется
}
unit Simplex;

interface

uses
  SysUtils, Classes, Grids;

type
  // Виды условий
  TLimitSign = (tsEqual, tsLess, tsGreater);
  // Виды оптимизации
  TOptimizeType = (otMin, otMax);
type
  TLimitRecord = record
    Params: array of Double;
    Sign: TLimitSign;
  end;
  TFuncRecord = record
    Params: array of Double;
    OptType: TOptimizeType;
  end;

type
  TSimplexDataModule = class(TDataModule)
  private
    FMaxLimitCount: integer;
    FMaxVarCount: integer;
    FSimplexTable: array of array of Variant;
    FLimitCount: integer;
    FOptimizeType: TOptimizeType;
    LimitsList: array of TLimitRecord;
    Func: TFuncRecord;
    function GetIsEnd: boolean;
    procedure CalcMarks;
    { Private declarations }
    // Запись ограничения в симплекс таблице
    procedure _SetLimit(AVarParams: array of integer; ASign: TLimitSign);
  public
    function PrintTable: string;
    procedure PrintTableToStringGrid(AStringGrid: TStringGrid);
    // Задание размерности симплек-таблицы и типа оптимизации
    procedure Init(AOptimizeType: TOptimizeType; AMaxVarCount: integer; AMaxLimitCount: integer);
    // Задаем целевую функцию
    procedure SetFunc(AVarParams: array of Double; AOptimizeType: TOptimizeType);
    // Задаем ограничения
    procedure SetLimit(AVarParams: array of Double; ASign: TLimitSign);
    // Составление симплекс таблицы
    procedure PreIterate;
    // Итерация Симплек-метода
    procedure Iterate;
    // Проверка на достижение оптимальности Симплек-метода
    property IsEnd: boolean read GetIsEnd;
    // Максимальное количество переменных
    property MaxVarCount: integer read FMaxVarCount;
    // Максимальное количество ограничений
    property MaxLimitCount: integer read FMaxLimitCount;
    // Количество установленых ограничений
    property LimitCount: integer read FLimitCount;
    // Тип оптимизации
    property OptimizeType: TOptimizeType read FOptimizeType;
  end;

const
  LimitSign: array[Low(TLimitSign)..High(TLimitSign)]of string
    = ('=','<=','>=');
const
  ColStartLim = 2;
  RowStartLim = 2;
  ColN = 0;
  ColC = 1;
  ColX = 2;

const
  M = 1e5;


var
  SimplexDataModule: TSimplexDataModule;

implementation

uses Variants;

{$R *.dfm}

{ TSimplexDataModule }

procedure TSimplexDataModule.Init(AOptimizeType: TOptimizeType;
  AMaxVarCount, AMaxLimitCount: integer);
begin
  FOptimizeType := AOptimizeType;
  FLimitCount := 0;
  FMaxVarCount := AMaxVarCount;
  FMaxLimitCount := AMaxLimitCount;
  SetLength(LimitsList,0);
end;

function TSimplexDataModule.GetIsEnd: boolean;
var
  i: integer;
begin
  Result := True;
  for i:=ColStartLim+1 to ColStartLim+MaxVarCount+MaxLimitCount do
  begin
    case OptimizeType of
      otMin:
        if not(FSimplexTable[high(FSimplexTable)][i] <= 0) then
          Result := False;
      otMax:
        if not(FSimplexTable[high(FSimplexTable)][i] >= 0) then
          Result := False;
    end;
  end;
end;

procedure TSimplexDataModule.Iterate;
var
  GuidElCol, GuidElRow, i,j: integer;
  val, GuidElVal: Double;
begin
  // Определяем направляющий столбец, согластно оценок, для максимизации минимальный
  // для минимазации максимальный
  val := 0;
  GuidElCol := 0;
  for i := ColStartLim+1 to ColStartLim+MaxVarCount+MaxLimitCount do
  begin
    case Self.OptimizeType of
      otMin:
        if FSimplexTable[high(FSimplexTable)][i] > val then
        begin
          val := FSimplexTable[high(FSimplexTable)][i];
          GuidElCol := i;
        end;
      otMax:
        if FSimplexTable[high(FSimplexTable)][i] < val then
        begin
          val := FSimplexTable[high(FSimplexTable)][i];
          GuidElCol := i;
        end;
    end;
  end;
  
  if FSimplexTable[RowStartLim][GuidElCol] > 0 then
    val := FSimplexTable[RowStartLim][ColX]/FSimplexTable[RowStartLim][GuidElCol]
  else
    val := M;
  GuidElRow := RowStartLim;
  GuidElVal := FSimplexTable[RowStartLim][GuidElCol];
  // Определив направляющий столбец выберем направляющий элемент
  for i:=RowStartLim to RowStartLim+Length(LimitsList) -1 do
  begin
    if FSimplexTable[i][GuidElCol] > 0 then
      if FSimplexTable[i][ColX]/FSimplexTable[i][GuidElCol] < val then
      begin
        val := FSimplexTable[RowStartLim][ColX]/FSimplexTable[i][GuidElCol];
        GuidElRow := i;
        GuidElVal := FSimplexTable[i][GuidElCol];
      end;
  end;
  // Вычислив направляющий элемент можно перестраивать симплекс таблицу
  // Начинаем с того что заполняем колонки С и N новыми значениями

  FSimplexTable[GuidElRow][ColC] := FSimplexTable[1][GuidElCol];
  FSimplexTable[GuidElRow][ColN] := FSimplexTable[0][GuidElCol];

  // По методу полного исключения Гаусса-Жордана пересчитываем остальную таблицу

  // Элементы оставшейся таблицы считаем, кроме направляющих столбца и строки
  for j := ColStartLim to ColStartLim+Length(LimitsList[0].Params)+Length(LimitsList)-1-1 do
  begin
    for i := RowStartLim to RowStartLim+Length(LimitsList) do
    begin
      if(i <> GuidElRow)and(j <> GuidElCol)then
        FSimplexTable[i][j] := FSimplexTable[i][j]
          - FSimplexTable[GuidElRow][j] * FSimplexTable[i][GuidElCol] / FSimplexTable[GuidElRow][GuidElCol];
    end;
  end;
  // Элементы строки делим на ведущий элемент
  for i := ColStartLim to ColStartLim+Length(LimitsList[0].Params)+Length(LimitsList)-1-1 do
  begin
    FSimplexTable[GuidElRow][i] := FSimplexTable[GuidElRow][i] / GuidElVal;
  end;
  // Элементы столбца ставим нулями
  for i:=RowStartLim to RowStartLim+Length(LimitsList)-1 do
  begin
    if i <> GuidElRow then
    begin
      FSimplexTable[i][GuidElCol] := 0;
    end;
  end;

end;

procedure TSimplexDataModule.SetLimit(AVarParams: array of Double;
  ASign: TLimitSign);
var
  i: integer;
begin
  if Length(AVarParams) > FMaxVarCount+1 then
    raise Exception.Create('Задано сильно много параметров переменных !');
  SetLength(LimitsList, Length(LimitsList)+1);
  SetLength(LimitsList[high(LimitsList)].Params, Length(AVarParams));
  for i:= low(AVarParams) to high(AVarParams) do
    LimitsList[high(LimitsList)].Params[i] := AVarParams[i];
  LimitsList[high(LimitsList)].Sign := ASign;

  exit;
  // запись в симплекс таблицу
  for i:=low(AVarParams) to high(AVarParams) do
    FSimplexTable[RowStartLim+FLimitCount][ColStartLim+i] := AVarParams[i];
  inc(FLimitCount);

  case ASign of
    tsLess:
    begin
      // Добавить дополительную переменную с коєфициєнтом "1"
      // Коэфициент переменной попадающей в начальный базис
      FSimplexTable[RowStartLim+FLimitCount-1][ColStartLim+FMaxVarCount+FLimitCount] := 1;
      // Проставляем номер переменной, которую попадает в начальный базис
      FSimplexTable[RowStartLim+FLimitCount-1][0] := FLimitCount+FMaxVarCount;
    end;
    tsEqual:
    begin
      // Нужно добавить вспомогательную переменную и ее ввести в базис
    end;
    tsGreater:
    begin
      // Добавить дополительную переменную с коєфициєнтом "-1" и вспомогательную
      FSimplexTable[RowStartLim+FLimitCount-1][ColStartLim+FMaxVarCount+FLimitCount] := -1;
    end;
  end;//case ASign of


  // Задаем начальные параметры таблицы
  if FLimitCount = Self.MaxVarCount+1 then
  begin
    //CalcMarks;
  end;
end;

procedure TSimplexDataModule._SetLimit(AVarParams: array of integer;
  ASign: TLimitSign);
var
  i: integer;
begin
  if Length(AVarParams) > FMaxVarCount+1 then
    raise Exception.Create('Задано сильно много параметров переменных !');

  // запись в симплекс таблицу
  for i:=low(AVarParams) to high(AVarParams) do
    FSimplexTable[RowStartLim+FLimitCount][ColStartLim+i] := AVarParams[i];
  inc(FLimitCount);

  case ASign of
    tsLess:
    begin
      // Добавить дополительную переменную с коєфициєнтом "1"
      // Коэфициент переменной попадающей в начальный базис
      FSimplexTable[RowStartLim+FLimitCount-1][ColStartLim+FMaxVarCount+FLimitCount] := 1;
      // Проставляем номер переменной, которую попадает в начальный базис
      FSimplexTable[RowStartLim+FLimitCount-1][0] := FLimitCount+FMaxVarCount;
    end;
    tsEqual:
    begin
      // Нужно добавить вспомогательную переменную и ее ввести в базис
    end;
    tsGreater:
    begin
      // Добавить дополительную переменную с коєфициєнтом "-1" и вспомогательную
      FSimplexTable[RowStartLim+FLimitCount-1][ColStartLim+FMaxVarCount+FLimitCount] := -1;
    end;
  end;//case ASign of


  // Задаем начальные параметры таблицы
  if FLimitCount = Self.MaxVarCount+1 then
  begin
    //CalcMarks;
  end;
end;

function TSimplexDataModule.PrintTable: string;
var
  i,j: integer;
begin
  Result := '';
  for i:=low(FSimplexTable) to high(FSimplexTable) do
  begin
    for j:=low(FSimplexTable[i]) to high(FSimplexTable[i]) do
    begin
      if FSimplexTable[i][j] <> Unassigned then
        Result := Result +  VarToStr(FSimplexTable[i][j]) + #09
      else
        Result := Result +  '0'+ #09;
    end;
    Result := Result + #10#13;
  end;
end;

procedure TSimplexDataModule.PrintTableToStringGrid(AStringGrid: TStringGrid);
var
  i,j: integer;
begin
  AStringGrid.RowCount := Length(FSimplexTable);
  AStringGrid.ColCount := Length(FSimplexTable[0]);
  for i:=low(FSimplexTable) to high(FSimplexTable) do
  begin
    for j:=low(FSimplexTable[i]) to high(FSimplexTable[i]) do
    begin
      if FSimplexTable[i][j] <> Unassigned then
        AStringGrid.Cells[j,i] := VarToStr(FSimplexTable[i][j])
      else
        AStringGrid.Cells[j,i] := '0';
    end;
  end;
end;

procedure TSimplexDataModule.CalcMarks;
//Mark(i) = Cj*Ai - Ci;
var
  i,j: integer;     
  res: Double;
begin
  for i:=ColStartLim to Length(FSimplexTable[0])-1 do
  begin
    res := 0;
    // Cj*Ai
    for j:=RowStartLim to Length(LimitsList)+RowStartLim-1 do
      res := res + FSimplexTable[j][i] * FSimplexTable[j][1];
    // Cj*Ai - Ci
    FSimplexTable[high(FSimplexTable)][i] := res - FSimplexTable[1][i];
  end;
end;

procedure TSimplexDataModule.SetFunc(AVarParams: array of Double; AOptimizeType: TOptimizeType);
var
  i: integer;
begin
  if Length(AVarParams) > FMaxVarCount+1 then
    raise Exception.Create('Задано сильно много параметров переменных !');
  SetLength(Func.Params, Length(AVarParams));
  for i:=low(AVarParams) to high(AVarParams) do
    Func.Params[i] := AVarParams[i];
  Func.OptType := AOptimizeType;
  exit;

  for i:=low(AVarParams) to high(AVarParams) do
    FSimplexTable[1][ColStartLim+i+1] := AVarParams[i];
  CalcMarks;
end;

procedure TSimplexDataModule.PreIterate;
var
  i, j: integer;
  LessCount, GreaterCount, EqualCount,
  LimitCount, AddVarCount, SupVarCount, VarCount: integer;
begin
  LessCount := 0; GreaterCount := 0; EqualCount := 0; VarCount := 0;
  for i := low(LimitsList) to high(LimitsList) do
  begin
    case LimitsList[i].Sign of
      tsEqual:
        inc(EqualCount);
      tsLess:
        inc(LessCount);
      tsGreater:
        inc(GreaterCount);
    end;
    if Length(LimitsList[i].Params) > VarCount then
      VarCount := Length(LimitsList[i].Params);
  end;
  dec(VarCount);
  if EqualCount+GreaterCount > 0 then
    ;// Имеем двухфазный симплекс метод

  // Произведя подсчет имеем картину о том какого рода задача будет решатся

  // Создаем структуру симплекс таблицы
  // Кол-во строк

  SetLength(FSimplexTable, RowStartLim+Length(LimitsList)+1);
  // Кол-во елементов в строке
  for i:=low(FSimplexTable) to high(FSimplexTable) do
    // Общее кол-во, кол-во доп.переменных, кол-во вспомогательных переменных
    SetLength(FSimplexTable[i], 3+VarCount+LessCount+GreaterCount+GreaterCount+EqualCount);
  // Заполняем таблицу пыстыми значениями
  for i:=low(FSimplexTable) to high(FSimplexTable) do
    for j:=low(FSimplexTable[i]) to high(FSimplexTable[i]) do
      FSimplexTable[i][j] := 0;

  FSimplexTable[0][0] := ' ';
  FSimplexTable[0][1] := ' ';
  FSimplexTable[0][2] := ' ';
  FSimplexTable[1][0] := 'N';
  FSimplexTable[1][1] := 'C';
  FSimplexTable[1][2] := '0';
  FSimplexTable[high(FSimplexTable)][0] := ' ';
  FSimplexTable[high(FSimplexTable)][1] := ' ';

  // ставим подписи дополнительных переменных сверху
  for i:=1 to VarCount do
    FSimplexTable[0][ColStartLim+i] := 'x'+IntToStr(i);

  // Заполняем симплекс-таблицу, сперва основные переменные, потом дополнительные, затем вспомогательные
  // Сперва ограничения меньше, потом больше, потом равно
  LimitCount := 0;
  AddVarCount := 0;
  SupVarCount := 0;
  for i := low(LimitsList) to high(LimitsList) do
  begin
    if LimitsList[i].Sign = tsLess then
    begin
      inc(LimitCount);   

      
      for j:= low(LimitsList[i].Params) to high(LimitsList[i].Params) do
        FSimplexTable[RowStartLim+LimitCount-1][ColStartLim+ j] := LimitsList[i].Params[j];
      Inc(AddVarCount);
      FSimplexTable[RowStartLim+LimitCount-1][ColStartLim+VarCount+AddVarCount] := 1;
      FSimplexTable[RowStartLim+LimitCount-1][0] := 'x'+IntToStr(VarCount + LimitCount);
      FSimplexTable[0][ColStartLim + VarCount + LimitCount] := 'x'+IntToStr(VarCount + LimitCount);
    end;
  end;

  for i := low(LimitsList) to high(LimitsList) do
  begin
    if LimitsList[i].Sign = tsGreater then
    begin
      inc(LimitCount);

      for j:= low(LimitsList[i].Params) to high(LimitsList[i].Params) do
        FSimplexTable[RowStartLim+LimitCount-1][ColStartLim+ j] := LimitsList[i].Params[j];
      Inc(AddVarCount);
      FSimplexTable[RowStartLim+LimitCount-1][ColStartLim+VarCount+AddVarCount] := -1;
      FSimplexTable[0][ColStartLim + VarCount + LimitCount] := 'x'+IntToStr(VarCount + LimitCount);
      Inc(SupVarCount);
      FSimplexTable[RowStartLim+LimitCount-1][ColStartLim+VarCount+LessCount+GreaterCount+SupVarCount] := 1;   
      FSimplexTable[RowStartLim-1][ColStartLim+VarCount+LessCount+GreaterCount+SupVarCount] := M;
      FSimplexTable[0][ColStartLim+VarCount+LessCount+GreaterCount+SupVarCount] := 'z'+IntToStr(SupVarCount);
      FSimplexTable[RowStartLim+LimitCount-1][0] := 'z'+IntToStr(SupVarCount);
      FSimplexTable[RowStartLim+LimitCount-1][1] := M;
    end;
  end;


  for i := low(LimitsList) to high(LimitsList) do
  begin
    if LimitsList[i].Sign = tsEqual  then
    begin
      inc(LimitCount);


      for j:= low(LimitsList[i].Params) to high(LimitsList[i].Params) do
        FSimplexTable[RowStartLim+LimitCount-1][ColStartLim+ j] := LimitsList[i].Params[j];
      Inc(SupVarCount);
      FSimplexTable[RowStartLim+LimitCount-1][ColStartLim+VarCount+LessCount+GreaterCount+SupVarCount] := 1;
      FSimplexTable[RowStartLim-1][ColStartLim+VarCount+LessCount+GreaterCount+SupVarCount] := M;
      FSimplexTable[0][ColStartLim+VarCount+LessCount+GreaterCount+SupVarCount] := 'z'+IntToStr(SupVarCount);
      FSimplexTable[RowStartLim+LimitCount-1][0] := 'z'+IntToStr(SupVarCount);
      FSimplexTable[RowStartLim+LimitCount-1][1] := M;
    end;
  end;

  // Теперь вводим целевую функцию
  for j:= low(Func.Params) to high(Func.Params) do
    FSimplexTable[RowStartLim-1][ColStartLim + j + 1] := Func.Params[j];

  Self.CalcMarks;
end;

end.
