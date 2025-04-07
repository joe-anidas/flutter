import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change Text on Button Click',
      home: ChangeTextScreen(),
    );
  }
}
class ChangeTextScreen extends StatefulWidget {
  @override
  _ChangeTextScreen createState() => _ChangeTextScreen();
}
class _ChangeTextScreen extends State<ChangeTextScreen>{
  String alarmText = "Alarm Off";
  int count = 0;
  void changeText(){
    setState(() {
      if(count % 2 ==0){
        alarmText = "Alarm Off";
      }
      else{
        alarmText = "Alarm On";
      }
      count++;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric( vertical: 250),
          child: Center(
            child: Column(
              children: [
                Text(alarmText),
                SizedBox(height: 20,),
                ElevatedButton(child: Text("Alarm Switch"), onPressed: changeText)
  ], ), ), ) );  }}

