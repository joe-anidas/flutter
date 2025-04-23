import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: MyHome()));

class MyHome extends StatefulWidget {
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final _fcm = FirebaseMessaging.instance;
  String? _deviceToken;

  @override
  void initState() {
    super.initState();
    _fcm.getToken().then((token) {
      setState(() => _deviceToken = token);
      print("Token: $token");
    });

    FirebaseMessaging.onMessage.listen((msg) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(msg.notification?.title ?? "Notification"),
          content: Text(msg.notification?.body ?? ""),
        ),
      );
    });
  }

  void sendTestNotification() async {
    if (_deviceToken == null) return;
    await http.post(
      Uri.parse('http://10.0.2.2:3000/send-notification'), // or your LAN IP
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': 'Hello from app',
        'deviceToken': _deviceToken,
      }),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Push Demo")),
        body: Center(
          child: ElevatedButton(
            onPressed: sendTestNotification,
            child: Text("Send Test Notification"),
          ),
        ),
      );
}
