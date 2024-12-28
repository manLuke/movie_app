import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieSearchProvider with ChangeNotifier {
  final ApiService apiService;
  bool isLoading = false;
  List<Movie> searchResults = [];
  String? errorMessage;
  Timer? _debounce;

  MovieSearchProvider({required this.apiService});

  void searchMovies(String query) {
    // Debounce mechanism to avoid unnecessary API calls
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length < 3) {
        // Clear results if the query is too short
        searchResults = [];
        errorMessage = null;
        notifyListeners();
        return;
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      try {
        final response = await apiService.get('/search/movie', params: {
          'query': query,
          'include_adult': 'false',
          'language': 'en-US',
          'page': '1',
        });
        final List results = response['results'];
        searchResults = results.map((json) => Movie.fromJson(json)).toList();
      } catch (e) {
        errorMessage = 'Failed to fetch search results: $e';
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
