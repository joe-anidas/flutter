import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: H1()));

class H1 extends StatefulWidget {
  @override
  _HangmanState createState() => _HangmanState();
}

class _HangmanState extends State<H1> {
  final word = "HANGMAN", guessed = <String>{};

  @override
  Widget build(BuildContext context) {
    String display = word.split('').map((c) => guessed.contains(c) ? c : "_").join(' ');

    return Scaffold(
      appBar: AppBar(title: Text("Hangman")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(display, style: TextStyle(fontSize: 30, letterSpacing: 2)),
          Wrap(
            children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
              return Padding(
                padding: EdgeInsets.all(2),
                child: ElevatedButton(
                  onPressed: guessed.contains(letter)
                      ? null
                      : () => setState(() => guessed.add(letter)),
                  child: Text(letter),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
