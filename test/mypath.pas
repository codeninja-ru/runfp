program mypath;

uses SysUtils;

begin
  writeln('My path: ' + ExpandFileName(paramStr(0)));
end.
