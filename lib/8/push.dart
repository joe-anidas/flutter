import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// //Update pubspec.yaml 

// dependencies:
//   flutter:
//     sdk: flutter
//   firebase_messaging: ^12.0.1
//   http: ^0.13.3

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    print('Firebase Messaging Token: $token');

    // Configure handlers for various notification scenarios
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message.notification?.title ?? 'Notification'),
          content: Text(message.notification?.body ?? ''),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
      // Handle notification when app is in background but opened by tapping on the notification
    });
  }

  Future<void> _sendTestNotification() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/send-notification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': 'Test notification', 'deviceToken': 'dummy-token'}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notifications Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _sendTestNotification,
          child: Text('Send Test Notification'),
        ),
      ),
    );
  }
}
