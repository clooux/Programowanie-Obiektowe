PROGRAM Z1;

CONST
    start: Integer = 0;
    stop: Integer = 100;
    how: Integer = 10;
VAR
    numbers : array of Integer;
    j: integer;
    
procedure generate(start, stop, howMany: Integer);
var
    a: Integer;
begin
    Randomize;
    for a := 0 to howMany do
        numbers[a] := random(stop - start) + start;
end;

procedure bubbleSort();
var
    i, j, temp, n: Integer;
begin
    n := high(numbers);
    for i := Low(numbers) to n - 1 do
    begin
        for j:= Low(numbers) to n - i do
        begin
            if numbers[j] > numbers[j+1] then
            begin
                temp := numbers[j];
                numbers[j] := numbers[j+1];
                numbers[j+1] := temp;
            end;
        end;
    end;
end;

procedure test1();
begin

end;

begin
    setlength(numbers, how);
    generate(start, stop, how);
    bubbleSort();
    for j:= start to how do
      writeln( numbers[j] );
end.

