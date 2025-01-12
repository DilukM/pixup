// lib/screens/details_screen.dart
import 'package:flutter/material.dart';
import 'package:pixup/models/movieModel.dart';
import 'package:pixup/services/api_service.dart';

class DetailsScreen extends StatelessWidget {
  final Movie movie;

  const DetailsScreen({Key? key, required this.movie}) : super(key: key);

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
                child: movie.posterPath != null
                    ? Image.network(
                        '${ApiService.imageBaseUrl}${movie.posterPath}',
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
                    Text(
                      movie.title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: isTablet ? 32 : 24,
                              ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4.0),
                        Text(movie.releaseDate),
                        const SizedBox(width: 16.0),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4.0),
                        Text('${movie.rating.toStringAsFixed(1)}/10'),
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
                      movie.overview,
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
