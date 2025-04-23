import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MaterialApp(home: GameScreen()));

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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