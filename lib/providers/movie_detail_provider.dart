import 'package:flutter/foundation.dart';
import '../models/movie_detail.dart';
import '../services/api_service.dart';

class MovieDetailProvider with ChangeNotifier {
  final ApiService apiService;
  bool isLoading = false;
  MovieDetail? movieDetail;
  String? errorMessage;

  MovieDetailProvider({required this.apiService});

  Future<void> fetchMovieDetail(int movieId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.get('/movie/$movieId');
      movieDetail = MovieDetail.fromJson(response);
    } catch (e) {
      errorMessage = 'Failed to fetch movie details: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
