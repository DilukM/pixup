import 'package:pixup/models/movie.dart';

// MovieResponse class to represent the response from the movie API
class MovieResponse {
  final List<Movie> movies;
  final int currentPage;
  final int totalPages;
  final int totalResults;

  // Constructor to initialize the MovieResponse object
  MovieResponse({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
    required this.totalResults,
  });

  // Factory method to create a MovieResponse object from JSON data
  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      movies: (json['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList(), // Extracting list of movies from JSON
      currentPage: json['page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
