import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/widgets/main_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      movieProvider.fetchPopularMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Discover Today\'s Popular Movies',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blueGrey[900],
          centerTitle: true,
          elevation: 0,
        ),
        body: movieProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              )
            : movieProvider.errorMessage != null
                ? Center(
                    child: Text(
                      movieProvider.errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: movieProvider.popularMovies.length,
                    itemBuilder: (context, index) {
                      final movie = movieProvider.popularMovies[index];
                      return MovieCard(
                        title: movie.title,
                        description: movie.overview,
                        imageUrl: movie.backdropPath,
                        rating: movie.voteAverage,
                      );
                    },
                  ),
        bottomNavigationBar: const MainNavigationBar(
          currentIndex: 0,
        ));
  }
}
