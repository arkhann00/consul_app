import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_storage_delegate.dart';

TokenStorageDelegate createTokenStorageDelegate() => _SecureTokenStorageDelegate();

class _SecureTokenStorageDelegate implements TokenStorageDelegate {
  _SecureTokenStorageDelegate()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          webOptions: WebOptions(),
        );

  final FlutterSecureStorage _storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessKey);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
