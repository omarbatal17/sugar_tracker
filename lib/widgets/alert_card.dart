import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../constants/colors.dart';

class AlertCard extends StatelessWidget {
  final String severity;
  final String type;
  final String title;
  final String message;
  final String timeAgo;
  final bool isRead;
  final VoidCallback? onTap;

  const AlertCard({
    super.key,
    required this.severity,
    required this.type,
    required this.title,
    required this.message,
    required this.timeAgo,
    this.isRead = false,
    this.onTap,
  });

  IconData _typeIcon() {
    switch (type) {
      case 'high':
        return FeatherIcons.arrowUp;
      case 'low':
        return FeatherIcons.arrowDown;
      default:
        return FeatherIcons.info;
    }
  }

  Color _severityColor(bool isDark) {
    switch (severity) {
      case 'critical':
        return AppColors.statusColors('low', isDark).foreground;
      case 'warning':
        return AppColors.statusColors('high', isDark).foreground;
      default:
        return isDark ? AppColors.dark.primary : AppColors.light.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final severityClr = _severityColor(isDark);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isRead ? palette.card : palette.card,
          borderRadius: BorderRadius.circular(AppColors.cardRadius),
          border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
          boxShadow: [
            BoxShadow(color: palette.shadow, blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Severity stripe
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: severityClr,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppColors.cardRadius),
                    bottomLeft: Radius.circular(AppColors.cardRadius),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: severityClr.withAlpha(25),
                          borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
                        ),
                        child: Icon(_typeIcon(), size: 18, color: severityClr),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: palette.mutedForeground,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              timeAgo,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: palette.mutedForeground,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: palette.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
