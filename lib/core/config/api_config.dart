/// Base URL and media resolution for Consilium REST API.
class ApiConfig {
  ApiConfig._();

  static String baseUrl = 'http://5.42.113.18:8001';

  static const String apiPrefix = '/api/v1';

  static String get apiUrl => '$baseUrl$apiPrefix';

  static void init({required String base}) {
    baseUrl = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  }

  /// Relative `/uploads/...` or absolute URL → full image URL.
  static String resolveMediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return '$baseUrl$path';
  }
}
