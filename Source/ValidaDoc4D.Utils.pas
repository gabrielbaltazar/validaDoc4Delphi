unit ValidaDoc4D.Utils;

interface

uses
  System.SysUtils;

function ContemApenasNumeros(const AValue: string): Boolean;

implementation

function ContemApenasNumeros(const AValue: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to AValue.Length do
    if not (CharInSet(AValue[I], ['0'..'9'])) then
      Exit(False);
end;

end.
