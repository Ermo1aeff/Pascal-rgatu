program N_3;

uses System, PABCSystem;

procedure WriteFile; 
var 
   f:Text;
   ArrayLength, choice, el: Integer;
begin
   Write('Укажите размер массива: ');
   Read(ArrayLength);
   Write('Выберите вариант заполнения массива (0-ручной/оснальное - случайные числа): ');
   assign(f,'D:\Input.txt');
   rewrite(f);
   Read(choice);
   if (choice = 0) then
   begin
      Writeln('Режим ручного заполнения массива:');
      for var i := 0 to ArrayLength - 1 do
      begin
         Write(i, ': ');
         Readln(el);
         Write(f, el + ' ');
      end;
   end else
   begin
      Randomize;
      for var i := 0 to ArrayLength - 1 do
      begin
         Write(f, random(10) + ' ');
      end;
      Writeln();
   end; 
   close(f);   
end;

function ReadFile: List<Integer>;
var 
   number: String;
   ch: Char;
   f:Text;
begin
   result:= new List<Integer>;
   assign(f,'D:\Input.txt');
   reset(f);
   while not(eof(f)) do
   begin
      read(f,ch);
      if (ch in ['0'..'9']) then
      begin
         number += ch;
      end else
      if (number <> '') then
      begin
         result.Add(number.ToInteger);
         number := '';
      end;
   end;
   Writeln(result);
end;

function Cocktail(a: Array of Integer): TimeSpan;
var
   DuplicateArray: Array of Integer;
   StartDateTime: DateTime := DateTime.Now;
   EndDateTime: DateTime;
   Start: Integer := 0;
   Finish: Integer := a.Length - 1;
   I: Integer := a.Length - 2;
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
   ArrayLength:=a.Length;
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
   ArrayLength := a.Length;
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
   var choice: string;
   Writeln('Сформировать новую запись? (0-да/ост.-нет)');
   Readln(choice);
   if (choice = '0') then WriteFile;

   Writeln('Cocktail: ', Cocktail(ReadFile.ToArray));
   Writeln('Insertion: ', Insertion(ReadFile.ToArray));
   Writeln('Selection: ', Selection(ReadFile.ToArray));
end.