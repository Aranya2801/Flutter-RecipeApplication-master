import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/recipe_model.dart';

class RecipePickerSheet extends StatefulWidget {
  final List<RecipeModel> recipes;
  final Function(RecipeModel) onSelect;
  const RecipePickerSheet({super.key, required this.recipes, required this.onSelect});
  @override State<RecipePickerSheet> createState() => _RecipePickerSheetState();
}

class _RecipePickerSheetState extends State<RecipePickerSheet> {
  String _query = '';
  List<RecipeModel> get _filtered => widget.recipes.where((r) =>
    r.title.toLowerCase().contains(_query.toLowerCase())
  ).toList();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.outline, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pick a Recipe', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final r = _filtered[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(r.imageUrl, width: 52, height: 52, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 52, height: 52,
                          color: AppTheme.brandPrimary.withOpacity(0.1))),
                    ),
                    title: Text(r.title, style: Theme.of(context).textTheme.titleSmall),
                    subtitle: Text('${r.totalTimeMin} min • ${r.caloriesPerServing} cal',
                      style: Theme.of(context).textTheme.bodySmall),
                    trailing: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: AppTheme.brandPrimary.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.add_rounded, color: AppTheme.brandPrimary, size: 18),
                    ),
                    onTap: () {
                      widget.onSelect(r);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
