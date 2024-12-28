import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/widgets/main_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/compact_movie_card.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, User!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Favorite Movies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (favoritesProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              )
            else if (favoritesProvider.favoriteMovies.isEmpty)
              const Center(
                child: Text(
                  'No favorite movies yet.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
            else
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favoritesProvider.favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favoritesProvider.favoriteMovies[index];
                    return CompactMovieCard(
                      id: movie.id,
                      title: movie.title,
                      imageUrl: movie.posterPath,
                      rating: movie.voteAverage,
                    );
                  },
                ),
              ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement logout logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(currentIndex: 2),
    );
  }
}
