//main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this import
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notifications Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _token;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      // Request permission (iOS)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print('Permission granted: ${settings.authorizationStatus}');

      // Get token
      _token = await _firebaseMessaging.getToken();
      print('Device Token: $_token');

      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground message received');
        _showNotificationDialog(
          message.notification?.title ?? 'Notification',
          message.notification?.body ?? '',
        );
      });

      // Background/terminated messages
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('App opened from notification');
        _showNotificationDialog(
          'App opened from notification',
          message.notification?.body ?? '',
        );
      });

    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  void _showNotificationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendTestNotification() async {
    if (_token == null) {
      print('No device token available');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/send-notification'), // Changed from localhost
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': 'Hello from Flutter!',
          'deviceToken': _token,
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification sent!')),
        );
      } else {
        print('Failed to send notification: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send notification')),
        );
      }
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Push Notifications Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendTestNotification,
              child: Text('Send Test Notification'),
            ),
            SizedBox(height: 20),

            if (_token != null) ...[
              Text('Device Token:'),
              SelectableText(
                _token!,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}







//server.js

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const admin = require('firebase-admin');
const app = express();
const port = process.env.PORT || 3000;
const serviceAccount = require('./serviceAccountKey.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Health check endpoint
app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'Push notification server is running' });
});

app.post('/send-notification', async (req, res) => {
  console.log('Received notification request:', req.body);

  const { message, deviceToken } = req.body;

  if (!message || !deviceToken) {
    console.log('Invalid request - missing parameters');
    return res.status(400).json({
      success: false,
      error: 'Both message and deviceToken are required'
    });
  }

  try {
    console.log('Attempting to send notification to token:', deviceToken);

    const messagePayload = {
      token: deviceToken,
      notification: {
        title: 'Push Notification',
        body: message,
      },
      data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        sent_time: new Date().toISOString(),
      },
    };

    const response = await admin.messaging().send(messagePayload);

    console.log('Successfully sent message:', response);
    res.json({
      success: true,
      message: 'Notification sent successfully',
      response
    });
  } catch (error) {
    console.error('Error sending notification:', error);
    res.status(500).json({
      success: false,
      error: error.message || 'Failed to send notification'
    });
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({ success: false, error: 'Internal server error' });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});