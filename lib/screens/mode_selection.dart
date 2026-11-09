import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tic_tac_toe/screens/game.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  Widget modeButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 50),
          const SizedBox(height: 10),
          Text(label),
        ],
      ),
    );
  }

  Widget floatingTriangle(Color color, double size, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: Text("▲", style: TextStyle(color: color, fontSize: size)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          // Decorative floating triangles
          floatingTriangle(Colors.yellow, 20, 40, 30),
          floatingTriangle(Colors.blue, 20, 80, 200),
          floatingTriangle(Colors.red.shade900, 24, 150, 100),
          floatingTriangle(Colors.yellow, 18, 300, 250),
          floatingTriangle(Colors.blue, 22, 400, 60),

          // Centered layout
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top button (Puzzle)
                modeButton(MdiIcons.puzzle, "PUZZLE", () {
                  // Navigate to Puzzle mode
                }),
                const SizedBox(height: 40),

                // Bottom row with two buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    modeButton(MdiIcons.accountGroup, "WITH FRIENDS", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GameScreen()));
                    }),
                    const SizedBox(width: 40),
                    modeButton(MdiIcons.robot, "AI BOT", () {
                      // Navigate to AI Bot mode
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
