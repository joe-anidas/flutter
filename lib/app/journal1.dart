import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmojiGridPage(),
    );
  }
}

class EmojiGridPage extends StatelessWidget {
  const EmojiGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of emoji data (emoji + name)
    final List<Map<String, String>> emojis = [
      {'emoji': '😊', 'name': 'Smiling Face'},
      {'emoji': '🐱', 'name': 'Cat'},
      {'emoji': '🌻', 'name': 'Sunflower'},
      {'emoji': '🍕', 'name': 'Pizza'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
     body: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        return EmojiCard(
          emoji: emojis[index]['emoji']!,
          name: emojis[index]['name']!,
        );
      },
    ),
  ),
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a snackbar when FAB is pressed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Message button pressed!'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        tooltip: 'Send Message', // Tooltip that appears on long press
        child: const Icon(Icons.message), // Message icon
      ),
    );
  }
}

class EmojiCard extends StatelessWidget {
  final String emoji;
  final String name;

  const EmojiCard({
    super.key,
    required this.emoji,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}