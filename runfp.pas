program runfp;

{$H+}

uses SysUtils, crt;

procedure showHelp;
begin
  writeln('Usage: runfp [option] filename');
  writeln('filename - can be any pascal source file');
end;

function execProgram(filename: string): integer;
var workDir: string;
    code: integer;
    programName: string;
begin
  workDir := GetCurrentDir();
  code := ExecuteProcess(workDir, 'fpc ' + filename);
  if code = 0 then
  begin
    programName := ExtractFileName(filename);
    code := ExecuteProcess(workDir, programName);
  end else
  begin
    ExitCode := code;
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
