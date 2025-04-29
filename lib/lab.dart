import 'package:flutter/material.dart';

// Folder 2
import 'lab/2/ui.dart';
import 'lab/2/alarm.dart';

// Folder 3
import 'lab/3/calc.dart';
import 'lab/3/calc2.dart';

// Folder 4
import 'lab/4/game1.dart';
import 'lab/4/game2.dart';
import 'lab/4/game3.dart';

// Folder 5
import 'lab/5/movie.dart';

// Folder 6
import 'lab/6/shop.dart';

// Folder 7
import 'lab/7/http.dart';

// Folder 9
import 'lab/9/map2.dart';

// Folder 10
import 'lab/10/h2.dart';

void main() {
  runApp(const Lab());
}

class Lab extends StatelessWidget {
  const Lab({super.key});

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
    // UI Components
    DemoItem(name: 'ui.dart', widget: Ui(), emoji: "🎨", category: "UI"),
    DemoItem(name: 'alarm.dart', widget: Alarm(), emoji: "⏰", category: "UI"),

    // Calculators
    DemoItem(name: 'calc.dart', widget: Calc(), emoji: "🧮", category: "Tools"),
    DemoItem(name: 'calc2.dart', widget: Calc2(), emoji: "📟", category: "Tools"),

    // Games
    DemoItem(name: 'game1.dart', widget: Game1(), emoji: "🎮", category: "Games"),
    DemoItem(name: 'game2.dart', widget: Game2(), emoji: "👾", category: "Games"),
    DemoItem(name: 'game3.dart', widget: Game3(), emoji: "🕹️", category: "Games"),

    // Media
    DemoItem(name: 'movie.dart', widget: MovieApp(), emoji: "🎬", category: "Media"),

    // Commerce
    DemoItem(name: 'shop.dart', widget: Shop(), emoji: "🛒", category: "Commerce"),

    // Networking
    DemoItem(name: 'http.dart', widget: Http(), emoji: "🌐", category: "Networking"),

    // Maps
    DemoItem(name: 'map2.dart', widget: Map2(), emoji: "📍", category: "Maps"),

    // Miscellaneous
    DemoItem(name: 'h2.dart', widget: H2(), emoji: "❓", category: "Misc"),
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
                        offset: Offset(0, 2),
                      ),
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
                        offset: Offset(0, 1),
                      ),
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
                      : ListView.separated(
                          itemCount: filteredItems.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 24),
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