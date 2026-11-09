import 'package:flutter/material.dart';
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

  bool replacementMode = false;

  int currentTriangleIndex = 0;
  int? selectedConePlayer; // track which player tapped the cone

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Stack(
        children: [
          Positioned(
              top: 40,
              left: 30,
              child: Text("▲",
                  style: TextStyle(color: Colors.yellow, fontSize: 20))),
          Positioned(
              top: 120,
              right: 50,
              child: Text("▲",
                  style: TextStyle(color: Colors.blue, fontSize: 24))),
          Positioned(
              bottom: 80,
              left: 100,
              child: Text("▲",
                  style: TextStyle(color: Colors.white, fontSize: 18))),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  buildPlayerPanels(),
                  const SizedBox(height: 20),
                  coneRow(
                    triangleSizes,
                    player1used,
                    player1Color,
                    1,
                  ),
                  const SizedBox(height: 20),
                  buildBoard(),
                  const SizedBox(height: 20),
                  coneRow(
                    triangleSizes,
                    player2used,
                    player2Color,
                    2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlayerPanels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        playerPanel("PLAYER 1", player1Color, player1Score, currentPlayer == 1),
        const CircleAvatar(
          backgroundColor: Colors.yellow,
          child: Text("VS", style: TextStyle(color: Colors.white)),
        ),
        playerPanel("PLAYER 2", player2Color, player2Score, currentPlayer == 2),
      ],
    );
  }

  Widget playerPanel(String title, Color color, int score, bool active) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: active ? Colors.yellow : Colors.yellow.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Icon(Icons.person, color: color, size: 40),
          Text("SCORE: $score", style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget buildBoard() {
    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Container(
          decoration: BoxDecoration(
            color: MainColor.secondaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.yellow, width: 6),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => tapped(index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: (board[index] == null
                        ? const SizedBox()
                        : Text("▲",
                            style: TextStyle(
                              fontSize: board[index],
                              color: boardPlayer[index] == 1
                                  ? player1Color
                                  : player2Color,
                            ))),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void tapped(int index) {
    if (selectedConeSize == null) return;

    setState(() {
      if (!replacementMode) {
        // ---------------- NORMAL MODE ----------------
        if (board[index] == null || selectedConeSize! > board[index]!) {
          placeCone(index);

          // Check winner
          int? winner = checkWinner(boardPlayer);
          if (winner != null) {
            handleWin(winner);
            return; // stop here, don’t flip turn after win
          }

          // Board full → activate replacement mode
          if (!boardPlayer.contains(null)) {
            replacementMode = true;
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Board Full!"),
                content: const Text("Replacement mode activated"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        replacementMode = true;
                      });
                    },
                    child: const Text("OK"),
                  )
                ],
              ),
            );
          } else {
            // Switch turns
            currentPlayer = (currentPlayer == 1) ? 2 : 1;
          }

          // ✅ Only clear AFTER winner/board checks
          selectedConeSize = null;
        }
      } else {
        // ---------------- REPLACEMENT MODE ----------------

        if (boardPlayer[index] != null &&
            boardPlayer[index] != selectedConePlayer &&
            selectedConeSize != null &&
            selectedConeSize! > board[index]!) {
          // Replace opponent’s cone
          board[index] = selectedConeSize;
          boardPlayer[index] = selectedConePlayer;

          // Mark cone as used
          int coneIndex = triangleSizes.indexOf(selectedConeSize!);
          if (selectedConePlayer == 1) {
            player1used[coneIndex] = true;
          } else {
            player2used[coneIndex] = true;
          }

          // ✅ Check winner immediately
          int? winner = checkWinner(boardPlayer);
          if (winner != null) {
            handleWin(winner);
            return; // stop here, don’t flip turn after win
          }

          // Clear selection only after winner check
          selectedConeSize = null;
        } else {}

        // Flip turn for next move
        currentPlayer = (currentPlayer == 1) ? 2 : 1;
      }
    });
  }

  void placeCone(int index) {
    board[index] = selectedConeSize;
    boardPlayer[index] = currentPlayer;
    int coneIndex = triangleSizes.indexOf(selectedConeSize!);
    if (currentPlayer == 1) {
      player1used[coneIndex] = true;
    } else {
      player2used[coneIndex] = true;
    }

    selectedConeSize = null; //deselect cone after placement
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
      replacementMode = false;
    });
  }

  Widget coneRow(
      List<double> sizes, List<bool> usedList, Color color, int player) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sizes.length, (i) {
        return GestureDetector(
          onTap: usedList[i]
              ? null
              : () {
                  setState(() {
                    selectedConeSize = sizes[i];
                    selectedConePlayer = player; //track who tapped
                  });
                },
          child: Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.yellow,
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
    );
  }

  void handleWin(int winner) {
    // update score
    if (winner == 1) {
      player1Score++;
    } else {
      player2Score++;
    }

    // show dialog and reset
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Player $winner Wins!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetBoard(); // reset everything
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
