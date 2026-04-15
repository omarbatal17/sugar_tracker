import '../constants/colors.dart';

class AppColorsProvider {
  final bool isDark;

  AppColorsProvider({required this.isDark});

  AppPalette get palette => isDark ? AppColors.dark : AppColors.light;

  StatusColors statusColor(String status) {
    return AppColors.statusColors(status, isDark);
  }
}
