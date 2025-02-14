program runfp;

{$mode objfpc}{$H+}

{todo cache files?}
{todo shebang}

uses SysUtils, StrUtils, Process;

procedure showHelp;
begin
  writeln('Usage: runfp [option] filename');
  writeln('filename - can be any pascal source file');
end;

function execProgram(filename: string; params: array of string): integer;
const BUFF_SIZE = 1024;
var workDir: string;
    tempDir: string;
    programName: string;
    programPath: string;
    fpcOut: string;
    status: integer;
    paramsStr: string;
    i: integer;
begin
  tempDir := GetTempDir(false) + 'runfp/';
  if not DirectoryExists(tempDir) then
  begin
    if not CreateDir(tempDir) then raise Exception.Create('Failed to create temp dir ' + tempDir);
  end;

  programName := ExtractFileName(filename);
  {$IFDEF Windows}
  programName := ChangeFileExt(programName, '.exe');
  {$ELSE}
  programName := ChangeFileExt(programName, '');
  {$ENDIF}
  programPath := tempDir + programName;

  workDir := ExtractFilePath(ExpandFileName(filename));
  if RunCommandIndir(workDir, 'fpc', [workDir + ExtractFileName(filename), '-FU' + tempDir, '-FE' + tempDir], fpcOut, status, [], swoNone) <> 0 then
  begin
    writeln('Cound not run fpc');
    Result := 2;
  end else
    if status <> 0 then
  begin
    writeln(fpcOut);
    Result := status;
  end
  else
  begin
    if FileExists(programPath) then
    begin
      for i := 0 to Length(params) - 1 do
        paramsStr := paramsStr + params[i] + ' ';
      Result := ExecuteProcess(programPath, Trim(paramsStr), []);
      {todo params} 
      {todo user input programs}
      {todo working dir}
      {todo pipes}
    end else
    begin
      WriteErrorsToStdErr := true;
      writeln('Error: file ' + programName + ' is not found in ' + workDir);
      Result := 2;
    end;
  end;
end;

var i: integer;
    paramFilename: string;
    params: array of string;

begin
  if paramCount() = 0 then
  begin
    showHelp();
  end else
  begin
    paramFilename := paramStr(1);
    SetLength(params, paramCount() - 1);
    for i := 2 to paramCount() do
      params[i - 2] := paramStr(i);

    if paramFilename <> '' then
    begin
      if FileExists(paramFilename) then
      begin
        ExitCode := execProgram(paramFilename, params);
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
