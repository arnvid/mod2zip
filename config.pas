Program Config;
Const
  Where     : Word = $020E2;
  FilNavn   : String = 'MOD2ZIP.EXE';
Var
  TempStr,
  ConfigStr : String;
  Fil       : File;

Function GetInfo:boolean;
Begin
{$I-}
  Assign(Fil,Filnavn); Reset(Fil,1); Seek(fil,where);
  BlockRead(Fil,configstr, sizeof(configstr));
  Close(fil);
{$I+}
  if IOResult <> 0 then Getinfo := False else Getinfo := true;
end;

Function PutInfo:Boolean;
Begin
{$I-}
  Assign(Fil,Filnavn); Reset(Fil,1); Seek(fil,where);
  Blockwrite(Fil,configstr, sizeof(configstr));
  Close(fil);
{$I+}
  if IOResult <> 0 then Putinfo := False else Putinfo := true;
end;
Begin
  Writeln (' Mod2Zip 1.2 configuration editor v1.0 by Warlock /iSD');
  Write(' Reading configuration information:');
  if Getinfo then writeln(' done!') else Begin Writeln (' failed.'); end;
  Write(' Current zip path and parameters: ');writeln(Configstr);
  Writeln(#10+#13+' Please enter new zip path and parameters below:');
  ReadLn(TempStr);
  if not (TempStr = '') then begin
    write(' Writing configuration information:'); 
    if PutInfo then writeln(' done!') else begin writeln(' failed.'); end;
  end;
End.
