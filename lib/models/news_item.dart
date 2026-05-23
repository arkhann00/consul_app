class NewsModel {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String title;
  final String description;
  final String? image;

  const NewsModel({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    required this.title,
    required this.description,
    this.image,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String).toUtc()
          : null,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String?,
    );
  }

  String get summaryExcerpt {
    final lines = description.split(RegExp(r'\r?\n'));
    final firstLine = lines.isNotEmpty ? lines.first : description;
    if (firstLine.length <= 220) return firstLine;
    return '${firstLine.substring(0, 220).trim()}…';
  }

  String get featuredSubtitle {
    final t = description.trim();
    if (t.length <= 80) return t;
    return '${t.substring(0, 80).trim()}…';
  }
}
