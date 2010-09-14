program Bachelor;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Simplex in 'Simplex.pas' {SimplexDataModule: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSimplexDataModule, SimplexDataModule);
  Application.Run;
end.
