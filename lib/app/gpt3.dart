import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ChatGPTApp());

class ChatGPTApp extends StatelessWidget {
  const ChatGPTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBox',
      theme: ThemeData(
        brightness: Brightness.dark, primaryColor: const Color(0xFF444654),scaffoldBackgroundColor: const Color(0xFF343541),
      ),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello! How can I help you today?', 'isUser': false}
  ];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    
    setState(() {
      _messages.add({'text': message, 'isUser': true});
      _isLoading = true;
      _controller.clear();
    });

    try {
      const apiKey = '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'; // Add your API key here
      const apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo",
          "messages": [{"role": "user", "content": message}]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.add({'text': data['choices'][0]['message']['content'], 'isUser': false});
        });
      } else {
        setState(() {
          _messages.add({'text': 'Error: Unable to get response.', 'isUser': false});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'text': 'Connection error. Please try again.', 'isUser': false});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatBox'), actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: () {
          setState(() => _messages.clear());
          setState(() => _messages.add({'text': 'Hello! How can I help you today?', 'isUser': false}));
        })
      ]),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              final msg = _messages[index];
              return Container(
                padding: const EdgeInsets.all(12),
                color: msg['isUser'] ? const Color(0xFF343541) : const Color(0xFF444654),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(msg['isUser'] ? Icons.person : Icons.smart_toy, 
                         color: msg['isUser'] ? Colors.teal : Colors.green),
                    const SizedBox(width: 12),
                    Expanded(child: Text(msg['text'], style: const TextStyle(fontSize: 16)))
                  ],
                )
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF444654),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Type a message...'),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _isLoading ? null : _sendMessage,
            )
          ]),
        )
      ]),
    );
  }
}