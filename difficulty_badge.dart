import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DifficultyBadge extends StatelessWidget {
  final String difficulty;
  final bool compact;
  const DifficultyBadge({super.key, required this.difficulty, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final label = compact ? _shortLabel() : _label();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 9, vertical: compact ? 3 : 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(_icon(), size: 11, color: color),
            const SizedBox(width: 4),
          ],
          Text(label, style: TextStyle(color: color, fontSize: compact ? 10 : 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Color _color() {
    switch (difficulty) {
      case 'beginner': return AppTheme.beginnerColor;
      case 'advanced': return AppTheme.advancedColor;
      default: return AppTheme.intermediateColor;
    }
  }

  IconData _icon() {
    switch (difficulty) {
      case 'beginner': return Icons.sentiment_satisfied_rounded;
      case 'advanced': return Icons.local_fire_department_rounded;
      default: return Icons.trending_up_rounded;
    }
  }

  String _label() {
    switch (difficulty) {
      case 'beginner': return 'Easy';
      case 'advanced': return 'Advanced';
      default: return 'Medium';
    }
  }

  String _shortLabel() {
    switch (difficulty) {
      case 'beginner': return 'Easy';
      case 'advanced': return 'Adv';
      default: return 'Med';
    }
  }
}
