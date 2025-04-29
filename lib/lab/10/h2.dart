import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(H2());
}

class H2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HangmanPage(),
    );
  }
}

class HangmanPage extends StatefulWidget {
  @override
  _HangmanPageState createState() => _HangmanPageState();
}

class _HangmanPageState extends State<HangmanPage> {
  final List<String> _words = [
    "PLENTY", "ACHIEVE", "CLASS", "FANTASY", "ATTACK", "COIN", "RACE", "FLAG", "GROW"
  ];
  final List<String> _progressImages = List.generate(
      8, (i) => 'assets/images/progress_$i.png');
  final String _victoryImage = 'assets/images/victory.png';
  final List<String> _alphabet = List.generate(26, (i) => String.fromCharCode(65 + i));

  late String _word;
  Set<String> _guessed = {};
  int _wrongGuesses = 0;
  bool _gameOver = false;
  bool _win = false;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    final random = Random();
    _word = _words[random.nextInt(_words.length)];
    _guessed.clear();
    _wrongGuesses = 0;
    _gameOver = false;
    _win = false;
    setState(() {});
  }

  void _guess(String letter) {
    if (_gameOver || _guessed.contains(letter)) return;
    _guessed.add(letter);
    if (!_word.contains(letter)) _wrongGuesses++;
    if (_wrongGuesses >= 7) _gameOver = true;
    if (_word.split('').every((ch) => _guessed.contains(ch))) {
      _gameOver = true;
      _win = true;
    }
    setState(() {});
  }

  String _displayWord() {
    return _word.split('').map((ch) => _guessed.contains(ch) ? ch : "_").join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final image = _win ? _victoryImage : _progressImages[_wrongGuesses];
    return Scaffold(
      appBar: AppBar(title: Text("Hangman")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 200),
          SizedBox(height: 20),
          Text(_displayWord(), style: TextStyle(fontSize: 32, letterSpacing: 4)),
          SizedBox(height: 20),
          if (_gameOver)
            ElevatedButton(child: Text("New Game"), onPressed: _newGame)
          else
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: _alphabet.map((letter) {
                return ElevatedButton(
                  onPressed: _guessed.contains(letter) ? null : () => _guess(letter),
                  child: Text(letter),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
