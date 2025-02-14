program params;
var i: integer;
begin
  for i := 0 to paramCount() - 1 do
    writeln(paramStr(i) + ' passed');
end.
