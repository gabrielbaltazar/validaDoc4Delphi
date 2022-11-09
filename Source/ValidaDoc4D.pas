unit ValidaDoc4D;

interface

uses
  ValidaDoc4D.Interfaces,
  ValidaDoc4D.CPF,
  ValidaDoc4D.CNPJ,
  ValidaDoc4D.Email,
  ValidaDoc4D.UF;

type
  TValidaDoc4D = class(TInterfacedObject, IValidaDoc4D)
  private
    FDocumento: string;
    FTipoDocumento: TV4DTipoDocumento;

    function GetStrategy: IValidaDoc4D;
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

{ TValidaDoc4D }

constructor TValidaDoc4D.Create;
begin
  FTipoDocumento := tdCPF;
end;

function TValidaDoc4D.Documento(const AValue: string): IValidaDoc4D;
begin
  Result := Self;
  FDocumento := AValue;
end;

function TValidaDoc4D.EhValido: Boolean;
var
  LStrategy: IValidaDoc4D;
begin
  LStrategy := GetStrategy;
  LStrategy.Documento(FDocumento);
  Result := LStrategy.EhValido;
end;

function TValidaDoc4D.GetStrategy: IValidaDoc4D;
begin
  case FTipoDocumento of
    tdCPF: Result := TValidaDoc4DCPF.New;
    tdCNPJ: Result := TValidaDoc4DCNPJ.New;
    tdEmail: Result := TValidaDoc4DEmail.New;
    tdUF: Result := TValidaDoc4DUF.New;
  end;
end;

class function TValidaDoc4D.New: IValidaDoc4D;
begin
  Result := Self.Create;
end;

function TValidaDoc4D.TipoDocumento(const AValue: TV4DTipoDocumento): IValidaDoc4D;
begin
  Result := Self;
  FTipoDocumento := AValue;
end;

procedure TValidaDoc4D.Validar;
var
  LStrategy: IValidaDoc4D;
begin
  LStrategy := GetStrategy;
  LStrategy.Documento(FDocumento);
  LStrategy.Validar;
end;

end.
