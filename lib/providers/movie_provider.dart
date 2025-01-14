import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixup/models/movie.dart';
import '../services/api_service.dart';

// MovieProvider class to manage movie-related state
class MovieProvider extends ChangeNotifier {
  final ApiService _apiService =
      ApiService(); // Instance of ApiService to handle API requests

  // Lists to store different categories of movies
  List<Movie> _movies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _topRatedMovies = [];

  // Variables to manage loading state and errors
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMorePages = true;

  // Getters to access the state
  List<Movie> get movies => _movies;
  List<Movie> get PopularMovies => _popularMovies;
  List<Movie> get TopRatedMovies => _topRatedMovies;
  List<Movie> get UpcomingMovies => _upcomingMovies;
  List<Movie> get NowPlayingMovies => _nowPlayingMovies;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMorePages => _hasMorePages;

// Method to search for movies
  Future<void> searchMovies(String query, String genreIds) async {
    try {
      _isLoading = true;
      _error = '';
      _currentPage = 1;
      notifyListeners();

      final response = await _apiService.searchMovies(
        query,
        genreIds: genreIds,
        page: _currentPage,
      );

      _movies = response.movies;
      _totalPages = response.totalPages;
      _hasMorePages = _currentPage < _totalPages;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// Method to load more movies for pagination
  Future<void> loadMoreMovies(String query, String genreIds) async {
    if (_isLoading || !_hasMorePages) return;

    try {
      _isLoading = true;
      notifyListeners();

      final nextPage = _currentPage + 1;
      final response = await _apiService.searchMovies(
        query,
        genreIds: genreIds,
        page: nextPage,
      );

      _movies.addAll(response.movies);
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;
      _hasMorePages = _currentPage < _totalPages;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to load popular movies
  Future<void> loadPopularMovies() async {
    if (_isLoading || !_hasMorePages) return;

    try {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final nextPage = _currentPage + 1;
      final response = await _apiService.getPopular();

      _popularMovies.addAll(response.movies);
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;
      _hasMorePages = _currentPage < _totalPages;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

// Method to load top rated movies
  Future<void> loadTopRatedMovies() async {
    if (_isLoading || !_hasMorePages) return;

    try {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final nextPage = _currentPage + 1;
      final response = await _apiService.getTopRated();

      _topRatedMovies.addAll(response.movies);
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;
      _hasMorePages = _currentPage < _totalPages;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Method to load now playing movies
  Future<void> loadNowPlayinMovies() async {
    if (_isLoading || !_hasMorePages) return;

    try {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final nextPage = _currentPage + 1;
      final response = await _apiService.getNowPlaying();

      _nowPlayingMovies.addAll(response.movies);
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;
      _hasMorePages = _currentPage < _totalPages;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Method to load upcoming movies
  Future<void> loadUpcomingMovies() async {
    if (_isLoading || !_hasMorePages) return;

    try {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final nextPage = _currentPage + 1;
      final response = await _apiService.getUpcoming();

      _upcomingMovies.addAll(response.movies);
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;
      _hasMorePages = _currentPage < _totalPages;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

// Method to reset the search state
  void resetSearch() {
    _movies = [];
    _currentPage = 1;
    _totalPages = 1;
    _hasMorePages = true;
    _error = '';
    notifyListeners();
  }
}
