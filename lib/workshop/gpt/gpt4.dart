
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GPTApp4 extends StatefulWidget {
  const GPTApp4({super.key});

  @override
  State<GPTApp4> createState() => _GPTApp4State();
}

class _GPTApp4State extends State<GPTApp4> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  static const String GEMINI_API_KEY = "AIzaSyA9wRMnCVuaZ_U-_mUDvGqQH7pd1wW2Nns";
  static const String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$GEMINI_API_KEY";

  Future<void> sendMessage(String userInput) async {
    if (userInput.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": userInput});
      _isLoading = true;
    });
    _controller.clear();

    final bodyData = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": userInput}
          ]
        }
      ]
    });

    try {
      final response = await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'}, body: bodyData);

      final data = json.decode(response.body);
      final reply = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "No reply";

      setState(() {
        _messages.add({"role": "gemini", "text": reply});
        _isLoading = false;
      });

      // Auto scroll
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      setState(() {
        _messages.add({"role": "gemini", "text": "Error occurred: $e"});
        _isLoading = false;
      });
    }
  }

  Widget buildMessage(Map<String, dynamic> msg) {
    final isUser = msg['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Text(
          msg['text'],
          style: TextStyle(color: isUser ? Colors.white : const Color.fromARGB(221, 211, 195, 195)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gemini Chat"),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => buildMessage(_messages[index]),
                ),
              ),
              if (_isLoading) const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: const Color.fromARGB(255, 0, 0, 0),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.deepPurple,
                    onPressed: () => sendMessage(_controller.text),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}