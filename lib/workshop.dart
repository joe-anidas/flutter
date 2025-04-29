import 'package:flutter/material.dart';

// Workshop
import 'workshop/gpt/gpt1.dart';
import 'workshop/gpt/gpt2.dart';
import 'workshop/gpt/gpt3.dart';
import 'workshop/gpt/gpt4.dart';
import 'workshop/journal/journal1.dart';
import 'workshop/journal/journal2.dart';
import 'workshop/journal/journal3.dart';
import 'workshop/journal/journal4.dart';
import 'workshop/todo/todo.dart';
import 'workshop/todo/todoserver.dart';

void main() {
  runApp(const Workshop());
}

class Workshop extends StatelessWidget {
  const Workshop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demos',
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
      home: const DemosListPage(),
    );
  }
}

class DemoItem {
  final String name;
  final Widget widget;
  final String emoji;
  final String category;

  DemoItem({
    required this.name,
    required this.widget,
    required this.emoji,
    required this.category,
  });
}

class DemosListPage extends StatefulWidget {
  const DemosListPage({super.key});

  @override
  State<DemosListPage> createState() => _DemosListPageState();
}

class _DemosListPageState extends State<DemosListPage> {
  bool isSearching = false;
  String searchText = '';

  final List<DemoItem> demoItems = [
    DemoItem(name: 'gpt1.dart', widget: GPTApp1(), emoji: "🤖", category: "Workshop"),
    DemoItem(name: 'gpt2.dart', widget: GPTApp2(), emoji: "🤖", category: "Workshop"),
    DemoItem(name: 'gpt3.dart', widget: GPTApp3(), emoji: "🤖", category: "Workshop"),
    DemoItem(name: 'gpt4.dart', widget: GPTApp4(), emoji: "🤖", category: "Workshop"),
    DemoItem(name: 'journal1.dart', widget: JournalApp1(), emoji: "📝", category: "Workshop"),
    DemoItem(name: 'journal2.dart', widget: JournalApp2(), emoji: "📝", category: "Workshop"),
    DemoItem(name: 'journal3.dart', widget: JournalApp3(), emoji: "📝", category: "Workshop"),
    DemoItem(name: 'journal4.dart', widget: JournalApp4(), emoji: "📝", category: "Workshop"),
    DemoItem(name: 'todo.dart', widget: Todo(), emoji: "✅", category: "Workshop"),
    DemoItem(name: 'todoserver.dart', widget: TodoServer(), emoji: "✅", category: "Workshop"),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = demoItems
        .where((item) => item.name.toLowerCase().contains(searchText.toLowerCase()) ||
            item.category.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search demos...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() => searchText = value);
                },
              )
            : const Text(
                'Flutter Demos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
        ],
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
                  'Available Demos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(0, 2),),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap on a demo to open it',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    shadows: const [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black12,
                        offset: Offset(0, 1),),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No demos found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return DemoListItem(
                              item: item,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => item.widget),
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
    );
  }
}

class DemoListItem extends StatelessWidget {
  final DemoItem item;
  final VoidCallback onTap;

  const DemoListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}