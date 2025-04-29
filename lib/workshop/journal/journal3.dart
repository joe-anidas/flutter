
import 'package:flutter/material.dart';

void main() {
  runApp(const JournalApp3());
}

class JournalApp3 extends StatelessWidget {
  const JournalApp3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      themeMode: ThemeMode.system,
      home: const EmojiGridPage(),
    );
  }
}
class EmojiGridPage extends StatefulWidget {
  const EmojiGridPage({super.key});

  @override
  State<EmojiGridPage> createState() => _EmojiGridPageState();
}

class _EmojiGridPageState extends State<EmojiGridPage> {
  bool isSearching = false;
  String searchText = '';

  final List<Map<String, String>> emojis = [
    {'emoji': '😊', 'name': 'Smiling Face'},
    {'emoji': '🐱', 'name': 'Cat'},
    {'emoji': '🌻', 'name': 'Sunflower'},
    {'emoji': '🍕', 'name': 'Pizza'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEmojis = emojis
        .where((e) => e['name']!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
  extendBodyBehindAppBar: true,
 appBar: AppBar(
  title: isSearching
      ? TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() => searchText = value);
          },
        )
      : const Text(
          'My Journal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
  centerTitle: true,
  elevation: 0,
  backgroundColor: Colors.transparent,
  leading: Builder(
    builder: (context) => IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openDrawer(),
    ),
  ),
  actions: [
    IconButton(
      icon: Icon(isSearching ? Icons.close : Icons.search),
      onPressed: () {
        setState(() {
          isSearching = !isSearching;
          searchText = '';
        });
      },
    ),
    IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menu tapped')),
        );
      },
    ),
  ],
),

  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: const [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('About'),
        ),
      ],
    ),
  ),
  body: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.deepPurple.shade300,
          Colors.purple.shade200,
          Colors.pink.shade200,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
               itemCount: filteredEmojis.length,
itemBuilder: (context, index) {
  return EmojiCard(
    emoji: filteredEmojis[index]['emoji']!,
    name: filteredEmojis[index]['name']!,
    onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected: ${filteredEmojis[index]['name']}'),
          duration: const Duration(seconds: 1),
        ),
      );
    },
  );
},

              ),
            ),
          ],
        ),
      ),
    ),
  ),
  floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatPage()),
    );
  },
  child: const Icon(Icons.message),
),
floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

);

  }
}
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(
        child: Text('Chatbox coming soon...'),
      ),
    );
  }
}

class EmojiCard extends StatelessWidget {
  final String emoji;
  final String name;
  final VoidCallback onTap;

  const EmojiCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.deepPurple.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'emoji_$emoji',
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 56),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}