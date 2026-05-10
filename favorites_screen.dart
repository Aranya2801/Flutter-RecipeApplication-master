import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/favorites/favorites_bloc.dart';
import '../../widgets/recipe/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text('Saved Recipes', style: Theme.of(context).textTheme.headlineMedium),
            ),
            Expanded(
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoaded) {
                    if (state.favorites.isEmpty) return _EmptyFavorites();
                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.favorites.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Dismissible(
                          key: ValueKey(state.favorites[i].id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.delete_outline_rounded, color: AppTheme.error, size: 28),
                          ),
                          confirmDismiss: (_) async {
                            context.read<FavoritesBloc>().add(ToggleFavoriteEvent(state.favorites[i]));
                            return false;
                          },
                          child: RecipeCard(
                            recipe: state.favorites[i],
                            onTap: () => context.push('/recipe/${state.favorites[i].id}'),
                          ).animate(delay: (i * 60).ms).fadeIn().slideX(begin: 0.1, end: 0),
                        ),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: AppTheme.brandPrimary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_outline_rounded, size: 50, color: AppTheme.brandPrimary),
          ),
          const SizedBox(height: 20),
          Text('No saved recipes yet', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Tap the heart icon on any recipe\nto save it here',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Explore Recipes'),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
