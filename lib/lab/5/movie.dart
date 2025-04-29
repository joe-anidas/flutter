import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb check

void main() {
  runApp(MovieApp());}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: MovieGridScreen(),); }}

class MovieGridScreen extends StatelessWidget {
 final List<Movie> movies = [
   Movie(
     title: "Interstellar",
     imageUrl: "lib/img/1.jpg",
     rating: 5.0, ),
   Movie(
     title: "Avengers: Endgame",
     imageUrl: "lib/img/2.jpg",
     rating: 4.5,
   ),
   Movie(
     title: "Mission: Impossible Dead Reckoning",
     imageUrl: "lib/img/3.jpg",
     rating: 4.0,  ),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            childAspectRatio: 0.8, // Adjust height-to-width ratio
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieCard(movie: movies[index]);},),),);  }}

class Movie {
  final String title;
  final String imageUrl;
  final double rating;

  Movie({required this.title, required this.imageUrl, required this.rating});}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2), // Red border for error
              ),
              child: Image.network(
                movie.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.red, size: 40),
                      SizedBox(height: 5),
                      Text(
                        "Unable to load image\nException: 404 not found",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),],),),),),),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < movie.rating ? Icons.star : Icons.star_border,
                      color: Colors.lightBlueAccent,
                      size: 20,
                    );
                  }),),
                SizedBox(height: 5),
                Text("Rating", style: TextStyle(fontSize: 12)),  ], ),  ), ],   ),   );  }}
