program Bachelor;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Simplex in 'Simplex.pas' {SimplexDataModule: TDataModule},
  About in 'About.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSimplexDataModule, SimplexDataModule);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
