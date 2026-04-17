import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';

class AlertDetailsScreen extends StatelessWidget {
  final String alertId;

  const AlertDetailsScreen({super.key, required this.alertId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final alert = appState.alerts.where((a) => a.id == alertId).firstOrNull;

    if (alert == null) {
      return Scaffold(
        appBar: AppBar(title: Text(tr.t('alertDetails'))),
        body: Center(child: Text(tr.t('noAlerts'))),
      );
    }

    Color severityColor;
    switch (alert.severity) {
      case 'critical':
        severityColor = AppColors.statusColors('low', isDark).foreground;
        break;
      case 'warning':
        severityColor = AppColors.statusColors('high', isDark).foreground;
        break;
      default:
        severityColor = palette.primary;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.t('alertDetails')),
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.trash2, color: palette.destructive),
            onPressed: () {
              appState.deleteAlert(alertId);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr.t('alertDeleted'))));
              context.pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          // Severity header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: severityColor.withAlpha(20),
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: severityColor.withAlpha(60)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: severityColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    alert.type == 'high' ? FeatherIcons.arrowUp : alert.type == 'low' ? FeatherIcons.arrowDown : FeatherIcons.info,
                    size: 28,
                    color: severityColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  tr.localized(alert.title, alert.titleAr),
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: severityColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tr.t(alert.severity),
                    style: TextStyle(color: severityColor, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
            ),
            child: Text(
              tr.localized(alert.message, alert.messageAr),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ),
          const SizedBox(height: 12),

          // Timestamp
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
            ),
            child: Row(
              children: [
                Icon(FeatherIcons.clock, size: 16, color: palette.mutedForeground),
                const SizedBox(width: 8),
                Text(tr.relativeTime(alert.timestamp), style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Mark as read
          if (!alert.read)
            SizedBox(
              width: double.infinity,
              height: AppColors.inputHeight,
              child: ElevatedButton.icon(
                onPressed: () {
                  appState.markAlertRead(alertId);
                },
                icon: Icon(FeatherIcons.check, size: 18),
                label: Text(tr.t('markAsRead')),
              ),
            ),

          // Related reading link
          if (alert.relatedReadingId != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: AppColors.inputHeight,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/reading-details/${alert.relatedReadingId}'),
                icon: Icon(FeatherIcons.activity, size: 18),
                label: Text(tr.t('viewRelatedReading')),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: palette.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.iconPillRadius)),
                ),
              ),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
