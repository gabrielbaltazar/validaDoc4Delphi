unit ValidaDoc4D.CPF.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  ValidaDoc4D.Interfaces,
  ValidaDoc4D.CPF;

type
  [TestFixture]
  TValidaCPFTest = class
  private
    FDocumento: string;
    FErro: string;
    FValidador: IValidaDoc4D;

    procedure Validar;
  public
    [Setup]
    procedure Setup;

    [Test]
    procedure CPFValido;

    [Test]
    [TestCase('Zero', '00000000000')]
    [TestCase('Um', '11111111111')]
    [TestCase('Dois', '22222222222')]
    [TestCase('Tres', '33333333333')]
    [TestCase('Quatro', '44444444444')]
    [TestCase('Cinco', '55555555555')]
    [TestCase('Seis', '66666666666')]
    [TestCase('Sete', '77777777777')]
    [TestCase('Oito', '88888888888')]
    [TestCase('Nove', '99999999999')]
    procedure TodosNumerosIguais(ADocumento: string);

    [Test]
    procedure CaracterInvalido;

    [Test]
    procedure MaisDe11Digitos;

    [Test]
    procedure MenosDe11Digitos;

    [Test]
    procedure CPFInvalido;
  end;

implementation

procedure TValidaCPFTest.CaracterInvalido;
begin
  FDocumento := 'a440.317.070-6';
  FErro := Format('CPF a4403170706 inválido: Documento deve conter apenas números.', [FDocumento]);
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECPFInvalidoException,
    FErro);
end;

procedure TValidaCPFTest.CPFInvalido;
begin
  FDocumento := '12345678901';
  FErro := Format('CPF 12345678901 inválido: ' +
    'Erro de CPF no cálculo do Segundo Dígito de Verificação. Valor Esperado 1 e o calculado foi 9.',
    [FDocumento]);
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECPFInvalidoException,
    FErro);
end;

procedure TValidaCPFTest.CPFValido;
begin
  FDocumento := '440.317.070-61';
  FValidador.Documento(FDocumento);
  Assert.IsTrue(FValidador.EhValido);
  Assert.WillNotRaiseAny(Validar);
end;

procedure TValidaCPFTest.MaisDe11Digitos;
begin
  FDocumento := '55555440.317.070-6';
  FErro := Format('CPF 555554403170706 inválido: CPF deve conter 11 dígitos númericos.', [FDocumento]);
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECPFInvalidoException,
    FErro);
end;

procedure TValidaCPFTest.MenosDe11Digitos;
begin
  FDocumento := '55555440';
  FErro := Format('CPF 55555440 inválido: CPF deve conter 11 dígitos númericos.', [FDocumento]);
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECPFInvalidoException,
    FErro);
end;

procedure TValidaCPFTest.Setup;
begin
  FDocumento := EmptyStr;
  FErro := EmptyStr;
  FValidador := TValidaDoc4DCPF.New;
end;

procedure TValidaCPFTest.TodosNumerosIguais(ADocumento: string);
begin
  FErro := Format('CPF %s inválido: Todos os números são iguais.', [ADocumento]);
  FDocumento := ADocumento;
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECPFInvalidoException,
    FErro);
end;

procedure TValidaCPFTest.Validar;
begin
  FValidador.Validar;
end;

end.
