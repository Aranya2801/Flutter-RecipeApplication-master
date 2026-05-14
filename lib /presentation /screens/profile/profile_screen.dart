import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../blocs/favorites/favorites_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildProfileHeader(context),
              _buildStatsRow(context),
              const SizedBox(height: 24),
              _buildSection(context, 'Preferences', [
                _SettingTile(icon: Icons.notifications_outlined, title: 'Notifications', subtitle: 'Recipe reminders & tips', trailing: Switch.adaptive(value: true, onChanged: (_) {}, activeColor: AppTheme.brandPrimary)),
                _SettingTile(icon: Icons.dark_mode_outlined, title: 'Dark Mode', subtitle: 'Switch app appearance', trailing: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (ctx, ts) => Switch.adaptive(value: ts.isDark, onChanged: (_) => ctx.read<ThemeBloc>().add(ToggleThemeEvent()), activeColor: AppTheme.brandPrimary),
                )),
                _SettingTile(icon: Icons.language_outlined, title: 'Units', subtitle: 'Metric (g, ml, °C)', onTap: () {}),
                _SettingTile(icon: Icons.person_outline_rounded, title: 'Dietary Preferences', subtitle: 'Vegetarian, Gluten-free...', onTap: () {}),
              ]),
              _buildSection(context, 'About', [
                _SettingTile(icon: Icons.star_outline_rounded, title: 'Rate the App', subtitle: 'Love it? Tell us!', onTap: () {}),
                _SettingTile(icon: Icons.share_outlined, title: 'Share Saveur', subtitle: 'Invite friends', onTap: () {}),
                _SettingTile(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () {}),
                _SettingTile(icon: Icons.info_outline_rounded, title: 'Version', subtitle: '2.0.0 (MIT-grade build)', onTap: () {}),
              ]),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  gradient: AppTheme.brandGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.elevatedShadow,
                ),
                child: const Center(child: Text('👨‍🍳', style: TextStyle(fontSize: 44))),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.brandPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                  ),
                  child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Home Chef', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Aspiring culinary artist 🍴', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppTheme.brandGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('✨ Intermediate Chef', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildStatsRow(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (ctx, state) {
        final favCount = state is FavoritesLoaded ? state.favorites.length : 0;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Row(
            children: [
              _StatItem(value: '$favCount', label: 'Saved', icon: Icons.favorite_rounded, color: AppTheme.error),
              _VertDivider(),
              _StatItem(value: '0', label: 'Cooked', icon: Icons.check_circle_rounded, color: AppTheme.success),
              _VertDivider(),
              _StatItem(value: '7', label: 'Day Streak', icon: Icons.local_fire_department_rounded, color: AppTheme.brandSecondary),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> tiles) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              letterSpacing: 0.5,
            )),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Column(children: tiles),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatItem({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 48, color: Theme.of(context).colorScheme.outline.withOpacity(0.5));
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _SettingTile({required this.icon, required this.title, this.subtitle, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppTheme.brandPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.brandPrimary, size: 20),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: subtitle != null ? Text(subtitle!, style: Theme.of(context).textTheme.bodySmall) : null,
      trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)) : null),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
