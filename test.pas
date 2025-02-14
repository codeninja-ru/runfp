program test;

{$mode objfpc}{$H+}

uses crt, SysUtils, StrUtils, Process;

procedure AssertTrue(desc: string; cond: boolean);
const STR_LEN = 75;
function dots(times: integer): string;
var i: integer;
begin
  Result := ' ';
  for i := 0 to times - 1 do Result := Result + '.';
  Result := Result + ' ';
end;
var defaultStyle: byte;
begin
  defaultStyle := TextAttr;
  write(desc + dots(STR_LEN - Length(desc)));
  if cond then
  begin
    TextColor(Green);
    writeln('ok');
    TextAttr := defaultStyle;
  end else
  begin
    TextColor(Red);
    writeln('failed');
    TextAttr := defaultStyle;
  end;
end;

var status: integer;
    out: string;
    success: boolean;
begin
  success := RunCommand('runfp', [], out, [poWaitOnExit]);
  AssertTrue('./runfp is executable', success);
  AssertTrue('./runfp prints help info', ContainsStr(out, 'Usage:'));

  success := RunCommand('runfp', ['test/helloworld.pas'], out, [poWaitOnExit]);
  AssertTrue('./runfp test/helloword.pas prints hello world', ContainsStr(out, 'Hello World'));

  success := RunCommand('runfp', ['test/error.pas'], out, [poWaitOnExit]);
  AssertTrue('./runfp test/error.pas prints error', ContainsStr(out, 'Fatal: Compilation aborted'));

  success := RunCommand('runfp', ['test/notfound.pas'], out, [poWaitOnExit]);
  AssertTrue('./runfp prints error if file not found', ContainsStr(out, 'file: test/notfound.pas not found'));

  success := RunCommand('runfp', ['test/params.pas', '-param1', '-param2'], out, [poWaitOnExit]);
  AssertTrue('./runfp passes params to the app', ContainsStr(out, '-param1 passed') and ContainsStr(out, '-param2 passed') and ContainsStr(out, 'params count: 2'));

  AssertTrue('./runfp passes stdin to the app', false);
end.
