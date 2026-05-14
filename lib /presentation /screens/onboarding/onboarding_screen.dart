import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      emoji: '👨‍🍳',
      title: 'Master Any Recipe',
      subtitle: 'From beginner-friendly weeknight dinners to advanced Michelin-star techniques — guided step by step.',
      gradient: [Color(0xFFE8401C), Color(0xFFC1440F)],
    ),
    _OnboardingPage(
      emoji: '📅',
      title: 'Plan Your Week',
      subtitle: 'Drag, drop, and build your perfect weekly meal plan. Track calories and nutrition effortlessly.',
      gradient: [Color(0xFFF4A261), Color(0xFFE76F51)],
    ),
    _OnboardingPage(
      emoji: '🔥',
      title: 'Cook Like a Pro',
      subtitle: 'In-app timers, ingredient scaling, wine pairings, chef tips — everything a real kitchen needs.',
      gradient: [Color(0xFF2EC4B6), Color(0xFF1A9E93)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _OnboardingPageView(page: _pages[i], index: i),
          ),
          Positioned(
            bottom: 60, left: 0, right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8, dotWidth: 8,
                    expansionFactor: 4,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.brandPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go('/home');
                        }
                      },
                      child: Text(
                        _currentPage < _pages.length - 1 ? 'Continue' : 'Start Cooking!',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                if (_currentPage < _pages.length - 1)
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Skip', style: TextStyle(color: Colors.white70)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;
  final int index;
  const _OnboardingPageView({required this.page, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: page.gradient,
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(page.emoji, style: const TextStyle(fontSize: 100))
                  .animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 40),
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 34, fontWeight: FontWeight.w800,
                  color: Colors.white, height: 1.15,
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
              const SizedBox(height: 20),
              Text(
                page.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17, color: Colors.white,
                  height: 1.6, fontWeight: FontWeight.w400,
                ),
              ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String emoji, title, subtitle;
  final List<Color> gradient;
  const _OnboardingPage({required this.emoji, required this.title, required this.subtitle, required this.gradient});
}
