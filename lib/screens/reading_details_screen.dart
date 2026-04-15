import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';
import '../widgets/status_badge.dart';

class ReadingDetailsScreen extends StatelessWidget {
  final String readingId;

  const ReadingDetailsScreen({super.key, required this.readingId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final reading = appState.readings.where((r) => r.id == readingId).firstOrNull;

    if (reading == null) {
      return Scaffold(
        appBar: AppBar(title: Text(tr.t('readingDetails'))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FeatherIcons.alertCircle, size: 64, color: palette.mutedForeground),
              const SizedBox(height: 16),
              Text(tr.t('readingNotFound'), style: theme.textTheme.titleMedium),
            ],
          ),
        ),
      );
    }

    final statusColors = AppColors.statusColors(reading.status, isDark);

    String mealLabel;
    switch (reading.mealContext) {
      case 'before':
        mealLabel = tr.t('beforeMeal');
        break;
      case 'after':
        mealLabel = tr.t('afterMeal');
        break;
      case 'fasting':
        mealLabel = tr.t('fasting');
        break;
      case 'bedtime':
        mealLabel = tr.t('bedtime');
        break;
      default:
        mealLabel = reading.mealContext;
    }

    String hintKey;
    switch (reading.status) {
      case 'low':
        hintKey = 'statusLowHint';
        break;
      case 'high':
        hintKey = 'statusHighHint';
        break;
      default:
        hintKey = 'statusNormalHint';
    }

    final date = DateTime.tryParse(reading.timestamp);
    final dateStr = date != null
        ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
        : reading.timestamp;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.t('readingDetails')),
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.trash2, color: palette.destructive),
            onPressed: () => _confirmDelete(context, appState, tr, palette),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          // Value card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                Text(
                  '${reading.value}',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                    color: statusColors.foreground,
                  ),
                ),
                Text(tr.t('mgdl'), style: theme.textTheme.bodyMedium?.copyWith(color: palette.mutedForeground)),
                const SizedBox(height: 12),
                StatusBadge(status: reading.status, size: BadgeSize.large),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Details
          _DetailRow(label: tr.t('mealContext'), value: mealLabel, palette: palette, theme: theme),
          _DetailRow(label: tr.t('lastUpdated'), value: dateStr, palette: palette, theme: theme),
          if (reading.note != null && reading.note!.isNotEmpty)
            _DetailRow(label: tr.t('note'), value: reading.note!, palette: palette, theme: theme),

          const SizedBox(height: 20),

          // Suggested action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColors.background,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(FeatherIcons.info, size: 18, color: statusColors.foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr.t('suggestedAction'),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: statusColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tr.t(hintKey),
                        style: theme.textTheme.bodySmall?.copyWith(color: statusColors.foreground),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppState appState, AppTranslation tr, AppPalette palette) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr.t('delete')),
        content: Text(tr.t('deleteReadingConfirm')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.cardRadius)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(tr.t('cancel'))),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              appState.deleteReading(readingId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(tr.t('readingDeleted'))),
              );
              context.pop();
            },
            child: Text(tr.t('delete'), style: TextStyle(color: palette.destructive)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final AppPalette palette;
  final ThemeData theme;

  const _DetailRow({required this.label, required this.value, required this.palette, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground)),
          Flexible(child: Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
