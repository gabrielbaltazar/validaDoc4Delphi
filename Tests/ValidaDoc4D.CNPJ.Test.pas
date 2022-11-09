unit ValidaDoc4D.CNPJ.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  ValidaDoc4D.Interfaces,
  ValidaDoc4D.CNPJ;

type
  [TestFixture]
  TValidaCNPJTest = class
  private
    FDocumento: string;
    FErro: string;
    FValidador: IValidaDoc4D;

    procedure Validar;
  public
    [Setup]
    procedure Setup;

    [Test]
    procedure CNPJValido;

    [Test]
    [TestCase('Zero', '00000000000000')]
    [TestCase('Um', '11111111111111')]
    [TestCase('Dois', '22222222222222')]
    [TestCase('Tres', '33333333333333')]
    [TestCase('Quatro', '44444444444444')]
    [TestCase('Cinco', '55555555555555')]
    [TestCase('Seis', '66666666666666')]
    [TestCase('Sete', '77777777777777')]
    [TestCase('Oito', '88888888888888')]
    [TestCase('Nove', '99999999999999')]
    procedure TodosNumerosIguais(ADocumento: string);

    [Test]
    procedure CaracterInvalido;

    [Test]
    procedure MaisDe14Digitos;

    [Test]
    procedure MenosDe14Digitos;

    [Test]
    procedure CNPJInvalido;
  end;

implementation

{ TValidaCNPJTest }

procedure TValidaCNPJTest.CaracterInvalido;
begin
  FDocumento := 'a29.336.520/0001-5';
  FErro := Format('CNPJ a2933652000015 inválido: Documento deve conter apenas números.', [FDocumento]);
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECNPJInvalidoException,
    FErro);
end;

procedure TValidaCNPJTest.CNPJInvalido;
begin
  FDocumento := '12345678901234';
  FErro := Format('CNPJ 12345678901234 inválido: ' +
    'Erro de CNPJ no cálculo do Segundo Dígito de Verificação. Valor Esperado 4 e o calculado foi 0.',
    [FDocumento]);
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECNPJInvalidoException,
    FErro);
end;

procedure TValidaCNPJTest.CNPJValido;
begin
  FDocumento := '29.336.520/0001-51';
  FValidador.Documento(FDocumento);
  Assert.IsTrue(FValidador.EhValido);
  Assert.WillNotRaiseAny(Validar);
end;

procedure TValidaCNPJTest.MaisDe14Digitos;
begin
  FDocumento := '5529.336.520/0001-51';
  FErro := Format('CNPJ 5529336520000151 inválido: CNPJ deve conter 14 dígitos númericos.', [FDocumento]);
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECNPJInvalidoException,
    FErro);
end;

procedure TValidaCNPJTest.MenosDe14Digitos;
begin
  FDocumento := '6.520/0001-51';
  FErro := Format('CNPJ 6520000151 inválido: CNPJ deve conter 14 dígitos númericos.', [FDocumento]);
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECNPJInvalidoException,
    FErro);
end;

procedure TValidaCNPJTest.Setup;
begin
  FDocumento := EmptyStr;
  FErro := EmptyStr;
  FValidador := TValidaDoc4DCNPJ.New;
end;

procedure TValidaCNPJTest.TodosNumerosIguais(ADocumento: string);
begin
  FErro := Format('CNPJ %s inválido: Todos os números são iguais.', [ADocumento]);
  FDocumento := ADocumento;
  FValidador.Documento(FDocumento);
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    ECNPJInvalidoException,
    FErro);
end;

procedure TValidaCNPJTest.Validar;
begin
  FValidador.Validar;
end;

end.
