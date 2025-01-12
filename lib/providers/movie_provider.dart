import 'package:flutter/foundation.dart';
import 'package:pixup/models/movie.dart';
import '../services/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Movie> _movies = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMorePages = true;
  
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMorePages => _hasMorePages;

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

  void resetSearch() {
    _movies = [];
    _currentPage = 1;
    _totalPages = 1;
    _hasMorePages = true;
    _error = '';
    notifyListeners();
  }
}
