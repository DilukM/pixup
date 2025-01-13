// lib/screens/details_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pixup/models/movie.dart';
import 'package:pixup/services/api_service.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;

  const DetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMovies = prefs.getStringList('favoriteMovies') ?? [];
    setState(() {
      isFavorite = favoriteMovies.contains(jsonEncode(widget.movie.toJson()));
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMovies = prefs.getStringList('favoriteMovies') ?? [];
    if (isFavorite) {
      favoriteMovies.remove(jsonEncode(widget.movie.toJson()));
    } else {
      favoriteMovies.add(jsonEncode(widget.movie.toJson()));
    }
    await prefs.setStringList('favoriteMovies', favoriteMovies);
    setState(() {
      isFavorite = !isFavorite;
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
              Padding(
                padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.movie.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: isTablet ? 32 : 24,
                              ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4.0),
                        Text(widget.movie.releaseDate),
                        const SizedBox(width: 16.0),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4.0),
                        Text('${widget.movie.rating.toStringAsFixed(1)}/10'),
                      ],
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
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );
  }
}
