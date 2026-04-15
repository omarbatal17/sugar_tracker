class GlucoseReading {
  final String id;
  final int value;
  final String status;
  final String timestamp;
  final String mealContext;
  final String? note;

  const GlucoseReading({
    required this.id,
    required this.value,
    required this.status,
    required this.timestamp,
    required this.mealContext,
    this.note,
  });

  GlucoseReading copyWith({
    String? id,
    int? value,
    String? status,
    String? timestamp,
    String? mealContext,
    String? note,
  }) {
    return GlucoseReading(
      id: id ?? this.id,
      value: value ?? this.value,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      mealContext: mealContext ?? this.mealContext,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'value': value,
    'status': status,
    'timestamp': timestamp,
    'mealContext': mealContext,
    'note': note,
  };

  factory GlucoseReading.fromJson(Map<String, dynamic> json) {
    return GlucoseReading(
      id: json['id'] as String,
      value: json['value'] as int,
      status: json['status'] as String,
      timestamp: json['timestamp'] as String,
      mealContext: json['mealContext'] as String,
      note: json['note'] as String?,
    );
  }

  static String computeStatus(int value) {
    if (value < 80) return 'low';
    if (value > 180) return 'high';
    return 'normal';
  }
}
