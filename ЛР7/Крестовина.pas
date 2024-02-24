
{$ reference Tao.FreeGlut.dll}
{$ reference Tao.OpenGl.dll}
{$ reference System.Drawing.dll}

uses GraphABC, System, System.Threading, System.Reflection;

type    
    Button = record
        x:integer;
        y:integer;
    end;
    
    PressedButton = (Up, Left, Down, Right);

var
   ButtonsSize := 50;
   UpButton:= new Button;
   LeftButton:= new Button;
   DownButton:= new Button;
   RightButton:= new Button;
   
   PressedButton1:PressedButton;
   
   time:DateTime;
   Frames:integer;
   
procedure DrowButton(x, y:integer);
begin
   FillRectangle(x, y, x + ButtonsSize, y + ButtonsSize);  
end;

procedure DrawCross(x, y, w, h: integer);
begin
   SetBrushColor(Color.YellowGreen);
   FillRectangle(x, y, x+h, y+w);
   
   SetBrushColor(Color.Blue);
   
   DrowButton(x + (w - ButtonsSize) div 2, y);
   UpButton.x:=x + (w - ButtonsSize) div 2;
   UpButton.y:=y;
   
   DrowButton(x, y + (h - ButtonsSize) div 2);
   LeftButton.x:=x;
   LeftButton.y:=y + (h - ButtonsSize) div 2;
   
   DrowButton(x + (w - ButtonsSize) div 2, y+h-ButtonsSize);
   DownButton.x:=x + (w - ButtonsSize) div 2;
   DownButton.y:=y+h-ButtonsSize;
   
   DrowButton(x + w - ButtonsSize, y + (h - ButtonsSize) div 2);
   RightButton.x:=x + w - ButtonsSize;
   RightButton.y:=y + (h - ButtonsSize) div 2;
end;

procedure WindowMouseDown(x,y,mb:integer);
begin
    if ((x > UpButton.x) and (x < UpButton.x + ButtonsSize) 
    and (y > UpButton.y) and (y < UpButton.y + ButtonsSize)) then
        PressedButton1:=Up;
    
    if ((x > LeftButton.x) and (x < LeftButton.x + ButtonsSize) 
    and (y > LeftButton.y) and (y < LeftButton.y + ButtonsSize)) then
      PressedButton1:=Left;
    
    if ((x > DownButton.x) and (x < DownButton.x + ButtonsSize) 
    and (y > DownButton.y) and (y < DownButton.y + ButtonsSize)) then
        PressedButton1:=Down;
    
    if ((x > RightButton.x) and (x < RightButton.x + ButtonsSize) 
    and (y > RightButton.y) and (y < RightButton.y + ButtonsSize)) then
        PressedButton1:=Right;
end;

procedure Paint;
begin
  time:= DateTime.Now;
  while true do
  begin
   Frames+=1; 
    try
      ClearWindow; 
      ButtonsSize:=(Window.Width div 2) div 4;
      DrawCross((Window.Width - Window.Width div 2) div 2, (Window.Height - Window.Width div 2) div 2, Window.Width div 2, Window.Width div 2);
      SetBrushColor(Color.Transparent);
      TextOut(0,0,(PressedButton1).ToString);
      Redraw;
      except
      
      end;
//      if (Frames > 60) then
//         Sleep(1);
   end;  
end;

begin
  OnMouseDown:=WindowMouseDown;
  var t:= new Thread(Paint);
  LockDrawing;
  t.Start;
  
  while true do
  begin
   var ct:TimeSpan:= DateTime.Now - time;
   if (ct.Seconds >= 1) then
   begin
      SetWindowTitle($'Крестовина {Frames} fps');
      Frames:=0;
      time:= DateTime.Now;  
   end; 
  end;
end.
