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
Unit Random.LinuxRandom;

interface

uses
  CTypes,
  Objects,
  Classes,
  SysUtils,
  Random.RandomInterface;

const
  {$IF DEFINED(CPU64)} SYS_getrandom = 318;
  {$ELSEIF DEFINED(CPU32)} SYS_getrandom = 355;
  {$ELSE} SYS_getrandom = 278; {$ENDIF}
  GRND_DEFAULT = $0000;

type
  PCChar = ^CChar;
  PLinuxRandom = ^LinuxRandom;
  LinuxRandom = class (RandomTrait, RandomInterface)
    private
      function GetSystemBytes(var RandomByteBuffer : TBytes; NBytes : SizeUint) : CInt;
    public
      function GetBytes(NBytes : SizeUInt) : TBytes;
      function GetString(NBytes : SizeUInt) : AnsiString;
  end;

function syscall(NRGetRandom : CInt) : CInt;cdecl;varargs;external 'c' name 'syscall';

implementation

function LinuxRandom.GetSystemBytes(var RandomByteBuffer : TBytes; NBytes : SizeUint) : CInt;
var
  RandomCharBuffer : PCChar;
  Return : CInt;
begin
  GetMem(RandomCharBuffer, NBytes);
  Return := syscall(SYS_getrandom, @RandomCharBuffer^, NBytes, GRND_DEFAULT);
  Move(RandomCharBuffer[0], RandomByteBuffer[0], NBytes);
  FreeMem(RandomCharBuffer);
  Result := Return;
end;

function LinuxRandom.GetBytes(NBytes : SizeUInt) : TBytes;
var
  RandomBuffer : AnsiString;
begin
  SetLength(Result, NBytes);
  SetLength(RandomBuffer, NBytes);
  RandomBuffer := GetString(NBytes);
  Move(RandomBuffer[1], Result[0], NBytes);
end;

function LinuxRandom.GetString(NBytes : SizeUInt) : AnsiString;
var
  Buffer : TFileStream;
  RandomByteBuffer : TBytes;
  ReadBytes : SizeUInt;
  SysBytesRead : CInt;
begin
  SetLength(RandomByteBuffer, (NBytes*2));
  SetLength(Result, NBytes);
  SysBytesRead := GetSystemBytes(RandomByteBuffer, (NBytes*2));
  if (SysBytesRead <> (NBytes*2)) then
    begin
      if FileExists('/dev/urandom') then
        begin
          Writeln('URandom');
          Buffer := TFileStream.Create('/dev/urandom', fmOpenRead);
          Buffer.Position := 0;
          ReadBytes := 0;
          while ReadBytes <= (NBytes*2) do
            begin
              Buffer.Read(RandomByteBuffer[ReadBytes], SizeOf(RandomByteBuffer));
              Inc(ReadBytes);
            end;
          Buffer.Free;
        end
        else if (not FileExists('/dev/urandom')) then
        begin
            Writeln('Random');
            RandomByteBuffer := MTRandomBytes((NBytes*2));
        end else
        begin
          raise Exception.Create('All methods to aquire random bytes failed.')
            at get_caller_addr(get_frame), get_caller_frame(get_frame);
        end;
    end;
  Move(RandomByteBuffer[0], Result[1], NBytes);
end;

end.
