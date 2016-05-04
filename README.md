# Free Pascal Random Bytes

This file is a part of [Renegade BBS](http://renegade.cc "Renegade BBS").

This will only work with [Free Pascal](http://freepascal.org "Free Pascal") version 3+.  I Think [namespacing](http://wiki.freepascal.org/FPC_New_Features_3.0#Delphi-like_namespaces_units "Namespaces") is a good idea, and FPC 3+ is not hard to get your hands on for any platform.  In fact, I believe its the most cross platform program that I have ever found, _**including** [ScummVM](http://scummvm.org/ "ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files.")_.

##### From the Free Pascal website :

_Free Pascal is a 32, 64 and 16 bit professional Pascal compiler. It can target many processor architectures: Intel x86 (including 8086), AMD64/x86-64, PowerPC, PowerPC64, SPARC, ARM, AArch64, MIPS and the JVM. Supported operating systems include Linux, FreeBSD, Haiku, Mac OS X/iOS/iPhoneSimulator/Darwin, DOS (16 and 32 bit), Win32, Win64, WinCE, OS/2, MorphOS, Nintendo GBA, Nintendo DS, Nintendo Wii, Android, AIX and AROS. Additionally, support for the Motorola 68k architecture is available in the development versions._

### Usage
Make sure to include ```{$mode objfpc}{$H+}``` in your header or compile with ```-S2 -Sh``` switches.

```pascal
Program RandomTest;
{$mode objfpc}{$H+}

uses
  Renegade.Random,
  Classes;

var
  R : TRandom;
  S : AnsiString;
  T : TBytes;
begin
  R := TRandom.Init;
  S := R.GetString(22);
  T := R.GetBytes(22);
  R.Free;
```

You can also use a custom random generator.  It needs to implement Renegade.Random.RandomInterface;
```pascal
Program RandomTest;
{$mode objfpc}{$H+}

uses
  Renegade.Random,
  MyCustomGenerator,
  Classes;

var
  R : TRandom;
  S : AnsiString;
  T : TBytes;
begin
  R := TRandom.Init;
  R.RandomGenerator := MyCustomGenerator.Create;
  S := R.GetString(22);
  T := R.GetBytes(22);
  R.SetDefaultGenerator; // To get back to the default Generator.
  S := R.GetString(22);
  T := R.GetBytes(22);
  R.Free;
```


  * On Linux systems TRandom reads from /dev/urandom.
  * On Windows systems TRandom uses Windows built in [CryptGenRandom](https://msdn.microsoft.com/en-us/library/windows/desktop/aa379942(v=vs.85).aspx "CryptGenRandom") function.
  * On BSD systems TRandom reads from /dev/urandom. (TODO : read from [arc4random_buf](https://www.freebsd.org/cgi/man.cgi?query=arc4random_buf&sektion=3 "arc4random_buf") this is the same on Mac systems, because Mac = FreeBSD)

TRandom will fall back on Free Pascal's [Random](http://www.freepascal.org/docs-html/rtl/system/random.html "Random") function which uses the [Mersenne Twister](https://en.wikipedia.org/wiki/Mersenne_Twister "Mersenne Twister") algorithm to get random bytes.
