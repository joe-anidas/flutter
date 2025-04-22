[11:55 pm, 22/4/2025] JOE💙: import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(MaterialApp(home: LibraryMgmtSystem()));
}

class LibraryMgmtSystem extends StatefulWidget {
  @override
  _LibraryMgmtSystemState createState() => _LibraryMgmtSystemState();
}

class _LibraryMgmtSystemState extends State<LibraryMgmtSystem> {
  final bookNameCtrl = TextEditingController();
  final authorCtrl = TextEditingController();
  final viewBookCtrl = TextEditingController();
  final updateBookCtrl = TextEditingController();
  final updateAuthorCtrl = TextEditingController();
  final deleteBookCtrl = TextEditingController();
  final borrowBookCtrl = TextEditingController();

  String viewResult = "";
  int available = 1000, issued = 300;
  final db = DBHelper();

  void showToast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Library Management')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: bookNameCtrl, decoration: InputDecoration(labelText: 'Book Name')),
          TextField(controller: authorCtrl, decoration: InputDecoration(labelText: 'Author')),
          ElevatedButton(onPressed: () async {
            await db.insertBook(bookNameCtrl.text, authorCtrl.text);
            showToast('Book Added');
          }, child: Text('SAVE')),

          TextField(controller: viewBookCtrl, decoration: InputDecoration(labelText: 'Book Name to View')),
          ElevatedButton(onPressed: () async {
            String? author = await db.getAuthor(viewBookCtrl.text);
            setState(() => viewResult = author ?? 'Book not found');
          }, child: Text('VIEW')),
          Text(viewResult),

          TextField(controller: updateBookCtrl, decoration: InputDecoration(labelText: 'Book Name to Update')),
          TextField(controller: updateAuthorCtrl, decoration: InputDecoration(labelText: 'New Author')),
          ElevatedButton(onPressed: () async {
            await db.updateAuthor(updateBookCtrl.text, updateAuthorCtrl.text);
            showToast('Book Updated');
          }, child: Text('UPDATE')),

          TextField(controller: deleteBookCtrl, decoration: InputDecoration(labelText: 'Book Name to Delete')),
          ElevatedButton(onPressed: () async {
            await db.deleteBook(deleteBookCtrl.text);
            showToast('Book Deleted');
          }, child: Text('DELETE')),

          TextField(controller: borrowBookCtrl, decoration: InputDecoration(labelText: 'Book to Borrow/Return')),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(onPressed: () {
              setState(() {
                available--;
                issued++;
              });
              showToast('Borrowed. Available: $available, Issued: $issued');
            }, child: Text('BORROW')),
            ElevatedButton(onPressed: () {
              setState(() {
                available++;
                issued--;
              });
              showToast('Returned. Available: $available, Issued: $issued');
            }, child: Text('RETURN')),
          ]),
        ]),
      ),
    );
  }
}
[11:56 pm, 22/4/2025] JOE💙: import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB('library.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE books(BookName TEXT PRIMARY KEY, Author TEXT)');
  }

  Future<void> insertBook(String name, String author) async {
    final dbClient = await db;
    await dbClient.insert('books', {'BookName': name, 'Author': author}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getAuthor(String name) async {
    final dbClient = await db;
    final res = await dbClient.query('books', where: 'BookName = ?', whereArgs: [name]);
    if (res.isNotEmpty) return res.first['Author'] as String;
    return null;
  }

  Future<void> updateAuthor(String name, String author) async {
    final dbClient = await db;
    await dbClient.update('books', {'Author': author}, where: 'BookName = ?', whereArgs: [name]);
  }

  Future<void> deleteBook(String name) async {
    final dbClient = await db;
    await dbClient.delete('books', where: 'BookName = ?', whereArgs: [name]);
  }
}