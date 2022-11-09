unit ValidaDoc4D.UF.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  ValidaDoc4D.Interfaces,
  ValidaDoc4D;

type
  [TestFixture]
  TValidaUFTest = class
  private
    FDocumento: string;
    FErro: string;
    FValidador: IValidaDoc4D;

    procedure Validar;
  public
    [Setup]
    procedure Setup;

    [Test]
    procedure UFValida;

    [Test]
    procedure DiferenteDe2Caracteres;

    [Test]
    procedure UFInvalida;
  end;

implementation

{ TValidaUFTest }

procedure TValidaUFTest.DiferenteDe2Caracteres;
begin
  FDocumento := 'RJA';
  FErro := 'UF RJA inválida: UF deve conter apenas 2 dígitos.';
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    EUFInvalidaException,
    FErro);
end;

procedure TValidaUFTest.Setup;
begin
  FDocumento := EmptyStr;
  FErro := EmptyStr;
  FValidador := TValidaDoc4D.New;
  FValidador.TipoDocumento(tdUF);
end;

procedure TValidaUFTest.UFInvalida;
begin
  FDocumento := 'RA';
  FErro := 'UF RA inválida: UF informada não contém na relação de UFs do Brasil.';
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    EUFInvalidaException,
    FErro);
end;

procedure TValidaUFTest.UFValida;
begin
  FValidador.Documento('RJ');
  Assert.IsTrue(FValidador.EhValido);
end;

procedure TValidaUFTest.Validar;
begin
  FValidador.Validar;
end;

end.
