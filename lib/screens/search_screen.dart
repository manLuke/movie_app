import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_search_provider.dart';
import '../widgets/movie_card.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    final searchProvider =
        Provider.of<MovieSearchProvider>(context, listen: false);
    searchController = TextEditingController(text: searchProvider.searchQuery);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<MovieSearchProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Search Movies',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: searchProvider.searchMovies,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.blueGrey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
              ),
            ),
          ),
          if (searchProvider.isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            )
          else if (searchProvider.errorMessage != null)
            Center(
              child: Text(
                searchProvider.errorMessage!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            )
          else if (searchProvider.searchResults.isEmpty &&
              searchController.text.isNotEmpty)
            const Center(
              child: Text(
                'No results found.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: searchProvider.searchResults.length,
                itemBuilder: (context, index) {
                  final movie = searchProvider.searchResults[index];
                  return MovieCard(
                    id: movie.id,
                    title: movie.title,
                    description: movie.overview,
                    imageUrl: movie.posterPath,
                    rating: movie.voteAverage,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
