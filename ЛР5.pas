program N_5;

type
   MPointer = ^Member;
   Member = record
      Data: String;
      Next: MPointer;
      Previous: MPointer;
   end;

var
   c, n, p: MPointer;
   Count: Integer;

function WriteName(): Integer;

var
   Input: String;

begin
   Writeln('Введите список имён');
   Readln(Input);
   try
      result := StrToInt(Input);
      Exit;
   except
      New(n); // Выделение памяти под первый элемент
      c := n; // Сохранение адреса первого элемента.
      p := n; // Сохранение адреса последнего элемента.
      n^.Data := Input; // Передача имени в первый эл.
      Readln(Input);
      while true do
      begin
         var err:integer;
         Val(Input, result, err);
         if (err = 0) then
         begin
           Writeln(Input);
           n^.Next := c;
           c^.Previous := n;
           Exit;
         end
         else
         begin
            New(n^.Next); // Выделение памяти для следующего эл.
            n := n^.Next; // Установка указателя на след. эл.
            n^.Data := Input;
            n^.Previous := p; // Сохранение адреса предыдущего эл.
            p := n;
            Readln(Input); 
         end;
      end;  
   end;
end;

begin
   repeat
      Count := WriteName;
   until c <> nil;
   
   while not(c^.Next = c) do
   begin
      n:=c;
      for var i := 0 to Count-1 do
         n := n^.Next;  
      
      n^.Previous^.Next := n^.Next;
      n^.Next^.Previous := n^.Previous;
      c := n^.Next;
      Dispose(n);
   end;
   writeln(c^.Data+' водит считалочку.');
end.

