// ignore: file_names
// ignore_for_file: duplicate_ignore, file_names

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/game.dart';
import 'package:tic_tac_toe/screens/game_4X4.dart';
import 'package:tic_tac_toe/screens/game_5x5.dart';

class WithFriends extends StatefulWidget {
  const WithFriends({super.key});

  @override
  State<WithFriends> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WithFriends> {
  String selectedBoardSize = "3x3";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          // Floating triangles for decoration
          Positioned(
              top: 40,
              left: 30,
              child: Text("▲",
                  style: TextStyle(color: Colors.yellow, fontSize: 20))),
          Positioned(
              top: 80,
              left: 200,
              child: Text("▲",
                  style: TextStyle(color: Colors.blue, fontSize: 20))),
          Positioned(
              top: 150,
              left: 100,
              child: Text("▲",
                  style: TextStyle(color: Colors.red.shade900, fontSize: 24))),
          Positioned(
              top: 300,
              left: 250,
              child: Text("▲",
                  style: TextStyle(color: Colors.yellow, fontSize: 18))),
          Positioned(
              top: 400,
              left: 60,
              child: Text("▲",
                  style: TextStyle(color: Colors.blue, fontSize: 22))),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "PLAY WITH FRIENDS",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Player 1
                    Container(
                      width: 150,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text("PLAYER 1",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Icon(Icons.person, color: Colors.red, size: 50),
                          const SizedBox(height: 10),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Enter Name",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var color in [
                                Colors.red,
                                Colors.yellow,
                                Colors.green,
                                Colors.blue
                              ])
                                CircleAvatar(
                                    backgroundColor: color, radius: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Player 2 (same structure)
                    Container(
                      width: 150,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text("PLAYER 2",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Icon(Icons.person,
                              color: Colors.blue, size: 50),
                          const SizedBox(height: 10),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Enter Name",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var color in [
                                Colors.red,
                                Colors.yellow,
                                Colors.green,
                                Colors.blue
                              ])
                                CircleAvatar(
                                    backgroundColor: color, radius: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Board Size:",
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedBoardSize,
                      items: ["3x3", "4x4", "5x5"]
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBoardSize = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 40),
                    const Text("Timer:", style: TextStyle(color: Colors.white)),
                    Switch(value: false, onChanged: (_) {}),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 25),
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Widget screen;
                    if (selectedBoardSize == "3x3") {
                      screen = const GameScreen();
                    } else if (selectedBoardSize == "4x4") {
                      screen = const GameScreen4x4();
                    } else {
                      screen = const GameScreen5x5();
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screen),
                    );
                  },
                  child: const Text("START GAME"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
