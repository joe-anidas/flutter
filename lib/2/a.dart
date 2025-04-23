import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: HomePage(),    );  }}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter UI Example')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Normal Text Widget',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Text widget inside a container widget with padding'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Text widget 1 in Row Widget'),
                SizedBox(width: 10),
                Text('Text widget 2 in Row Widget'),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.red,             ),
                Positioned(
                  top: 30,
                  left: 10,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: Center(child: Text('Container at the first in stack', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 80,
                  child: Container(
                    width: 120,
                    height: 120,
                    color: Colors.yellow,
                    child: Center(child: Text('middle in stack', textAlign: TextAlign.center)),
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
              color: Colors.black,
              child: Center(
                child: Text(
                  'BOTTOM OVERLAY BY A ROW',
                  style: TextStyle(color: Colors.white),  ),  ),  ), ], ), ),   );  }}
