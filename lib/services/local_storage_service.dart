import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/glucose_reading.dart';
import '../models/alert_item.dart';
import '../models/recommendation.dart';
import '../models/pump_simulation.dart';
import '../models/user_profile.dart';
import '../models/notification_settings.dart';
import '../models/chat_message.dart';

class LocalStorageService {
  static const _readingsKey = 'readings';
  static const _alertsKey = 'alerts';
  static const _recommendationsKey = 'recommendations';
  static const _pumpHistoryKey = 'pumpHistory';
  static const _userKey = 'user';
  static const _notificationSettingsKey = 'notificationSettings';
  static const _themeModeKey = 'themeMode';
  static const _languageKey = 'language';
  static const _isLoggedInKey = 'isLoggedIn';
  static const _hasCompletedOnboardingKey = 'hasCompletedOnboarding';
  static const _chatKey = 'chat_messages';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Readings ──
  Future<void> saveReadings(List<GlucoseReading> readings) async {
    final json = jsonEncode(readings.map((r) => r.toJson()).toList());
    await _prefs.setString(_readingsKey, json);
  }

  List<GlucoseReading> loadReadings() {
    final json = _prefs.getString(_readingsKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => GlucoseReading.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ── Alerts ──
  Future<void> saveAlerts(List<AlertItem> alerts) async {
    final json = jsonEncode(alerts.map((a) => a.toJson()).toList());
    await _prefs.setString(_alertsKey, json);
  }

  List<AlertItem> loadAlerts() {
    final json = _prefs.getString(_alertsKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => AlertItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ── Recommendations ──
  Future<void> saveRecommendations(List<RecommendationItem> recs) async {
    final json = jsonEncode(recs.map((r) => r.toJson()).toList());
    await _prefs.setString(_recommendationsKey, json);
  }

  List<RecommendationItem> loadRecommendations() {
    final json = _prefs.getString(_recommendationsKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => RecommendationItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ── Pump History ──
  Future<void> savePumpHistory(List<PumpSimulationItem> items) async {
    final json = jsonEncode(items.map((p) => p.toJson()).toList());
    await _prefs.setString(_pumpHistoryKey, json);
  }

  List<PumpSimulationItem> loadPumpHistory() {
    final json = _prefs.getString(_pumpHistoryKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => PumpSimulationItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ── User ──
  Future<void> saveUser(UserProfile? user) async {
    if (user == null) {
      await _prefs.remove(_userKey);
    } else {
      await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    }
  }

  UserProfile? loadUser() {
    final json = _prefs.getString(_userKey);
    if (json == null) return null;
    return UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  // ── Notification Settings ──
  Future<void> saveNotificationSettings(NotificationSettingsModel settings) async {
    await _prefs.setString(_notificationSettingsKey, jsonEncode(settings.toJson()));
  }

  NotificationSettingsModel loadNotificationSettings() {
    final json = _prefs.getString(_notificationSettingsKey);
    if (json == null) return const NotificationSettingsModel();
    return NotificationSettingsModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  // ── Theme ──
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }

  String loadThemeMode() {
    return _prefs.getString(_themeModeKey) ?? 'system';
  }

  // ── Language ──
  Future<void> saveLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }

  String loadLanguage() {
    return _prefs.getString(_languageKey) ?? 'en';
  }

  // ── Auth ──
  Future<void> saveIsLoggedIn(bool value) async {
    await _prefs.setBool(_isLoggedInKey, value);
  }

  bool loadIsLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  // ── Onboarding ──
  Future<void> saveHasCompletedOnboarding(bool value) async {
    await _prefs.setBool(_hasCompletedOnboardingKey, value);
  }

  bool loadHasCompletedOnboarding() {
    return _prefs.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  // ── Chat ──
  Future<void> saveChatMessages(List<ChatMessage> messages) async {
    final json = jsonEncode(messages.map((m) => m.toJson()).toList());
    await _prefs.setString(_chatKey, json);
  }

  List<ChatMessage> loadChatMessages() {
    final json = _prefs.getString(_chatKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList();
  }
}
