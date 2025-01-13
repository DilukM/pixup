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
  final ApiService apiService = ApiService();
  List<Movie> favoriteMovies = [];
  List<Genre> genres = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
    fetchGenres();
  }

  Future<void> fetchGenres() async {
    try {
      final fetchedGenres = await apiService.getGenres();
      setState(() {
        genres = fetchedGenres;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadFavoriteMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMoviesJson = prefs.getStringList('favoriteMovies') ?? [];
    setState(() {
      favoriteMovies = favoriteMoviesJson
          .map((movieJson) => Movie.fromJson(jsonDecode(movieJson)))
          .toList();
    });
  }

  String _getGenreName(int id) {
    final genre = genres.firstWhere((genre) => genre.id == id,
        orElse: () => Genre(id: id, name: 'Unknown'));
    return genre.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = favoriteMovies[index];
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (movie.posterPath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      '${ApiService.imageBaseUrl}${movie.posterPath}',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 8.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        clipBehavior: Clip.antiAlias,
                        spacing: 8.0,
                        children: movie.genreIds.map((id) {
                          return Chip(
                            labelPadding: const EdgeInsets.all(0),
                            label: Text(
                              _getGenreName(id),
                              style: TextStyle(fontSize: 10),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Text('${movie.rating.toStringAsFixed(1)}'),
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
          );
        },
      ),
    );
  }
}
