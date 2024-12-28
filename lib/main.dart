import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/providers/favorites_provider.dart';
import 'package:movie_app/providers/movie_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/providers/auth_provider.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:movie_app/providers/movie_search_provider.dart';
import 'package:movie_app/services/api_service.dart';
import 'package:movie_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final router = AppRouter();
  final app = await MainApp.initialize(router);

  runApp(app);
}

class MainApp extends StatelessWidget {
  final AppRouter _router;
  late final ApiService _apiService;
  late final AuthService _authService;
  late final AuthProvider _authProvider;
  late final MovieProvider _movieProvider;
  late final MovieDetailProvider _movieDetailProvider;
  late final MovieSearchProvider _movieSearchProvider;
  late final FavoritesProvider _favoritesProvider;

  MainApp._(this._router) {
    _apiService = ApiService(
      baseUrl: dotenv.env['BASE_URL']!,
      apiKey: dotenv.env['API_KEY']!,
      accessToken: dotenv.env['API_ACCESS_TOKEN']!,
    );
    _authService = AuthService(apiService: _apiService);
    _authProvider = AuthProvider(authService: _authService, router: _router);
    _movieProvider = MovieProvider(apiService: _apiService);
    _movieDetailProvider = MovieDetailProvider(apiService: _apiService);
    _movieSearchProvider = MovieSearchProvider(apiService: _apiService);
    _favoritesProvider =
        FavoritesProvider(apiService: _apiService, authProvider: _authProvider);

    _authProvider.setFavoritesProvider(_favoritesProvider);
  }

  static Future<MainApp> initialize(AppRouter router) async {
    final app = MainApp._(router);
    await app._authProvider.initializeApp();
    await app._favoritesProvider.fetchFavorites();
    return app;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _movieProvider),
        ChangeNotifierProvider.value(value: _movieDetailProvider),
        ChangeNotifierProvider.value(value: _movieSearchProvider),
        ChangeNotifierProvider.value(value: _favoritesProvider),
      ],
      child: MaterialApp.router(
        title: 'Movie App',
        debugShowCheckedModeBanner: false,
        routeInformationParser: _router.defaultRouteParser(),
        routerDelegate: AutoRouterDelegate(_router),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
