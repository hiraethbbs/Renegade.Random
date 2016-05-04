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

{ ???: Todo - use arc4random_buf }
{$mode objfpc}{$H+}
Unit Renegade.Random.BSDRandom;

interface

uses
  CTypes,
  Objects,
  Classes,
  SysUtils,
  Renegade.Random.RandomInterface,
  Renegade.Random.URandom;

type
  PBSDRandom = ^BSDRandom;
  BSDRandom = class (RandomTrait, RandomInterface)
    private
      function GetSystemBytes(var RandomByteBuffer : TBytes; NBytes : SizeUint) : CInt;
    public
      function GetBytes(NBytes : SizeUInt) : TBytes;
      function GetString(NBytes : SizeUInt) : AnsiString;
  end;

procedure arc4random_buf(var Buffer : PCChar; StringLength : CInt);
  cdecl;varargs;external 'c' name 'arc4random_buf';

implementation

function GetSystemBytes(var RandomByteBuffer : TBytes; NBytes : SizeUint) : CInt;
begin
  arc4random_buf(@RandomByteBuffer^, NBytes);
  if Length(RandomByteBuffer^) <> NBytes then
    begin
      Result := -1;
    end else
    begin
      Result := Length(RandomByteBuffer^);
    end;
end;

function BSDRandom.GetBytes(NBytes : SizeUInt) : TBytes;
var
  RandomBuffer : AnsiString;
begin
  SetLength(Result, NBytes);
  RandomBuffer := GetString(NBytes);
  Move(RandomBuffer[1], Result[0], NBytes);
end;

function BSDRandom.GetString(NBytes : SizeUInt) : AnsiString;
var
  TURandom : URandom;
begin
  TURandom := URandom.Create;
  SetLength(Result, NBytes);
  Result := TURandom.GetString(NBytes);
end;

end.
