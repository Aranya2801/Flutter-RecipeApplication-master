import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/recipe_model.dart';
import '../../blocs/favorites/favorites_bloc.dart';
import '../common/difficulty_badge.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;
  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.network(
                    recipe.imageUrl,
                    width: 120, height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 120, height: 120,
                      color: AppTheme.brandPrimary.withOpacity(0.1),
                      child: const Icon(Icons.restaurant_menu_rounded, color: AppTheme.brandPrimary, size: 36),
                    ),
                  ),
                  if (recipe.isTrending)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.brandPrimary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('🔥', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Difficulty
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.brandPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            recipe.cuisine,
                            style: const TextStyle(color: AppTheme.brandPrimary, fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Spacer(),
                        DifficultyBadge(difficulty: recipe.difficulty, compact: true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Stats Row
                    Row(
                      children: [
                        _Stat(icon: Icons.timer_outlined, value: '${recipe.totalTimeMin}m'),
                        const SizedBox(width: 12),
                        _Stat(icon: Icons.local_fire_department_outlined, value: '${recipe.caloriesPerServing}'),
                        const Spacer(),
                        // Favorite
                        BlocBuilder<FavoritesBloc, FavoritesState>(
                          builder: (ctx, state) {
                            final isFav = state is FavoritesLoaded && state.isFavorite(recipe.id);
                            return GestureDetector(
                              onTap: () => ctx.read<FavoritesBloc>().add(ToggleFavoriteEvent(recipe)),
                              child: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                size: 20,
                                color: isFav ? AppTheme.error : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppTheme.brandGold),
                        const SizedBox(width: 3),
                        Text(
                          '${recipe.rating} (${_formatCount(recipe.ratingCount)})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  const _Stat({required this.icon, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
      const SizedBox(width: 3),
      Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
    ]);
  }
}
