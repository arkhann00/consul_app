class DoctorModel {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String firstName;
  final String lastName;
  final String? patronymic;
  final String? avatarUrl;
  final String position;
  final String? description;

  const DoctorModel({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    required this.firstName,
    required this.lastName,
    this.patronymic,
    this.avatarUrl,
    required this.position,
    this.description,
  });

  String get displayName {
    final p = patronymic?.trim();
    return [
      lastName,
      firstName,
      if (p != null && p.isNotEmpty) p,
    ].join(' ');
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String).toUtc()
          : null,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      patronymic: json['patronymic'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      position: json['position'] as String,
      description: json['description'] as String?,
    );
  }
}
