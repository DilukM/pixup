import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pixup/models/genre.dart';
import 'package:pixup/models/movie.dart';
import 'package:pixup/models/movie_response.dart';

// ApiService class to handle API requests
class ApiService {
  static final String baseUrl = "https://api.themoviedb.org/3";
  static final String apiKey = "ad6fd113e364ff58fbfd2c8e80545f84";
  static final String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

  // Method to fetch genres
  Future<List<Genre>> getGenres() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=en'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final genres = data['genres'] as List;
        return genres.map((genre) => Genre.fromJson(genre)).toList();
      } else {
        throw Exception('Failed to fetch genres');
      }
    } catch (e) {
      throw Exception('Error fetching genres: $e');
    }
  }

  // Method to fetch popular movies
  Future<MovieResponse> getPopular() async {
    try {
      final Uri uri =
          Uri.parse('$baseUrl/movie/popular?language=en-US&api_key=$apiKey');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  // Method to fetch top-rated movies
  Future<MovieResponse> getTopRated() async {
    try {
      final Uri uri =
          Uri.parse('$baseUrl/movie/top_rated?language=en-US&api_key=$apiKey');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  // Method to fetch upcoming movies
  Future<MovieResponse> getUpcoming() async {
    try {
      final Uri uri =
          Uri.parse('$baseUrl/movie/upcoming?language=en-US&api_key=$apiKey');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  // Method to fetch now playing movies
  Future<MovieResponse> getNowPlaying() async {
    try {
      final Uri uri = Uri.parse(
          '$baseUrl/movie/now_playing?language=en-US&api_key=$apiKey');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  // Method to search for movies
  Future<MovieResponse> searchMovies(
    String query, {
    String genreIds = '',
    int page = 1,
  }) async {
    try {
      if (query.isEmpty) {
        return getAllMovies(genreIds: genreIds, page: page);
      }

      final Uri uri = Uri.parse('$baseUrl/search/movie').replace(
        queryParameters: {
          'api_key': apiKey,
          'query': query,
          'with_genres': genreIds,
          'page': page.toString(),
          'include_adult': 'false',
        }..removeWhere((key, value) => value.isEmpty),
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieResponse.fromJson(data);
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  // Method to fetch all movies with optional filters
  Future<MovieResponse> getAllMovies({
    String genreIds = '',
    int page = 1,
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/discover/movie').replace(
        queryParameters: {
          'api_key': apiKey,
          'with_genres': genreIds,
          'page': page.toString(),
          'include_adult': 'false',
          'sort_by': 'popularity.desc',
        }..removeWhere((key, value) => value.isEmpty),
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }
}
