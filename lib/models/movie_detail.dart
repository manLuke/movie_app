import 'package:movie_app/models/movie.dart';

class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final DateTime releaseDate;
  final String? backdropPath;
  final String? posterPath;
  final List<String> genres;
  final double voteAverage;
  final double popularity;
  final int runtime;
  final int budget;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
    required this.backdropPath,
    required this.genres,
    required this.voteAverage,
    required this.popularity,
    required this.runtime,
    required this.budget,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      releaseDate: DateTime.parse(json['release_date']),
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'] ?? json['poster_path'],
      genres: (json['genres'] as List).map((g) => g['name'] as String).toList(),
      voteAverage: (json['vote_average'] as num).toDouble(),
      popularity: (json['popularity'] as num).toDouble(),
      runtime: json['runtime'],
      budget: json['budget'],
    );
  }

  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      popularity: popularity,
    );
  }
}
