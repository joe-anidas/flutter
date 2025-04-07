import 'package:flutter/material.dart';

void main() {
  runApp(ECommerceApp());}

class ECommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/cart': (context) => CartPage(),
      },    );  }}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();}

class _HomePageState extends State<HomePage> {
  List<String> cartItems = [];

  void addToCart(String item) {
    setState(() {
      cartItems.add(item);    });  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
     ),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ItemCard(
                          image: 'assets/1.png',
                          name: 'Mobile',
                          price: 100,
                          onAddToCart: () => addToCart('Mobile'),
                        ),
                        SizedBox(height: 20.0),
                        ItemCard(
                          image: 'assets/2.png',
                          name: 'Earphone',
                          price: 30,
                          onAddToCart: () => addToCart('Earphone'),
                        ),
                        SizedBox(height: 20.0),
                        ItemCard(
                          image: 'assets/3.png',
                          name: 'Bag',
                          price: 60,
                          onAddToCart: () => addToCart('Bag'),
                        ),  ],    ),    ),  ),  ),  ],),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.blue,
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/cart',
                      arguments: cartItems,
                    );
                  },
                  child: Text('View Cart'),
                ), ),  ),  ), ],  ),    );  }}

class ItemCard extends StatelessWidget {
  final String image;
  final String name;
  final int price;
  final Function()? onAddToCart;

  const ItemCard({
    required this.image,
    required this.name,
    required this.price,
    this.onAddToCart,  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: Image.asset(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '\$$price',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: onAddToCart,
              child: Text('Add to Cart'),
            ),],  ), ), );  }}

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> cartItems = ModalRoute.of(context)!.settings.arguments as List<String>;
    final Map<String, int> itemCounts = {};
    for (String item in cartItems) {
      itemCounts[item] = (itemCounts[item] ?? 0) + 1;
    }

    final Map<String, int> itemPrices = {
      'Mobile': 100,
      'Earphone': 30,
      'Bag': 60,
    };

    int totalAmount = 0;
    for (var entry in itemCounts.entries) {
      final itemName = entry.key;
      final itemCount = entry.value;
      final itemPrice = itemPrices[itemName] ?? 0;
      totalAmount += (itemCount * itemPrice);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: itemCounts.entries.map((entry) {
                  final itemName = entry.key;
                  final itemCount = entry.value;
                  final itemPrice = itemPrices[itemName] ?? 0;
                  final totalItemPrice = itemCount * itemPrice;

                  return Text('$itemName x $itemCount = \$$totalItemPrice');
                }).toList(),
              ),
              Divider(
                height: 30,
                thickness: 2,
                color: Colors.black,
              ),
              Text(
                'Total = \$$totalAmount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Payment logic goes here');
                },
                child: Text('Pay'),
              ),   ],  ),  ),  ),  );  }}
