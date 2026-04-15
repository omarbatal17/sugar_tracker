import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/empty_state.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final filtered = _filter == 'all'
        ? appState.recommendations
        : _filter == 'saved'
            ? appState.recommendations.where((r) => r.saved).toList()
            : appState.recommendations.where((r) => r.category == _filter).toList();

    final filters = [
      {'key': 'all', 'label': tr.t('all')},
      {'key': 'meal', 'label': tr.t('meals')},
      {'key': 'exercise', 'label': tr.t('exercise')},
      {'key': 'lifestyle', 'label': tr.t('lifestyle')},
      {'key': 'tip', 'label': tr.t('tips')},
      {'key': 'saved', 'label': tr.t('saved')},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(tr.t('recommendations'))),
      body: Column(
        children: [
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
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: FeatherIcons.bookmark,
                    title: tr.t('noRecommendations'),
                    description: tr.t('noRecommendationsDesc'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final rec = filtered[index];
                      return RecommendationCard(
                        title: tr.localized(rec.title, rec.titleAr),
                        description: tr.localized(rec.description, rec.descriptionAr),
                        category: rec.category,
                        iconName: rec.icon,
                        isSaved: rec.saved,
                        onToggleSave: () {
                          appState.toggleSaveRecommendation(rec.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(rec.saved ? tr.t('removedFromFavorites') : tr.t('savedToFavorites')),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
