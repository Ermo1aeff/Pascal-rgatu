program N_7;

uses GraphABC, System.Threading, Timers;

type 
   SnakeBody = record
      x:integer;
      y:integer;
   end;
   
   Button = record
      x:integer;
      y:integer;
   end;
   
   Direction = (North, East, South, West);
   
var
  // Поле
  RowCount: integer := 30;
  ColCount: integer := 20;
  w: integer := 600;
  h: integer := 800;
  CellSize: integer;
  i: integer;
  FieldWidth, FieldHeigth: integer;
  x1, y1, x2, y2: integer;
  
  SnakeSpeed:=70; // Задержка в миллисекундах
  
  //Верхняя панель
  PanelSize: integer;
  PanelScale:=0.15;
  Score:=0;
  
  //Змейка
  SnakeDirection:Direction:=East;
  Snake:= new List<SnakeBody>;
  SnakePart:= new SnakeBody;
  Head:= new SnakeBody;
  SnakeLength:integer;
  
  //Яблоко
  Apple:= new SnakeBody;
  
  //Крестовина
  ButtonScale:=0.3;
  ButtonsSize:integer;
  UpButton:= new Button;
  LeftButton:= new Button;
  DownButton:= new Button;
  RightButton:= new Button;
  
  GameOver:boolean:=false;
  
  thr_r: Thread;
  thr_r2: Thread;
  
  //Параметры шрифра для исключения ошибок выполнения 
  _FontSize:integer:=1;
  _FontHeight:integer:=1;
  _FontWidth:integer:=TextWidth('GameOver');
  ppi:integer:= 0;
  
  IsDirectionChange:=false;
  
  //Цвета
  SnakeColor:=RGB(70,115,232);
  AppleColor:=RGB(231,71,29);
  BackgroundColor:=RGB(87,138,52);
  FieldFirstColor:=RGB(170,215,81);
  FieldSecondColor:=RGB(162,209,73);
  CrossButtonsColor:=RGB(61,97,35);
  PanelColor:=RGB(74,117,44);
  
procedure SnakeDraw;
begin
   SetBrushColor(SnakeColor);
   foreach var item in Snake do
      FillRectangle(
      x1 + CellSize * item.x,
      y1 + CellSize * item.y, 
      x1 + CellSize * item.x + CellSize, 
      y1 + CellSize * item.y + CellSize);
end;

procedure DrawButton(x, y:integer);
begin
   FillRectangle(x, y, x + ButtonsSize, y + ButtonsSize);  
end;

procedure DrawCross(x, y, w, h: integer); 
begin
//   SetBrushColor(Color.YellowGreen);
   FillRectangle(x, y, x+h, y+w);
   
   SetBrushColor(CrossButtonsColor);
   
   ButtonsSize := Round(PanelSize * ButtonScale);      
   
   DrawButton(x + (w - ButtonsSize) div 2, y);
   UpButton.x:=x + (w - ButtonsSize) div 2;
   UpButton.y:=y;
   
   DrawButton(x, y + (h - ButtonsSize) div 2);
   LeftButton.x:=x;
   LeftButton.y:=y + (h - ButtonsSize) div 2;
   
   DrawButton(x + (w - ButtonsSize) div 2, y+h-ButtonsSize);
   DownButton.x:=x + (w - ButtonsSize) div 2;
   DownButton.y:=y+h-ButtonsSize;
   
   DrawButton(x + w - ButtonsSize, y + (h - ButtonsSize) div 2);
   RightButton.x:=x + w - ButtonsSize;
   RightButton.y:=y + (h - ButtonsSize) div 2;
end;

procedure WindowMouseDown(x,y,mb:integer);
begin
    if ((x > UpButton.x) and (x < UpButton.x + ButtonsSize) 
    and (y > UpButton.y) and (y < UpButton.y + ButtonsSize)) then
        if (SnakeDirection <> South) then SnakeDirection := North; //w /\ 
    
    if ((x > LeftButton.x) and (x < LeftButton.x + ButtonsSize) 
    and (y > LeftButton.y) and (y < LeftButton.y + ButtonsSize)) then
        if (SnakeDirection <> East) then SnakeDirection := West;   //a <
    
    if ((x > DownButton.x) and (x < DownButton.x + ButtonsSize) 
    and (y > DownButton.y) and (y < DownButton.y + ButtonsSize)) then
        if (SnakeDirection <> North) then SnakeDirection := South; //s \/
    
    if ((x > RightButton.x) and (x < RightButton.x + ButtonsSize) 
    and (y > RightButton.y) and (y < RightButton.y + ButtonsSize)) then
        if (SnakeDirection <> West) then SnakeDirection := East;   //d >
end;

procedure Paint;
begin
   while true do
   begin
      try
         ClearWindow(BackgroundColor);
         
         if (w <= h) then  //Вычисление размера верхней панели
            PanelSize := Round(Window.Width * PanelScale) 
         else
            PanelSize := Round(Window.Height * PanelScale);
         
         //Отрисовка поля
         w:=Window.Width;
         h:=Window.Height - PanelSize;
         
         if (w div ColCount <= h div RowCount) then // Определение размера клеток
            CellSize := w div ColCount
         else
            CellSize := h div RowCount;
         
         FieldWidth := CellSize * ColCount;
         FieldHeigth := CellSize * RowCount;
         
         SetBrushColor(PanelColor);
         
         x1:=(w - FieldWidth) div 2; // Вычисление положения в. панели
         y1:=(h - FieldHeigth) div 2;
         x2:=(w + FieldWidth) div 2;
         y2:=(h - FieldHeigth) div 2 + PanelSize-1;
         
         FillRectangle(x1, y1, x2, y2); //Отрисовка в. панели
         
         // Отрисовка содержимого панели
         SetBrushColor(RGB(231,71,29)); 
         FillRectangle(x1 + CellSize*2, y1 + (PanelSize - CellSize) div 2, x1 + CellSize, y1 + (PanelSize - CellSize) div 2 + CellSize); //Яблоко 
         
         while (_FontHeight < CellSize) do // Изменяет размер шрифта. Вызывает ошибку
         begin
            Font.Size += 1;
            _FontSize += 1;
            _FontHeight:=_FontSize * ppi div 72;
         end;
        
         while (_FontHeight > CellSize) do
         begin
            Font.Size -= 1; 
            _FontSize -= 1;
            _FontHeight := _FontSize * ppi div 72;
         end;
         
         SetBrushColor(Color.Transparent);
         TextOut(Round(x1 + CellSize*2.5), y1 + (PanelSize - _FontHeight) div 2, $'X {Score.ToString}');
         
         DrawCross((x2 - PanelSize), y1, PanelSize, PanelSize);
      
         SetBrushColor(FieldFirstColor);
         
         y1:=(h - FieldHeigth) div 2 + PanelSize;
         y2:=(h + FieldHeigth) div 2 + PanelSize;
         FillRectangle(x1, y1, x2, y2); // Отрисока поля
         
         SetBrushColor(FieldSecondColor);
         
         for var j:=0 to RowCount-1 do
         begin
            if (j mod 2 = 0) then i:=0 else i:=1;  
            while (i <= ColCount - 1) do
            begin
               FillRectangle(x1 + CellSize * i, y1 + CellSize * j, x1 + CellSize * i + CellSize, y1 + CellSize * j + CellSize);
               i+=2;
            end;
         end;  
         
         SetBrushColor(AppleColor);
         FillRectangle(x1 + CellSize * Apple.x, y1 + CellSize * Apple.y, x1 + CellSize * Apple.x + CellSize, y1 + CellSize * Apple.y + CellSize); // Отрисовка яблока
         SnakeDraw;
         
         if GameOver then
         begin
            while (_FontHeight < (x2 - x1) div 10) do // Изменяет размер шрифта. Вызывает ошибку
            begin
               Font.Size += 1; 
               _FontSize += 1;
               _FontHeight:=_FontSize * ppi div 72;
            end;
        
            while (_FontHeight > (x2 - x1) div 10) do
            begin
               Font.Size -= 1; 
               _FontSize -= 1;
               _FontHeight:=_FontSize * ppi div 72;
            end;
            
            SetBrushColor(Color.Transparent);
            TextOut((x2 + x1- TextWidth('Game Over')) div 2, (y2 + y1 - _FontHeight) div 2, $'Game Over');  
         end;
         Redraw;
      except
      end;
   end;
end;

procedure SnakeChangeDerection(key:integer);
begin
   if not(IsDirectionChange) then
   begin
   case key of
         87, 38: if (SnakeDirection <> South) then SnakeDirection := North; //w /\  // Здесь надо заменить ASCII код на константы
         65, 37: if (SnakeDirection <> East) then SnakeDirection := West;   //a <
         83, 40: if (SnakeDirection <> North) then SnakeDirection := South; //s \/
         68, 39: if (SnakeDirection <> West) then SnakeDirection := East;   //d >
   end;
   IsDirectionChange:=true;
   end;
end;

procedure RandomApple;
begin
   repeat
      Apple.x:=random(ColCount);
      Apple.y:=random(RowCount);
   until not(Apple in Snake)
end;

procedure TimerProc;
begin
   while true do
   begin
      case SnakeDirection of
         North: Head.y := Head.y - 1;
         West: Head.x := Head.x - 1;
         South: Head.y := Head.y + 1;
         East: Head.x := Head.x + 1;
      end;
      
      IsDirectionChange:=false;
      
      // Перемещение змейки в противоположную сторону
      if (Head.x < 0) then Head.x:=ColCount-1; 
      if (Head.x > ColCount-1) then Head.x:=0;
      if (Head.y < 0) then Head.y:=RowCount-1;
      if (Head.y > RowCount-1) then Head.y:=0;
       
//      if (Head.x < 0) or (Head.x > ColCount-1)
//      or (Head.y < 0) or (Head.y > RowCount-1) then 
//      begin
//         GameOver:=true;
//         thr_r2.Join;
//      end;
      
      if (Head <> Snake[0]) then
         if (Head in Snake) then 
         begin
            GameOver:=true;
            thr_r2.Join;
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
   
      Sleep(SnakeSpeed);
   end;
end;
  
begin
   Window.Left:=(ScreenWidth - w) div 2;
   Window.Top:= (ScreenHeight - h) div 2;
   Window.SetSize(w, h);
   LockDrawing;
   OnKeyDown:=SnakeChangeDerection;
   OnMouseDown:=WindowMouseDown;
   
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
   
   Font.Size:=12;
   _FontSize:=Font.Size;
   ppi:=72*TextHeight('T') div Font.Size;
   
   thr_r2:= new Thread(TimerProc);
   thr_r2.Start;

   Paint;
  
end.
  