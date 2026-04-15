class AlertItem {
  final String id;
  final String type;
  final String title;
  final String titleAr;
  final String message;
  final String messageAr;
  final String severity;
  final String timestamp;
  final bool read;
  final String? relatedReadingId;

  const AlertItem({
    required this.id,
    required this.type,
    required this.title,
    required this.titleAr,
    required this.message,
    required this.messageAr,
    required this.severity,
    required this.timestamp,
    this.read = false,
    this.relatedReadingId,
  });

  AlertItem copyWith({
    String? id,
    String? type,
    String? title,
    String? titleAr,
    String? message,
    String? messageAr,
    String? severity,
    String? timestamp,
    bool? read,
    String? relatedReadingId,
  }) {
    return AlertItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      message: message ?? this.message,
      messageAr: messageAr ?? this.messageAr,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
      relatedReadingId: relatedReadingId ?? this.relatedReadingId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'titleAr': titleAr,
    'message': message,
    'messageAr': messageAr,
    'severity': severity,
    'timestamp': timestamp,
    'read': read,
    'relatedReadingId': relatedReadingId,
  };

  factory AlertItem.fromJson(Map<String, dynamic> json) {
    return AlertItem(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      titleAr: json['titleAr'] as String,
      message: json['message'] as String,
      messageAr: json['messageAr'] as String,
      severity: json['severity'] as String,
      timestamp: json['timestamp'] as String,
      read: json['read'] as bool? ?? false,
      relatedReadingId: json['relatedReadingId'] as String?,
    );
  }
}
