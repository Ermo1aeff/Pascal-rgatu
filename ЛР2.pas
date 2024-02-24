program N_2;

uses System, PABCSystem;

var
   ArrayLength: Integer; 
   NoSortedArray: Array of Integer;

function CopyArray: Array of Integer;
begin
   Result := new integer[ArrayLength];
   for var i := 0 to ArrayLength - 1 do
      Result[i] := NoSortedArray[i];
end;

function Cocktail(a: Array of Integer): TimeSpan;
var
   DuplicateArray: Array of Integer;
   StartDateTime: DateTime := DateTime.Now;
   EndDateTime: DateTime;
   Start: Integer := 0;
   Finish: Integer := ArrayLength - 1;
   I: Integer := ArrayLength - 2;
   J: Integer;
   MinI, MaxI: Integer;
   Tmp: Integer;
begin
   while (Start < Finish) do
   begin
      for J := Start + 1 to Finish do
      begin
         if (A[J] < A[J - 1]) then
         begin
            Tmp := A[J - 1];
            A[J - 1] := A[J];
            A[J] := Tmp;
            I := J;
         end;
      end;
      Finish := I - 1;
      for J := Finish downto Start + 1 do
      begin
         if (A[J] < A[J - 1]) then
         begin
            Tmp := A[J - 1];
            A[J - 1] := A[J];
            A[J] := Tmp;
            I := J;
         end;
      end;
      Start := I;
   end;
   EndDateTime := DateTime.Now;
   Result := EndDateTime - StartDateTime;
end;

function Insertion(a: Array of Integer): TimeSpan;
var
   StartDateTime: DateTime := DateTime.Now;
   EndDateTime: DateTime;
   i, j, x: integer;
begin
   for i := 1 to ArrayLength - 1 do
   begin
      x := A[i];
      j := i - 1;
      while (j >= 0) and (A[j] > x) do
      begin
         A[j + 1] := A[j];
         j := j - 1;
      end;
      A[j + 1] := x;
   end;
   EndDateTime := DateTime.Now;
   Result := EndDateTime - StartDateTime;
end;

function Selection(a: Array of Integer): TimeSpan;
var
   StartDateTime: DateTime := DateTime.Now;
   EndDateTime: DateTime;
   i, j, x, k: integer;
begin
   for i := 0 to ArrayLength - 1 do
   begin
      k := i;
      x := a[i];
      for j := i + 1 to ArrayLength - 1 do
      begin
         if (x > a[j]) then
         begin
            k := j;
            x := a[j];
         end;
      end;
      a[k] := a[i];
      a[i] := x;
   end;
   EndDateTime := DateTime.Now;
   Result := EndDateTime - StartDateTime;
end;

begin
   Write('Введите размер массива: ');
   Read(ArrayLength);
   NoSortedArray := new integer[ArrayLength];
   Write('Выберите вариант заполнения массива (0-ручной/оснальное - случайные числа): ');
   var r: integer;
   Read(r);
   if (r = 0) then
   begin
      Writeln('Режим ручного заполнения массива:');
      for var i := 0 to ArrayLength - 1 do
      begin
         Write(i, ': ');
         Readln(NoSortedArray[i]);
      end;
   end else
   begin
      Randomize;
      for var i := 0 to ArrayLength - 1 do
      begin
         NoSortedArray[i] := Random(10);
      end;
      Writeln();
   end;
   Writeln('Cocktail: ', Cocktail(CopyArray));
   Writeln('Insertion: ', Insertion(CopyArray));
   Writeln('Selection: ', Selection(CopyArray));
end.