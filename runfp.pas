program runfp;

{$mode objfpc}{$H+}

uses SysUtils, Classes, Process;

procedure showHelp;
begin
  writeln('Usage: runfp [option] filename');
  writeln('filename - can be any pascal source file');
end;

function execProgram(filename: string): integer;
const BUFF_SIZE = 1024;
var workDir: string;
    code: integer;
    programName: string;
    fpcApp: TProcess;
    buff: array[1..BUFF_SIZE] of byte;
    byteCount: integer;
    fpcOut: TMemoryStream;
    i: integer;
begin
  fpcApp := TProcess.Create(nil);
  fpcOut := TMemoryStream.Create;
  try
    fpcApp.Executable := 'fpc';
    fpcApp.Parameters.Add(filename);
    fpcApp.Options := fpcApp.Options + [poWaitOnExit, poUsePipes];
    fpcApp.Execute;
    repeat
      byteCount := fpcApp.Output.Read(buff, BUFF_SIZE);
      fpcOut.Write(buff, byteCount);
    until byteCount = 0;
    if fpcApp.ExitStatus <> 0 then
    begin
      fpcOut.Position := 0;
      repeat
        byteCount := fpcOut.Read(buff, BUFF_SIZE);
        FileWrite(TextRec(StdErr).Handle, buff, byteCount);
      until byteCount = 0;
      Result := fpcApp.ExitStatus;
    end
    else
    begin
      programName := ExtractFileName(filename);
      {$IFDEF Windows}
      programName := ChangeFileExt(programName, '.exe');
      {$ELSE}
      programName := ChangeFileExt(programName, '');
      {$ENDIF}
      if FileExists(programName) then
      begin
        Result := ExecuteProcess(programName, '', []);
        //{todo params} 
        //{todo pipes}
      end else
      begin
        WriteErrorsToStdErr := true;
        writeln('Error: file ' + programName + ' is not found');
        Result := 2;
      end;
    end;
  finally
    fpcApp.Free;
    fpcOut.Free;
  end;
end;

var i: integer;
    paramFilename: string;

begin
  if paramCount() <> 1 then
  begin
    showHelp();
  end
  else
  begin
    for i := 0 to paramCount() do
    begin
      paramFilename := paramStr(i);
    end;

    if paramFilename <> '' then
    begin
      if FileExists(paramFilename) then
      begin
        ExitCode := execProgram(paramFilename);
      end else
      begin
        writeln('file: ' + paramFilename + ' not found');
        ExitCode := 2;
      end;
    end else
    begin
      writeln('Invalid params');
      showHelp();
      ExitCode := 1;
    end;
  end;

end.
