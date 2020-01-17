import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe/widgets/custom_dialog.dart';
import 'package:tictactoe/widgets/game_button.dart';

import '../widgets/game_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  List<int> player1Cells;
  List<int> player2Cells;
  int activePlayer;

  @override
  void initState() {
    super.initState();
    buttonsList = initGame();
  }

  List<GameButton> initGame() {
    activePlayer = 1;
    player1Cells = List();
    player2Cells = List();
    return List.generate(9, (i) => GameButton(id: i + 1));
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        player1Cells.add(gb.id);
        switchPlayer(activePlayer);
      } else {
        gb.text = "0";
        gb.bg = Colors.black;
        player2Cells.add(gb.id);
        switchPlayer(activePlayer);
      }
      gb.enabled = false;
      var winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((p) => p.text != "")) {
          showDialog(
              context: context,
              builder: (_) => CustomDialog("Game Tied",
                  "Press the reset button to start again.", resetGame));
        } else {
          activePlayer == 2 ? autoPlay() : null;
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = List();
    var list = List.generate(9, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1Cells.contains(cellID) || player2Cells.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    var r = Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellID = emptyCells[randIndex];
    playGame(buttonsList[cellID - 1]);
  }

  void switchPlayer(int player) {
    if (player == 1) {
      activePlayer = 2;
    } else {
      activePlayer = 1;
    }
  }

  int checkWinner() {
    var winner = -1;
    if (player1Cells.contains(1) &&
        player1Cells.contains(2) &&
        player1Cells.contains(3)) {
      winner = 1;
    }
    if (player2Cells.contains(1) &&
        player2Cells.contains(2) &&
        player2Cells.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1Cells.contains(4) &&
        player1Cells.contains(5) &&
        player1Cells.contains(6)) {
      winner = 1;
    }
    if (player2Cells.contains(4) &&
        player2Cells.contains(5) &&
        player2Cells.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1Cells.contains(7) &&
        player1Cells.contains(8) &&
        player1Cells.contains(9)) {
      winner = 1;
    }
    if (player2Cells.contains(7) &&
        player2Cells.contains(8) &&
        player2Cells.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1Cells.contains(1) &&
        player1Cells.contains(4) &&
        player1Cells.contains(7)) {
      winner = 1;
    }
    if (player2Cells.contains(1) &&
        player2Cells.contains(4) &&
        player2Cells.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1Cells.contains(2) &&
        player1Cells.contains(5) &&
        player1Cells.contains(8)) {
      winner = 1;
    }
    if (player2Cells.contains(2) &&
        player2Cells.contains(5) &&
        player2Cells.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1Cells.contains(3) &&
        player1Cells.contains(6) &&
        player1Cells.contains(9)) {
      winner = 1;
    }
    if (player2Cells.contains(3) &&
        player2Cells.contains(6) &&
        player2Cells.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1Cells.contains(1) &&
        player1Cells.contains(5) &&
        player1Cells.contains(9)) {
      winner = 1;
    }
    if (player2Cells.contains(1) &&
        player2Cells.contains(5) &&
        player2Cells.contains(9)) {
      winner = 2;
    }

    if (player1Cells.contains(3) &&
        player1Cells.contains(5) &&
        player1Cells.contains(7)) {
      winner = 1;
    }
    if (player2Cells.contains(3) &&
        player2Cells.contains(5) &&
        player2Cells.contains(7)) {
      winner = 2;
    }

    if (winner == 1) {
      showDialog(
          context: context,
          builder: (_) => CustomDialog("Player 1 Won",
              "Press the reset button to start again.", resetGame));
    } else if (winner == 2) {
      showDialog(
          context: context,
          builder: (_) => CustomDialog("Player 2 Won",
              "Press the reset button to start again.", resetGame));
    }

    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tic Tac Toe"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 9.0),
                itemCount: buttonsList.length,
                itemBuilder: (context, i) => SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: buttonsList[i].enabled
                        ? () => playGame(buttonsList[i])
                        : null,
                    child: Text(
                      buttonsList[i].text,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: buttonsList[i].bg,
                    disabledColor: buttonsList[i].bg,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
