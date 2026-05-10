import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/recipe/recipe_bloc.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../widgets/recipe/recipe_card.dart';
import '../../widgets/recipe/featured_recipe_card.dart';
import '../../widgets/recipe/category_chip_card.dart';
import '../../widgets/common/shimmer_loader.dart';
import '../../../data/models/recipe_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _isScrolled = _scrollController.offset > 60);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, isDark),
              if (state is RecipeLoading)
                const SliverFillRemaining(child: HomeShimmer())
              else if (state is RecipeLoaded) ...[
                _buildGreetingBanner(context, state),
                _buildCategoriesSection(context, state.categories),
                _buildFeaturedSection(context, state.featuredRecipes),
                _buildTrendingSection(context, state.trendingRecipes),
                if (state.recentlyViewed.isNotEmpty)
                  _buildRecentlyViewed(context, state.recentlyViewed),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ] else if (state is RecipeError)
                SliverFillRemaining(child: _ErrorView(message: state.message)),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      snap: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: _isScrolled ? 1 : 0,
      titleSpacing: 20,
      title: Row(
        children: [
          // Logo
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: AppTheme.brandGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.restaurant_menu_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            'Saveur',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.brandPrimary,
            ),
          ),
        ],
      ),
      actions: [
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (ctx, ts) => IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                ts.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(ts.isDark),
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onPressed: () => ctx.read<ThemeBloc>().add(ToggleThemeEvent()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  SliverToBoxAdapter _buildGreetingBanner(BuildContext context, RecipeLoaded state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'What shall we cook\ntoday? 🍳',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700, height: 1.15,
              ),
            ),
            const SizedBox(height: 20),
            // Quick Stats Row
            Row(
              children: [
                _StatChip(icon: Icons.local_fire_department_rounded, label: '${state.featuredRecipes.length} Featured', color: AppTheme.brandPrimary),
                const SizedBox(width: 10),
                _StatChip(icon: Icons.trending_up_rounded, label: '${state.trendingRecipes.length} Trending', color: AppTheme.brandSecondary),
                const SizedBox(width: 10),
                _StatChip(icon: Icons.category_outlined, label: '${state.categories.length} Cuisines', color: AppTheme.brandAccent),
              ],
            ),
            const SizedBox(height: 24),
            // Search Bar Tap Target
            GestureDetector(
              onTap: () => context.go('/search'),
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                    const SizedBox(width: 12),
                    Text(
                      'Search recipes, ingredients...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Filter', style: TextStyle(color: AppTheme.brandPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
    );
  }

  SliverToBoxAdapter _buildCategoriesSection(BuildContext context, List<CategoryModel> categories) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader(title: 'Cuisines', onSeeAll: () => context.go('/categories')),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 108,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (_, i) => CategoryChipCard(
                category: categories[i],
                index: i,
                onTap: () {},
              ).animate(delay: (i * 60).ms).fadeIn().slideX(begin: 0.2, end: 0),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildFeaturedSection(BuildContext context, List<RecipeModel> recipes) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader(title: '⭐ Chef\'s Pick', onSeeAll: () {}),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 280,
            child: PageView.builder(
              padEnds: false,
              controller: PageController(viewportFraction: 0.88),
              physics: const BouncingScrollPhysics(),
              itemCount: recipes.length,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.only(left: i == 0 ? 20 : 10, right: 10),
                child: FeaturedRecipeCard(
                  recipe: recipes[i],
                  onTap: () => context.push('/recipe/${recipes[i].id}'),
                ).animate(delay: (i * 80).ms).fadeIn().scale(begin: const Offset(0.95, 0.95)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildTrendingSection(BuildContext context, List<RecipeModel> recipes) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader(title: '🔥 Trending Now', onSeeAll: () {}),
          ),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: recipes.length.clamp(0, 5),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: RecipeCard(
                recipe: recipes[i],
                onTap: () => context.push('/recipe/${recipes[i].id}'),
              ).animate(delay: (i * 100).ms).fadeIn().slideX(begin: 0.15, end: 0),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildRecentlyViewed(BuildContext context, List<RecipeModel> recipes) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader(title: '🕐 Recently Viewed', onSeeAll: null),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: recipes.length.clamp(0, 8),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _RecentRecipeTile(
                  recipe: recipes[i],
                  onTap: () => context.push('/recipe/${recipes[i].id}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, Chef! ☀️';
    if (hour < 17) return 'Good afternoon, Chef! 🌤️';
    return 'Good evening, Chef! 🌙';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'See all',
              style: TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _RecentRecipeTile extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;
  const _RecentRecipeTile({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                recipe.imageUrl,
                height: 110, width: 130, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 110, color: AppTheme.brandPrimary.withOpacity(0.1),
                  child: const Icon(Icons.restaurant_menu_rounded, color: AppTheme.brandPrimary),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title, style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${recipe.totalTimeMin} min', style: TextStyle(fontSize: 11, color: AppTheme.brandPrimary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 64, color: AppTheme.error),
          const SizedBox(height: 16),
          Text('Oops! Something went wrong', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<RecipeBloc>().add(LoadRecipesEvent()),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
