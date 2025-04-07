import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,),
      home: HomePage(),);}}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();}

class _HomePageState extends State<HomePage> {
  String data = "Fetching data...";
  @override
  void initState() {
    super.initState();
    fetchData();}

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    
    if (response.statusCode == 200) {
      setState(() {
 
        data = jsonDecode(response.body)['title'];
      });
    } else {
      setState(() {
        data = "Failed to load data";
      });}}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HTTP Request Example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            data,  
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ), ), ),);}}
