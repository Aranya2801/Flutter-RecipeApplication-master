import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/recipe_model.dart';

class NutritionChart extends StatelessWidget {
  final NutritionInfo nutrition;
  final int servings;
  const NutritionChart({super.key, required this.nutrition, required this.servings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nutrition Facts', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('Per serving • $servings servings total', style: theme.textTheme.bodySmall),
        const SizedBox(height: 24),
        // Calories hero card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppTheme.brandGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Calories', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text(
                    '${nutrition.calories}',
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w800, height: 1),
                  ),
                  const Text('kcal', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 120, height: 120,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(
                        value: nutrition.proteinG * 4,
                        color: Colors.white,
                        title: '',
                        radius: 20,
                      ),
                      PieChartSectionData(
                        value: nutrition.carbsG * 4,
                        color: Colors.white.withOpacity(0.6),
                        title: '',
                        radius: 20,
                      ),
                      PieChartSectionData(
                        value: nutrition.fatG * 9,
                        color: Colors.white.withOpacity(0.3),
                        title: '',
                        radius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Macro breakdown
        Row(
          children: [
            _MacroCard(
              label: 'Protein',
              value: '${nutrition.proteinG.toStringAsFixed(0)}g',
              percentage: _percentage(nutrition.proteinG * 4, nutrition.calories),
              color: AppTheme.success,
              icon: '🥩',
            ),
            const SizedBox(width: 10),
            _MacroCard(
              label: 'Carbs',
              value: '${nutrition.carbsG.toStringAsFixed(0)}g',
              percentage: _percentage(nutrition.carbsG * 4, nutrition.calories),
              color: AppTheme.brandSecondary,
              icon: '🍞',
            ),
            const SizedBox(width: 10),
            _MacroCard(
              label: 'Fat',
              value: '${nutrition.fatG.toStringAsFixed(0)}g',
              percentage: _percentage(nutrition.fatG * 9, nutrition.calories),
              color: AppTheme.brandPrimary,
              icon: '🫒',
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Detailed nutrient rows
        _NutrientRow(label: 'Dietary Fiber', value: '${nutrition.fiberG.toStringAsFixed(0)}g', dailyPct: (nutrition.fiberG / 28 * 100).round()),
        _NutrientRow(label: 'Sugar', value: '${nutrition.sugarG.toStringAsFixed(0)}g', dailyPct: null),
        _NutrientRow(label: 'Sodium', value: '${nutrition.sodiumMg}mg', dailyPct: (nutrition.sodiumMg / 2300 * 100).round()),
        _NutrientRow(label: 'Cholesterol', value: '${nutrition.cholesterolMg}mg', dailyPct: (nutrition.cholesterolMg / 300 * 100).round()),
        const SizedBox(height: 16),
        Text(
          '* Percent Daily Values are based on a 2,000 calorie diet. Your daily values may be higher or lower depending on your calorie needs.',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  double _percentage(double macroCalories, int totalCalories) {
    if (totalCalories == 0) return 0;
    return (macroCalories / totalCalories * 100).clamp(0, 100);
  }
}

class _MacroCard extends StatelessWidget {
  final String label, value, icon;
  final double percentage;
  final Color color;
  const _MacroCard({required this.label, required this.value, required this.percentage, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: color)),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(color),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text('${percentage.toStringAsFixed(0)}% of cal', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _NutrientRow extends StatelessWidget {
  final String label, value;
  final int? dailyPct;
  const _NutrientRow({required this.label, required this.value, this.dailyPct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (dailyPct != null) ...[
            const SizedBox(width: 12),
            Text('$dailyPct%', style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700,
              color: dailyPct! > 20 ? AppTheme.error : AppTheme.success,
            )),
          ],
          const Divider(),
        ],
      ),
    );
  }
}
