import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../constants/colors.dart';

enum BadgeSize { small, medium, large }

class StatusBadge extends StatelessWidget {
  final String status;
  final BadgeSize size;

  const StatusBadge({
    super.key,
    required this.status,
    this.size = BadgeSize.medium,
  });

  IconData _icon() {
    switch (status) {
      case 'low':
        return FeatherIcons.arrowDown;
      case 'high':
        return FeatherIcons.arrowUp;
      default:
        return FeatherIcons.checkCircle;
    }
  }

  String _label() {
    switch (status) {
      case 'low':
        return 'LOW';
      case 'high':
        return 'HIGH';
      default:
        return 'NORMAL';
    }
  }

  double _iconSize() {
    switch (size) {
      case BadgeSize.small:
        return 10;
      case BadgeSize.medium:
        return 12;
      case BadgeSize.large:
        return 14;
    }
  }

  double _fontSize() {
    switch (size) {
      case BadgeSize.small:
        return 9;
      case BadgeSize.medium:
        return 10;
      case BadgeSize.large:
        return 12;
    }
  }

  EdgeInsets _padding() {
    switch (size) {
      case BadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case BadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case BadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = AppColors.statusColors(status, isDark);

    return Container(
      padding: _padding(),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppColors.badgeRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon(), size: _iconSize(), color: colors.foreground),
          SizedBox(width: size == BadgeSize.small ? 3 : 4),
          Text(
            _label(),
            style: TextStyle(
              color: colors.foreground,
              fontSize: _fontSize(),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
