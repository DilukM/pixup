// lib/screens/details_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pixup/models/genre.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pixup/models/movie.dart';
import 'package:pixup/services/api_service.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie; // Movie object passed to the screen

  const DetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isFavorite = false; // Flag to indicate if the movie is a favorite
  List<Genre> genres = []; // List of genres
  final ApiService apiService =
      ApiService(); // Instance of ApiService to handle API requests

  @override
  void initState() {
    super.initState();
    _checkIfFavorite(); // Check if the movie is a favorite
    fetchGenres(); // Fetch genres
  }

  Future<void> fetchGenres() async {
    try {
      final fetchedGenres =
          await apiService.getGenres(); // Fetch genres from API
      setState(() {
        genres = fetchedGenres; // Update genres list
      });
    } catch (e) {
      print(e); // Print error if fetching genres fails
    }
  }

  String _getGenreName(int id) {
    final genre = genres.firstWhere((genre) => genre.id == id,
        orElse: () => Genre(id: id, name: 'Unknown')); // Find genre by ID
    return genre.name; // Return genre name
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences
        .getInstance(); // Get shared preferences instance
    final favoriteMovies = prefs.getStringList('favoriteMovies') ??
        []; // Get favorite movies from shared preferences
    setState(() {
      isFavorite = favoriteMovies.contains(jsonEncode(
          widget.movie.toJson())); // Check if the movie is a favorite
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences
        .getInstance(); // Get shared preferences instance
    final favoriteMovies = prefs.getStringList('favoriteMovies') ??
        []; // Get favorite movies from shared preferences
    if (isFavorite) {
      favoriteMovies.remove(
          jsonEncode(widget.movie.toJson())); // Remove movie from favorites
    } else {
      favoriteMovies
          .add(jsonEncode(widget.movie.toJson())); // Add movie to favorites
    }
    await prefs.setStringList(
        'favoriteMovies', favoriteMovies); // Save updated favorites list
    setState(() {
      isFavorite = !isFavorite; // Toggle favorite status
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: widget.movie.posterPath != null
                        ? Image.network(
                            '${ApiService.imageBaseUrl}${widget.movie.posterPath}',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.movie, size: 100),
                          )
                        : const Icon(Icons.movie, size: 100),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: const [0, 0.8],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: isTablet ? 32 : 24,
                              ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 4.0),
                            Text(widget.movie.releaseDate.split('-')[0]),
                            const SizedBox(width: 16.0),
                            const Icon(Icons.star,
                                size: 16, color: Colors.amber),
                            const SizedBox(width: 4.0),
                            Text('${widget.movie.rating.toStringAsFixed(1)}'),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: _toggleFavorite, // Toggle favorite status
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: widget.movie.genreIds.map((id) {
                        return Chip(
                          shape: StadiumBorder(),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          label: Text(
                            _getGenreName(id),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.movie.overview,
                      style: TextStyle(fontSize: isTablet ? 18 : 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 300,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black38, Colors.transparent],
            ),
          ),
        ),
        Positioned(
          top: 50,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
          ),
        ),
      ]),
    );
  }
}
