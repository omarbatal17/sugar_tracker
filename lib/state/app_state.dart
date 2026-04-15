import 'dart:math';
import 'package:flutter/material.dart';
import '../models/glucose_reading.dart';
import '../models/alert_item.dart';
import '../models/recommendation.dart';
import '../models/pump_simulation.dart';
import '../models/user_profile.dart';
import '../models/notification_settings.dart';
import '../services/local_storage_service.dart';
import '../services/mock_data_service.dart';
import '../models/chat_message.dart';
import '../hooks/app_translation.dart';

class AppState extends ChangeNotifier {
  final LocalStorageService _storage;

  // ── State Shape ──
  String themeMode = 'system'; // light | dark | system
  String language = 'en';
  bool get isRTL => language == 'ar';
  bool isLoggedIn = false;
  UserProfile? user;
  bool hasCompletedOnboarding = false;
  List<GlucoseReading> readings = [];
  List<AlertItem> alerts = [];
  List<RecommendationItem> recommendations = [];
  List<PumpSimulationItem> pumpHistory = [];
  NotificationSettingsModel notificationSettings = const NotificationSettingsModel();
  List<ChatMessage> chatMessages = [];

  bool _initialized = false;
  bool get initialized => _initialized;

  AppState(this._storage);

  // ── Initialization ──
  Future<void> init() async {
    await _storage.init();

    themeMode = _storage.loadThemeMode();
    language = _storage.loadLanguage();
    isLoggedIn = _storage.loadIsLoggedIn();
    hasCompletedOnboarding = _storage.loadHasCompletedOnboarding();
    user = _storage.loadUser();
    notificationSettings = _storage.loadNotificationSettings();

    // Load persisted data or fall back to mock data
    readings = _storage.loadReadings();
    alerts = _storage.loadAlerts();
    recommendations = _storage.loadRecommendations();
    pumpHistory = _storage.loadPumpHistory();
    chatMessages = _storage.loadChatMessages();

    if (readings.isEmpty) {
      readings = MockDataService.generateReadings();
      await _storage.saveReadings(readings);
    }
    if (alerts.isEmpty) {
      alerts = MockDataService.mockAlerts();
      await _storage.saveAlerts(alerts);
    }
    if (recommendations.isEmpty) {
      recommendations = MockDataService.mockRecommendations();
      await _storage.saveRecommendations(recommendations);
    }

    _initialized = true;
    notifyListeners();
  }

  // ── ID Generation ──
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextDouble().toString();
  }

  // ── Reading Actions ──
  Future<void> addReading(GlucoseReading reading) async {
    readings.insert(0, reading);
    await _storage.saveReadings(readings);

    // Auto-create alert if out of range
    if (reading.status == 'high') {
      final alert = AlertItem(
        id: _generateId(),
        type: 'high',
        title: 'High Glucose Detected',
        titleAr: 'اكتشاف ارتفاع الجلوكوز',
        message: 'Your blood sugar reading of ${reading.value} mg/dL is above the target range.',
        messageAr: 'قراءة سكر الدم ${reading.value} مغ/دل أعلى من النطاق المستهدف.',
        severity: 'critical',
        timestamp: DateTime.now().toIso8601String(),
        relatedReadingId: reading.id,
      );
      alerts.insert(0, alert);
      await _storage.saveAlerts(alerts);
    } else if (reading.status == 'low') {
      final alert = AlertItem(
        id: _generateId(),
        type: 'low',
        title: 'Low Glucose Warning',
        titleAr: 'تحذير من انخفاض الجلوكوز',
        message: 'Your blood sugar reading of ${reading.value} mg/dL is below the target range.',
        messageAr: 'قراءة سكر الدم ${reading.value} مغ/دل أقل من النطاق المستهدف.',
        severity: 'warning',
        timestamp: DateTime.now().toIso8601String(),
        relatedReadingId: reading.id,
      );
      alerts.insert(0, alert);
      await _storage.saveAlerts(alerts);
    }

    notifyListeners();
  }

  Future<void> updateReading(String id, GlucoseReading updated) async {
    final index = readings.indexWhere((r) => r.id == id);
    if (index != -1) {
      readings[index] = updated;
      await _storage.saveReadings(readings);
      notifyListeners();
    }
  }

  Future<void> deleteReading(String id) async {
    readings.removeWhere((r) => r.id == id);
    await _storage.saveReadings(readings);
    notifyListeners();
  }

  // ── Alert Actions ──
  Future<void> markAlertRead(String id) async {
    final index = alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      alerts[index] = alerts[index].copyWith(read: true);
      await _storage.saveAlerts(alerts);
      notifyListeners();
    }
  }

  Future<void> deleteAlert(String id) async {
    alerts.removeWhere((a) => a.id == id);
    await _storage.saveAlerts(alerts);
    notifyListeners();
  }

  Future<void> markAllAlertsRead() async {
    alerts = alerts.map((a) => a.copyWith(read: true)).toList();
    await _storage.saveAlerts(alerts);
    notifyListeners();
  }

  int get unreadAlertCount => alerts.where((a) => !a.read).length;

  // ── Recommendation Actions ──
  Future<void> toggleSaveRecommendation(String id) async {
    final index = recommendations.indexWhere((r) => r.id == id);
    if (index != -1) {
      recommendations[index] = recommendations[index].copyWith(
        saved: !recommendations[index].saved,
      );
      await _storage.saveRecommendations(recommendations);
      notifyListeners();
    }
  }

  // ── Pump Actions ──
  Future<void> addPumpSimulation(PumpSimulationItem sim) async {
    pumpHistory.insert(0, sim);
    await _storage.savePumpHistory(pumpHistory);
    notifyListeners();
  }

  // ── Theme ──
  Future<void> setThemeMode(String mode) async {
    themeMode = mode;
    await _storage.saveThemeMode(mode);
    notifyListeners();
  }

  // ── Language ──
  Future<void> setLanguage(String lang) async {
    language = lang;
    await _storage.saveLanguage(lang);
    notifyListeners();
  }

  // ── Auth ──
  Future<void> login(String email, String password) async {
    // Simulate 1s delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock auth — accept any non-empty credentials
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    isLoggedIn = true;
    user ??= MockDataService.mockUser().copyWith(email: email);
    await _storage.saveIsLoggedIn(true);
    await _storage.saveUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    isLoggedIn = false;
    await _storage.saveIsLoggedIn(false);
    notifyListeners();
  }

  Future<void> setUser(UserProfile profile) async {
    user = profile;
    await _storage.saveUser(user);
    notifyListeners();
  }

  // ── Notification Settings ──
  Future<void> updateNotificationSettings(NotificationSettingsModel settings) async {
    notificationSettings = settings;
    await _storage.saveNotificationSettings(settings);
    notifyListeners();
  }

  // ── Onboarding ──
  Future<void> completeOnboarding() async {
    hasCompletedOnboarding = true;
    await _storage.saveHasCompletedOnboarding(true);
    notifyListeners();
  }

  // ── Chat Actions ──
  Future<void> sendMessage(String text) async {
    final userMsg = ChatMessage(
      id: _generateId(),
      text: text,
      isBot: false,
      timestamp: DateTime.now(),
    );
    chatMessages.add(userMsg);
    await _storage.saveChatMessages(chatMessages);
    notifyListeners();

    // Simulated automated response
    await Future.delayed(const Duration(milliseconds: 800));
    final botMsg = ChatMessage(
      id: _generateId(),
      text: _getChatReply(text),
      isBot: true,
      timestamp: DateTime.now(),
    );
    chatMessages.add(botMsg);
    await _storage.saveChatMessages(chatMessages);
    notifyListeners();
  }

  Future<void> clearChat() async {
    chatMessages.clear();
    await _storage.saveChatMessages(chatMessages);
    notifyListeners();
  }

  String _getChatReply(String query) {
    final q = query.toLowerCase();
    final tr = AppTranslation(language);

    if (q.contains('high') || q.contains('ارتفاع') || q.contains('مرتفع')) {
      return tr.t('chatbotHighReply');
    } else if (q.contains('low') || q.contains('انخفاض') || q.contains('منخفض')) {
      return tr.t('chatbotLowReply');
    } else if (q.contains('pump') || q.contains('مضخة')) {
      return tr.t('chatbotPumpReply');
    } else if (q.contains('report') || q.contains('تقرير')) {
      return tr.t('chatbotReportReply');
    } else if (q.contains('reading') || q.contains('قراءة') || q.contains('قياس')) {
      return tr.t('chatbotReadingReply');
    }
    return tr.t('chatbotDefaultReply');
  }
}
