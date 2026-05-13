import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/recipe_detail/recipe_detail_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/favorites/favorites_screen.dart';
import '../../presentation/screens/meal_plan/meal_plan_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/categories/categories_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/shell/main_shell.dart';

class AppRouter {
  static final _rootKey = GlobalKey<NavigatorState>();
  static final _shellKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
          GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
          GoRoute(path: '/meal-plan', builder: (_, __) => const MealPlanScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(path: '/categories', builder: (_, __) => const CategoriesScreen()),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/recipe/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RecipeDetailScreen(recipeId: id),
            transitionsBuilder: (ctx, anim, _, child) {
              return SlideTransition(
                position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                    .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}
