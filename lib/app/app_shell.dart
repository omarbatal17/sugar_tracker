import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';
import '../screens/chatbot_screen.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static const _tabPaths = [
    '/tabs/dashboard',
    '/tabs/history',
    '/tabs/reports',
    '/tabs/profile',
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _tabPaths.length; i++) {
      if (location.startsWith(_tabPaths[i])) return i;
    }
    return 0;
  }

  void _showChatbot(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: ChatbotScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final currentIndex = _currentIndex(context);

    return Scaffold(
      extendBody: true,
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showChatbot(context),
        backgroundColor: palette.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: !kIsWeb && _isIOS() ? palette.tabBar.withAlpha(200) : palette.tabBar,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        padding: EdgeInsets.zero,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(context, 0, currentIndex, FeatherIcons.home, tr.t('dashboard'), palette, theme, tr),
            _buildTabItem(context, 1, currentIndex, FeatherIcons.clock, tr.t('history'), palette, theme, tr),
            const SizedBox(width: 40), // Space for FAB
            _buildTabItem(context, 2, currentIndex, FeatherIcons.barChart2, tr.t('reports'), palette, theme, tr),
            _buildTabItem(context, 3, currentIndex, FeatherIcons.user, tr.t('profile'), palette, theme, tr),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    int index,
    int current,
    IconData icon,
    String label,
    AppPalette palette,
    ThemeData theme,
    AppTranslation tr,
  ) {
    final isActive = index == current;
    final color = isActive ? palette.primary : palette.mutedForeground;
    final isRTL = tr.isRTL;

    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(_tabPaths[index]),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.flip(
              flipX: isRTL,
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  bool _isIOS() {
    return !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS);
  }
}

