import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  final ApiService apiService;
  bool isLoading = false;
  List<Movie> popularMovies = [];
  String? errorMessage;

  MovieProvider({required this.apiService});

  Future<void> fetchPopularMovies() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.get('/discover/movie');
      final List results = response['results'];
      popularMovies = results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      errorMessage = 'Failed to fetch movies: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
