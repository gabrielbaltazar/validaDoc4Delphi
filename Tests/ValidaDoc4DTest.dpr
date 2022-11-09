program ValidaDoc4DTest;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  TestInsight.DUnitX,
  DUnitX.TestFramework,
  ValidaDoc4D.CPF.Test in 'ValidaDoc4D.CPF.Test.pas',
  ValidaDoc4D.Interfaces in '..\Source\ValidaDoc4D.Interfaces.pas',
  ValidaDoc4D.CPF in '..\Source\ValidaDoc4D.CPF.pas',
  ValidaDoc4D.Exceptions in '..\Source\ValidaDoc4D.Exceptions.pas',
  ValidaDoc4D.Utils in '..\Source\ValidaDoc4D.Utils.pas',
  ValidaDoc4D in '..\Source\ValidaDoc4D.pas',
  ValidaDoc4D.CNPJ in '..\Source\ValidaDoc4D.CNPJ.pas',
  ValidaDoc4D.CNPJ.Test in 'ValidaDoc4D.CNPJ.Test.pas',
  ValidaDoc4D.UF in '..\Source\ValidaDoc4D.UF.pas',
  ValidaDoc4D.UF.Test in 'ValidaDoc4D.UF.Test.pas',
  ValidaDoc4D.Email in '..\Source\ValidaDoc4D.Email.pas',
  ValidaDoc4D.Email.Test in 'ValidaDoc4D.Email.Test.pas';

begin
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  TestInsight.DUnitX.RunRegisteredTests;
end.
