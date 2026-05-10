import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home', path: '/home'),
    _TabItem(icon: Icons.search_outlined, activeIcon: Icons.search_rounded, label: 'Search', path: '/search'),
    _TabItem(icon: Icons.favorite_outline_rounded, activeIcon: Icons.favorite_rounded, label: 'Saved', path: '/favorites'),
    _TabItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: 'Meal Plan', path: '/meal-plan'),
    _TabItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile', path: '/profile'),
  ];

  int _currentIndex(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _currentIndex(location);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20, offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 66,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isActive = i == currentIndex;
                return Expanded(
                  child: _NavItem(
                    tab: tab, isActive: isActive,
                    onTap: () => context.go(tab.path),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _TabItem tab;
  final bool isActive;
  final VoidCallback onTap;
  const _NavItem({required this.tab, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? tab.activeIcon : tab.icon,
                key: ValueKey(isActive),
                color: isActive ? AppTheme.brandPrimary : Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? AppTheme.brandPrimary : Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon, activeIcon;
  final String label, path;
  const _TabItem({required this.icon, required this.activeIcon, required this.label, required this.path});
}
