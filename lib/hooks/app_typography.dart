import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  final bool isArabic;

  AppTypography({required this.isArabic});

  double get scale => isArabic ? 1.08 : 1.0;
  double get lineHeightMultiplier => isArabic ? 1.55 : 1.35;

  String get fontFamily => isArabic ? 'IBM Plex Sans Arabic' : 'Inter';

  double fs(double base) => (base * scale).roundToDouble();

  TextStyle get regular => _base(FontWeight.w400);
  TextStyle get medium => _base(FontWeight.w500);
  TextStyle get semibold => _base(FontWeight.w600);
  TextStyle get bold => _base(FontWeight.w700);

  TextStyle _base(FontWeight weight) {
    final style = TextStyle(
      fontWeight: weight,
      height: lineHeightMultiplier,
    );
    if (isArabic) {
      return GoogleFonts.ibmPlexSansArabic(textStyle: style);
    }
    return GoogleFonts.inter(textStyle: style);
  }

  /// Headline style — large titles
  TextStyle headline({double size = 24}) {
    return bold.copyWith(fontSize: fs(size));
  }

  /// Title style — section titles
  TextStyle title({double size = 18}) {
    return semibold.copyWith(fontSize: fs(size));
  }

  /// Body style — regular text
  TextStyle body({double size = 14}) {
    return regular.copyWith(fontSize: fs(size));
  }

  /// Label style — small labels
  TextStyle label({double size = 12}) {
    return medium.copyWith(fontSize: fs(size));
  }

  /// Caption style — smallest text
  TextStyle caption({double size = 11}) {
    return regular.copyWith(fontSize: fs(size));
  }
}
