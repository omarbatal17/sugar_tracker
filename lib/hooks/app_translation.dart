import '../i18n/translations.dart';

class AppTranslation {
  final String language;

  AppTranslation(this.language);

  String t(String key) {
    return translations[language]?[key] ??
        translations['en']?[key] ??
        key;
  }

  bool get isRTL => language == 'ar';

  String tWithParam(String key, Map<String, String> params) {
    String result = t(key);
    params.forEach((paramKey, value) {
      result = result.replaceAll('{$paramKey}', value);
    });
    return result;
  }

  /// Returns the localized field based on current language.
  /// For models with both `title` and `titleAr` fields.
  String localized(String en, String ar) {
    return language == 'ar' ? ar : en;
  }

  /// Relative time string from an ISO 8601 timestamp.
  String relativeTime(String isoTimestamp) {
    final date = DateTime.tryParse(isoTimestamp);
    if (date == null) return isoTimestamp;

    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return t('justNow');
    if (diff.inMinutes < 60) {
      return tWithParam('minutesAgo', {'n': diff.inMinutes.toString()});
    }
    if (diff.inHours < 24) {
      return tWithParam('hoursAgo', {'n': diff.inHours.toString()});
    }
    if (diff.inDays == 1) return t('yesterday');
    return tWithParam('daysAgo', {'n': diff.inDays.toString()});
  }
}
