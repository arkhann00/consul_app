import 'package:shared_preferences/shared_preferences.dart';

import 'auth_debug.dart';

/// Token storage for all platforms.
///
/// Uses [SharedPreferences] (localStorage on Web). Works on HTTP without
/// Web Crypto API — unlike flutter_secure_storage_web.
class TokenStorage {
  TokenStorage({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  Future<SharedPreferences> get _store async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<String?> readAccessToken() async {
    final store = await _store;
    return store.getString(_accessKey);
  }

  Future<String?> readRefreshToken() async {
    final store = await _store;
    return store.getString(_refreshKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    logAuthStep('saveTokens: access=${accessToken.length} chars');
    final store = await _store;
    final okAccess = await store.setString(_accessKey, accessToken);
    final okRefresh = await store.setString(_refreshKey, refreshToken);
    if (!okAccess || !okRefresh) {
      throw StateError('Не удалось сохранить токены в localStorage');
    }
    logAuthStep('saveTokens: ok');
  }

  Future<void> clear() async {
    final store = await _store;
    await store.remove(_accessKey);
    await store.remove(_refreshKey);
  }
}
