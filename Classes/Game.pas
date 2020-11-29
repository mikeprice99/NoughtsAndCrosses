unit Game;

interface

type
  (*
     board is an array of cells of type byte
       if cell is empty, value = 0
       if cell owned by player 1 (eg X) : value = 1   (bit 1 set)
       if cell owned by player 2 (eg 0) : value = 2   (bit 2 set)

       if cell is part of a winning line: value > 8   (bit 4 set)
  *)

  TByteEvent = procedure(i: byte) of object;
  TCellEvent = procedure(x,y: byte) of object;

  TGameStatus = (gsPlay, gsDraw, gsWin);
  TBoard = array[0..2, 0..2] of byte;

  TGame = class
  private
    fPlayer: byte;
    fBoard: TBoard;
    fStatus: TGameStatus;
    fOnWin: TByteEvent;
    fOnCellClaimed: TCellEvent;
    procedure CheckWin;
    procedure CheckCells(x0, y0, x1, y1, x2, y2: byte);
    procedure ClearBoard;
  public
    constructor Create;

    procedure Reset;

    // when player attempts to claim this cell, typically by clicking on it
    function Claim(x,y: byte):boolean;

    // returns which player owns a cell
    function Owner(x,y: byte):byte;

    // check cell to see if its a winning cell
    function Winner(x, y: byte): boolean;

    // returns current player
    property CurrentPlayer: byte read fPlayer;

    // event fired when player successfully claims a empty cell
    property OnCellClaimed: TCellEvent read fOnCellClaimed write fOnCellClaimed;

    // event fired when a player wins. The winner can be identified as the currentplayer.
    property OnWin: TByteEvent read fOnWin write fOnWin;

  end;

implementation

{ TGame }

constructor TGame.Create;
begin
  Reset;
end;

procedure TGame.ClearBoard;
var x,y : byte;
begin
   for x:= 0 to 2 do
   begin
     for y:= 0 to 2 do fBoard[x,y] := 0;
   end;
end;

procedure TGame.Reset;

begin
   fPlayer := 1;
   fStatus := gsPlay;
   ClearBoard;
end;

function TGame.Claim(x,y: byte):boolean;
begin
  result:= false;
  if (x < 3) and
     (y < 3) and
     (fBoard[x,y] = 0) and
     (fStatus = gsPlay) then // ony do if cell free
  begin
    fBoard[x,y] := fPlayer;
    CheckWin;
    // allow calling app to show new owner of cell
    if assigned(fOnCellClaimed) then fOnCellClaimed(x,y);
    if fStatus = gsPlay then
    begin
       // toggle player
       if fPlayer = 1 then fPlayer := 2 else fPlayer := 1;
    end;
    result:= true;
  end;
end;

procedure TGame.CheckWin;
begin
   //check cols
   CheckCells(0,0, 0,1, 0,2);
   CheckCells(1,0, 1,1, 1,2);
   CheckCells(2,0, 2,1, 2,2);
   //check rows
   CheckCells(0,0, 1,0, 2,0);
   CheckCells(0,1, 1,1, 2,1);
   CheckCells(0,2, 1,2, 2,2);
   //check diags
   CheckCells(0,0, 1,1, 2,2);
   CheckCells(0,2, 1,1, 2,0);
end;

procedure TGame.CheckCells(x0,y0,x1,y1,x2,y2:byte);
var cellValue: byte;
begin
   if fStatus = gsPlay then
   begin
      cellValue := fBoard[x0,y0];
      if (cellValue > 0)
         and (fBoard[x1,y1] = cellValue)
         and (fBoard[x2,y2] = cellValue) then
      begin
         fStatus := gsWin;
         fBoard[x0,y0] := cellValue or 8;
         fBoard[x1,y1] := cellValue or 8;
         fBoard[x2,y2] := cellValue or 8;
         if assigned(OnWin) then OnWin(fPlayer);
      end;
   end;
end;

function TGame.Owner(x,y: byte): byte;
begin
   result:= fBoard[x,y] and 3;
end;

function TGame.Winner(x,y: byte): boolean;
begin
   result:= fBoard[x,y] > 8;
end;

end.
