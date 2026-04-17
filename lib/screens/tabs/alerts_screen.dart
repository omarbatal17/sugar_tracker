import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../hooks/app_translation.dart';
import '../../constants/colors.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/empty_state.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final unreadCount = appState.unreadAlertCount;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tr.t('alerts')),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: palette.primaryForeground.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unreadCount',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: palette.primaryForeground),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () => appState.markAllAlertsRead(),
              child: Text(
                tr.t('markAllRead'),
                style: TextStyle(color: palette.primaryForeground, fontSize: 13),
              ),
            ),
        ],
      ),
      body: appState.alerts.isEmpty
          ? EmptyState(
              icon: FeatherIcons.bell,
              title: tr.t('noAlerts'),
              description: tr.t('noAlertsDesc'),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: AppColors.bottomScreenPadding,
              ),
              itemCount: appState.alerts.length,
              itemBuilder: (context, index) {
                final alert = appState.alerts[index];
                return AlertCard(
                  severity: alert.severity,
                  type: alert.type,
                  title: tr.localized(alert.title, alert.titleAr),
                  message: tr.localized(alert.message, alert.messageAr),
                  timeAgo: tr.relativeTime(alert.timestamp),
                  isRead: alert.read,
                  onTap: () => context.push('/alert-details/${alert.id}'),
                );
              },
            ),
    );
  }
}
