{
  Модуль содержит клас, в котором формируеться симплекс таблица, и итеративно
  оптимизируется
}
unit Simplex;

interface

uses
  SysUtils, Classes, DB, MemDS, VirtualTable;

type
  // Все виды условий
  TLimitSign = (tsEqual, tsLess, tsGreater, tsLessEqual, tsGreaterEqual);

type
  TSimplexDataModule = class(TDataModule)
    VirtualTable: TVirtualTable;
  private
    FLimitCount: integer;
    FVarCount: integer;
    function GetIsEnd: boolean;
    { Private declarations }
  public
    constructor Create(AVarCount: integer; ALimitCount: integer);
    // Задаем ограничения
    procedure SetLimit(AVarParams: array of integer; ASign: TLimitSign);
    // Итерация Симплек-метода
    procedure Iterate;
    // Проверка на достижение оптимальности Симплек-метода
    property IsEnd: boolean read GetIsEnd;
    // Количество переменных
    property VarCount: integer read FVarCount;
    // Количество ограничений
    property LimitCount: integer read FLimitCount;
  end;

const
  LimitSign: array[Low(TLimitSign)..High(TLimitSign)]of string
    = ('=','<','>','<=','>=');

var
  SimplexDataModule: TSimplexDataModule;

implementation

{$R *.dfm}

{ TSimplexDataModule }

constructor TSimplexDataModule.Create(AVarCount, ALimitCount: integer);
begin
  inherited Create(nil);
  FVarCount := AVarCount;
  FLimitCount := ALimitCount;
end;

function TSimplexDataModule.GetIsEnd: boolean;
begin

end;

procedure TSimplexDataModule.Iterate;
begin

end;

procedure TSimplexDataModule.SetLimit(AVarParams: array of integer;
  ASign: TLimitSign);
begin

end;

end.
