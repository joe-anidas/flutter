import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MaterialApp(home: Game2()));

class Game2 extends StatefulWidget {
  const Game2({super.key});

  @override
  State<Game2> createState() => _Game2State();
}

class _Game2State extends State<Game2> {
  double birdY = 0, velocity = 0, gravity = 0.005;
  bool isRunning = false;
  Timer? loop;

  void startGame() {
    isRunning = true;
    loop = Timer.periodic(const Duration(milliseconds: 16), (_) {
      setState(() {
        velocity += gravity;
        birdY += velocity;
        if (birdY > 1 || birdY < -1) resetGame();
      });
    });
  }

  void jump() => setState(() => velocity = -0.03);

  void resetGame() {
    loop?.cancel();
    isRunning = false;
    birdY = 0;
    velocity = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isRunning ? jump() : startGame(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(color: Colors.blue),
            Align(
              alignment: Alignment(0, birdY),
              child: Container(width: 50, height: 50, color: Colors.yellow),
            ),
          ],
        ),
      ),
    );
  }
}