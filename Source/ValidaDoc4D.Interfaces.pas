unit ValidaDoc4D.Interfaces;

interface

uses
  System.SysUtils,
  ValidaDoc4D.Exceptions;

type
  TV4DTipoDocumento = (tdCPF, tdCNPJ, tdEmail, tdUF);

  EDocumentoInvalidoException = ValidaDoc4D.Exceptions.EDocumentoInvalidoException;
  ECPFInvalidoException = ValidaDoc4D.Exceptions.ECPFInvalidoException;
  ECNPJInvalidoException = ValidaDoc4D.Exceptions.ECNPJInvalidoException;
  EUFInvalidaException = ValidaDoc4D.Exceptions.EUFInvalidaException;
  EEmailInvalidoException = ValidaDoc4D.Exceptions.EEmailInvalidoException;

  IValidaDoc4D = interface
    ['{FFAD15A1-A122-4182-BB28-85F696659CEB}']
    function TipoDocumento(const AValue: TV4DTipoDocumento): IValidaDoc4D;
    function Documento(const AValue: string): IValidaDoc4D;
    function EhValido: Boolean;
    procedure Validar;
  end;

implementation

end.
