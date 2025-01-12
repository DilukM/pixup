import 'package:flutter/foundation.dart';
import 'package:pixup/models/movieModel.dart';
import '../services/api_service.dart';

class MovieProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Movie> _movies = [];
  bool _isLoading = false;
  String _error = '';

  MovieProvider() {
    _initializeMovies();
  }

  Future<void> _initializeMovies() async {
    _isLoading = true;
    notifyListeners();
    try {
      _movies = await _apiService.getAllMovies();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> searchMovies(String query) async {


    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _movies = await _apiService.getAllMovies();
    } catch (e) {
      _error = e.toString();
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
