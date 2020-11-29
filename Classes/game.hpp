
enum GameStatus { gsPlay = 0,
                  gsDraw = 1,
                  gsWin = 2 };

struct Cell {
    uint8_t x;
    uint8_t y;
};

class Game {
   private:
    uint8_t _player;
    uint8_t board[3][3];

    void CheckCells(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2) {
        if (status == gsPlay) {
            uint8_t cellValue = board[x0][y0];
            if ((cellValue > 0) && (board[x1][y1] == cellValue) && (board[x2][y2] == cellValue)) {
                status = gsWin;
                board[x0][y0] |= 8;
                board[x1][y1] |= 8;
                board[x2][y2] |= 8;
            }
        }
        // check for draw
        if (status == gsPlay) {
            if ((board[x0][y0] | board[x1][y1] | board[x2][y2]) == 3) {
                drawCounter += 1;
                if (drawCounter == 8) status = gsDraw;
            }
        }
    }

    void CheckWin() {
        drawCounter = 0;
        //check cols
        CheckCells(0, 0, 0, 1, 0, 2);
        CheckCells(1, 0, 1, 1, 1, 2);
        CheckCells(2, 0, 2, 1, 2, 2);
        //check rows
        CheckCells(0, 0, 1, 0, 2, 0);
        CheckCells(0, 1, 1, 1, 2, 1);
        CheckCells(0, 2, 1, 2, 2, 2);
        //check diags
        CheckCells(0, 0, 1, 1, 2, 2);
        CheckCells(0, 2, 1, 1, 2, 0);
    }

    void ClearBoard() {
        for (uint8_t x = 0; x <= 2; x++) {
            for (uint8_t y = 0; y <= 2; y++) {
                board[x][y] = 0;
            }
        }
    }

   public:
    GameStatus status = gsPlay;
    uint8_t drawCounter;

    Game() {
        Reset();
    }

    void Reset() {
        _player = 1;
        status = gsPlay;
        ClearBoard();
    }

    bool Claim(Cell cell) {
        if ((status == gsPlay) &&
            (cell.x < 3) &&
            (cell.y < 3) &&
            (board[cell.x][cell.y] == 0)) {
            board[cell.x][cell.y] = _player;
            CheckWin();
            if (status == gsPlay) {  // toggle player
                _player = _player == 1 ? 2 : 1;
            }
            return true;
        }
        return false;
    }

    uint8_t Player() {
        return _player;
    }

    uint8_t Owner(Cell cell) {
        return board[cell.x][cell.y] & 3;  // mask out bits above 2
    }

    bool Winner(Cell cell) {
        return board[cell.x][cell.y] > 8;  // ie owned and bit 4 set
    }
};
