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
Unit Random.Generic;

interface

uses
  Objects,
  Classes,
  SysUtils,
  Random.RandomInterface;

type
  PRandomGeneric = ^RandomGeneric;
  RandomGeneric = class (RandomTrait, RandomInterface)
    public
      function GetBytes(NBytes : SizeUInt) : TBytes;
      function GetString(NBytes : SizeUInt) : AnsiString;
  end;

implementation


function RandomGeneric.GetBytes(NBytes : SizeUInt) : TBytes;
var
  RandomBuffer : AnsiString;
begin
  SetLength(Result, NBytes);
  RandomBuffer := GetString(NBytes);
  Move(RandomBuffer[1], Result[0], NBytes);
end;

function RandomGeneric.GetString(NBytes : SizeUInt) : AnsiString;
var
  ByteBuffer : TBytes;
begin
  SetLength(Result, NBytes);
  SetLength(ByteBuffer, (NBytes*2));
  ByteBuffer := MTRandomBytes((NBytes*2));
  Move(ByteBuffer[0], Result[1], NBytes);
end;

end.
