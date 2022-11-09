unit ValidaDoc4D.UF;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  ValidaDoc4D.Interfaces;

type
  TValidaDoc4DUF = class(TInterfacedObject, IValidaDoc4D)
  private
    FDocumento: string;
    FMensagem: string;
    FUFs: TList<string>;

    procedure InicializaUF;
  protected
    function TipoDocumento(const AValue: TV4DTipoDocumento): IValidaDoc4D;
    function Documento(const AValue: string): IValidaDoc4D;
    function EhValido: Boolean;
    procedure Validar;
  public
    constructor Create;
    class function New: IValidaDoc4D;
    destructor Destroy; override;
  end;

implementation

{ TValidaDoc4DUF }

constructor TValidaDoc4DUF.Create;
begin
  InicializaUF;
end;

destructor TValidaDoc4DUF.Destroy;
begin
  FUFs.Free;
  inherited;
end;

function TValidaDoc4DUF.Documento(const AValue: string): IValidaDoc4D;
begin
  Result := Self;
  FDocumento := AValue;
end;

function TValidaDoc4DUF.EhValido: Boolean;
var
  LUF: string;
begin
  LUF := FDocumento.ToUpper;
  if LUF.Length <> 2 then
  begin
    FMensagem := 'UF deve conter apenas 2 dígitos.';
    Exit(False);
  end;

  if not FUFs.Contains(LUF) then
  begin
    FMensagem := 'UF informada não contém na relação de UFs do Brasil.';
    Exit(False);
  end;

  Result := True;
end;

procedure TValidaDoc4DUF.InicializaUF;
begin
  FUFs := TList<string>.Create;
  FUFs.Add('AC');
  FUFs.Add('AL');
  FUFs.Add('AM');
  FUFs.Add('AP');
  FUFs.Add('BA');
  FUFs.Add('CE');
  FUFs.Add('DF');
  FUFs.Add('ES');
  FUFs.Add('GO');
  FUFs.Add('MA');
  FUFs.Add('MT');
  FUFs.Add('MS');
  FUFs.Add('MG');
  FUFs.Add('PA');
  FUFs.Add('PB');
  FUFs.Add('PR');
  FUFs.Add('PE');
  FUFs.Add('PI');
  FUFs.Add('RJ');
  FUFs.Add('RN');
  FUFs.Add('RS');
  FUFs.Add('RO');
  FUFs.Add('RR');
  FUFs.Add('SC');
  FUFs.Add('SP');
  FUFs.Add('SE');
  FUFs.Add('TO');
end;

class function TValidaDoc4DUF.New: IValidaDoc4D;
begin
  Result := Self.Create;
end;

function TValidaDoc4DUF.TipoDocumento(const AValue: TV4DTipoDocumento): IValidaDoc4D;
begin
  Result := Self;
end;

procedure TValidaDoc4DUF.Validar;
begin
  if not EhValido then
    raise EUFInvalidaException.Create(FDocumento,
      Format('UF %s inválida: %s', [FDocumento, FMensagem]));
end;

end.
