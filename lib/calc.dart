import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String output = "0";
  String _output = "";
  double num1 = 0;
  double num2 = 0;
  String operand = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "";
        output = "0";
        num1 = 0;
        num2 = 0;
        operand = "";
      } else if (buttonText == "⌫") {
        _output = _output.isNotEmpty ? _output.substring(0, _output.length - 1) : "";
        output = _output.isNotEmpty ? _output : "0";
      } else if (buttonText == "=") {
        try {
          num2 = double.parse(_output.split(operand)[1]);
          if (operand == "+") {
            _output = (num1 + num2).toString();
          } else if (operand == "-") {
            _output = (num1 - num2).toString();
          } else if (operand == "*") {
            _output = (num1 * num2).toString();
          } else if (operand == "/") {
            _output = (num1 / num2).toString();
          }
          output = _output;
        } catch (e) {
          output = "Error";
        }
      } else if (["+", "-", "*", "/"].contains(buttonText)) {
        if (_output.isNotEmpty && !["+", "-", "*", "/"].contains(_output[_output.length - 1])) {
          num1 = double.parse(_output);
          operand = buttonText;
          _output += buttonText;
        }
      } else {
        _output += buttonText;
        output = _output;
      }
    });
  }

  final buttons = [
    "C", "⌫", "%", "/",
    "7", "8", "9", "*",
    "4", "5", "6", "-",
    "1", "2", "3", "+",
    "+/-", "0", ".", "="
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  output,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.3,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 11, 94, 218),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => buttonPressed(buttons[index]),
                    child: Text(
                      buttons[index],
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}