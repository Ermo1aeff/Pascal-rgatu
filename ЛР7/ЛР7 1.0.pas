program N_7;

uses GraphABC, ABCObjects, System.Threading, Timers;

type 
   SnakeBody = record
     x:integer;
     y:integer;
   end;
   
   Direction = (North, East, South, West);

var
  // Поле
  RowCount: integer := 20;
  ColCount: integer := 10;
  w: integer := 900;
  h: integer := 600;
  CellSize: integer;
  i: integer;
  FieldWidth, FieldHeigth: integer;
  x1, y1, x2, y2: integer;
  
  //Верхняя панель
  Panel: integer;
  PanelSize: real:=0.12;
  Score:=0;
  
  //Змейка
  SnakeDirection:Direction:=East;
  Snake:= new List<SnakeBody>;
  SnakePart:= new SnakeBody;
  Head:= new SnakeBody;
  SnakeLength:integer;
  
  //Яблоко
  Apple:= new SnakeBody;
  
  GameOver:boolean:=false;
  
  t :timer;
  
//  gr:Graphics;
  
  txt:= new TextABC(0, 0, 10, '0');
  
procedure SnakeDraw(cl:color);
begin
   SetBrushColor(cl);
   foreach var item in Snake do
      FillRectangle(
      x1 + CellSize * item.x,
      y1 + CellSize * item.y, 
      x1 + CellSize * item.x + CellSize, 
      y1 + CellSize * item.y + CellSize);
end;

procedure Paint;
begin
   LockDrawing;
   ClearWindow(RGB(87,138,52));
   
   
   if (w <= h) then  //Вычисление размера верхней панели
      Panel := Round(Window.Width * PanelSize) 
   else
      Panel := Round(Window.Height * PanelSize);
   
   //Отрисовка поля
   w:=Window.Width;
   h:=Window.Height - Panel;
   
   if (w div ColCount <= h div RowCount) then // Определение размера клеток
      CellSize := w div ColCount
   else
      CellSize := h div RowCount;
   
   FieldWidth := CellSize * ColCount;
   FieldHeigth := CellSize * RowCount;
   
   SetBrushColor(RGB(74,117,44));
   
   x1:=(w - FieldWidth) div 2; // Вычисление положения в. панели
   y1:=(h - FieldHeigth) div 2;
   x2:=(w + FieldWidth) div 2;
   y2:=(h - FieldHeigth) div 2 + Panel-1;
   
   FillRectangle(x1, y1, x2, y2); //Отрисовка в. панели
   
   // Отрисовка содержимого панели
   SetBrushColor(RGB(231,71,29)); 
   FillRectangle(x1 + CellSize*2, y1 + (Panel - CellSize) div 2, x1 + CellSize, y1 + (Panel - CellSize) div 2 + CellSize); //Яблоко 
   
//   var txth:= TextHeight(Score.ToString); // Вызывает ошибку
//
//   if (TextHeight(Score.ToString) > CellSize) then
//   begin
//      while (TextHeight(Score.ToString) > CellSize) do
//         Font.Size -= 1;
//   end else
//   begin
//      while (TextHeight(Score.ToString) < CellSize) do
//         Font.Size += 1;  
//   end;
   
   SetBrushColor(Color.Transparent);
   TextOut(Round(x1 + CellSize*2.5), y1 + (Panel - CellSize) div 2, $'X {Score.ToString}');
   
   SetBrushColor(RGB(170,215,81));
   
   y1:=(h - FieldHeigth) div 2 + Panel;
   y2:=(h + FieldHeigth) div 2 + Panel;
   FillRectangle(x1, y1, x2, y2); // Отрисока поля
   
   SetBrushColor(RGB(162,209,73));
   
   for var j:=0 to RowCount-1 do
   begin
      if (j mod 2 = 0) then i:=0 else i:=1;  
      while (i <= ColCount - 1) do
      begin
         FillRectangle(x1 + CellSize * i, y1 + CellSize * j, x1 + CellSize * i + CellSize, y1 + CellSize * j + CellSize);
         i+=2;
      end;
   end;  
   
   SetBrushColor(RGB(231,71,29));
   FillRectangle(x1 + CellSize * Apple.x, y1 + CellSize * Apple.y, x1 + CellSize * Apple.x + CellSize, y1 + CellSize * Apple.y + CellSize); // Отрисовка яблока
   SnakeDraw(RGB(70,115,232));
   Redraw;
end;

procedure SnakeChangeDerection(key:integer);
begin
   case key of
      87, 38: if (SnakeDirection <> South) then SnakeDirection := North; //w /\  
      65, 37: if (SnakeDirection <> East) then SnakeDirection := West;   //a <
      83, 40: if (SnakeDirection <> North) then SnakeDirection := South; //s \/
      68, 39: if (SnakeDirection <> West) then SnakeDirection := East;   //d >
   end;
end;

procedure RandomApple;
begin
   Apple.x:=random(ColCount);
   Apple.y:=random(RowCount);     
end;

procedure TimerProc();
begin
  
   case SnakeDirection of
      North: Head.y := Head.y - 1;
      West: Head.x := Head.x - 1;
      South: Head.y := Head.y + 1;
      East: Head.x := Head.x + 1;
   end;
   
   if (Head.x < 0) then Head.x:=ColCount-1;
   if (Head.x > ColCount-1) then Head.x:=0;
   if (Head.y < 0) then Head.y:=RowCount-1;
   if (Head.y > RowCount-1) then Head.y:=0;
   
   if (Head in Snake) then 
   begin
     t.Stop;
   end;

   if (Head = Apple) then
   begin
      Inc(Score);
      RandomApple;
      Inc(SnakeLength);
      Snake.Add(Head);
   end else
   begin
   for var i:=0 to SnakeLength-2 do
      Snake[i]:=Snake[i+1];  
   Snake[SnakeLength-1]:=Head;
   end;

   Paint;
end;
  
begin
   Window.SetSize(w, h);
   OnKeyDown:=SnakeChangeDerection;
   
   SnakePart.x:= ColCount div 2 - 7;
   SnakePart.y:= RowCount div 2;
   Snake.Add(SnakePart);
   
   SnakePart.x:= ColCount div 2  - 6;
   SnakePart.y:= RowCount div 2;
   Snake.Add(SnakePart);
   
   SnakePart.x:= ColCount div 2  - 5;
   SnakePart.y:= RowCount div 2;
   Snake.Add(SnakePart);
   
   SnakeLength:=Snake.Count;
   Head:=SnakePart;
   
   RandomApple;
   Paint;
   
   t := new Timer(80, TimerProc);
   
   t.Start;
   
end.
  