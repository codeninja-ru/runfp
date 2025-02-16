program stdin_test;

var str: string;

begin
  while not eof(Input) do
  begin
    readln(Input, str);
    writeln('Recived: ' + str);
  end;
end.
