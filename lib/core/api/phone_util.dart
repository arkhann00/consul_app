/// Normalizes phone for API: digits and `+` only (same format for login/register).
String normalizePhone(String raw) {
  final buffer = StringBuffer();
  for (final codeUnit in raw.trim().codeUnits) {
    final c = String.fromCharCode(codeUnit);
    if (c == '+' || (codeUnit >= 48 && codeUnit <= 57)) {
      buffer.write(c);
    }
  }
  return buffer.toString();
}
