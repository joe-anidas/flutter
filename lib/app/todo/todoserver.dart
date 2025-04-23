import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Map<String, dynamic>> _todos = [];
  final TextEditingController _controller = TextEditingController();
  final String _baseUrl = "http://localhost:3000"; // Change this

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    final response = await http.get(Uri.parse('$_baseUrl/todos'));
    if (response.statusCode == 200) {
      setState(() {
        _todos = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }

  Future<void> _addTodo() async {
    if (_controller.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('$_baseUrl/todos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': _controller.text}),
      );
      if (response.statusCode == 201) {
        _controller.clear();
        _fetchTodos();
      }
    }
  }

  Future<void> _deleteTodo(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/todos/$id'));
    if (response.statusCode == 200) {
      _fetchTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple TodoList'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a todo list',
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                IconButton(
                  onPressed: _addTodo,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(todo['title']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTodo(todo['_id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}