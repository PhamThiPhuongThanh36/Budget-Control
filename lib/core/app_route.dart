import 'package:budget_control/views/transactions_history_screen.dart';
import 'package:go_router/go_router.dart';
import '../views/home_screen.dart';
import '../views/sign_in_screen.dart';
import '../views/statistics_screen.dart';
import '../views/categories_screen.dart';
import '../layout/main_wrapper.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/transactions_history',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => TransactionsHistoryScreen()
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