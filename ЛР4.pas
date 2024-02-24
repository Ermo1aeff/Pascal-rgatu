program N_4;

var
   ArrayLength: Integer;
   RealsArray: Array of Real;
   OperationsList:= new List<String>;

procedure ArrayFilling();
var 
   Operation: String;
begin
   while true do
   begin
      Write('Операция: ');
      Readln(Operation);
      if (UpperCase(Operation) = 'Q') then Exit;
      OperationsList.Add(Operation);
   end;   
end;

procedure ArrayProcessing();
begin
   foreach var item in OperationsList do
   begin
      case item[1] of
         '-' : RealsArray.ForEach((x, i) -> RealsArray.SetValue(x - StrToReal(copy(item, 2, Length(item))), i));
         '+' : RealsArray.ForEach((x, i) -> RealsArray.SetValue(x + StrToReal(copy(item, 2, Length(item))), i));
         '*' : RealsArray.ForEach((x, i) -> RealsArray.SetValue(x * StrToReal(copy(item, 2, Length(item))), i));
         '/' : RealsArray.ForEach((x, i) -> RealsArray.SetValue(x / StrToReal(copy(item, 2, Length(item))), i));
         '^' : RealsArray.ForEach((x, i) -> RealsArray.SetValue(Power(x, StrToReal(copy(item, 2, Length(item)))), i));
         '%' : RealsArray.ForEach((x, i) -> RealsArray.SetValue(x / 100 * StrToReal(copy(item, 2, Length(item))), i));
//         '*' : RealsArray := RealsArray.Select(x -> x * StrToReal(copy(item, 2, Length(item)))).ToArray; 
      end;
   end;
end;

begin

   repeat
      Write('Укажите размер массива от 1 до 10: ');
      Read(ArrayLength);
      
      if not(ArrayLength in [1..10]) then
         Writeln('Указан не верный размер массива!');
         
   until (ArrayLength in [1..10]); 

   RealsArray := new Real[ArrayLength];
   Write('Выберите вариант заполнения массива (0-ручной/оснальное - случайные числа): ');
   
   var r: integer;
   Readln(r);
   
   if (r = 0) then
   begin
      Writeln('Режим ручного заполнения массива:');
      var i: Integer := 0;
      repeat
         Write(i, ': ');
         try
            begin
               var p: string;
               Readln(RealsArray[i]);
               Inc(i);
            end
         except
            begin
               Writeln('Ошибка ввода');
            end;
         end;
      until (i > ArrayLength - 1)
//      for var i := 0 to ArrayLength - 1 do
//      begin
//         Write(i, ': ');
//         Readln(RealsArray[i]);
//      end;
   end else
   begin
      Randomize;
      RealsArray := RealsArray.Select(x -> Random(10) + Random()).ToArray;
   end;
         
   Writeln(RealsArray);
   ArrayFilling();
   ArrayProcessing();
   Writeln(OperationsList);  
   Writeln(RealsArray);
end.