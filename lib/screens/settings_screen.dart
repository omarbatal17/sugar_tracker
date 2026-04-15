import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final ns = appState.notificationSettings;

    return Scaffold(
      appBar: AppBar(title: Text(tr.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          // Notifications Section
          Text(tr.t('notifications'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _ToggleTile(label: tr.t('highGlucoseAlerts'), value: ns.highGlucose, icon: FeatherIcons.arrowUp, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(highGlucose: v))),
          _ToggleTile(label: tr.t('lowGlucoseAlerts'), value: ns.lowGlucose, icon: FeatherIcons.arrowDown, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(lowGlucose: v))),
          _ToggleTile(label: tr.t('readingReminders'), value: ns.readingReminder, icon: FeatherIcons.clock, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(readingReminder: v))),
          _ToggleTile(label: tr.t('dailySummary'), value: ns.dailySummary, icon: FeatherIcons.fileText, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(dailySummary: v))),
          _ToggleTile(label: tr.t('pumpAlerts'), value: ns.pumpAlerts, icon: FeatherIcons.zap, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(pumpAlerts: v))),
          _ToggleTile(label: tr.t('appUpdates'), value: ns.appUpdates, icon: FeatherIcons.download, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(appUpdates: v))),

          const SizedBox(height: 28),

          // Appearance Section
          Text(tr.t('appearance'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          // Theme
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr.t('theme'), style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'light', label: Text(tr.t('lightMode'), style: const TextStyle(fontSize: 12))),
                    ButtonSegment(value: 'dark', label: Text(tr.t('darkMode'), style: const TextStyle(fontSize: 12))),
                    ButtonSegment(value: 'system', label: Text(tr.t('systemMode'), style: const TextStyle(fontSize: 12))),
                  ],
                  selected: {appState.themeMode},
                  onSelectionChanged: (s) => appState.setThemeMode(s.first),
                ),
              ],
            ),
          ),

          // Language
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr.t('language'), style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'en', label: Text(tr.t('english'), style: const TextStyle(fontSize: 12))),
                    ButtonSegment(value: 'ar', label: Text(tr.t('arabic'), style: const TextStyle(fontSize: 12))),
                  ],
                  selected: {appState.language},
                  onSelectionChanged: (s) => appState.setLanguage(s.first),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String label;
  final bool value;
  final IconData icon;
  final AppPalette palette;
  final ThemeData theme;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.palette,
    required this.theme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: palette.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: palette.primary,
          ),
        ],
      ),
    );
  }
}
