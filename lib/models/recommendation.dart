class RecommendationItem {
  final String id;
  final String category;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final bool saved;
  final String icon;

  const RecommendationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    this.saved = false,
    required this.icon,
  });

  RecommendationItem copyWith({
    String? id,
    String? category,
    String? title,
    String? titleAr,
    String? description,
    String? descriptionAr,
    bool? saved,
    String? icon,
  }) {
    return RecommendationItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      saved: saved ?? this.saved,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'title': title,
    'titleAr': titleAr,
    'description': description,
    'descriptionAr': descriptionAr,
    'saved': saved,
    'icon': icon,
  };

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      titleAr: json['titleAr'] as String,
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String,
      saved: json['saved'] as bool? ?? false,
      icon: json['icon'] as String,
    );
  }
}
