import 'dart:convert';

import 'api_exception.dart';

Map<String, dynamic> requireJsonMap(
  Object? data, {
  String context = 'ответ сервера',
  int? statusCode,
}) {
  if (data == null) {
    if (statusCode == 200 || statusCode == 201) {
      throw ApiException(
        statusCode: statusCode,
        message:
            'Сервер ответил $statusCode, но браузер не передал данные в приложение. '
            'Чаще всего это CORS: на API разрешите origin сайта '
            '(например http://IP:8083), а не только origin API.',
      );
    }
    throw ApiException(statusCode: statusCode, message: 'Пустой $context');
  }

  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  if (data is String && data.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      throw ApiException(
        statusCode: statusCode,
        message: 'Не удалось разобрать JSON в $context',
      );
    }
  }

  throw ApiException(
    statusCode: statusCode,
    message: 'Некорректный формат $context',
  );
}
