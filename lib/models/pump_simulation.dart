class PumpSimulationItem {
  final String id;
  final int currentGlucose;
  final double suggestedDose;
  final double manualDose;
  final String timestamp;
  final bool confirmed;

  const PumpSimulationItem({
    required this.id,
    required this.currentGlucose,
    required this.suggestedDose,
    required this.manualDose,
    required this.timestamp,
    this.confirmed = false,
  });

  PumpSimulationItem copyWith({
    String? id,
    int? currentGlucose,
    double? suggestedDose,
    double? manualDose,
    String? timestamp,
    bool? confirmed,
  }) {
    return PumpSimulationItem(
      id: id ?? this.id,
      currentGlucose: currentGlucose ?? this.currentGlucose,
      suggestedDose: suggestedDose ?? this.suggestedDose,
      manualDose: manualDose ?? this.manualDose,
      timestamp: timestamp ?? this.timestamp,
      confirmed: confirmed ?? this.confirmed,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'currentGlucose': currentGlucose,
    'suggestedDose': suggestedDose,
    'manualDose': manualDose,
    'timestamp': timestamp,
    'confirmed': confirmed,
  };

  factory PumpSimulationItem.fromJson(Map<String, dynamic> json) {
    return PumpSimulationItem(
      id: json['id'] as String,
      currentGlucose: json['currentGlucose'] as int,
      suggestedDose: (json['suggestedDose'] as num).toDouble(),
      manualDose: (json['manualDose'] as num).toDouble(),
      timestamp: json['timestamp'] as String,
      confirmed: json['confirmed'] as bool? ?? false,
    );
  }
}
