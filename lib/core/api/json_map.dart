import 'api_exception.dart';

Map<String, dynamic> requireJsonMap(
  Object? data, {
  String context = 'ответ сервера',
}) {
  if (data == null) {
    throw ApiException(message: 'Пустой $context');
  }
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  throw ApiException(message: 'Некорректный формат $context');
}
