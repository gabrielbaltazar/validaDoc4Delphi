unit ValidaDoc4D.Email.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  ValidaDoc4D.Interfaces,
  ValidaDoc4D;

type
  [TestFixture]
  TValidaEmailTest = class
  private
    FDocumento: string;
    FErro: string;
    FValidador: IValidaDoc4D;

    procedure Validar;
    procedure AssertErro(AMessage: string);
  public
    [Setup]
    procedure Setup;

    [Test]
    procedure EmailValido;

    [Test]
    procedure EmailSemArroba;

    [Test]
    procedure EmailCom2Arrobas;

    [Test]
    procedure NomeInvalido;

    [Test]
    procedure NomeCaracterInvalido;

    [Test]
    procedure ServerInvalido;

    [Test]
    procedure ServerCaracterInvalido;
  end;

implementation

{ TValidaEmailTest }

procedure TValidaEmailTest.AssertErro(AMessage: string);
begin
  Assert.IsFalse(FValidador.EhValido);
  Assert.WillRaiseWithMessage(
    Validar,
    EEmailInvalidoException,
    AMessage);
end;

procedure TValidaEmailTest.EmailCom2Arrobas;
begin
  FValidador.Documento('teste@@email.com');
  AssertErro('Email teste@@email.com inv�lido: Servidor do email @email.com inv�lido.');
end;

procedure TValidaEmailTest.EmailSemArroba;
begin
  FValidador.Documento('testeemail.com');
  AssertErro('Email testeemail.com inv�lido: Email n�o cont�m @.');
end;

procedure TValidaEmailTest.EmailValido;
begin
  FValidador.Documento('teste@email.com');
  Assert.IsTrue(FValidador.EhValido);
end;

procedure TValidaEmailTest.NomeCaracterInvalido;
begin
  FValidador.Documento('test|e@email.com');
  AssertErro('Email test|e@email.com inv�lido: Nome do email test|e inv�lido.');
end;

procedure TValidaEmailTest.NomeInvalido;
begin
  FValidador.Documento('@email.com');
  AssertErro('Email @email.com inv�lido: Nome do email  inv�lido.');
end;

procedure TValidaEmailTest.ServerCaracterInvalido;
begin
  FValidador.Documento('teste@email|.com');
  AssertErro('Email teste@email|.com inv�lido: Servidor do email email|.com inv�lido.');
end;

procedure TValidaEmailTest.ServerInvalido;
begin
  FValidador.Documento('teste@');
  AssertErro('Email teste@ inv�lido: Servidor do email  inv�lido, cont�m menos de 5 caracteres.');
end;

procedure TValidaEmailTest.Setup;
begin
  FDocumento := EmptyStr;
  FErro := EmptyStr;
  FValidador := TValidaDoc4D.New;
  FValidador.TipoDocumento(tdEmail);
end;

procedure TValidaEmailTest.Validar;
begin
  FValidador.Validar;
end;

end.
