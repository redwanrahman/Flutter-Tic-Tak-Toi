import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<List<String>> grid;
  late bool player1Turn;
  late bool gameOver;
  late String winner;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    grid = List<List<String>>.generate(3, (_) => List<String>.filled(3, ''));
    player1Turn = true;
    gameOver = false;
    winner = '';
  }

  void makeMove(int row, int col) {
    if (grid[row][col] == '' && !gameOver) {
      setState(() {
        grid[row][col] = player1Turn ? 'X' : 'O';
        checkGameOver();
        player1Turn = !player1Turn;
      });
    }
  }

  void checkGameOver() {
    // Check rows
    for (int row = 0; row < 3; row++) {
      if (grid[row][0] == grid[row][1] &&
          grid[row][1] == grid[row][2] &&
          grid[row][0] != '') {
        setGameOver(grid[row][0]);
        return;
      }
    }

    // Check columns
    for (int col = 0; col < 3; col++) {
      if (grid[0][col] == grid[1][col] &&
          grid[1][col] == grid[2][col] &&
          grid[0][col] != '') {
        setGameOver(grid[0][col]);
        return;
      }
    }

    // Check diagonals
    if ((grid[0][0] == grid[1][1] &&
            grid[1][1] == grid[2][2] &&
            grid[0][0] != '') ||
        (grid[0][2] == grid[1][1] &&
            grid[1][1] == grid[2][0] &&
            grid[0][2] != '')) {
      setGameOver(grid[1][1]);
      return;
    }

    // Check for draw
    bool isDraw = true;
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (grid[row][col] == '') {
          isDraw = false;
          break;
        }
      }
    }
    if (isDraw) {
      setGameOver('');
    }
  }

  // Game over  winner logic

  void setGameOver(String winner) {
    setState(() {
      gameOver = true;
      this.winner = winner;
    });
  }

  // box Desing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final row = index ~/ 3;
                final col = index % 3;
                return GestureDetector(
                  onTap: () {
                    makeMove(row, col);
                  },
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        grid[row][col],
                        style: TextStyle(fontSize: 48.0, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            gameOver
                ? (winner != '' ? 'Winner: $winner' : 'Draw!')
                : 'Next Player: ${player1Turn ? 'X' : 'O'}',
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: gameOver ? initializeGame : null,
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }
}
