unit unitUtilsCode;

interface

uses
  System.SysUtils;

function MascaraTelefone(const Numero: string): string;
function MascaraCEP(const CEP: string): string;
function MascaraCNPJ(const CNPJ: string): string;

implementation

function MascaraTelefone(const Numero: string): string;
var
  Digitos: string;
  ch: Char;
begin
  Digitos := '';
  for ch in Numero do
    if ch in ['0'..'9'] then
      Digitos := Digitos + ch;

  case Length(Digitos) of
    10:
      Result := Format('(%s) %s-%s',
        [Copy(Digitos, 1, 2), Copy(Digitos, 3, 4), Copy(Digitos, 7, 4)]);
    11:
      Result := Format('(%s) %s-%s',
        [Copy(Digitos, 1, 2), Copy(Digitos, 3, 5), Copy(Digitos, 8, 4)]);
  else
    Result := Digitos;
  end;
end;

function MascaraCEP(const CEP: string): string;
var
  Digitos: string;
  ch: Char;
begin
  Digitos := '';
  for ch in CEP do
    if ch in ['0'..'9'] then
      Digitos := Digitos + ch;

  if Length(Digitos) = 8 then
    Result := Format('%s-%s', [Copy(Digitos, 1, 5), Copy(Digitos, 6, 3)])
  else
    Result := Digitos;
end;

function MascaraCNPJ(const CNPJ: string): string;
var
  Digitos: string;
  ch: Char;
begin
  Digitos := '';
  for ch in CNPJ do
    if ch in ['0'..'9'] then
      Digitos := Digitos + ch;

  if Length(Digitos) = 14 then
    Result := Format('%s.%s.%s/%s-%s',
      [Copy(Digitos, 1, 2),
       Copy(Digitos, 3, 3),
       Copy(Digitos, 6, 3),
       Copy(Digitos, 9, 4),
       Copy(Digitos, 13, 2)])
  else
    Result := Digitos;
end;

end.

