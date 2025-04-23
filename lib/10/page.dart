
//ui/hangman_page.dart
import 'package:flutter/material.dart';
import 'package:hangman/engine/hangman.dart';

const List<String> progressImages = [
  'assets/images/progress_0.png',
  'assets/images/progress_1.png',
  'assets/images/progress_2.png',
  'assets/images/progress_3.png',
  'assets/images/progress_4.png',
  'assets/images/progress_5.png',
  'assets/images/progress_6.png',
  'assets/images/progress_7.png',
];

const String victoryImage = 'assets/images/victory.png';

const List<String> alphabet = [
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
  'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
];

const TextStyle activeWordStyle = TextStyle(
  fontSize: 30.0,
  letterSpacing: 5.0,
);

class HangmanPage extends StatefulWidget {
  final HangmanGame _engine;

  HangmanPage(this._engine);

  @override
  _HangmanPageState createState() => _HangmanPageState();
}

class _HangmanPageState extends State<HangmanPage> {
  bool _showNewGame = false;
  String _activeImage = progressImages[0];
  String _activeWord = '';

  @override
  void initState() {
    super.initState();
    widget._engine.onChange.listen(_updateWordDisplay);
    widget._engine.onWrong.listen(_updateGallowsImage);
    widget._engine.onWin.listen(_win);
    widget._engine.onLose.listen(_gameOver);
    _newGame(); }

  void _updateWordDisplay(String word) {
    setState(() {
      _activeWord = word;
    }); }

  void _updateGallowsImage(int wrongGuessCount) {
    setState(() {
      _activeImage = progressImages[wrongGuessCount];
    });}

  void _win([_]) {
    setState(() {
      _activeImage = victoryImage;
      _gameOver();
    }); }

  void _gameOver([_]) {
    setState(() {
      _showNewGame = true;
    });  }

  void _newGame() {
    widget._engine.newGame();
    setState(() {
      _activeWord = '';
      _activeImage = progressImages[0];
      _showNewGame = false;
    });  }

  Widget _renderBottomContent() {
    if (_showNewGame) {
      return ElevatedButton(
        child: Text('New Game'),
        onPressed: _newGame,
      );
    } else {
      final Set<String> lettersGuessed = widget._engine.lettersGuessed;
      return Wrap(
        spacing: 1.0,
        runSpacing: 1.0,
        alignment: WrapAlignment.center,
        children: alphabet.map((letter) {
          return MaterialButton(
            child: Text(letter),
            padding: EdgeInsets.all(2.0),
            onPressed: lettersGuessed.contains(letter)
                ? null
                : () => widget._engine.guessLetter(letter),
          );
        }).toList(),);}  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Hangman')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Image.asset(_activeImage)),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(_activeWord, style: activeWordStyle),
              ),
            ),
            Expanded(child: Center(child: _renderBottomContent())),],),),); }}





