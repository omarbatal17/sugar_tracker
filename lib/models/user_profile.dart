class UserProfile {
  final String name;
  final String email;
  final int age;
  final String diabetesType;
  final int targetRangeMin;
  final int targetRangeMax;

  const UserProfile({
    required this.name,
    required this.email,
    required this.age,
    required this.diabetesType,
    required this.targetRangeMin,
    required this.targetRangeMax,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    int? age,
    String? diabetesType,
    int? targetRangeMin,
    int? targetRangeMax,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      diabetesType: diabetesType ?? this.diabetesType,
      targetRangeMin: targetRangeMin ?? this.targetRangeMin,
      targetRangeMax: targetRangeMax ?? this.targetRangeMax,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'age': age,
    'diabetesType': diabetesType,
    'targetRangeMin': targetRangeMin,
    'targetRangeMax': targetRangeMax,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      diabetesType: json['diabetesType'] as String,
      targetRangeMin: json['targetRangeMin'] as int,
      targetRangeMax: json['targetRangeMax'] as int,
    );
  }
}
