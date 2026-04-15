import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../hooks/app_translation.dart';
import '../../constants/colors.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final filtered = _filter == 'all'
        ? appState.readings
        : appState.readings.where((r) => r.status == _filter).toList();

    final filters = [
      {'key': 'all', 'label': tr.t('all')},
      {'key': 'low', 'label': tr.t('low')},
      {'key': 'normal', 'label': tr.t('normal')},
      {'key': 'high', 'label': tr.t('high')},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.t('history')),
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.plus),
            onPressed: () => context.push('/add-reading'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: filters.map((f) {
                final isActive = _filter == f['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isActive,
                    label: Text(f['label']!),
                    labelStyle: TextStyle(
                      color: isActive ? palette.primaryForeground : palette.text,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 13,
                    ),
                    backgroundColor: palette.surfaceInput,
                    selectedColor: palette.primary,
                    checkmarkColor: palette.primaryForeground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppColors.badgeRadius),
                      side: BorderSide(color: isActive ? palette.primary : palette.border),
                    ),
                    onSelected: (_) => setState(() => _filter = f['key']!),
                  ),
                );
              }).toList(),
            ),
          ),

          // List
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: FeatherIcons.inbox,
                    title: tr.t('noReadingsYet'),
                    description: tr.t('noReadingsDesc'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final reading = filtered[index];
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

                      return GestureDetector(
                        onTap: () => context.push('/reading-details/${reading.id}'),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: palette.card,
                            borderRadius: BorderRadius.circular(AppColors.cardRadius),
                            border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
                            boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: statusColors.background,
                                  borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
                                ),
                                child: Icon(FeatherIcons.activity, size: 18, color: statusColors.foreground),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${reading.value} ${tr.t('mgdl')}',
                                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(width: 8),
                                        StatusBadge(status: reading.status, size: BadgeSize.small),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$mealLabel  •  ${tr.relativeTime(reading.timestamp)}',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: palette.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(FeatherIcons.chevronRight, size: 18, color: palette.mutedForeground),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
