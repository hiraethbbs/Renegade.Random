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
{$interfaces corba}
{$codepage UTF8}

Unit Random.RandomInterface;

interface

uses
  Classes,
  SysUtils;

type
   RandomInterface = interface
       ['{0750E585-C1D2-4C1F-A8A4-4EDC41847396}']
       function GetBytes(NBytes : SizeUInt) : TBytes;
       function GetString(NBytes : SizeUInt) : AnsiString;
  end;

  RandomTrait = class (TObject)
    public
    constructor Create;
    destructor Destroy; override;
    function MTRandomBytes(NBytes : SizeUInt) : TBytes; virtual;
  end;

implementation

constructor RandomTrait.Create;
begin
  inherited Create;
end;

destructor RandomTrait.Destroy;
begin
  inherited Destroy;
end;

function RandomTrait.MTRandomBytes(NBytes : SizeUInt) : TBytes;
var
  i : SizeUint;
begin
  System.Randomize;
  SetLength(Result, (NBytes*2));
  for i := 0 to (NBytes*2) do
    begin
      Result[i] := System.Random(MaxInt) mod 256;
    end;
  SetLength(Result, NBytes);
end;

end.
