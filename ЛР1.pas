program N_1;

function Fact(fn: Integer): BigInteger;
begin
   Result := 1;
   for var i := 1 to fn do
      Result *= i;
end;

function Sin(fx, fe: Double): Double;
var
   jk: Double;
   k: Integer = 0;
begin
   fx -= (2 * pi) * Trunc(fx / (2 * pi)); // Сокращение вводимого значения до 2 * pi радиан
   
   if (fx < 0) then 
      fx += (2 * pi); // Преобразование отр. радиана в полож. путём прибавления 2 * pi
   
   repeat
      jk := (Power(-1, k) * Power(fx, 2 * k + 1)) / Fact(2 * k + 1); // Формула расчета jk
      Result += jk;
      Inc(k);
   until (Abs(jk) < fe)
end;

begin
   Writeln(Sin(-30, 1.0E-27));
   Writeln(Sin(-30));
end.