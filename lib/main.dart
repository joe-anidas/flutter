import 'package:flutter/material.dart';

void main() {
  runApp(LibraryMgmtSystem());
}

class LibraryMgmtSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LibraryHomePage(),
    );
  }
}

class LibraryHomePage extends StatelessWidget {
  final TextEditingController bookNameCtrl = TextEditingController();
  final TextEditingController authorCtrl = TextEditingController();
  final TextEditingController viewBookCtrl = TextEditingController();
  final TextEditingController updateBookCtrl = TextEditingController();
  final TextEditingController updateAuthorCtrl = TextEditingController();
  final TextEditingController deleteBookCtrl = TextEditingController();
  final TextEditingController borrowBookCtrl = TextEditingController();

  Widget inputField(String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget actionButton(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Library Management')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            inputField("Book Name", bookNameCtrl),
            inputField("Author", authorCtrl),
            actionButton("SAVE"),

            Divider(),

            inputField("Book Name (View)", viewBookCtrl),
            actionButton("VIEW"),
            SizedBox(height: 8),
            Text("Author: [Result shown here]"),

            Divider(),

            inputField("Book Name (Update)", updateBookCtrl),
            inputField("Author (Update)", updateAuthorCtrl),
            actionButton("UPDATE"),

            Divider(),

            inputField("Book Name (Delete)", deleteBookCtrl),
            actionButton("DELETE"),

            Divider(),

            Text("Book Borrow and Return", style: TextStyle(fontWeight: FontWeight.bold)),

            inputField("Book Name", borrowBookCtrl),
            actionButton("BORROW"),
            actionButton("RETURN"),
          ],
        ),
      ),
    );
  }
}