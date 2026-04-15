import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'services/local_storage_service.dart';
import 'app/router.dart';
import 'constants/colors.dart';
import 'hooks/app_typography.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalStorageService();
  await storage.init();

  final appState = AppState(storage);
  await appState.init();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const SmartDiabetesCareApp(),
    ),
  );
}

class SmartDiabetesCareApp extends StatelessWidget {
  const SmartDiabetesCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isArabic = appState.language == 'ar';
    final typography = AppTypography(isArabic: isArabic);

    // Resolve theme mode
    ThemeMode themeMode;
    switch (appState.themeMode) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Smart Diabetes Care',
      themeMode: themeMode,
      theme: _buildTheme(AppColors.light, typography, Brightness.light),
      darkTheme: _buildTheme(AppColors.dark, typography, Brightness.dark),
      routerConfig: AppRouter.router(appState),
      locale: Locale(appState.language),
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }

  ThemeData _buildTheme(AppPalette palette, AppTypography typography, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: palette.primary,
        onPrimary: palette.primaryForeground,
        primaryContainer: palette.primaryContainer,
        secondary: palette.secondary,
        onSecondary: palette.primaryForeground,
        error: palette.destructive,
        onError: Colors.white,
        surface: palette.card,
        onSurface: palette.text,
        outline: palette.border,
      ),
      cardColor: palette.card,
      dividerColor: palette.border,
      textTheme: TextTheme(
        headlineLarge: typography.headline(size: 28).copyWith(color: palette.text),
        headlineMedium: typography.headline(size: 24).copyWith(color: palette.text),
        headlineSmall: typography.headline(size: 20).copyWith(color: palette.text),
        titleLarge: typography.title(size: 18).copyWith(color: palette.text),
        titleMedium: typography.title(size: 16).copyWith(color: palette.text),
        titleSmall: typography.title(size: 14).copyWith(color: palette.text),
        bodyLarge: typography.body(size: 16).copyWith(color: palette.text),
        bodyMedium: typography.body(size: 14).copyWith(color: palette.text),
        bodySmall: typography.body(size: 12).copyWith(color: palette.textSecondary),
        labelLarge: typography.label(size: 14).copyWith(color: palette.text),
        labelMedium: typography.label(size: 12).copyWith(color: palette.textSecondary),
        labelSmall: typography.caption(size: 11).copyWith(color: palette.textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.headerBackground,
        foregroundColor: palette.primaryForeground,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.primaryForeground,
          minimumSize: const Size(double.infinity, AppColors.inputHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
          ),
          textStyle: typography.semibold.copyWith(fontSize: typography.fs(16)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
        ),
      ),
    );
  }
}
