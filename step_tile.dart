import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/recipe_model.dart';

class StepTile extends StatelessWidget {
  final RecipeStep step;
  final int index;
  final bool isActive;
  final int? timerRemaining;
  final VoidCallback onTap;
  final VoidCallback? onStartTimer;

  const StepTile({
    super.key,
    required this.step,
    required this.index,
    required this.isActive,
    required this.onTap,
    this.timerRemaining,
    this.onStartTimer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.brandPrimary.withOpacity(0.05)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? AppTheme.brandPrimary.withOpacity(0.4) : theme.colorScheme.outline,
              width: isActive ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Step number circle
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        gradient: isActive ? AppTheme.brandGradient : null,
                        color: isActive ? null : theme.colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${step.stepNumber}',
                          style: TextStyle(
                            color: isActive ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isActive ? AppTheme.brandPrimary : null,
                        ),
                      ),
                    ),
                    // Timer badge
                    if (step.hasTimer)
                      GestureDetector(
                        onTap: onStartTimer,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: timerRemaining != null
                                ? AppTheme.warning.withOpacity(0.15)
                                : AppTheme.brandPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: timerRemaining != null
                                  ? AppTheme.warning.withOpacity(0.5)
                                  : AppTheme.brandPrimary.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                timerRemaining != null
                                    ? Icons.timer_rounded
                                    : Icons.play_circle_outline_rounded,
                                size: 14,
                                color: timerRemaining != null ? AppTheme.warning : AppTheme.brandPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                timerRemaining != null
                                    ? _formatTime(timerRemaining!)
                                    : step.formattedTimer,
                                style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700,
                                  color: timerRemaining != null ? AppTheme.warning : AppTheme.brandPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                // Expandable content when active
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isActive
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 14),
                            Text(
                              step.description,
                              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                            ),
                            if (step.tip != null) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppTheme.brandGold.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.brandGold.withOpacity(0.3)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('💡', style: TextStyle(fontSize: 16)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Chef's Tip",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700, fontSize: 12,
                                              color: AppTheme.brandGold,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(step.tip!, style: TextStyle(
                                            fontSize: 13, color: AppTheme.brandGold,
                                            height: 1.5,
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
