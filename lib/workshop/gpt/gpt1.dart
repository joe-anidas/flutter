
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const GPTApp1());
}

class GPTApp1 extends StatelessWidget {
  const GPTApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat with GPT',
      theme: ThemeData.dark(),
      home: const ChatGPTScreen(),
    );
  }
}

class ChatGPTScreen extends StatefulWidget {
  const ChatGPTScreen({super.key});

  @override
  State createState() => _ChatGPTScreenState();
}

class Message {
  final String text;
  final bool isUser;

  Message(this.text, this.isUser);
}

class _ChatGPTScreenState extends State {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [Message('Ask me something!', false)];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(Message(message, true));
      _isLoading = true;
      _messageController.clear();
    });

    _scrollToBottom();

    const String apiKey = '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'; // 🔁 Put your real key here
    const String apiUrl = 'https://openrouter.ai/api/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'your-app.com', // Optional, can be fake too
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": message}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        setState(() {
          _messages.add(Message(reply.trim(), false));
        });
      } else {
        setState(() {
          _messages.add(Message('API Error: ${response.statusCode}\n${response.body}', false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message('Exception: $e', false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatBox')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return MessageBubble(
                    message: _messages[index].text,
                    isUser: _messages[index].isUser,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask anything...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                  color: Colors.greenAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const MessageBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isUser ? Colors.greenAccent.shade700 : Colors.blueGrey.shade700,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}