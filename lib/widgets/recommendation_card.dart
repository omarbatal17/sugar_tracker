import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../constants/colors.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final String iconName;
  final bool isSaved;
  final VoidCallback? onToggleSave;
  final VoidCallback? onTap;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.iconName,
    this.isSaved = false,
    this.onToggleSave,
    this.onTap,
  });

  IconData _resolveIcon() {
    switch (iconName) {
      case 'activity':
        return FeatherIcons.activity;
      case 'coffee':
        return FeatherIcons.coffee;
      case 'heart':
        return FeatherIcons.heart;
      case 'droplet':
        return FeatherIcons.droplet;
      case 'shopping-bag':
        return FeatherIcons.shoppingBag;
      case 'trending-up':
        return FeatherIcons.trendingUp;
      default:
        return FeatherIcons.star;
    }
  }

  Color _categoryColor(bool isDark) {
    final palette = isDark ? AppColors.dark : AppColors.light;
    switch (category) {
      case 'meal':
        return AppColors.statusColors('high', isDark).foreground;
      case 'exercise':
        return AppColors.statusColors('normal', isDark).foreground;
      case 'lifestyle':
        return palette.secondary;
      case 'tip':
        return palette.primary;
      default:
        return palette.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final catColor = _categoryColor(isDark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(AppColors.cardRadius),
          border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
          boxShadow: [
            BoxShadow(color: palette.shadow, blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: catColor.withAlpha(25),
                borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
              ),
              child: Icon(_resolveIcon(), size: 20, color: catColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: catColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        color: catColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onToggleSave,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  size: 22,
                  color: isSaved ? palette.primary : palette.mutedForeground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
