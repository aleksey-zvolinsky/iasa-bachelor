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
  SysUtils, Classes;

type
  // Виды условий
  TLimitSign = (tsEqual, tsLess, tsGreater, tsLessEqual, tsGreaterEqual);
  // Виды оптимизации
  TOptimizeType = (otMin, otMax);

type
  TSimplexDataModule = class(TDataModule)
  private
    FMaxLimitCount: integer;
    FMaxVarCount: integer;
    FSimplexTable: array of array of Variant;
    FLimitCount: integer;
    FOptimizeType: TOptimizeType;
    function GetIsEnd: boolean;
    procedure CalcMarks;
    { Private declarations }
  public
    function PrintTable: string;
    // Заданиче размерности симплек-таблицы
    procedure Init(AOptimizeType: TOptimizeType; AMaxVarCount: integer; AMaxLimitCount: integer);
    // Задаем целевую функцию
    procedure SetFunc(AVarParams: array of integer);
    // Задаем ограничения
    procedure SetLimit(AVarParams: array of integer; ASign: TLimitSign);
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
    = ('=','<','>','<=','>=');
const
  ColStartLim = 2;
  RowStartLim = 2;


var
  SimplexDataModule: TSimplexDataModule;

implementation

uses Variants;

{$R *.dfm}

{ TSimplexDataModule }

procedure TSimplexDataModule.Init(AOptimizeType: TOptimizeType;
  AMaxVarCount, AMaxLimitCount: integer);
var
  i,j: integer;
begin
  FOptimizeType := AOptimizeType;
  FLimitCount := 0;
  FMaxVarCount := AMaxVarCount;
  FMaxLimitCount := AMaxLimitCount;
  // Создаем структуру симплекс таблицы
  SetLength(FSimplexTable, 2+MaxLimitCount+1);
  for i:=low(FSimplexTable) to high(FSimplexTable) do
    SetLength(FSimplexTable[i], 3+MaxVarCount+MaxLimitCount);
  // Заполняем таблицу пыстыми значениями
  for i:=low(FSimplexTable) to high(FSimplexTable) do
    for j:=low(FSimplexTable[i]) to high(FSimplexTable[i]) do
      FSimplexTable[i][j] := 0;


  FSimplexTable[0][0] := ' ';
  FSimplexTable[0][1] := ' ';
  FSimplexTable[0][2] := ' ';
  FSimplexTable[1][0] := 'N';
  FSimplexTable[1][1] := 'C';
  FSimplexTable[1][2] := 'X';
  FSimplexTable[high(FSimplexTable)][0] := ' ';
  FSimplexTable[high(FSimplexTable)][1] := ' ';

  // ставим подписи дополнительных переменных слева
  for i:=1 to MaxVarCount+MaxLimitCount do
    FSimplexTable[0][ColStartLim+i] := i;

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
begin

end;

procedure TSimplexDataModule.SetLimit(AVarParams: array of integer;
  ASign: TLimitSign);
var
  i: integer;
begin
  if Length(AVarParams) > FMaxVarCount+1 then
    raise Exception.Create('Задано сильно много параметров переменных !');
  for i:=low(AVarParams) to high(AVarParams) do
    FSimplexTable[RowStartLim+FLimitCount][ColStartLim+i] := AVarParams[i];
  inc(FLimitCount);
  FSimplexTable[RowStartLim+FLimitCount-1][ColStartLim+FMaxVarCount+FLimitCount] := 1;
  FSimplexTable[RowStartLim+FLimitCount-1][0] := FLimitCount+FMaxVarCount;


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

procedure TSimplexDataModule.CalcMarks;
//Mark(i) = Cj*Ai - Ci;
var
  i,j: integer;     
  res: Double;
begin
  for i:=ColStartLim+1 to ColStartLim+MaxVarCount+MaxLimitCount do
  begin
    res := 0;
    // Cj*Ai
    for j:=RowStartLim to LimitCount+RowStartLim-1 do
      res := res + FSimplexTable[j][i] * FSimplexTable[j][1];
    // Cj*Ai - Ci
    FSimplexTable[high(FSimplexTable)][i] := res - FSimplexTable[low(FSimplexTable)+1][i];
  end;
end;

procedure TSimplexDataModule.SetFunc(AVarParams: array of integer);
var
  i: integer;
begin
  if Length(AVarParams) > FMaxVarCount+1 then
    raise Exception.Create('Задано сильно много параметров переменных !');
  for i:=low(AVarParams) to high(AVarParams) do
    FSimplexTable[1][ColStartLim+i+1] := AVarParams[i];
  CalcMarks;
end;

end.
