import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onClose;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        title: title,
        onClose: () => Navigator.of(context).pop(),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppColors.cardRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: palette.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: palette.mutedForeground),
                ),
              ],
            ),
          ),
          Divider(color: palette.border, height: 1),
          // Content
          Flexible(child: child),
        ],
      ),
    );
  }
}
