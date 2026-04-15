import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';
import '../widgets/section_header.dart';
import '../widgets/status_badge.dart';

class DetailedReportScreen extends StatelessWidget {
  const DetailedReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final now = DateTime.now();
    final last7Days = appState.readings.where((r) {
      final date = DateTime.tryParse(r.timestamp);
      return date != null && now.difference(date).inDays < 7;
    }).toList();

    final avg = last7Days.isEmpty ? 0 : (last7Days.map((r) => r.value).reduce((a, b) => a + b) / last7Days.length).round();
    final normalCount = last7Days.where((r) => r.status == 'normal').length;
    final highCount = last7Days.where((r) => r.status == 'high').length;
    final lowCount = last7Days.where((r) => r.status == 'low').length;
    final tirPct = last7Days.isEmpty ? 0 : (normalCount / last7Days.length * 100).round();

    // Group by day
    final Map<String, List<dynamic>> dailyGroups = {};
    for (final reading in last7Days) {
      final date = DateTime.tryParse(reading.timestamp);
      if (date == null) continue;
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      dailyGroups.putIfAbsent(key, () => []);
      dailyGroups[key]!.add(reading);
    }
    final sortedDays = dailyGroups.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: Text(tr.t('detailedReport'))),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.primaryContainer.withAlpha(60),
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
            ),
            child: Row(
              children: [
                Icon(FeatherIcons.calendar, color: palette.primary),
                const SizedBox(width: 12),
                Text(tr.t('past7Days'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats
          SectionHeader(title: tr.t('weeklyReport')),
          const SizedBox(height: 8),
          _StatRow(label: tr.t('totalReadings'), value: '${last7Days.length}', palette: palette, theme: theme),
          _StatRow(label: tr.t('average'), value: '$avg ${tr.t('mgdl')}', palette: palette, theme: theme),
          _StatRow(label: tr.t('timeInRange'), value: '$tirPct%', palette: palette, theme: theme),
          _StatRow(label: tr.t('highReadings'), value: '$highCount', palette: palette, theme: theme, color: AppColors.statusColors('high', isDark).foreground),
          _StatRow(label: tr.t('lowReadings'), value: '$lowCount', palette: palette, theme: theme, color: AppColors.statusColors('low', isDark).foreground),
          _StatRow(label: tr.t('normalReadings'), value: '$normalCount', palette: palette, theme: theme, color: AppColors.statusColors('normal', isDark).foreground),

          const SizedBox(height: 24),

          // Daily Breakdown
          SectionHeader(title: tr.t('dailyBreakdown')),
          const SizedBox(height: 8),
          ...sortedDays.map((day) {
            final dayReadings = dailyGroups[day]!;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: palette.card,
                borderRadius: BorderRadius.circular(AppColors.cardRadius),
                border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(day, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...dayReadings.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        StatusBadge(status: r.status, size: BadgeSize.small),
                        const SizedBox(width: 8),
                        Text('${r.value} ${tr.t('mgdl')}', style: theme.textTheme.bodySmall),
                        const Spacer(),
                        Text(tr.relativeTime(r.timestamp), style: theme.textTheme.labelSmall?.copyWith(color: palette.mutedForeground)),
                      ],
                    ),
                  )),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // Observations
          SectionHeader(title: tr.t('observations')),
          const SizedBox(height: 8),
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
                _ObservationItem(text: tirPct >= 70 ? tr.t('observationGood') : tr.t('observationImprove'), icon: FeatherIcons.checkCircle, color: tirPct >= 70 ? AppColors.statusColors('normal', isDark).foreground : AppColors.statusColors('high', isDark).foreground, theme: theme),
                if (highCount > 0) _ObservationItem(text: tr.tWithParam('observationHigh', {'n': highCount.toString()}), icon: FeatherIcons.arrowUp, color: AppColors.statusColors('high', isDark).foreground, theme: theme),
                if (lowCount > 0) _ObservationItem(text: tr.tWithParam('observationLow', {'n': lowCount.toString()}), icon: FeatherIcons.arrowDown, color: AppColors.statusColors('low', isDark).foreground, theme: theme),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Follow-up
          SectionHeader(title: tr.t('followUpActions')),
          const SizedBox(height: 8),
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
                _ActionItem(text: tr.t('followUp1'), theme: theme, palette: palette),
                _ActionItem(text: tr.t('followUp2'), theme: theme, palette: palette),
                _ActionItem(text: tr.t('followUp3'), theme: theme, palette: palette),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final AppPalette palette;
  final ThemeData theme;
  final Color? color;

  const _StatRow({required this.label, required this.value, required this.palette, required this.theme, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
        border: Border.all(color: palette.border.withAlpha(60), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _ObservationItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final ThemeData theme;

  const _ObservationItem({required this.text, required this.icon, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String text;
  final ThemeData theme;
  final AppPalette palette;

  const _ActionItem({required this.text, required this.theme, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: palette.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
