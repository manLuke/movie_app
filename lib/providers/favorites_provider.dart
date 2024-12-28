import 'package:flutter/foundation.dart';
import 'package:movie_app/models/movie_detail.dart';
import 'package:movie_app/providers/auth_provider.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class FavoritesProvider with ChangeNotifier {
  final ApiService apiService;
  final AuthProvider authProvider;

  bool isLoading = false;
  List<Movie> favoriteMovies = [];
  String? errorMessage;

  FavoritesProvider({
    required this.apiService,
    required this.authProvider,
  });

  Future<void> fetchFavorites() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final accountId = authProvider.user?.id;
      if (accountId == null) throw Exception('User not authenticated');

      final response = await apiService.get(
        '/account/$accountId/favorite/movies',
        params: {
          'language': 'en-US',
          'page': '1',
          'sort_by': 'created_at.asc',
        },
      );

      final List results = response['results'];
      favoriteMovies = results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      errorMessage = 'Failed to fetch favorites: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(int movieId) {
    return favoriteMovies.any((movie) => movie.id == movieId);
  }

  Future<void> toggleFavorite(MovieDetail movieDetail) async {
    final accountId = authProvider.user?.id;
    if (accountId == null) throw Exception('User not authenticated');
    final isAdding = !isFavorite(movieDetail.id);

    try {
      await apiService.post(
        '/account/$accountId/favorite',
        body: {
          'media_type': 'movie',
          'media_id': movieDetail.id,
          'favorite': isAdding,
        },
      );

      if (isAdding) {
        favoriteMovies.add(movieDetail.toMovie());
      } else {
        favoriteMovies.removeWhere((fav) => fav.id == movieDetail.id);
      }

      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to update favorites: $e';
    }
  }
}
