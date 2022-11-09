unit ValidaDoc4D.CPF;

interface

uses
  System.Math,
  System.SysUtils,
  ValidaDoc4D.Utils,
  ValidaDoc4D.Interfaces;

type
  TValidaDoc4DCPF = class(TInterfacedObject, IValidaDoc4D)
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

{ TValidaDoc4DCPF }

function TValidaDoc4DCPF.CalculaPrimeiroDigito: Word;
var
  I: Integer;
  LCpf: array[0..10] of Byte;
begin
  for I := 1 to 11 do
    LCpf[I - 1] := StrToInt(FDocumento[I]);
  Result := 10 * LCpf[0] + 9 * LCpf[1] + 8 * LCpf[2];
  Result := Result + 7 * LCpf[3] + 6 * LCpf[4] + 5 * LCpf[5];
  Result := Result + 4 * LCpf[6] + 3 * LCpf[7] + 2 * LCpf[8];
  Result := 11 - Result mod 11;
  Result := IfThen(Result >= 10, 0, Result);
end;

function TValidaDoc4DCPF.CalculaSegundoDigito: Word;
var
  I: Integer;
  LCpf: array[0..10] of Byte;
  LPrimeiroDigito: Word;
begin
  LPrimeiroDigito := CalculaPrimeiroDigito;
  for I := 1 to 11 do
    LCpf[I - 1] := StrToInt(FDocumento[I]);
  Result := 11 * LCpf[0] + 10 * LCpf[1] + 9 * LCpf[2];
  Result := Result + 8 * LCpf[3] + 7 * LCpf[4] + 6 * LCpf[5];
  Result := Result + 5 * LCpf[6] + 4 * LCpf[7] + 3 * LCpf[8];
  Result := Result + 2 * LPrimeiroDigito;
  Result := 11 - Result mod 11;
  Result := IfThen(Result >= 10, 0, Result);
end;

constructor TValidaDoc4DCPF.Create;
begin
end;

function TValidaDoc4DCPF.Documento(const AValue: string): IValidaDoc4D;
begin
  Result := Self;
  FDocumento := AValue.Replace('.', '').Replace('-', '');
end;

function TValidaDoc4DCPF.EhValido: Boolean;
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

class function TValidaDoc4DCPF.New: IValidaDoc4D;
begin
  Result := Self.Create;
end;

function TValidaDoc4DCPF.TipoDocumento(const AValue: TV4DTipoDocumento): IValidaDoc4D;
begin
  Result := Self;
end;

procedure TValidaDoc4DCPF.Validar;
begin
  if not EhValido then
    raise ECPFInvalidoException.Create(FDocumento,
      Format('CPF %s inválido: %s', [FDocumento, FMensagem]));
end;

procedure TValidaDoc4DCPF.ValidarCaracteres;
begin
  if not ContemApenasNumeros(FDocumento) then
    raise Exception.Create('Documento deve conter apenas números.');
end;

procedure TValidaDoc4DCPF.ValidarDigitos;
var
  I: Integer;
  LPrimeiroDigito: Integer;
  LSegundoDigito: Integer;
  LCpf: array[0..10] of Integer;
begin
  for I := 1 to 11 do
    LCpf[I - 1] := StrToInt(FDocumento[I]);
  LPrimeiroDigito := CalculaPrimeiroDigito;
  LSegundoDigito := CalculaSegundoDigito;

  if LPrimeiroDigito <> LCpf[9] then
    raise Exception.CreateFmt('Erro de CPF no cálculo do Primeiro Dígito de Verificação. ' +
      'Valor Esperado %d e o calculado foi %d.', [LCpf[9], LPrimeiroDigito]);

  if LSegundoDigito <> LCpf[10] then
    raise Exception.CreateFmt('Erro de CPF no cálculo do Segundo Dígito de Verificação. ' +
      'Valor Esperado %d e o calculado foi %d.', [LCpf[10], LSegundoDigito]);
end;

procedure TValidaDoc4DCPF.ValidarNumerosIguais;
begin
  if Pos(FDocumento, '11111111111.22222222222.33333333333.44444444444.55555555555.' +
    '66666666666.77777777777.88888888888.99999999999.00000000000') > 0 then
    raise Exception.Create('Todos os números são iguais.');
end;

procedure TValidaDoc4DCPF.ValidarTamanho;
begin
  if FDocumento.Length <> 11 then
    raise Exception.Create('CPF deve conter 11 dígitos númericos.');
end;

end.
