{$ASSERTIONS ON}
{$mode objfpc}{$H+}
Program RandomTest;

Uses
  Renegade.Random,
  Renegade.Random.Generic,
  Renegade.Random.RandomInterface,
  Classes,
  SysUtils;

var
  S : AnsiString;
  T : TBytes;
  RRandom : TRandom;
  i : Byte;
begin
  SetLength(S, 22);
  SetLength(T, 22);
  { Custom random generator }
  RRandom := TRandom.Init;
  Assert(RRandom.InheritsFrom(RandomTrait));
  RRandom.RandomGenerator := RandomGeneric.Create;
  Assert(RRandom.InheritsFrom(RandomTrait));
  S := RRandom.GetString(22);
  T := RRandom.GetBytes(22);
  Assert(Length(S) = 22);
  Assert(High(S) = 22);
  Assert(Low(S) = 1);
  for i := Low(S) to High(S) do
    begin
      Assert(S[i] in [#0..#255]);
    end;
    { Custom random generator bytes }
    Assert(Length(T) = 22);
    Assert(High(T) = 21);
    Assert(Low(T) = 0);
    for i := 0 to High(T) do
      begin
        Assert(T[i] in [0..255]);
      end;

  { Reset to default }
  RRandom.SetDefaultGenerator;
  S := RRandom.GetString(22);
  Assert(Length(S) = 22);
  Assert(High(S) = 22);
  Assert(Low(S) = 1);
  for i := Low(S) to High(S) do
    begin
      Assert(S[i] in [#0..#255]);
    end;
  T := RRandom.GetBytes(22);
  { Random Bytes Default Generator }
  Assert(Length(T) = 22);
  Assert(High(T) = 21);
  Assert(Low(T) = 0);
  for i := 0 to High(T) do
    begin
      Assert(T[i] in [0..255]);
    end;
    RRandom.Free;
    try // Check for access violation after free.
      RRandom.GetString(22);
    except
      on e: Exception do
        begin
          Assert(e.ClassNameIs('EAccessViolation'));
          Assert(e.Message = 'Access violation');
        end;
    end;
end.
