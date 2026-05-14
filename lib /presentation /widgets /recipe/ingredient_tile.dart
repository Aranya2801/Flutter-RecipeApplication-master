import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/recipe_model.dart';

class IngredientTile extends StatefulWidget {
  final Ingredient ingredient;
  final int index;
  const IngredientTile({super.key, required this.ingredient, required this.index});
  @override State<IngredientTile> createState() => _IngredientTileState();
}

class _IngredientTileState extends State<IngredientTile> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => setState(() => _checked = !_checked),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _checked
                ? AppTheme.success.withOpacity(0.08)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _checked ? AppTheme.success.withOpacity(0.4) : Theme.of(context).colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: _checked ? AppTheme.success : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: _checked ? AppTheme.success : Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: _checked
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ingredient.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: _checked ? TextDecoration.lineThrough : null,
                        color: _checked ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4) : null,
                      ),
                    ),
                    if (widget.ingredient.notes != null && widget.ingredient.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          widget.ingredient.notes!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.brandPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.ingredient.displayText.split(' ').take(2).join(' '),
                  style: const TextStyle(
                    color: AppTheme.brandPrimary, fontSize: 12, fontWeight: FontWeight.w700,
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
