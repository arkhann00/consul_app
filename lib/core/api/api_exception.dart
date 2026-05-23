import 'package:dio/dio.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic rawDetail;

  const ApiException({
    this.statusCode,
    required this.message,
    this.rawDetail,
  });

  @override
  String toString() => message;

  factory ApiException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    final detail = parseDetail(data);
    if (detail != null && detail.isNotEmpty) {
      return ApiException(statusCode: status, message: detail, rawDetail: data);
    }
    return ApiException(
      statusCode: status,
      message: e.message ?? 'Сетевая ошибка',
      rawDetail: data,
    );
  }

  static String? parseDetail(dynamic data) {
    if (data is! Map) return null;
    final detail = data['detail'];
    if (detail is String) return detail;
    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map) {
        final msg = first['msg'];
        if (msg is String) return msg;
      }
    }
    return null;
  }
}
