// ignore: duplicate_ignore
// ignore: file_names

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/colors.dart';

class GameScreen4x4 extends StatefulWidget {
  const GameScreen4x4({super.key});

  @override
  State<GameScreen4x4> createState() => _GameScreen4x4State();
}

class _GameScreen4x4State extends State<GameScreen4x4> {
  late List<double?> board;
  late List<int?> boardPlayer;
  late List<List<int>> winningCombos;

  int currentPlayer = 1;
  double? selectedConeSize;
  int? selectedConePlayer;
  bool replacementMode = false;

  final Color player1Color = Colors.red;
  final Color player2Color = Colors.blue;

  List<double> triangleSizes = [24, 28, 32, 36, 40, 44];
  int player1Score = 0;
  int player2Score = 0;

  // Usage limits: smallest 6, then 5, then 4, etc.
  late List<int> coneLimits;
  late List<int> player1used;
  late List<int> player2used;

  @override
  void initState() {
    super.initState();
    board = List.filled(16, null);
    boardPlayer = List.filled(16, null);
    winningCombos = generateWinningCombos(4);

    coneLimits = [6, 5, 4, 3, 2, 1];
    player1used = List.filled(6, 0);
    player2used = List.filled(6, 0);
  }

  List<List<int>> generateWinningCombos(int size) {
    List<List<int>> combos = [];
    for (int r = 0; r < size; r++) {
      combos.add(List.generate(size, (c) => r * size + c));
    }
    for (int c = 0; c < size; c++) {
      combos.add(List.generate(size, (r) => r * size + c));
    }
    combos.add(List.generate(size, (i) => i * size + i));
    combos.add(List.generate(size, (i) => i * size + (size - 1 - i)));
    return combos;
  }

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
            itemCount: 16,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
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

  Widget coneRow(
      List<double> sizes, List<int> usedList, Color color, int player) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sizes.length, (i) {
        bool exhausted = usedList[i] >= coneLimits[i];
        return GestureDetector(
          onTap: exhausted
              ? null
              : () {
                  setState(() {
                    selectedConeSize = sizes[i];
                    selectedConePlayer = player;
                  });
                },
          child: Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: exhausted
                ? const Text("❌",
                    style: TextStyle(fontSize: 28, color: Colors.white))
                : Text(
                    "▲",
                    style: TextStyle(fontSize: sizes[i], color: color),
                  ),
          ),
        );
      }),
    );
  }

  void tapped(int index) {
    if (selectedConeSize == null) return;

    setState(() {
      if (!replacementMode) {
        if (board[index] == null || selectedConeSize! > board[index]!) {
          board[index] = selectedConeSize;
          boardPlayer[index] = currentPlayer;

          int coneIndex = triangleSizes.indexOf(selectedConeSize!);
          if (currentPlayer == 1) {
            player1used[coneIndex]++;
          } else {
            player2used[coneIndex]++;
          }

          int? winner = checkWinner(boardPlayer);
          if (winner != null) {
            handleWin(winner);
            return;
          }

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
            currentPlayer = (currentPlayer == 1) ? 2 : 1;
          }

          selectedConeSize = null;
        }
      } else {
        // replacement mode logic same as 3x3
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
            player1used[coneIndex]++; // increase usage count
          } else {
            player2used[coneIndex]++; // increase usage count
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
      player1used[coneIndex]++;
    } else {
      player2used[coneIndex]++;
    }

    selectedConeSize = null; //deselect cone after placement
  }

  int? checkWinner(List<int?> boardplayer) {
    for (var combo in winningCombos) {
      int? first = boardPlayer[combo[0]];
      if (first == null) continue;
      if (combo.every((index) => boardPlayer[index] == first)) {
        return first;
      }
    }
    return null;
  }

  void resetBoard() {
    setState(() {
      // clear board
      board = List.filled(16, null);
      boardPlayer = List.filled(16, null);
      // reset cone usage
      player1used = List.filled(6, 0);
      player2used = List.filled(6, 0);
      //reset selection
      selectedConeSize = null;
      //reset turn
      currentPlayer = 1;
      //reset timer
      replacementMode = false;
    });
  }

  void handleWin(int winner) {
    if (winner == 1) {
      player1Score++;
    } else {
      player2Score++;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Player $winner Wins!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                board = List.filled(16, null);
                boardPlayer = List.filled(16, null);
                player1used = List.filled(6, 0);
                player2used = List.filled(6, 0);
                replacementMode = false;
                currentPlayer = 1;
              });
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
