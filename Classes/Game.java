import java.awt.Point;

enum GameStatus {
  GSPLAY,
  GSDRAW,
  GSWIN
}

public class Game {
	private byte player;
	private GameStatus status; 
	byte[][] board = {{0,0,0},{0,0,0},{0,0,0}};
	
	public Game() {
		Reset();
	}
	
	public void Reset() {
		player = 1;
		status = GameStatus.GSPLAY;
		ClearBoard();
	}	
	
	private void ClearBoard() 
	{	
		for (byte x = 0; x <= 2; x++)
		{
			for (byte y = 0; y <= 2; y++)
			{
				board[x][y] = 0;
			}
		}
	}
	
	public boolean Claim(Point cell)
	{
		byte player1 = 1;
		byte player2 = 2;
		if ((status == GameStatus.GSPLAY) &&
			(cell.x < 3) &&
			(cell.y < 3) &&
			(board[cell.x][cell.y] == 0) )
		{
			board[cell.x][cell.y] = player;
			CheckWin();
			if (status == GameStatus.GSPLAY)
			{
				player = player == player1 ? player2 : player1;
			}
			return true;
		}
		return false;
	}
	
	private void CheckCells(byte x0, byte y0, byte x1, byte y1, byte x2, byte y2)
	{
		if (status == GameStatus.GSPLAY)
		{ 
			byte cellValue = board[x0][y0];
			if ((cellValue > 0)
			&& (board[x1][y1] == cellValue)
			&& (board[x2][y2] == cellValue))
			{
				status = GameStatus.GSWIN;
				board[x0][y0] |= 8;
				board[x1][y1] |= 8;
				board[x2][y2] |= 8;
			}
		}
	}
	
	private void CheckWin()
	{  
		byte b0 = 0;
		byte b1 = 1;
		byte b2 = 2;
		//check cols
		CheckCells(b0, b0, b0, b1, b0, b2);
		CheckCells(b1, b0, b1, b1, b1, b2);
		CheckCells(b2, b0, b2, b1, b2, b2);
		//check rows
		CheckCells(b0, b0, b1, b0, b2, b0);
		CheckCells(b0, b1, b1, b1, b2, b1);
		CheckCells(b0, b2, b1, b2, b2, b2);
		//check diags
		CheckCells(b0, b0, b1, b1, b2, b2);
		CheckCells(b0, b2, b1, b1, b2, b0);
	}
	
	public byte Owner(Point cell)
	{
		return (byte)(board[cell.x][cell.x] & 3);
	}

	public boolean Winner(Point cell)
	{
		return board[cell.x][cell.x] > 8;
	}

}
