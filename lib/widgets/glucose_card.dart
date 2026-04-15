import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'status_badge.dart';

class GlucoseCard extends StatelessWidget {
  final String title;
  final int value;
  final String status;
  final String lastUpdated;
  final String unit;
  final VoidCallback? onTap;

  const GlucoseCard({
    super.key,
    required this.title,
    required this.value,
    required this.status,
    required this.lastUpdated,
    this.unit = 'mg/dL',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final statusColor = AppColors.statusColors(status, isDark);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(AppColors.cardPadding),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(AppColors.cardRadius),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: palette.mutedForeground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 8,
                        children: [
                          Text(
                            '$value',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 72,
                              height: 1.0,
                              color: statusColor.foreground,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              unit,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: palette.mutedForeground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lastUpdated,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 24),
            // Range bar restored to its position
            _RangeBar(value: value, statusColor: statusColor),
          ],
        ),
      ),
    );
  }
}

class _RangeBar extends StatelessWidget {
  final int value;
  final StatusColors statusColor;

  const _RangeBar({required this.value, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    // Map value 40–400 to 0–1
    final clampedValue = value.clamp(40, 400);
    final position = (clampedValue - 40) / (400 - 40);

    // Markers at 80 and 180
    const marker80 = (80 - 40) / (400 - 40);
    const marker180 = (180 - 40) / (400 - 40);

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      children: [
        SizedBox(
          height: 12,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Full Background bar (Empty Track)
                  Positioned(
                    top: 4,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2E3238) : const Color(0xFFE2E4E9),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  // Filled bar (Current Value Progress)
                  Positioned.directional(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    start: 0,
                    top: 4,
                    child: Container(
                      width: width * position,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor.foreground, // E.g. Solid Green for Normal
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  // Marker at 80 (Lower limit of normal)
                  Positioned.directional(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    start: width * marker80,
                    top: 2,
                    child: Container(
                      width: 2,
                      height: 10,
                      color: AppColors.statusColors('normal', isDark).foreground.withAlpha(200),
                    ),
                  ),
                  // Marker at 180 (Upper limit of normal, start of high)
                  Positioned.directional(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    start: width * marker180,
                    top: 2,
                    child: Container(
                      width: 2,
                      height: 10,
                      color: AppColors.statusColors('high', isDark).foreground,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('40', style: theme.textTheme.labelSmall?.copyWith(
              color: palette.mutedForeground, fontSize: 10,
            )),
            Text('80–180', style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.statusColors('normal', isDark).foreground,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            )),
            Text('400', style: theme.textTheme.labelSmall?.copyWith(
              color: palette.mutedForeground, fontSize: 10,
            )),
          ],
        ),
      ],
    );
  }
}
