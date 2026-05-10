import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/recipe/recipe_bloc.dart';
import '../../blocs/favorites/favorites_bloc.dart';
import '../../../data/models/recipe_model.dart';
import '../../widgets/recipe/nutrition_chart.dart';
import '../../widgets/recipe/ingredient_tile.dart';
import '../../widgets/recipe/step_tile.dart';
import '../../widgets/common/difficulty_badge.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _servings = 4;
  int _activeStep = 0;

  // Timers map: stepIndex -> (secondsRemaining, isRunning)
  final Map<int, int> _timerSeconds = {};
  final Map<int, Timer?> _timers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<RecipeBloc>().add(LoadRecipeDetailEvent(widget.recipeId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final t in _timers.values) t?.cancel();
    super.dispose();
  }

  void _startTimer(int stepIndex, int totalSeconds) {
    _timers[stepIndex]?.cancel();
    setState(() => _timerSeconds[stepIndex] = totalSeconds);
    _timers[stepIndex] = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if ((_timerSeconds[stepIndex] ?? 0) > 0) {
          _timerSeconds[stepIndex] = _timerSeconds[stepIndex]! - 1;
        } else {
          t.cancel();
          _showTimerDone(stepIndex);
        }
      });
    });
  }

  void _showTimerDone(int stepIndex) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.timer_off_rounded, color: Colors.white),
          const SizedBox(width: 10),
          Text('Step ${stepIndex + 1} timer complete! 🎉'),
        ]),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeDetailLoading || state is RecipeLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is RecipeDetailLoaded) {
          return _buildDetail(context, state);
        }
        return const Scaffold(body: Center(child: Text('Recipe not found')));
      },
    );
  }

  Widget _buildDetail(BuildContext context, RecipeDetailLoaded state) {
    final recipe = state.recipe.copyWith(servings: _servings);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHero(context, recipe, state),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildQuickInfo(context, recipe),
                _buildServingsScaler(context, recipe),
                _buildTabBar(context),
                _buildTabContent(context, recipe, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildHero(BuildContext context, RecipeModel recipe, RecipeDetailLoaded state) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      stretch: true,
      backgroundColor: AppTheme.darkBackground,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
      ),
      actions: [
        BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (ctx, favState) {
            final isFav = favState is FavoritesLoaded
                ? favState.isFavorite(recipe.id)
                : state.isFavorite;
            return GestureDetector(
              onTap: () => ctx.read<FavoritesBloc>().add(ToggleFavoriteEvent(recipe)),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  color: isFav ? AppTheme.error : Colors.white,
                ),
              ),
            );
          },
        ),
        GestureDetector(
          onTap: () => Share.share('Check out this recipe: ${recipe.title}'),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.share_rounded, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              recipe.imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppTheme.brandPrimary.withOpacity(0.2),
                child: const Icon(Icons.restaurant_menu_rounded, size: 80, color: AppTheme.brandPrimary),
              ),
            ),
            const DecoratedBox(decoration: BoxDecoration(gradient: AppTheme.heroGradient)),
            Positioned(
              bottom: 20, left: 20, right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      DifficultyBadge(difficulty: recipe.difficulty),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(recipe.category,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    recipe.title,
                    style: const TextStyle(color: Colors.white, fontSize: 26,
                        fontWeight: FontWeight.w800, height: 1.2, shadows: [
                      Shadow(blurRadius: 10, color: Colors.black54),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: recipe.rating,
                        itemCount: 5,
                        itemSize: 16,
                        itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppTheme.brandGold),
                      ),
                      const SizedBox(width: 6),
                      Text('${recipe.rating} (${recipe.ratingCount} reviews)',
                        style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const Spacer(),
                      Text('by ${recipe.author}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(BuildContext context, RecipeModel recipe) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          _InfoItem(icon: Icons.timer_outlined, label: 'Prep', value: '${recipe.prepTimeMin}m'),
          _Divider(),
          _InfoItem(icon: Icons.local_fire_department_outlined, label: 'Cook', value: '${recipe.cookTimeMin}m'),
          _Divider(),
          _InfoItem(icon: Icons.people_outline_rounded, label: 'Serves', value: '${recipe.servings}'),
          _Divider(),
          _InfoItem(icon: Icons.bolt_outlined, label: 'Cals', value: '${recipe.caloriesPerServing}'),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildServingsScaler(BuildContext context, RecipeModel recipe) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.brandPrimary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.brandPrimary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.people_rounded, color: AppTheme.brandPrimary, size: 20),
            const SizedBox(width: 10),
            Text('Servings', style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.brandPrimary, fontWeight: FontWeight.w600)),
            const Spacer(),
            _ScalerButton(
              icon: Icons.remove_rounded,
              onTap: () { if (_servings > 1) setState(() => _servings--); },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('$_servings', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.brandPrimary, fontWeight: FontWeight.w800)),
            ),
            _ScalerButton(
              icon: Icons.add_rounded,
              onTap: () { if (_servings < 20) setState(() => _servings++); },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppTheme.brandPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          tabs: const [
            Tab(text: 'Ingredients'),
            Tab(text: 'Method'),
            Tab(text: 'Nutrition'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, RecipeModel recipe, RecipeDetailLoaded state) {
    return SizedBox(
      height: 600,
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildIngredients(context, recipe),
          _buildSteps(context, recipe),
          _buildNutrition(context, recipe),
        ],
      ),
    );
  }

  Widget _buildIngredients(BuildContext context, RecipeModel recipe) {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (recipe.storage != null) ...[
          _StorageTip(tip: recipe.storage!),
          const SizedBox(height: 16),
        ],
        ...recipe.ingredients.asMap().entries.map((entry) =>
          IngredientTile(
            ingredient: entry.value,
            index: entry.key,
          ).animate(delay: (entry.key * 50).ms).fadeIn().slideX(begin: 0.1, end: 0),
        ),
      ],
    );
  }

  Widget _buildSteps(BuildContext context, RecipeModel recipe) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipe.steps.length,
      itemBuilder: (_, i) {
        final step = recipe.steps[i];
        final remaining = _timerSeconds[i];
        return StepTile(
          step: step,
          index: i,
          isActive: i == _activeStep,
          timerRemaining: remaining,
          onTap: () => setState(() => _activeStep = i),
          onStartTimer: step.hasTimer
              ? () => _startTimer(i, step.timerSeconds!)
              : null,
        ).animate(delay: (i * 60).ms).fadeIn().slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _buildNutrition(BuildContext context, RecipeModel recipe) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      child: NutritionChart(nutrition: recipe.nutrition, servings: _servings),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppTheme.brandPrimary, size: 22),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.5));
  }
}

class _ScalerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ScalerButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: AppTheme.brandPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _StorageTip extends StatelessWidget {
  final String tip;
  const _StorageTip({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppTheme.info, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(tip, style: TextStyle(color: AppTheme.info, fontSize: 13))),
        ],
      ),
    );
  }
}
