import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../hooks/app_translation.dart';
import '../../constants/colors.dart';
import '../../widgets/section_header.dart';
import '../../widgets/trend_chart.dart';
import '../../widgets/empty_state.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final last14 = appState.readings.take(14).toList();

    if (last14.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(tr.t('reports'))),
        body: EmptyState(
          icon: FeatherIcons.barChart2,
          title: tr.t('weeklyReport'),
          description: tr.t('noReportData'),
        ),
      );
    }

    final avg = (last14.map((r) => r.value).reduce((a, b) => a + b) / last14.length).round();
    final normalCount = last14.where((r) => r.status == 'normal').length;
    final highCount = last14.where((r) => r.status == 'high').length;
    final lowCount = last14.where((r) => r.status == 'low').length;
    final tirPct = (normalCount / last14.length * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.t('reports')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          // Stats Grid
          SectionHeader(title: tr.t('weeklyReport')),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: [
              _ReportStatCard(
                label: tr.t('average'),
                value: '$avg',
                unit: tr.t('mgdl'),
                icon: FeatherIcons.trendingUp,
                color: palette.primary,
                palette: palette,
                theme: theme,
              ),
              _ReportStatCard(
                label: tr.t('timeInRange'),
                value: '$tirPct%',
                unit: '',
                icon: FeatherIcons.target,
                color: AppColors.statusColors('normal', isDark).foreground,
                palette: palette,
                theme: theme,
              ),
              _ReportStatCard(
                label: tr.t('highReadings'),
                value: '$highCount',
                unit: '',
                icon: FeatherIcons.arrowUp,
                color: AppColors.statusColors('high', isDark).foreground,
                palette: palette,
                theme: theme,
              ),
              _ReportStatCard(
                label: tr.t('lowReadings'),
                value: '$lowCount',
                unit: '',
                icon: FeatherIcons.arrowDown,
                color: AppColors.statusColors('low', isDark).foreground,
                palette: palette,
                theme: theme,
              ),
            ],
          ),

          const SizedBox(height: 8),
          // Total readings & normal count
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(AppColors.cardRadius),
                    border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
                  ),
                  child: Column(
                    children: [
                      Text('${last14.length}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      Text(tr.t('totalReadings'), style: theme.textTheme.labelSmall?.copyWith(color: palette.mutedForeground)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(AppColors.cardRadius),
                    border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
                  ),
                  child: Column(
                    children: [
                      Text('$normalCount', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppColors.statusColors('normal', isDark).foreground)),
                      Text(tr.t('normalReadings'), style: theme.textTheme.labelSmall?.copyWith(color: palette.mutedForeground)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Trend Chart
          SectionHeader(title: tr.t('glucoseTrends')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
              boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: TrendChart(readings: last14, isRTL: tr.isRTL, height: 200),
          ),

          const SizedBox(height: 24),

          // AI Insight
          SectionHeader(title: tr.t('aiInsight')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.primaryContainer.withAlpha(60),
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.primary.withAlpha(40)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(FeatherIcons.zap, size: 20, color: palette.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tirPct >= 70
                        ? tr.tWithParam('insightGood', {'pct': tirPct.toString()})
                        : tr.tWithParam('insightImprove', {'pct': tirPct.toString()}),
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.t('reportDownloaded'))),
                    );
                  },
                  icon: Icon(FeatherIcons.download, size: 16),
                  label: Text(tr.t('downloadReport'), style: const TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: palette.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.iconPillRadius)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr.t('reportShared'))),
                    );
                  },
                  icon: Icon(FeatherIcons.share2, size: 16),
                  label: Text(tr.t('shareReport'), style: const TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: palette.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.iconPillRadius)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Detailed Report Link
          SizedBox(
            width: double.infinity,
            height: AppColors.inputHeight,
            child: ElevatedButton(
              onPressed: () => context.push('/detailed-report'),
              child: Text(tr.t('viewDetailedReport')),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ReportStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final AppPalette palette;
  final ThemeData theme;

  const _ReportStatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.palette,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
        boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: color)),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(unit, style: theme.textTheme.labelSmall?.copyWith(color: palette.mutedForeground)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: palette.mutedForeground, fontSize: 11)),
        ],
      ),
    );
  }
}
