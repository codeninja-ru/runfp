program runfp;

{$mode objfpc}{$H+}

uses SysUtils, Process;

procedure showHelp;
begin
  writeln('Usage: runfp [option] filename');
  writeln('filename - can be any pascal source file');
end;

function execProgram(filename: string): integer;
const BUFF_SIZE = 1024;
var workDir: string;
    programName: string;
    fpcOut: string;
    status: integer;
begin
  workDir := GetCurrentDir();
  if RunCommandIndir(workDir, 'fpc', [filename], fpcOut, status, [], swoNone) <> 0 then
  begin
    writeln('Cound not run fpc');
    Result := 2;
  end else
    if status <> 0then
  begin
    writeln(fpcOut);
    Result := status;
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
