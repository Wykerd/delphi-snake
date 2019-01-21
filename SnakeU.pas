unit SnakeU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TForm1 = class(TForm)
    drawTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Clearbm;
    procedure drawTimerTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  PDW = ^DWORD;


var
  Form1: TForm1;
  map : TBitmap;
  tailx : array[0..1024] of integer;
  taily : array[0..1024] of integer;
  headx : integer = 32;
  heady : integer = 32;
  pillx : integer = 16;
  pilly : integer = 16;
  pbase, p : PDW;
  dirx : integer = 1;
  diry : integer = 0;
  length : integer = 0;
  oppositekey : char = 'A';

const
  headcolor = $0;

implementation

{$R *.dfm}

procedure TForm1.Clearbm;
begin
  map.Free;
  map := nil;
  map := TBitmap.Create;
  with map do
  begin
    PixelFormat := pf32bit;
    height := 33;
    width := 33
  end;
end;

procedure TForm1.drawTimerTimer(Sender: TObject);
var
  i : integer;
begin
  clearbm;
  headx := headx + dirx;
  heady := heady + diry;
  if headx = 33 then
    headx := 0;
  if headx < 0 then
    headx := 32;
  if heady = 33 then
    heady := 0;
  if heady < 0 then
    heady := 32;

  if (headx = pillx) AND (heady = pilly) then
  begin
    length := length + 1;
    if length <> 0 then
    begin
      for i := length downto 0 do
      begin
        tailx[i + 1] := tailx[i];
        taily[i + 1] := taily[i];
      end;
      tailx[0] := pillx;
      taily[0] := pilly;
      pillx := random(33);
      pilly := random(33);
    end;
  end
  else
  begin
    for i := length downto 1 do
    begin
      tailx[i] := tailx[i - 1];
      taily[i] := taily[i - 1];
    end;
    tailx[0] := headx;
    taily[0] := heady;

    for I := 1 to length do
    begin
      if (headx = tailx[i]) AND (heady = taily[i]) then
        length := 0;
    end;
  end;

  for i := 0 to length do
  begin
    pbase := map.ScanLine[taily[i]];
    p := PDW(DWORD(pbase) + (tailx[i] shl 2));
     p^ := $ff0000;
  end;

  //head
  pbase := map.ScanLine[heady];
  p := PDW(DWORD(pbase) + (headx shl 2));
  p^ := headcolor;
  //pill
  pbase := map.ScanLine[pilly];
  p := PDW(DWORD(pbase) + (pillx shl 2));
  p^ := $ff00ff;

  canvas.StretchDraw(rect(0,0,clientwidth, clientheight), map);
end;

procedure TForm1.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  newheight := newwidth
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  map := TBitmap.Create;
  with map do
  begin
    PixelFormat := pf32bit;
    height := 33;
    width := 33
  end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if oppositeKey <> upcase(key) then

  case upcase(key) of
    'W' :
    begin
      dirx := 0;
      diry := -1;
      oppositeKey := 'S';
    end;
    'A':
    begin
      dirx := -1;
      diry := 0;
      oppositeKey := 'D';
    end;
    'S':
    begin
      dirx := 0;
      diry := 1;
      oppositeKey := 'W';
    end;
    'D' :
    begin
      dirx := 1;
      diry := 0;
      oppositeKey := 'A';
    end;
  end;
end;

end.
