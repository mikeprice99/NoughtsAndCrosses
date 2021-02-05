
// define constants for game status
const gsPlay = 0;
const gsDraw = 1;
const gsWin = 2;

class Game {
   constructor(){
      this.Reset();
   }

   OnWinEvent(_game, player){};
   
   OnPaintCellEvent(_game,cell_x,cell_y){}
   
   ClearBoard(){
      this._board = [[0,0,0],[0,0,0],[0,0,0]];
      for (let y = 0; y < 3; y++) {
         for (let x = 0; x < 3; x++) {
            this.OnPaintCellEvent(this,x,y);
         }
      }
   }
   
   Reset(){
      this._player = 1;
      this._status = gsPlay; // gsplay
      //this.drawCounter = 0;
      this.ClearBoard();
   }

   Claim(cell_x, cell_y) {
      if ((this._status == gsPlay) && 
          (cell_x < 3) && 
          (cell_y < 3) && 
          (this._board[cell_x][cell_y] == 0)
          )
      {
         this._board[cell_x][cell_y] = this._player;
         this.OnPaintCellEvent(this, cell_x, cell_y);
         this.CheckWin();
         if (this._status == gsPlay) {
            this._player = this._player==1 ? 2 : 1;
         }
         return true;
      }
      return false;
   }
   
   CheckWin(){
      //check cols
      this.CheckCells(1, 0, 1, 1, 1, 2);
      this.CheckCells(0, 0, 0, 1, 0, 2);
      this.CheckCells(2, 0, 2, 1, 2, 2);
      //check rows
      this.CheckCells(0, 0, 1, 0, 2, 0);
      this.CheckCells(0, 1, 1, 1, 2, 1);
      this.CheckCells(0, 2, 1, 2, 2, 2);
      //check diags
      this.CheckCells(0, 0, 1, 1, 2, 2);
      this.CheckCells(0, 2, 1, 1, 2, 0);
   }  
   
   CheckCells(x0, y0, x1, y1, x2, y2) {
      if (this._status == gsPlay)
      { 
         var cellValue = this._board[x0][y0];
         if ((cellValue > 0)
            && (this._board[x1][y1] == cellValue)
            && (this._board[x2][y2] == cellValue))
         {
            this._status = gsWin;
            this._board[x0][y0] |= 8;
            this._board[x1][y1] |= 8;
            this._board[x2][y2] |= 8;
            this.OnPaintCellEvent(this, x0, y0);
            this.OnPaintCellEvent(this, x1, y1);
            this.OnPaintCellEvent(this, x2, y2);
            this.OnWinEvent(this, this._player);
         }
      }
      // add draw detection
   }

   Owner(cell_x, cell_y) {
      return this._board[cell_x][cell_y] & 3;
   }
   
   Winner(cell_x, cell_y) {
      return this._board[cell_x][cell_y] > 8;
   }
      
}