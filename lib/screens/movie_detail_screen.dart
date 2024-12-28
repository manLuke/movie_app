import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/movie_detail_provider.dart';
import '../providers/favorites_provider.dart';

@RoutePage()
class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({
    super.key,
    @PathParam('movieId') required this.movieId,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final detailProvider =
          Provider.of<MovieDetailProvider>(context, listen: false);
      detailProvider.fetchMovieDetail(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<MovieDetailProvider>(context);
    final movieDetail = detailProvider.movieDetail;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Movie Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: detailProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            )
          : detailProvider.errorMessage != null
              ? Center(
                  child: Text(
                    detailProvider.errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                )
              : movieDetail == null
                  ? const Center(
                      child: Text(
                        'Movie details not found.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (movieDetail.backdropPath != null)
                            Image.network(
                              'https://image.tmdb.org/t/p/w500${movieDetail.backdropPath}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        movieDetail.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Consumer<FavoritesProvider>(
                                      builder:
                                          (context, favoritesProvider, _) =>
                                              IconButton(
                                        icon: Icon(
                                          favoritesProvider
                                                  .isFavorite(movieDetail.id)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.redAccent,
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          favoritesProvider
                                              .toggleFavorite(movieDetail);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.yellow, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      movieDetail.voteAverage
                                          .toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Genres: ${movieDetail.genres.join(', ')}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Overview',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movieDetail.overview,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Release Date: ${movieDetail.releaseDate.toLocal().toIso8601String().split('T').first}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Runtime: ${movieDetail.runtime} minutes',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Budget: \$${movieDetail.budget.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
