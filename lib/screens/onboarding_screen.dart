import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final slides = [
      _SlideData(
        icon: Icons.monitor_heart_outlined,
        title: tr.t('onboardingTitle1'),
        description: tr.t('onboardingDesc1'),
        color: palette.primary,
      ),
      _SlideData(
        icon: Icons.medical_services_outlined,
        title: tr.t('onboardingTitle2'),
        description: tr.t('onboardingDesc2'),
        color: palette.secondary,
      ),
      _SlideData(
        icon: Icons.insights_outlined,
        title: tr.t('onboardingTitle3'),
        description: tr.t('onboardingDesc3'),
        color: AppColors.statusColors('normal', isDark).foreground,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _complete,
                  child: Text(
                    tr.t('skip'),
                    style: TextStyle(color: palette.mutedForeground),
                  ),
                ),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return _buildSlide(slide, theme, palette);
                },
              ),
            ),
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? palette.primary : palette.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: AppColors.inputHeight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < slides.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _complete();
                    }
                  },
                  child: Text(
                    _currentPage < slides.length - 1
                        ? tr.t('next')
                        : tr.t('getStarted'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(_SlideData slide, ThemeData theme, AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: slide.color.withAlpha(25),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(slide.icon, size: 72, color: slide.color),
          ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            slide.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: palette.mutedForeground,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _complete() {
    context.read<AppState>().completeOnboarding();
    context.go('/login');
  }
}

class _SlideData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _SlideData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
