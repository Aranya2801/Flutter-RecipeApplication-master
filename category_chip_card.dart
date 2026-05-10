import 'package:flutter/material.dart';
import '../../../data/models/recipe_model.dart';

class CategoryChipCard extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final VoidCallback onTap;
  const CategoryChipCard({super.key, required this.category, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _hexToColor(category.color);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 90,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
              textAlign: TextAlign.center,
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${category.recipeCount}',
              style: TextStyle(fontSize: 10, color: color.withOpacity(0.7), fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}
