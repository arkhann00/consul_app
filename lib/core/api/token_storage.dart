import 'token_storage_delegate.dart';
import 'token_storage_stub.dart'
    if (dart.library.io) 'token_storage_io.dart'
    if (dart.library.html) 'token_storage_web.dart';

class TokenStorage {
  TokenStorage({TokenStorageDelegate? delegate})
      : _delegate = delegate ?? createTokenStorageDelegate();

  final TokenStorageDelegate _delegate;

  Future<String?> readAccessToken() => _delegate.readAccessToken();

  Future<String?> readRefreshToken() => _delegate.readRefreshToken();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    return _delegate.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> clear() => _delegate.clear();
}
