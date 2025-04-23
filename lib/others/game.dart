
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const FlappyBirdGame());
}

class FlappyBirdGame extends StatelessWidget {
  const FlappyBirdGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
     
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  double bnirdY = 0;
  double velocity = 0;
  double gravity = 0.005;
  bool isGameRunning = false;
  Timer? gameLoop;

  void startGame() {
    if (isGameRunning) return;
    isGameRunning = true;
    velocity = -0.02;
    gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        velocity += gravity;
        birdY += velocity;
      });
      if (birdY > 1 || birdY < -1) {
        timer.cancel();
        isGameRunning = false;
        resetGame();
      }
    });
  }

  void jump() {
    setState(() {
      velocity = -0.03;
    });
  }

  void resetGame() {
    setState(() {
      birdY = 0;
      velocity = 0;
      isGameRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isGameRunning) {
          startGame();
        }
        jump();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(color: Colors.blue),
            AnimatedContainer(
              alignment: Alignment(0, birdY),
              duration: const Duration(milliseconds: 16),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Tap to Play",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}