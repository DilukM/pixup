import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pixup/models/movieModel.dart';

class ApiService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'ad6fd113e364ff58fbfd2c8e80545f84';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

 Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  Future<List<Movie>> getAllMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/discover/movie?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }
}
