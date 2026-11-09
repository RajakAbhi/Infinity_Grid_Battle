import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/mode_selection.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool swap = false;
  late AnimationController _controller;
  late Animation<Offset> _floatUpDown;

  @override
  void initState() {
    super.initState();

    // Trigger swap after 2 seconds (for animation)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => swap = true);
    });

    // Navigate to ModeSelectionScreen after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => ModeSelectionScreen()),
      );
    });

    // Animation controller for floating triangles
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatUpDown = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: const Offset(0, 0.05),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget floatingTriangle(Color color, double size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedSlide(
          offset: _floatUpDown.value,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
      child: Text("▲", style: TextStyle(color: color, fontSize: size)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          // Decorative scattered triangles (now animated)
          Positioned(
              top: 40, left: 30, child: floatingTriangle(Colors.yellow, 18)),
          Positioned(
              top: 80, right: 50, child: floatingTriangle(Colors.blue, 18)),
          Positioned(
              bottom: 100, left: 60, child: floatingTriangle(Colors.blue, 18)),
          Positioned(
              bottom: 50,
              right: 40,
              child: floatingTriangle(Colors.yellow, 18)),
          Positioned(
              top: 200, right: 120, child: floatingTriangle(Colors.blue, 18)),
          Positioned(
              bottom: 200,
              left: 100,
              child: floatingTriangle(Colors.yellow, 18)),

          // Deep red scattered triangles
          Positioned(
              top: 150,
              left: 20,
              child: floatingTriangle(Colors.red.shade900, 22)),
          Positioned(
              bottom: 150,
              right: 80,
              child: floatingTriangle(Colors.red.shade900, 22)),
          Positioned(
              top: 300,
              left: 200,
              child: floatingTriangle(Colors.red.shade900, 22)),

          // Centered content (title + grid)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: const [
                    Text("TIC",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w900)),
                    SizedBox(height: 10),
                    Text("TAC",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w900)),
                    SizedBox(height: 10),
                    Text("TOE",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 160,
                  height: 160,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (index == 0)
                              const Text("▲",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 40)),
                            if (index == 3)
                              const Text("▲",
                                  style: TextStyle(
                                      color: Color.fromRGBO(33, 150, 243, 1), fontSize: 40)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
