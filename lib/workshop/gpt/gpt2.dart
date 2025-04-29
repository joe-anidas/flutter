
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  runApp(const GPTApp2());
}

class GPTApp2 extends StatelessWidget {
  const GPTApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBox',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF444654),
        scaffoldBackgroundColor: const Color(0xFF343541),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF444654),
          elevation: 0,
        ),
        fontFamily: 'Inter',
      ),
      home: const ChatGPTScreen(),
      debugShowCheckedModeBanner: false,
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
  final DateTime timestamp;

  Message(this.text, this.isUser) : timestamp = DateTime.now();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [Message('Hello! I\'m ChatGPT. How can I help you today?', false)];
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

  Future<void> _sendMessage() async {
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
          'HTTP-Referer': 'your-app.com',
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
          _messages.add(Message('Error ${response.statusCode}: Unable to get response from server.', false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message('Connection error. Please check your internet and try again.', false));
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
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: Colors.teal.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'ChatBox',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(Message('Hello! I\'m ChatGPT. How can I help you today?', false));
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Show settings dialog/page
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text('Start a conversation!'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return const ThinkingIndicator();
                      }
                      
                      final message = _messages[index];
                      final showAvatar = index == 0 || (_messages[index - 1].isUser != message.isUser);
                      
                      return MessageTile(
                        message: message,
                        showAvatar: showAvatar,
                      );
                    },
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF444654),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.15),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF40414F),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade800,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Message ChatGPT...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                              onPressed: _isLoading ? null : _sendMessage,
                            ),
                          ],
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
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

class MessageTile extends StatelessWidget {
  final Message message;
  final bool showAvatar;

  const MessageTile({
    super.key,
    required this.message,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: message.isUser ? const Color(0xFF343541) : const Color(0xFF444654),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            _buildAvatar(),
            const SizedBox(width: 16),
          ] else ...[
            const SizedBox(width: 40),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 16, height: 1.5),
                  code: TextStyle(
                    fontFamily: 'monospace',
                    backgroundColor: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (message.isUser) {
      return CircleAvatar(
        backgroundColor: Colors.teal.shade700,
        radius: 20,
        child: const Icon(
          Icons.person,
          color: Colors.white,
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.green.shade700,
        radius: 20,
        child: const Icon(
          Icons.smart_toy_outlined,
          color: Colors.white,
        ),
      );
    }
  }
}

class ThinkingIndicator extends StatelessWidget {
  const ThinkingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: const Color(0xFF444654),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade700,
            radius: 20,
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                _buildPulsingDot(300),
                const SizedBox(width: 4),
                _buildPulsingDot(500),
                const SizedBox(width: 4),
                _buildPulsingDot(700),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingDot(int milliseconds) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.5, end: 1),
      duration: Duration(milliseconds: milliseconds),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }
}