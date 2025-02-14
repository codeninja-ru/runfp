program params;
var i: integer;
begin
  write('params count: ');
  writeln(paramCount());
  for i := 1 to paramCount() do
    writeln(paramStr(i) + ' passed');
end.
