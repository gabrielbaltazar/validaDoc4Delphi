unit ValidaDoc4D.Exceptions;

interface

uses
  System.SysUtils;

type
  EDocumentoInvalidoException = class(Exception)
  private
    FDocumento: string;
  public
    constructor Create(ADocumento: string; AMessage: string); reintroduce;

    property Documento: string read FDocumento;
  end;

  ECPFInvalidoException = class(EDocumentoInvalidoException);
  ECNPJInvalidoException = class(EDocumentoInvalidoException);
  EUFInvalidaException = class(EDocumentoInvalidoException);
  EEmailInvalidoException = class(EDocumentoInvalidoException);

implementation

{ EDocumentoInvalidoException }

constructor EDocumentoInvalidoException.Create(ADocumento, AMessage: string);
begin
  inherited Create(AMessage);
  FDocumento := ADocumento;
end;

end.
