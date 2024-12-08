import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/providers/movie_provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MaterialApp.router(
        title: 'Movie App',
        routerConfig: appRouter.config(),
      ),
    );
  }
}
