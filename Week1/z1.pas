PROGRAM Z1;

CONST
    start: Integer = 0;
    stop: Integer = 100;
    how: Integer = 10;
VAR
    numbers : array of Integer;
    j: integer;
    
procedure generate(start, stop, howMany: Integer; var anArray: array of Integer);
var
    a: Integer;
begin
    Randomize;
    for a := Low(anArray) to High(anArray) - 1 do
    begin
        anArray[a] := random(stop - start) + start;
        // writeln(a, anArray[a]);
    end;
end;

procedure bubbleSort(var anArray: array of Integer);
var
    i, j, temp, n: Integer;
begin
    n := high(anArray);
    for i := Low(anArray) to n - 1 do
    begin
        for j:= Low(anArray) to n - i do
        begin
            if anArray[j] > anArray[j+1] then
            begin
                temp := anArray[j];
                anArray[j] := anArray[j+1];
                anArray[j+1] := temp;
            end;
        end;
    end;
end;

procedure test1();
var
    start, stop, how: Integer;
    list : array of Integer;
    i: Integer;
    passed: boolean;
begin
    start := 0;
    stop := 2;
    how := 5;

    setlength(list, how);

    if Length(list) = 0 then
        passed := false
    else
        passed := true;

    writeln('test1 - passed: ', passed);
end;

procedure test2();
var
    start, stop, how: Integer;
    list : array of Integer;
    i: Integer;
    passed: boolean;
begin
    start := 0;
    stop := 2;
    how := 5;

    setlength(list, how);

    if Length(list) = 5 then
        passed := true
    else
        passed := false;

    writeln('test2 - passed: ', passed);
end;

procedure test3();
var
    start, stop, how: Integer;
    list : array of Integer;
    i: Integer;
    passed: boolean;
begin
    start := 0;
    stop := 5;
    how := 5;

    setlength(list, how);
    generate(start, stop, how, list);

    passed := true;

    for i:= start to how do
        if list[i] < start then
            passed := false;

    writeln('test3 - passed: ', passed);
end;

procedure test4();
var
    start, stop, how: Integer;
    list : array of Integer;
    i: Integer;
    passed: boolean;
begin
    start := 0;
    stop := 5;
    how := 5;

    setlength(list, how);
    generate(start, stop, how, list);

    passed := true;

    for i:= start to how do
        if list[i] > stop then
            passed := false;

    writeln('test4 - passed: ', passed);
end;


procedure test5();
var
    start, stop, how: Integer;
    list : array of Integer;
    i: Integer;
    passed: boolean;
begin
    start := 0;
    stop := 5;
    how := 5;

    setlength(list, how);
    generate(start, stop, how, list);
    bubbleSort(list);

    passed := true;

    for i:= start to how do
        if list[i-1] > list[i] then
            passed := false;

    writeln('test5 - passed: ', passed);
end;

begin
    setlength(numbers, how);
    generate(start, stop, how, numbers);
    bubbleSort(numbers);
    for j:= start to how do
      writeln( numbers[j] );

    test1();
    test2();
    test3();
    test4();
    test5();
end.

