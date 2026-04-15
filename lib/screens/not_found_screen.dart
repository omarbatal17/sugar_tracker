import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../hooks/app_translation.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../constants/colors.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore_off, size: 80, color: palette.mutedForeground),
              const SizedBox(height: 24),
              Text(
                '404',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: palette.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tr.t('pageNotFound'),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                tr.t('pageNotFoundDesc'),
                style: theme.textTheme.bodyMedium?.copyWith(color: palette.mutedForeground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/tabs/dashboard'),
                child: Text(tr.t('goHome')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
