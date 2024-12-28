import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movie_app/screens/login_screen.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:movie_app/screens/search_screen.dart';
import 'package:movie_app/screens/movie_detail_screen.dart';
import 'package:movie_app/screens/account_screen.dart';
import 'package:movie_app/screens/main_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: "/login", page: LoginRoute.page, initial: true),
        AutoRoute(
          path: "/main",
          page: MainRoute.page,
          children: [
            AutoRoute(
              path: "home",
              page: HomeRoute.page,
            ),
            AutoRoute(path: "search", page: SearchRoute.page),
            AutoRoute(path: "account", page: AccountRoute.page),
          ],
        ),
        AutoRoute(path: '/detail/:movieId', page: MovieDetailRoute.page),
      ];
}
