import 'package:flutter/material.dart';

class AppPalette {
  final Color background;
  final Color card;
  final Color primary;
  final Color primaryForeground;
  final Color primaryContainer;
  final Color secondary;
  final Color muted;
  final Color mutedForeground;
  final Color surfaceInput;
  final Color surfaceSoft;
  final Color border;
  final Color destructive;
  final Color shadow;
  final Color headerBackground;
  final Color tabBar;
  final Color text;
  final Color textSecondary;

  const AppPalette({
    required this.background,
    required this.card,
    required this.primary,
    required this.primaryForeground,
    required this.primaryContainer,
    required this.secondary,
    required this.muted,
    required this.mutedForeground,
    required this.surfaceInput,
    required this.surfaceSoft,
    required this.border,
    required this.destructive,
    required this.shadow,
    required this.headerBackground,
    required this.tabBar,
    required this.text,
    required this.textSecondary,
  });
}

class StatusColors {
  final Color foreground;
  final Color background;

  const StatusColors({required this.foreground, required this.background});
}

class AppColors {
  // ── Light Palette ──
  static const light = AppPalette(
    background: Color(0xFFF5F7FB),
    card: Color(0xFFFFFFFF),
    primary: Color(0xFF003D9B),
    primaryForeground: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDBEAFE),
    secondary: Color(0xFF004AAD),
    muted: Color(0xFFF1F5F9),
    mutedForeground: Color(0xFF94A3B8),
    surfaceInput: Color(0xFFF1F5F9),
    surfaceSoft: Color(0xFFF8FAFC),
    border: Color(0xFFE2E8F0),
    destructive: Color(0xFFEF4444),
    shadow: Color(0x1A000000),
    headerBackground: Color(0xFF003D9B),
    tabBar: Color(0xFFFFFFFF),
    text: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
  );

  // ── Dark Palette ──
  static const dark = AppPalette(
    background: Color(0xFF1A1C1E),
    card: Color(0xFF23262A),
    primary: Color(0xFFAEC6FF),
    primaryForeground: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF2E384D),
    secondary: Color(0xFFAEC6FF),
    muted: Color(0xFF353A41),
    mutedForeground: Color(0xFF9CA0AA),
    surfaceInput: Color(0xFF2A2D34),
    surfaceSoft: Color(0xFF1A1C1E),
    border: Color(0xFF353A41),
    destructive: Color(0xFFFF8A8A),
    shadow: Color(0x33000000),
    headerBackground: Color(0xFFAEC6FF),
    tabBar: Color(0xFF23262A),
    text: Color(0xFFE2E3E8),
    textSecondary: Color(0xFF9CA0AA),
  );

  // ── Status Colors ──
  static const lowLight = StatusColors(
    foreground: Color(0xFFEF4444),
    background: Color(0xFFFEE2E2),
  );
  
  static const lowDark = StatusColors(
    foreground: Color(0xFFFFB96D),
    background: Color(0xFF4C2F15),
  );

  static const normalLight = StatusColors(
    foreground: Color(0xFF22C55E),
    background: Color(0xFFDCFCE7),
  );
  
  static const normalDark = StatusColors(
    foreground: Color(0xFF6CE3A0),
    background: Color(0xFF1A3D2C),
  );

  static const highLight = StatusColors(
    foreground: Color(0xFFF59E0B),
    background: Color(0xFFFEF3C7),
  );
  
  static const highDark = StatusColors(
    foreground: Color(0xFFFF8A8A),
    background: Color(0xFF4D1F1C),
  );

  static StatusColors statusColors(String status, bool isDark) {
    switch (status) {
      case 'low':
        return isDark ? lowDark : lowLight;
      case 'high':
        return isDark ? highDark : highLight;
      default:
        return isDark ? normalDark : normalLight;
    }
  }

  // ── Geometry Constants ──
  static const double cardRadius = 20.0;
  static const double badgeRadius = 20.0;
  static const double iconPillRadius = 12.0;
  static const double cardPadding = 22.0;
  static const double inputHeight = 52.0;
  static const double rangeBarHeight = 6.0;
  static const double screenHorizontalPadding = 16.0;
  static const double bottomScreenPadding = 100.0;
  static const double sectionGap = 14.0;
}
