import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/constants/colors.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GameScreen> {
  List<double?> board = List.filled(9, null); // -1 means empty
  List<int?> boardPlayer = List.filled(9, null); // track which player placed it
  int player1Index = 0;
  int player2Index = 0; // -1 means empty
  int currentPlayer = 1;
  final Color player1Color = Colors.red;
  final Color player2Color = Colors.blue;
  double? selectedConeSize;
  List<bool> player1used = List.filled(6, false);
  List<bool> player2used = List.filled(6, false);

  int currentTriangleIndex = 0;
  final List<String> triangles = ["▲", "▲", "▲", "▲", "▲", "▲"];
  List<double> triangleSizes = [24, 28, 32, 36, 40, 44];
  final List<List<int>> winningCombos = [
    [0, 1, 2], // row 1
    [3, 4, 5], // row 2
    [6, 7, 8], // row 3
    [0, 3, 6], // col 1
    [1, 4, 7], // col 2
    [2, 5, 8], // col 3
    [0, 4, 8], // diag 1
    [2, 4, 6], // diag 2
  ];
  int player1Score = 0;
  int player2Score = 0;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Text(
                    'Player 1',
                    style: customFontWhite,
                  ),
                  Text("$player1Score", style: customFontWhite),
                ]),
                const SizedBox(
                  width: 30,
                ),
                Column(children: [
                  Text(
                    'Player 2',
                    style: customFontWhite,
                  ),
                  Text("$player2Score", style: customFontWhite),
                ]),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 70,
              child: coneRow(triangleSizes, player1used, player1Color, 1),
            ),
            const SizedBox(height: 20),

            AspectRatio(
              aspectRatio: 1, // keeps grid square and centered
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => tapped(index),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 5,
                            color: MainColor.primaryColor,
                          ),
                          color: MainColor.secondaryColor,
                        ),
                        child: Center(
                          child: (board[index] == null
                              ? const SizedBox()
                              : Text(
                                  "▲",
                                  style: TextStyle(
                                    fontSize: board[index],
                                    color: boardPlayer[index] == 1
                                        ? player1Color
                                        : player2Color,
                                  ),
                                )),
                        ),
                      ),
                    );
                  }),
            ),

            const SizedBox(height: 20),

            // player 2 cones(blue) below grid
            SizedBox(
              height: 70,
              child: coneRow(triangleSizes, player2used, player2Color, 2),
            ),
          ]),
        ),
      ),
    );
  }

  void tapped(int index) {
    if (selectedConeSize == null) return; //must choose a cone first

    setState(() {
      if (board[index] == null || selectedConeSize! > board[index]!) {
        board[index] = selectedConeSize;
        boardPlayer[index] = currentPlayer;
        // mark cone as used
        int coneIndex = triangleSizes.indexOf(selectedConeSize!);
        if (currentPlayer == 1) {
          player1used[coneIndex] = true;
        } else {
          player2used[coneIndex] = true;
        }

        //reset selected cone after placing
        selectedConeSize = null;

        // check winner after every move
        int? winner = checkWinner(boardPlayer);
        if (winner != null) {
          if (winner == 1) {
            player1Score++;
          } else {
            player2Score++;
          }

          // show a dialog or reset board
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("Player $winner Wins!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          resetBoard(); //reset everything
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ));
        } else if (!boardPlayer.contains(null)) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text("It's a Tie!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          resetBoard();
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ));
        } else {
          // switch turns if no winner/tie
          currentPlayer = (currentPlayer == 1) ? 2 : 1;
        }
      }
    });
  }

  int? checkWinner(List<int?> boardplayer) {
    for (var combo in winningCombos) {
      int a = combo[0];
      int b = combo[1];
      int c = combo[2];
      if (boardplayer[a] != null &&
          boardPlayer[a] == boardplayer[b] &&
          boardplayer[a] == boardplayer[c]) {
        return boardplayer[a]; // 1=player1 , 2=player2
      }
    }
    return null; // no winner yet
  }

  void resetBoard() {
    setState(() {
      // clear board
      board = List.filled(9, null);
      boardPlayer = List.filled(9, null);
      // reset cone usage
      player1used = List.filled(6, false);
      player2used = List.filled(6, false);
      //reset selection
      selectedConeSize = null;
      //reset turn
      currentPlayer = 1;
      //reset timer
    });
  }

  Widget coneRow(
      List<double> sizes, List<bool> usedList, Color color, int player) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(sizes.length, (i) {
          return GestureDetector(
            onTap: usedList[i]
                ? null
                : () {
                    setState(() {
                      selectedConeSize = sizes[i];
                    });
                  },
            child: Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: color.withValues(alpha: 0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                usedList[i] ? "❌" : "▲",
                style: TextStyle(
                  fontSize: sizes[i],
                  color: color,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
