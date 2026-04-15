import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final ns = appState.notificationSettings;

    return Scaffold(
      appBar: AppBar(title: Text(tr.t('notifications'))),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          _NotifTile(label: tr.t('highGlucoseAlerts'), desc: tr.t('highGlucoseAlertsDesc'), value: ns.highGlucose, icon: FeatherIcons.arrowUp, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(highGlucose: v))),
          _NotifTile(label: tr.t('lowGlucoseAlerts'), desc: tr.t('lowGlucoseAlertsDesc'), value: ns.lowGlucose, icon: FeatherIcons.arrowDown, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(lowGlucose: v))),
          _NotifTile(label: tr.t('readingReminders'), desc: tr.t('readingRemindersDesc'), value: ns.readingReminder, icon: FeatherIcons.clock, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(readingReminder: v))),
          _NotifTile(label: tr.t('dailySummary'), desc: tr.t('dailySummaryDesc'), value: ns.dailySummary, icon: FeatherIcons.fileText, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(dailySummary: v))),
          _NotifTile(label: tr.t('pumpAlerts'), desc: tr.t('pumpAlertsDesc'), value: ns.pumpAlerts, icon: FeatherIcons.zap, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(pumpAlerts: v))),
          _NotifTile(label: tr.t('appUpdates'), desc: tr.t('appUpdatesDesc'), value: ns.appUpdates, icon: FeatherIcons.download, palette: palette, theme: theme,
            onChanged: (v) => appState.updateNotificationSettings(ns.copyWith(appUpdates: v))),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final String label;
  final String desc;
  final bool value;
  final IconData icon;
  final AppPalette palette;
  final ThemeData theme;
  final ValueChanged<bool> onChanged;

  const _NotifTile({
    required this.label,
    required this.desc,
    required this.value,
    required this.icon,
    required this.palette,
    required this.theme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: palette.primaryContainer.withAlpha(60),
              borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
            ),
            child: Icon(icon, size: 18, color: palette.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(desc, style: theme.textTheme.labelSmall?.copyWith(color: palette.mutedForeground)),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged, activeTrackColor: palette.primary),
        ],
      ),
    );
  }
}
