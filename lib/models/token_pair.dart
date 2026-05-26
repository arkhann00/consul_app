import '../core/api/api_exception.dart';

class TokenPair {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const TokenPair({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'bearer',
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) {
    final access = json['access_token'];
    final refresh = json['refresh_token'];
    if (access is! String || access.isEmpty) {
      throw const ApiException(message: 'В ответе сервера нет access_token');
    }
    if (refresh is! String || refresh.isEmpty) {
      throw const ApiException(message: 'В ответе сервера нет refresh_token');
    }
    final tokenType = json['token_type'];
    return TokenPair(
      accessToken: access,
      refreshToken: refresh,
      tokenType: tokenType is String && tokenType.isNotEmpty ? tokenType : 'bearer',
    );
  }
}
