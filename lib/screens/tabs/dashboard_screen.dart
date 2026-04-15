import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../hooks/app_translation.dart';
import '../../constants/colors.dart';
import '../../widgets/glucose_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/trend_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting(AppTranslation tr) {
    final hour = DateTime.now().hour;
    if (hour < 12) return tr.t('goodMorning');
    if (hour < 18) return tr.t('goodAfternoon');
    return tr.t('goodEvening');
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final latestReading = appState.readings.isNotEmpty ? appState.readings.first : null;
    final last14 = appState.readings.take(14).toList();

    // Today's stats
    final today = DateTime.now();
    final todayReadings = appState.readings.where((r) {
      final date = DateTime.tryParse(r.timestamp);
      return date != null &&
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).toList();
    final todayAvg = todayReadings.isEmpty
        ? 0
        : (todayReadings.map((r) => r.value).reduce((a, b) => a + b) / todayReadings.length).round();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: palette.headerBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _greeting(tr),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.primaryForeground.withAlpha(200),
                    fontSize: 14,
                  ),
                ),
                Text(
                  appState.user?.name ?? 'User',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: palette.primaryForeground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: palette.primaryForeground.withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(FeatherIcons.bell, color: palette.primaryForeground),
                onPressed: () => context.push('/tabs/alerts'),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          const SizedBox(height: 8),

          // Latest Reading Card
          if (latestReading != null)
            GlucoseCard(
              title: tr.t('latestReading'),
              value: latestReading.value,
              status: latestReading.status,
              lastUpdated: '${tr.t('lastUpdated')}: ${tr.relativeTime(latestReading.timestamp)}',
              unit: tr.t('mgdl'),
              onTap: () => context.push('/reading-details/${latestReading.id}'),
            )
          else
            _EmptyReadingCard(tr: tr, palette: palette, theme: theme),

          const SizedBox(height: 24),

          // Quick Actions
          SectionHeader(title: tr.t('quickActions')),
          const SizedBox(height: 12),
          _QuickActionsGrid(tr: tr, palette: palette, theme: theme),

          const SizedBox(height: 24),

          // Trend Chart
          SectionHeader(title: tr.t('glucoseTrends')),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
              boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: TrendChart(
              readings: last14,
              isRTL: tr.isRTL,
              height: 200,
            ),
          ),

          const SizedBox(height: 24),

          // Today's Summary
          SectionHeader(title: tr.t('todaySummary')),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: FeatherIcons.activity,
                  label: tr.t('average'),
                  value: todayReadings.isEmpty ? '--' : '$todayAvg',
                  color: palette.primary,
                  palette: palette,
                  theme: theme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  icon: FeatherIcons.arrowUpRight,
                  label: tr.t('highReadings'),
                  value: todayReadings.isEmpty ? '--' : '${todayReadings.map((r) => r.value).reduce((a, b) => a > b ? a : b)}',
                  color: AppColors.statusColors('high', isDark).foreground,
                  palette: palette,
                  theme: theme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  icon: FeatherIcons.arrowDownRight,
                  label: tr.t('lowReadings'),
                  value: todayReadings.isEmpty ? '--' : '${todayReadings.map((r) => r.value).reduce((a, b) => a < b ? a : b)}',
                  color: AppColors.statusColors('low', isDark).foreground,
                  palette: palette,
                  theme: theme,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'dashboard_fab',
        onPressed: () => context.push('/add-reading'),
        backgroundColor: palette.primary,
        child: Icon(FeatherIcons.plus, color: palette.primaryForeground),
      ),
    );
  }
}

class _EmptyReadingCard extends StatelessWidget {
  final AppTranslation tr;
  final AppPalette palette;
  final ThemeData theme;

  const _EmptyReadingCard({required this.tr, required this.palette, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppColors.cardPadding),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: palette.border.withAlpha(80)),
      ),
      child: Column(
        children: [
          Icon(FeatherIcons.activity, size: 40, color: palette.mutedForeground),
          const SizedBox(height: 12),
          Text(tr.t('noReadingsYet'), style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(tr.t('noReadingsDesc'), style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground)),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final AppTranslation tr;
  final AppPalette palette;
  final ThemeData theme;

  const _QuickActionsGrid({required this.tr, required this.palette, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final actions = [
      _QuickAction(FeatherIcons.plusCircle, tr.t('addReading'), palette.primary, '/add-reading'),
      _QuickAction(FeatherIcons.bell, tr.t('viewAlerts'), AppColors.statusColors('low', isDark).foreground, '/alerts'),
      _QuickAction(FeatherIcons.barChart2, tr.t('viewReports'), AppColors.statusColors('normal', isDark).foreground, '/tabs/reports'),
      _QuickAction(FeatherIcons.heart, tr.t('viewTips'), isDark ? const Color(0xFFE4B5FF) : const Color(0xFFA855F7), '/recommendations'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((action) {
        return Expanded(
          child: GestureDetector(
            onTap: () => context.push(action.route),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              decoration: BoxDecoration(
                color: palette.card,
                borderRadius: BorderRadius.circular(AppColors.cardRadius),
                border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
                boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: action.color.withAlpha(20),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(action.icon, size: 22, color: action.color),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    action.label,
                    style: theme.textTheme.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  const _QuickAction(this.icon, this.label, this.color, this.route);
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final AppPalette palette;
  final ThemeData theme;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.palette,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
        boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: palette.mutedForeground)),
        ],
      ),
    );
  }
}
