import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/recipe/recipe_bloc.dart';
import '../../../data/models/recipe_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text('All Cuisines', style: Theme.of(context).textTheme.headlineMedium),
            ),
            Expanded(
              child: BlocBuilder<RecipeBloc, RecipeState>(
                builder: (context, state) {
                  if (state is RecipeLoaded) {
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1.15,
                        crossAxisSpacing: 14, mainAxisSpacing: 14,
                      ),
                      itemCount: state.categories.length,
                      itemBuilder: (_, i) => _CategoryCard(
                        category: state.categories[i],
                        onTap: () {},
                      ).animate(delay: (i * 50).ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
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

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _hexToColor(category.color);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withOpacity(0.12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image with low opacity
              Opacity(
                opacity: 0.15,
                child: Image.network(category.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox()),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(category.icon, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(category.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    Text('${category.recipeCount} recipes', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}
