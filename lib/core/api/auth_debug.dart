/// Console diagnostics for auth issues on Flutter Web (works in release builds).
void logAuthStep(String message) {
  // ignore: avoid_print
  print('[consul AUTH] $message');
}

void logAuthError(Object error, StackTrace stackTrace) {
  // ignore: avoid_print
  print('[consul AUTH ERROR] $error');
  // ignore: avoid_print
  print('[consul AUTH STACK]\n$stackTrace');
}

String describeAuthResponse({
  required int? statusCode,
  required Object? data,
}) {
  final dataType = data == null ? 'null' : data.runtimeType.toString();
  final preview = data == null
      ? '—'
      : data.toString().length > 120
          ? '${data.toString().substring(0, 120)}...'
          : data.toString();
  return 'status=$statusCode dataType=$dataType preview=$preview';
}
