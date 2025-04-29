import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(MaterialApp(home: Map2()));

class Map2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Map')),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(13.0827, 80.2707),
          zoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
        ],
      ),
    );
  }
}

// dependencies:
//   flutter:
//     sdk: flutter
//   flutter_map: ^6.1.0
//   latlong2: ^0.9.0

