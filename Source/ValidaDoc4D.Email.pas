unit ValidaDoc4D.Email;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  ValidaDoc4D.Interfaces;

type
  TValidaDoc4DEmail = class(TInterfacedObject, IValidaDoc4D)
  private
    FDocumento: string;
    FMensagem: string;
  protected
    function TipoDocumento(const AValue: TV4DTipoDocumento): IValidaDoc4D;
    function Documento(const AValue: string): IValidaDoc4D;
    function EhValido: Boolean;
    procedure Validar;
  public
    class function New: IValidaDoc4D;
  end;

implementation

{ TValidaDoc4DEmail }

function TValidaDoc4DEmail.Documento(const AValue: string): IValidaDoc4D;
begin
  Result := Self;
  FDocumento := AValue;
end;

function TValidaDoc4DEmail.EhValido: Boolean;
var
  LPos: Integer;
  LName: string;
  LServer: string;

  function VerificaCaracteres(AValue: string): Boolean;
  var
    LCount: Integer;
  begin
    for LCount := 1 to AValue.Length do
    begin
      if not (CharInSet(AValue.ToLower[LCount], ['a'..'z', '0'..'9', '_', '.'])) then
        Exit(False);
    end;
    Result := True;
  end;
begin
  LPos := Pos('@', FDocumento);
  if LPos = 0 then
  begin
    FMensagem := 'Email não contém @.';
    Exit(False);
  end;

  LName := Copy(FDocumento, 1, LPos - 1);
  if Length(LName) = 0 then
  begin
    FMensagem := Format('Nome do email %s inválido.', [LName]);
    Exit(False);
  end;

  LServer := Copy(FDocumento, LPos + 1, Length(FDocumento));
  if Length(LServer) < 5 then
  begin
    FMensagem := Format('Servidor do email %s inválido, contém menos de 5 caracteres.', [LServer]);
    Exit(False);
  end;

  if not VerificaCaracteres(LName) then
  begin
    FMensagem := Format('Nome do email %s inválido.', [LName]);
    Exit(False);
  end;

  if not VerificaCaracteres(LServer) then
  begin
    FMensagem := Format('Servidor do email %s inválido.', [LServer]);
    Exit(False);
  end;

  Result := True;
end;

class function TValidaDoc4DEmail.New: IValidaDoc4D;
begin
  Result := Self.Create;
end;

function TValidaDoc4DEmail.TipoDocumento(const AValue: TV4DTipoDocumento): IValidaDoc4D;
begin
  Result := Self;
end;

procedure TValidaDoc4DEmail.Validar;
begin
  if not EhValido then
    raise EEmailInvalidoException.Create(FDocumento,
      Format('Email %s inválido: %s', [FDocumento, FMensagem]));
end;

end.
