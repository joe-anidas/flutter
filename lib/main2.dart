import 'package:flutter/material.dart';

void main() {
  runApp(LibraryMgmtApp());
}

class LibraryMgmtApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Management System',
      home: LibraryHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LibraryHomePage extends StatelessWidget {
  final TextEditingController bookName = TextEditingController();
  final TextEditingController author = TextEditingController();
  final TextEditingController viewBook = TextEditingController();
  final TextEditingController updateBook = TextEditingController();
  final TextEditingController updateAuthor = TextEditingController();
  final TextEditingController deleteBook = TextEditingController();
  final TextEditingController borrowBook = TextEditingController();

  int available = 1000;
  int issued = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Library Management')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 160),
            TextField(
              controller: bookName,
              decoration: InputDecoration(
                hintText: "Book Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: author,
              decoration: InputDecoration(
                hintText: "Author",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: Text("SAVE")),
            SizedBox(height: 8),
            TextField(
              controller: viewBook,
              decoration: InputDecoration(
                hintText: "Book Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: Text("VIEW")),
            SizedBox(height: 8),
            Text("[Author Display Here]"),
            SizedBox(height: 8),
            TextField(
              controller: updateBook,
              decoration: InputDecoration(
                hintText: "Book Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: updateAuthor,
              decoration: InputDecoration(
                hintText: "Author",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: Text("UPDATE")),
            SizedBox(height: 8),
            TextField(
              controller: deleteBook,
              decoration: InputDecoration(
                hintText: "Book Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: Text("DELETE")),
            SizedBox(height: 16),
            Text("Book Borrow and Return", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: borrowBook,
              decoration: InputDecoration(
                hintText: "Book Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: Text("BORROW")),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: Text("RETURN")),
          ],
        ),
      ),
    );
  }
}