import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, String?>) onApply;
  const FilterBottomSheet({super.key, required this.onApply});
  @override State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedDifficulty;
  String? _selectedCategory;
  int _maxTime = 120;
  int _maxCalories = 1000;

  static const _difficulties = ['beginner', 'intermediate', 'advanced'];
  static const _categories = ['Italian', 'Japanese', 'Thai', 'French', 'Korean', 'Mediterranean', 'British', 'Baking', 'Breakfast', 'Desserts'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.outline, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text('Filter Recipes', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDifficulty = null;
                      _selectedCategory = null;
                      _maxTime = 120;
                      _maxCalories = 1000;
                    });
                  },
                  child: const Text('Reset', style: TextStyle(color: AppTheme.brandPrimary)),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FilterSection(
                    title: 'Difficulty',
                    child: Wrap(
                      spacing: 10, runSpacing: 10,
                      children: _difficulties.map((d) => FilterChip(
                        label: Text(d[0].toUpperCase() + d.substring(1)),
                        selected: _selectedDifficulty == d,
                        onSelected: (_) => setState(() => _selectedDifficulty = _selectedDifficulty == d ? null : d),
                        selectedColor: AppTheme.brandPrimary.withOpacity(0.15),
                        checkmarkColor: AppTheme.brandPrimary,
                        labelStyle: TextStyle(color: _selectedDifficulty == d ? AppTheme.brandPrimary : null, fontWeight: FontWeight.w600),
                      )).toList(),
                    ),
                  ),
                  _FilterSection(
                    title: 'Cuisine',
                    child: Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _categories.map((c) => FilterChip(
                        label: Text(c),
                        selected: _selectedCategory == c,
                        onSelected: (_) => setState(() => _selectedCategory = _selectedCategory == c ? null : c),
                        selectedColor: AppTheme.brandPrimary.withOpacity(0.15),
                        checkmarkColor: AppTheme.brandPrimary,
                        labelStyle: TextStyle(color: _selectedCategory == c ? AppTheme.brandPrimary : null, fontWeight: FontWeight.w600),
                      )).toList(),
                    ),
                  ),
                  _FilterSection(
                    title: 'Max Cook Time: ${_maxTime} min',
                    child: Slider(
                      value: _maxTime.toDouble(),
                      min: 15, max: 240, divisions: 15,
                      activeColor: AppTheme.brandPrimary,
                      onChanged: (v) => setState(() => _maxTime = v.round()),
                    ),
                  ),
                  _FilterSection(
                    title: 'Max Calories: $_maxCalories kcal',
                    child: Slider(
                      value: _maxCalories.toDouble(),
                      min: 100, max: 2000, divisions: 19,
                      activeColor: AppTheme.brandPrimary,
                      onChanged: (v) => setState(() => _maxCalories = v.round()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply({
                          'difficulty': _selectedDifficulty,
                          'category': _selectedCategory,
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _FilterSection({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
