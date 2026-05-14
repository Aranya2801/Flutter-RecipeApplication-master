import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/recipe_model.dart';
import '../common/difficulty_badge.dart';

class FeaturedRecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;
  const FeaturedRecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero image
              Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.brandPrimary.withOpacity(0.15),
                  child: const Icon(Icons.restaurant_menu_rounded, size: 60, color: AppTheme.brandPrimary),
                ),
              ),
              // Gradient overlay
              const DecoratedBox(decoration: BoxDecoration(gradient: AppTheme.heroGradient)),
              // Content
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags row
                      Row(
                        children: [
                          DifficultyBadge(difficulty: recipe.difficulty),
                          const SizedBox(width: 8),
                          if (recipe.tags.isNotEmpty)
                            _Tag(recipe.tags.first),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Title
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          color: Colors.white, fontSize: 20,
                          fontWeight: FontWeight.w800, height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      // Info row
                      Row(
                        children: [
                          _InfoBadge(icon: Icons.timer_outlined, label: '${recipe.totalTimeMin} min'),
                          const SizedBox(width: 10),
                          _InfoBadge(icon: Icons.local_fire_department_outlined, label: '${recipe.caloriesPerServing} cal'),
                          const Spacer(),
                          RatingBarIndicator(
                            rating: recipe.rating,
                            itemCount: 5,
                            itemSize: 14,
                            itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppTheme.brandGold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            recipe.rating.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Featured badge
              Positioned(
                top: 16, right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.brandGold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '⭐ FEATURED',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String tag;
  const _Tag(this.tag);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoBadge({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 14),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
