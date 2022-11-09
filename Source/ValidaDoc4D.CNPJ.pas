unit ValidaDoc4D.CNPJ;

interface

uses
  System.Math,
  System.SysUtils,
  ValidaDoc4D.Utils,
  ValidaDoc4D.Interfaces;

type
  TValidaDoc4DCNPJ = class(TInterfacedObject, IValidaDoc4D)
  private
    FDocumento: string;
    FMensagem: string;

    procedure ValidarCaracteres;
    procedure ValidarTamanho;
    procedure ValidarNumerosIguais;
    function CalculaPrimeiroDigito: Word;
    function CalculaSegundoDigito: Word;
    procedure ValidarDigitos;
  protected
    function TipoDocumento(const AValue: TV4DTipoDocumento): IValidaDoc4D;
    function Documento(const AValue: string): IValidaDoc4D;
    function EhValido: Boolean;
    procedure Validar;
  public
    constructor Create;
    class function New: IValidaDoc4D;
  end;

implementation

{ TValidaDoc4DCNPJ }

function TValidaDoc4DCNPJ.CalculaPrimeiroDigito: Word;
var
  I: Integer;
  LCNPJ: array[1..14] of Byte;
begin
  for I := 1 to 14 do
    LCNPJ[I] := StrToInt(FDocumento[I]);
  Result := 5 * LCNPJ[1] + 4 * LCNPJ[2] + 3 * LCNPJ[3] + 2 * LCNPJ[4];
  Result := Result + 9 * LCNPJ[5] + 8 * LCNPJ[6]  + 7 * LCNPJ[7] + 6 * LCNPJ[8];
  Result := Result + + 5 * LCNPJ[9] + 4 * LCNPJ[10] + 3 * LCNPJ[11] + 2 * LCNPJ[12];
  Result := 11 - Result mod 11;
  Result := IfThen(Result >= 10, 0, Result);
end;

function TValidaDoc4DCNPJ.CalculaSegundoDigito: Word;
var
  I: Integer;
  LCNPJ: array[1..14] of Byte;
  LPrimeiroDigito: Word;
begin
  LPrimeiroDigito := CalculaPrimeiroDigito;
  for I := 1 to 14 do
    LCNPJ[I] := StrToInt(FDocumento[I]);
  Result := 6 * LCNPJ[1] + 5 * LCNPJ[2] + 4 * LCNPJ[3] + 3 * LCNPJ[4];
  Result := Result + 2 * LCNPJ[5] + 9 * LCNPJ[6]  + 8 * LCNPJ[7]  + 7 * LCNPJ[8];
  Result := Result + 6 * LCNPJ[9] + 5 * LCNPJ[10] + 4 * LCNPJ[11] + 3 * LCNPJ[12];
  Result := Result + 2 * LPrimeiroDigito;
  Result := 11 - Result mod 11;
  Result := IfThen(Result >= 10, 0, Result);
end;

constructor TValidaDoc4DCNPJ.Create;
begin
end;

function TValidaDoc4DCNPJ.Documento(const AValue: string): IValidaDoc4D;
begin
  Result := Self;
  FDocumento := AValue.Replace('.', '')
    .Replace('-', '').Replace('/', '');
end;

function TValidaDoc4DCNPJ.EhValido: Boolean;
begin
  Result := False;
  try
    ValidarTamanho;
    ValidarCaracteres;
    ValidarNumerosIguais;
    ValidarDigitos;
    Result := True;
  except
    on E: Exception do
      FMensagem := E.Message;
  end;
end;

class function TValidaDoc4DCNPJ.New: IValidaDoc4D;
begin
  Result := Self.Create;
end;

function TValidaDoc4DCNPJ.TipoDocumento(const AValue: TV4DTipoDocumento): IValidaDoc4D;
begin
  Result := Self;
end;

procedure TValidaDoc4DCNPJ.Validar;
begin
  if not EhValido then
    raise ECNPJInvalidoException.Create(FDocumento,
      Format('CNPJ %s inválido: %s', [FDocumento, FMensagem]));
end;

procedure TValidaDoc4DCNPJ.ValidarCaracteres;
begin
  if not ContemApenasNumeros(FDocumento) then
    raise Exception.Create('Documento deve conter apenas números.');
end;

procedure TValidaDoc4DCNPJ.ValidarDigitos;
var
  I: Integer;
  LPrimeiroDigito: Integer;
  LSegundoDigito: Integer;
  LCNPJ: array[1..14] of Integer;
begin
  for I := 1 to 14 do
    LCNPJ[I] := StrToInt(FDocumento[I]);
  LPrimeiroDigito := CalculaPrimeiroDigito;
  LSegundoDigito := CalculaSegundoDigito;

  if LPrimeiroDigito <> LCNPJ[13] then
    raise Exception.CreateFmt('Erro de CNPJ no cálculo do Primeiro Dígito de Verificação. ' +
      'Valor Esperado %d e o calculado foi %d.', [LCNPJ[13], LPrimeiroDigito]);

  if LSegundoDigito <> LCNPJ[14] then
    raise Exception.CreateFmt('Erro de CNPJ no cálculo do Segundo Dígito de Verificação. ' +
      'Valor Esperado %d e o calculado foi %d.', [LCNPJ[14], LSegundoDigito]);
end;

procedure TValidaDoc4DCNPJ.ValidarNumerosIguais;
begin
  if Pos(FDocumento, '11111111111111.22222222222222.33333333333333.' +
    '44444444444444.55555555555555.66666666666666.77777777777777.' +
    '88888888888888.99999999999999.00000000000000') > 0 then
    raise Exception.Create('Todos os números são iguais.');
end;

procedure TValidaDoc4DCNPJ.ValidarTamanho;
begin
  if FDocumento.Length <> 14 then
    raise Exception.Create('CNPJ deve conter 14 dígitos númericos.');
end;

end.
