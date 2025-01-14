import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pixup/models/genre.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pixup/models/movie.dart';
import 'package:pixup/services/api_service.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({Key? key}) : super(key: key);

  @override
  _LikedScreenState createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  final ApiService apiService =
      ApiService(); // Instance of ApiService to handle API requests
  List<Movie> favoriteMovies = []; // List of favorite movies
  List<Genre> genres = []; // List of genres

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies(); // Load favorite movies when the screen is initialized
    fetchGenres(); // Fetch genres when the screen is initialized
  }

  Future<void> fetchGenres() async {
    try {
      final fetchedGenres =
          await apiService.getGenres(); // Fetch genres from API
      setState(() {
        genres = fetchedGenres; // Update genres list
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadFavoriteMovies() async {
    final prefs = await SharedPreferences
        .getInstance(); // Get shared preferences instance
    final favoriteMoviesJson = prefs.getStringList('favoriteMovies') ??
        []; // Get favorite movies from shared preferences
    setState(() {
      favoriteMovies = favoriteMoviesJson
          .map((movieJson) => Movie.fromJson(
              jsonDecode(movieJson))) // Decode JSON and create Movie objects
          .toList();
    });
  }

  String _getGenreName(int id) {
    final genre = genres.firstWhere((genre) => genre.id == id,
        orElse: () => Genre(id: id, name: 'Unknown')); // Find genre by ID
    return genre.name; // Return genre name
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: favoriteMovies.isEmpty
          ? Center(
              child: Text(
                'No favorite movies yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 2 : 1,
                childAspectRatio: isTablet ? 3 : 3.3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: favoriteMovies.length + 1,
              itemBuilder: (context, index) {
                if (index == favoriteMovies.length) {
                  return SizedBox(
                      height: 80); // Add space at the end of the list
                }
                final movie = favoriteMovies[index];
                final genreNames = movie.genreIds
                    .map((id) => _getGenreName(id))
                    .join(', '); // Get genre names
                return Container(
                  height: 110,
                  width: isTablet
                      ? MediaQuery.of(context).size.width * 0.4
                      : MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ]),
                  child: Row(
                    children: [
                      if (movie.posterPath != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            '${ApiService.imageBaseUrl}${movie.posterPath}', // Movie poster URL
                            width: isTablet
                                ? MediaQuery.of(context).size.width * 0.13
                                : MediaQuery.of(context).size.width * 0.25,
                            height: isTablet
                                ? MediaQuery.of(context).size.width * 0.13
                                : MediaQuery.of(context).size.width * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: isTablet
                                ? MediaQuery.of(context).size.width * 0.32
                                : MediaQuery.of(context).size.width * 0.65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  maxLines: 2,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  genreNames,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  Text('${movie.rating.toStringAsFixed(1)}'),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text("|"),
                              ),
                              Text(
                                movie.releaseDate.split('-')[0],
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
