{*******************************************************}
{                                                       }
{   Renegade BBS                                        }
{                                                       }
{   Copyright (c) 1990-2013 The Renegade Dev Team       }
{   Copyleft  (ↄ) 2016 Renegade BBS                     }
{                                                       }
{   This file is part of Renegade BBS                   }
{                                                       }
{   Renegade is free software: you can redistribute it  }
{   and/or modify it under the terms of the GNU General }
{   Public License as published by the Free Software    }
{   Foundation, either version 3 of the License, or     }
{   (at your option) any later version.                 }
{                                                       }
{   Renegade is distributed in the hope that it will be }
{   useful, but WITHOUT ANY WARRANTY; without even the  }
{   implied warranty of MERCHANTABILITY or FITNESS FOR  }
{   A PARTICULAR PURPOSE.  See the GNU General Public   }
{   License for more details.                           }
{                                                       }
{   You should have received a copy of the GNU General  }
{   Public License along with Renegade.  If not, see    }
{   <http://www.gnu.org/licenses/>.                     }
{                                                       }
{*******************************************************}
{   _______                                  __         }
{  |   _   .-----.-----.-----.-----.---.-.--|  .-----.  }
{  |.  l   |  -__|     |  -__|  _  |  _  |  _  |  -__|  }
{  |.  _   |_____|__|__|_____|___  |___._|_____|_____|  }
{  |:  |   |                 |_____|                    }
{  |::.|:. |                                            }
{  `--- ---'                                            }
{*******************************************************}

{$mode objfpc}{$H+}
{ namespace Renegade.Random }
Unit Random.WinRandom;

interface

uses
  Objects,
  Classes,
  SysUtils,
  Windows,
  Random.RandomInterface;

const
  CRYPT_VERIFYCONTEXT = $F0000000;
  CRYPT_MACHINE_KEYSET = 32;
  PROV_RSA_FULL  = 1;
  CRYPT_NEWKEYSET = 8;


type
  HCRYPTPROV = ULONG_PTR;
  PWinRandom = ^WinRandom;
  WinRandom = class (RandomTrait, RandomInterface)
    public
      function GetBytes(NBytes : SizeUInt) : TBytes;
      function GetString(NBytes : SizeUInt) : AnsiString;
  end;

  function CryptAcquireContextW(var phProv: HCRYPTPROV; pszContainer: LPCTSTR;
    pszProvider: LPCTSTR; dwProvType: DWORD; dwFlags: DWORD): BOOL;stdcall; external 'advapi32' name 'CryptAcquireContextW';
  function CryptGenRandom(hProv: HCRYPTPROV; dwLen: DWORD;
    var pbBuffer: BYTE): BOOL; stdcall; external 'advapi32' name 'CryptGenRandom';

implementation


function WinRandom.GetBytes(NBytes : SizeUInt) : TBytes;
var
  RandomBuffer : AnsiString;
begin
  SetLength(Result, NBytes);
  SetLength(RandomBuffer, NBytes);
  RandomBuffer := GetString(NBytes);
  Move(RandomBuffer[1], Result[0], NBytes);
end;

function WinRandom.GetString(NBytes : SizeUInt) : AnsiString;
var
  RandomBuffer : ^BYTE;
  hCryptProv : ^ULONG_PTR;
  WinCrypt : Boolean;
  ReturnString : AnsiString;
  i, Bytes : SizeInt;
  ReturnBytes : TBytes;
begin
  GetMem(RandomBuffer, (NBytes * 2));
  CryptAcquireContextW(hCryptProv^, nil, nil, PROV_RSA_FULL,
    CRYPT_NEWKEYSET or CRYPT_MACHINE_KEYSET or CRYPT_VERIFYCONTEXT );
  WinCrypt := CryptGenRandom(hCryptProv^, (NBytes * 2), RandomBuffer^);
  SetLength(ReturnString, (NBytes*2));
  if WinCrypt then
    begin
      for i := 1 to (NBytes*2) do
        begin
          ReturnString[i] := Chr(RandomBuffer[i]);
        end;
    end else
    begin
      SetLength(ReturnBytes, (NBytes*2));
      ReturnBytes := MTRandomBytes((NBytes*2));
    end;
  SetLength(Result, NBytes);
  FreeMem(RandomBuffer, (NBytes * 2));
  if WinCrypt then
    begin
      Move(ReturnString[1], Result[1], NBytes);
    end else
    begin
      Move(ReturnBytes[0], Result[1], NBytes);
    end;

end;

end.
