# TicTacToe
A fun little TicTacToe game : )

Description:
This is a simple TicTacToe app.

Model:
The TicTacToe model is composed of Piece, Board, Player, and TicTacToeGame
structs. A Piece belongs to certain Player (usually X or O). A Board is a 2D
array of optional Piece instances. The TicTacToeGame has a list of players, a
board, and a few other properties but it's main task is to privide an interface
for placing pieces and checking the game status.

View:
To create the view, I kept things simple. I used an image view for the board,
and a series of buttons (in 3 horzintal and 1 vertical stack views) for the
X,O placements.

Unit Tests:
This project also contains unit tests (found in "TicTacToeTests" folder) which
test all of the functionality of the the TicTacToeGame and Board structs. As well
as tests that test a NxN TicTacToeGame and Board.

Usage:
When you open the app, a new game is started. You then pass the device back an
forth between two players till either someone wins or a draw is reached. In
either case an UIAlert will alert the user of the game ending condition and
asks if they wish to restart the game or not.

(This app will also work on any device size)

<b>Game Play</b>
<img src="https://github.com/Athena96/TicTacToe/blob/master/GamePlay.png" width="300">

<b>Win Scenario</b>
<img src="https://github.com/Athena96/TicTacToe/blob/master/WinScenario.png" width="300">
