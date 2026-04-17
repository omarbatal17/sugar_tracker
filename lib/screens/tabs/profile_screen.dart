import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../hooks/app_translation.dart';
import '../../constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final user = appState.user;

    String diabetesLabel;
    switch (user?.diabetesType ?? 'type1') {
      case 'type1':
        diabetesLabel = tr.t('type1');
        break;
      case 'type2':
        diabetesLabel = tr.t('type2');
        break;
      case 'gestational':
        diabetesLabel = tr.t('gestational');
        break;
      default:
        diabetesLabel = tr.t('prediabetes');
    }

    return Scaffold(
      appBar: AppBar(title: Text(tr.t('profile'))),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          // Avatar & Info
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: palette.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: palette.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.name ?? 'User',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(label: diabetesLabel, palette: palette, theme: theme),
                    const SizedBox(width: 8),
                    _InfoChip(
                      label: '${user?.targetRangeMin ?? 80}-${user?.targetRangeMax ?? 180} ${tr.t('mgdl')}',
                      palette: palette,
                      theme: theme,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Quick Access
          _ProfileTile(
            icon: FeatherIcons.edit3,
            label: tr.t('editProfile'),
            palette: palette,
            theme: theme,
            onTap: () => context.push('/edit-profile'),
          ),
          _ProfileTile(
            icon: FeatherIcons.settings,
            label: tr.t('settings'),
            palette: palette,
            theme: theme,
            onTap: () => context.push('/settings'),
          ),
          _ProfileTile(
            icon: FeatherIcons.bell,
            label: tr.t('notifications'),
            palette: palette,
            theme: theme,
            onTap: () => context.push('/notifications'),
          ),
          _ProfileTile(
            icon: FeatherIcons.helpCircle,
            label: tr.t('helpSupport'),
            palette: palette,
            theme: theme,
            onTap: () => context.push('/help-support'),
          ),
          _ProfileTile(
            icon: FeatherIcons.messageCircle,
            label: tr.t('chatbot'),
            palette: palette,
            theme: theme,
            onTap: () => context.push('/chatbot'),
          ),

          const SizedBox(height: 24),

          // Language Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(FeatherIcons.globe, size: 20, color: palette.primary),
                      const SizedBox(width: 12),
                      Text(tr.t('language'), style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Flexible(
                  child: SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(value: 'en', label: FittedBox(child: Text(tr.t('english'), style: const TextStyle(fontSize: 11)))),
                      ButtonSegment(value: 'ar', label: FittedBox(child: Text(tr.t('arabic'), style: const TextStyle(fontSize: 11)))),
                    ],
                    selected: {appState.language},
                    onSelectionChanged: (selected) {
                      appState.setLanguage(selected.first);
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Theme Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(FeatherIcons.moon, size: 20, color: palette.primary),
                      const SizedBox(width: 12),
                      Text(tr.t('theme'), style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Flexible(
                  child: SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(value: 'light', label: FittedBox(child: Text(tr.t('lightMode'), style: const TextStyle(fontSize: 10)))),
                      ButtonSegment(value: 'dark', label: FittedBox(child: Text(tr.t('darkMode'), style: const TextStyle(fontSize: 10)))),
                      ButtonSegment(value: 'system', label: FittedBox(child: Text(tr.t('systemMode'), style: const TextStyle(fontSize: 10)))),
                    ],
                    selected: {appState.themeMode},
                    onSelectionChanged: (selected) {
                      appState.setThemeMode(selected.first);
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Logout
          SizedBox(
            width: double.infinity,
            height: AppColors.inputHeight,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context, appState, tr, palette),
              icon: Icon(FeatherIcons.logOut, size: 18, color: palette.destructive),
              label: Text(tr.t('logout'), style: TextStyle(color: palette.destructive)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: palette.destructive.withAlpha(80)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.iconPillRadius)),
              ),
            ),
          ),

          const SizedBox(height: AppColors.bottomScreenPadding),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppState appState, AppTranslation tr, AppPalette palette) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr.t('logoutConfirmTitle')),
        content: Text(tr.t('logoutConfirmMessage')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.cardRadius)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(tr.t('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              appState.logout();
              context.go('/login');
            },
            child: Text(tr.t('logout'), style: TextStyle(color: palette.destructive)),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final AppPalette palette;
  final ThemeData theme;

  const _InfoChip({required this.label, required this.palette, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: palette.surfaceInput,
        borderRadius: BorderRadius.circular(AppColors.badgeRadius),
      ),
      child: Text(label, style: theme.textTheme.labelSmall),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppPalette palette;
  final ThemeData theme;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.palette,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(AppColors.cardRadius),
          border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: palette.primary),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            Icon(FeatherIcons.chevronRight, size: 18, color: palette.mutedForeground),
          ],
        ),
      ),
    );
  }
}
