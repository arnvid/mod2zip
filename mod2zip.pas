{.$D-,L-,S-,I-,R-,G+}
{$M 16384,0,80000}

Program Mod2Zip;
Uses Crt,dos;
Var NextF : SearchRec;
    de,
    Mods,s3m : Boolean;
    SongName : String;
    ModType  : String[3];
    WorkF    : String;
    TpStr    : String;
    DF       : file of byte;
    TY       : Word;
    DIS      : DirStr;
    NM       : NameStr;
    EXT      : ExtStr;
label skip;

Procedure _Header;
Begin
ClrScr;
WriteLn(' Mod2Zip Converter 1.Oá by iNviSiBLE EviL                               [iSD]');
WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
End;
Function Exist(s1 : String):Boolean;
Var S: SearchRec; I:IntegeR;
begin
  I:= DosError;
  FindFirst(s1,Anyfile,S);
  Exist:= Doserror = 0;
End;

Procedure ZipEmDown;
var args : String;
Begin
  Args := 'c:\util\PKZIP.EXE '+NM+'.ZIP '+NM+Ext+' FILE_ID.DIZ';
  exec(GETENV('COMSPEC'),'/C'+args+' >nul:');
End;

Procedure GetS3mInfo;
Var f: file;
    NameArray : Array [1..28] of Char;
    j,i       : Word;
label hump;
Begin
  songname := '';
  if not exist(WorkF) then begin writeLn(' File Error ! '); halt; end;
  Assign(f,WorkF);
{$I-}Reset(f,1);{$I+}
  BlockRead(f,NameArray,28,i);
  For j := 1 To 28 Do SongName := SongName + NameArray[j];
  j := 28;
  While (Ord(SongName[Length(SongName)]) = 0) Or (Ord(SongName[Length(SongName)]) = 32)  Do
  Begin
    j := j - 1;
    SongName[0] := Chr(j);
    if j = 1 then goto hump;
  End;
hump:
  if j = 1 then
  begin
    SongName := NextF.Name;
  end;
  Mods := False;
  S3M := True;
  close(f);
End;

Procedure GetModInfo;
Var NameArray : Array [1..21] of char;
    typearray : Array [1..4] of char;
    f         : file;
    j,i       : integer;
    ta        : word;
label hump;
Begin
  songname := '';
  if not exist(WorkF) then begin writeLn(' File Error ! '); halt; end;
  Assign(f,WorkF);
{$I-}Reset(f,1);{$I+}
  BlockRead(f,NameArray,21,i);
  For j := 1 To 20 Do SongName := SongName + NameArray[j];
  j := 21;
  While (Ord(SongName[Length(SongName)]) = 0) Or (Ord(SongName[Length(SongName)]) = 32) Do
  Begin
    j := j - 1;
    SongName[0] := Chr(j);
    if j = 1 then goto hump;
  End;
  if j = 1 then
  begin
    SongName := NextF.Name;
  end;
hump:
  Close(f);
  Mods := True;
  S3M := False;
End;
Procedure MakeDiz;
Var
  DizF  : Text;
  DizStr : String;
  Tstr   : String;
  ta,isd : byte;
Begin
 DizStr := '';
 if s3m then TStr  := '[S3M]' else TStr := '[MOD]';
 DizStr := SongName;
 ta := ((40 - ord(TStr[0])) - ord(DizStr[0]));
 for isd := 1 to ta do DizStr := DizStr +' ';
 DizStr := DizStr + TStr;
 Assign(DizF,'FILE_ID.DIZ');
{$I-}ReWrite(DizF);{$I+}
 WriteLn(DizF,DizStr);
 Close(DizF);
End;

Begin
  _header;
  if paramcount < 1 then begin WriteLn(' Parameters missing.. read the dox ');halt;end;
  de := false;
  if paramcount = 2 then
  begin
    if (paramstr(2) = '/d') or (paramstr(2) = '/D') then de := true;
  end;
  FindFirst(ParamStr(1),AnyFile,NextF);
  if DosError <> 0 then Begin WriteLn(' No files found.'); Halt;End;
  while not (DosError = 18) do
  Begin
    Mods := False; S3M := False;
    WorkF := FExpand(NextF.Name);
    FSPlit(WorkF,DIS,NM,EXT);
    if not ((EXT = '.S3M') or (EXT = '.MOD')) then goto skip;
    if (NextF.name = '.') or (NextF.name = '..') then goto skip;
    if (NextF.Size = 0) then goto skip;
    Write(' Processing : ');Write(NextF.Name); TY := WhereY;
    if (EXT = '.S3M') then
    GetS3Minfo
    else
    GetModInfo;
    MakeDiz;
    ZipEmDown;
    gotoxy(73,ty);WriteLn('Done.');
    if de then
    begin
      Assign(df,NextF.Name);
      Erase(df);
    end;
skip:
(*    if (pos('*',ParamStr(1)) = 0) then halt;*)
    FindNext(NextF);
  end;
  if exist('FILE_ID.DIZ') then
  begin
   Assign(Df, 'FILE_ID.DIZ');
   ERASE(DF);
  end;
End.
