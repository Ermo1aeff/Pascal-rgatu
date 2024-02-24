program N_6;

uses 
   GraphABC,  ABCObjects,
   ABCButtons;

var
   button1: ButtonABC;
   text1: RectangleABC; 
   button2: RoundRectABC;
   picture1: PictureABC;
   isButtonPressed:=false;

procedure button1_Click;
begin
   text1.Text := 'Путь к ООП';
   text1.FontColor := clBlue;
   text1.Color := clRed;       
end;

function IsButtonDown(x, y, mb: integer): boolean;
begin
   result:= (x >= button2.Bounds.Left) and (x <= button2.Bounds.Right)
   and (y >= button2.Bounds.Top) and (y <= button2.Bounds.Bottom) and (mb = 1)
end;

procedure ButtonPress; begin button2.MoveOn(1, 1); end;

procedure ButtonUnPress; begin button2.MoveOn(-1, -1); end;

procedure ChangeColor;
begin
   text1.Text := 'Рисуй кнопки дальше';
   text1.FontColor := clRed;
   text1.Color := clBlue;   
end;

procedure ButtonUp(x, y, bm: Integer);
begin
   if isButtonPressed then
      begin
         if IsButtonDown(x, y, bm) then ChangeColor; 
         ButtonUnPress;
      end;
   isButtonPressed:=false;
end;

procedure Window_Resize;

var
   WindowHeight := Window.Height;
   WindowWidth := Window.Width;

begin
   text1.MoveTo(Window.Width div 2 - text1.Width div 2, Round(Window.Height * 0.4));
   
   button1.MoveTo(WindowWidth div 4 - button1.Width div 2, WindowHeight - button1.Height - Round(WindowHeight * 0.1));
   button2.MoveTo(WindowWidth div 4 * 3 - button2.Width div 2, WindowHeight - button2.Height - Round(WindowHeight * 0.1));
   
   picture1.Width := WindowWidth;
   picture1.Height := WindowHeight;
end;

procedure Window_MouseMove(x, y, bm:integer);
begin
   OnMouseUp += ButtonUp; 
end;

begin
   picture1 := new PictureABC(0, 0, 'Morpheus.png');
   
   Window.Caption := 'Кнопочки';
   OnResize += Window_Resize;
   OnMouseDown += (x, y, mb) -> if IsButtonDown(x, y, mb) then begin ButtonPress; isButtonPressed:=true end;
   OnMouseMove += Window_MouseMove;
   OnMouseUp:= (x,y,bm) -> begin end; // Лютый костыль
//   OnMouseUp += (x, y, bm) -> if IsButtonDown(x, y, bm) and isButtonPressed then ChangeColor else begin ButtonUnPress; isButtonPressed:=false; end;
   
   button1 := new ButtonABC(0, 0, 200, 100, 'ABCButton', clRed);
   button1.OnClick += button1_Click;
   button2 := new RoundRectABC(0, 0, 200, 100, 5, clBlue);
   button2.Text := 'Custom Button';
   
   text1 := new RectangleABC(0, 0, 300, 40, clTransparent);
   text1.BorderColor := clTransparent;
   text1.FontColor := clWhite;
   text1.Text := 'Выбирай';
   
   Window_Resize;
end.