import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/categories_screen.dart';
import 'main_wrapper.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const SignInScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/statistics', builder: (context, state) => const StatisticsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/categories', builder: (context, state) => const CategoriesScreen()),
          ]),
        ],
      ),
    ],
  );
}