import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/meal_plan/meal_plan_bloc.dart';
import '../../blocs/recipe/recipe_bloc.dart';
import '../../../data/models/recipe_model.dart';
import '../../widgets/common/recipe_picker_sheet.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});
  @override State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedDayIndex = DateTime.now().weekday - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildDaySelector(context),
            Expanded(child: _buildDayMeals(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: BlocBuilder<MealPlanBloc, MealPlanState>(
        builder: (ctx, state) {
          final total = state is MealPlanLoaded ? state.totalCalories : 0;
          final count = state is MealPlanLoaded ? state.totalMealsPlanned : 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Weekly Meal Plan', style: Theme.of(context).textTheme.headlineMedium)),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () => ctx.read<MealPlanBloc>().add(ClearWeekEvent()),
                    tooltip: 'Clear week',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _PlanStat(icon: Icons.restaurant_menu_rounded, label: '$count meals planned', color: AppTheme.brandPrimary),
                  const SizedBox(width: 12),
                  _PlanStat(icon: Icons.local_fire_department_rounded, label: '$total total calories', color: AppTheme.brandSecondary),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context) {
    final days = MealPlanBloc.weekDays;
    final today = DateTime.now().weekday - 1;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: days.length,
          itemBuilder: (_, i) {
            final isSelected = i == _selectedDayIndex;
            final isToday = i == today;
            return GestureDetector(
              onTap: () => setState(() => _selectedDayIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.brandPrimary : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: isToday && !isSelected
                      ? Border.all(color: AppTheme.brandPrimary, width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      days[i].substring(0, 3),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                    if (isToday) Container(
                      width: 5, height: 5, margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppTheme.brandPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: (i * 40).ms).fadeIn().slideX(begin: 0.2, end: 0),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayMeals(BuildContext context) {
    final day = MealPlanBloc.weekDays[_selectedDayIndex];
    return BlocBuilder<MealPlanBloc, MealPlanState>(
      builder: (ctx, state) {
        if (state is! MealPlanLoaded) return const Center(child: CircularProgressIndicator());
        final dayMeals = state.week[day] ?? {};
        return ListView(
          padding: const EdgeInsets.all(20),
          children: MealPlanBloc.mealTypes.asMap().entries.map((entry) {
            final meal = entry.value;
            final recipe = dayMeals[meal];
            return _MealSlot(
              mealType: meal,
              recipe: recipe,
              index: entry.key,
              onAdd: () => _showRecipePicker(ctx, day, meal),
              onRemove: () => ctx.read<MealPlanBloc>().add(RemoveMealEvent(day: day, mealType: meal)),
              onTap: recipe != null ? () => context.push('/recipe/${recipe.id}') : null,
            );
          }).toList(),
        );
      },
    );
  }

  void _showRecipePicker(BuildContext ctx, String day, String mealType) {
    final recipeState = ctx.read<RecipeBloc>().state;
    List<RecipeModel> recipes = [];
    if (recipeState is RecipeLoaded) {
      recipes = [...recipeState.featuredRecipes, ...recipeState.trendingRecipes];
    }
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecipePickerSheet(
        recipes: recipes,
        onSelect: (recipe) {
          ctx.read<MealPlanBloc>().add(AssignMealEvent(day: day, mealType: mealType, recipe: recipe));
        },
      ),
    );
  }
}

class _MealSlot extends StatelessWidget {
  final String mealType;
  final RecipeModel? recipe;
  final int index;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback? onTap;
  const _MealSlot({required this.mealType, required this.recipe, required this.index,
    required this.onAdd, required this.onRemove, this.onTap});

  static const _icons = {'breakfast': '🌅', 'lunch': '☀️', 'dinner': '🌙', 'snack': '🍎'};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: recipe != null ? onTap : onAdd,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: recipe != null
                ? AppTheme.brandPrimary.withOpacity(0.3)
                : Theme.of(context).colorScheme.outline),
          ),
          child: recipe != null ? _FilledSlot(recipe: recipe!, mealType: mealType, onRemove: onRemove)
              : _EmptySlot(mealType: mealType),
        ),
      ).animate(delay: (index * 80).ms).fadeIn().slideY(begin: 0.1, end: 0),
    );
  }
}

class _FilledSlot extends StatelessWidget {
  final RecipeModel recipe;
  final String mealType;
  final VoidCallback onRemove;
  const _FilledSlot({required this.recipe, required this.mealType, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(recipe.imageUrl, width: 60, height: 60, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(width: 60, height: 60,
              color: AppTheme.brandPrimary.withOpacity(0.1))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mealType.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                  letterSpacing: 1, color: AppTheme.brandPrimary)),
              const SizedBox(height: 4),
              Text(recipe.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('${recipe.caloriesPerServing} cal • ${recipe.totalTimeMin} min',
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
        ),
        IconButton(icon: const Icon(Icons.close_rounded, size: 18), onPressed: onRemove,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  final String mealType;
  const _EmptySlot({required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: AppTheme.brandPrimary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.brandPrimary.withOpacity(0.2), style: BorderStyle.solid),
          ),
          child: Center(child: Text({'breakfast': '🌅', 'lunch': '☀️', 'dinner': '🌙', 'snack': '🍎'}[mealType] ?? '🍽️',
              style: const TextStyle(fontSize: 26))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(mealType[0].toUpperCase() + mealType.substring(1),
              style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text('Tap to add a recipe', style: TextStyle(fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
          ]),
        ),
        Icon(Icons.add_circle_outline_rounded, color: AppTheme.brandPrimary, size: 28),
      ],
    );
  }
}

class _PlanStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _PlanStat({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }
}
