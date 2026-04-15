class NotificationSettingsModel {
  final bool highGlucose;
  final bool lowGlucose;
  final bool readingReminder;
  final bool dailySummary;
  final bool pumpAlerts;
  final bool appUpdates;

  const NotificationSettingsModel({
    this.highGlucose = true,
    this.lowGlucose = true,
    this.readingReminder = true,
    this.dailySummary = false,
    this.pumpAlerts = true,
    this.appUpdates = false,
  });

  NotificationSettingsModel copyWith({
    bool? highGlucose,
    bool? lowGlucose,
    bool? readingReminder,
    bool? dailySummary,
    bool? pumpAlerts,
    bool? appUpdates,
  }) {
    return NotificationSettingsModel(
      highGlucose: highGlucose ?? this.highGlucose,
      lowGlucose: lowGlucose ?? this.lowGlucose,
      readingReminder: readingReminder ?? this.readingReminder,
      dailySummary: dailySummary ?? this.dailySummary,
      pumpAlerts: pumpAlerts ?? this.pumpAlerts,
      appUpdates: appUpdates ?? this.appUpdates,
    );
  }

  Map<String, dynamic> toJson() => {
    'highGlucose': highGlucose,
    'lowGlucose': lowGlucose,
    'readingReminder': readingReminder,
    'dailySummary': dailySummary,
    'pumpAlerts': pumpAlerts,
    'appUpdates': appUpdates,
  };

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      highGlucose: json['highGlucose'] as bool? ?? true,
      lowGlucose: json['lowGlucose'] as bool? ?? true,
      readingReminder: json['readingReminder'] as bool? ?? true,
      dailySummary: json['dailySummary'] as bool? ?? false,
      pumpAlerts: json['pumpAlerts'] as bool? ?? true,
      appUpdates: json['appUpdates'] as bool? ?? false,
    );
  }
}
