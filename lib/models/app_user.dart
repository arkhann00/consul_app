/// User profile from `GET /api/v1/auth/me`.
class AppUser {
  final int id;
  final String name;
  final String phone;
  final bool isAdmin;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.isAdmin,
    required this.createdAt,
  });

  String get displayName => name.trim();

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      isAdmin: json['is_admin'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }
}
