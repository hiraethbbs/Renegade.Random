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
Unit Renegade.Random;

interface

uses
  Objects,
  Classes,
  SysUtils,
  Renegade.Random.RandomInterface,
{$IF DEFINED(LINUX)}
  Renegade.Random.URandom
{$ELSEIF DEFINED(WINDOWS)}
  Renegade.Random.WinRandom
{$ELSEIF DEFINED(BSD)}
  Renegade.Random.BSDRandom
{$ELSE}
  Renegade.Random.Generic;
{$ENDIF}
 ;

type
  PRandom = ^TRandom;
  TRandom = class (RandomTrait, RandomInterface)
    private
      FRandomGenerator :  RandomInterface;
      procedure SetRandomGenerator(GeneratorClass : RandomInterface);
    public
      constructor Init;
      destructor Destroy; override;
      procedure SetDefaultGenerator;
      function GetBytes(NBytes : SizeUInt) : TBytes;
      function GetString(NBytes : SizeUInt) : AnsiString;
      property RandomGenerator : RandomInterface read FRandomGenerator write SetRandomGenerator;
  end;

implementation


constructor TRandom.Init;
begin
  SetDefaultGenerator;
end;

destructor TRandom.Destroy;
begin
  inherited Destroy;
end;

procedure TRandom.SetRandomGenerator(GeneratorClass : RandomInterface);
begin
  FRandomGenerator := GeneratorClass;
end;

procedure TRandom.SetDefaultGenerator;
begin
  {$IF DEFINED(LINUX)}
    FRandomGenerator := URandom.Create;
  {$ELSEIF DEFINED(WINDOWS)}
    FRandomGenerator := WinRandom.Create;
  {$ELSEIF DEFINED(BSD)}
    FRandomGenerator := BSDRandom.Create;
  {$ELSE}
    FRandomGenerator := RandomGeneric.Create;
  {$ENDIF}
end;

function TRandom.GetBytes(NBytes : SizeUInt) : TBytes;
begin
  SetLength(Result, NBytes);
  Result := FRandomGenerator.GetBytes(NBytes);
end;
function TRandom.GetString(NBytes : SizeUInt) : AnsiString;
begin
  SetLength(Result, NBytes);
  Result := FRandomGenerator.GetString(NBytes);

end;

end.
