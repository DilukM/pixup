import 'package:pixup/models/movie.dart';

class MovieResponse {
  final List<Movie> movies;
  final int currentPage;
  final int totalPages;
  final int totalResults;

  MovieResponse({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      movies: (json['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList(),
      currentPage: json['page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
