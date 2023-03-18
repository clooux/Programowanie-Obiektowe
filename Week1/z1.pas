PROGRAM Z1;

CONST
    start: Integer = 1;
    stop: Integer = 50;
    top: Integer = 100;
VAR
    numbers : array[start .. stop] of Integer;
    j: integer;
    
procedure generate(start, stop, howMany: Integer);
var
    a: Integer;
begin
    Randomize;
    for a := 1 to howMany do
        numbers[a] := random(0,stop);

end;

procedure bubbleSort();
begin
    
end;

begin
    writeln('Hello World');
    generate(start, stop, TOP);
    for j:= 1 to stop do
      writeln( numbers[j] );
end.