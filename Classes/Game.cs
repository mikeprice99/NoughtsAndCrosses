using System.Drawing;  // only needed for Point class

namespace NoughtsAndCrossesApp
{
	enum Status : byte { gsPlay, gsDraw, gsWin };

	public class Game
	{
		private Status status; 
		
		private byte player;
		readonly byte[,] board = new byte[3, 3]; // x, y coords

		public delegate void OnWin(byte _player);
		public event OnWin OnWinEvent;

		public delegate void OnCellClaimed(Point cell);
		public event OnCellClaimed OnCellClaimedEvent;

		public delegate void OnDecorateCell(Point cell);
		public event OnDecorateCell OnDecorateCellEvent;

		public Game()
		{
			Reset();
		}

		private void ClearBoard()
        {
			for (byte x = 0; x <= 2; x++)
			{
				for (byte y = 0; y <= 2; y++)
				{
					board[x, y] = 0;
				}
			}
		}

		public void Reset()
		{
			player = 1;
			status = Status.gsPlay;
			ClearBoard();
		}

		public bool Claim(Point cell)
		{
			bool outcome = false;
			if ((status == Status.gsPlay) &&
				(cell.X < 3) &&
				(cell.Y < 3) &&
				(board[cell.X, cell.Y] == 0) )
			{
				board[cell.X, cell.Y] = player;
				OnCellClaimedEvent?.Invoke(cell);
				CheckWin();
				if (status == Status.gsPlay)
				{
					player = (byte) (player.Equals(1) ? 2 : 1);
				}
				outcome = true;
			}
			return outcome;
		}

		private void CheckWin()
		{
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

		private void CheckCells(byte x0, byte y0, byte x1, byte y1, byte x2, byte y2)
		{
			if (status == Status.gsPlay)
			{ 
				byte cellValue = board[x0, y0];
				if ((cellValue > 0)
				&& (board[x1, y1] == cellValue)
				&& (board[x2, y2] == cellValue))
				{
					status = Status.gsWin;
					board[x0, y0] |= 8;
					board[x1, y1] |= 8;
					board[x2, y2] |= 8;
					OnDecorateCellEvent?.Invoke(new Point(x0, y0));
					OnDecorateCellEvent?.Invoke(new Point(x1, y1));
					OnDecorateCellEvent?.Invoke(new Point(x2, y2));
					OnWinEvent?.Invoke(player);
				}
			}
		}

		public byte Owner(Point cell)
		{
			return (byte)(board[cell.X, cell.Y] & 3);
		}

		public bool Winner(Point cell)
		{
			return board[cell.X, cell.Y] > 8;
		}
	}
}