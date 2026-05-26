import 'dart:html' as html;

import 'token_storage_delegate.dart';

TokenStorageDelegate createTokenStorageDelegate() => _WebTokenStorageDelegate();

/// Plain localStorage for Flutter Web.
///
/// [FlutterSecureStorage] on web needs a secure context (HTTPS) for Web Crypto.
/// On HTTP (e.g. VPS IP :8083) it throws "Null check operator used on a null value".
class _WebTokenStorageDelegate implements TokenStorageDelegate {
  static const _prefix = 'consul_app.';
  static const _accessKey = '${_prefix}access_token';
  static const _refreshKey = '${_prefix}refresh_token';

  @override
  Future<String?> readAccessToken() async => html.window.localStorage[_accessKey];

  @override
  Future<String?> readRefreshToken() async => html.window.localStorage[_refreshKey];

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    html.window.localStorage[_accessKey] = accessToken;
    html.window.localStorage[_refreshKey] = refreshToken;
  }

  @override
  Future<void> clear() async {
    html.window.localStorage.remove(_accessKey);
    html.window.localStorage.remove(_refreshKey);
  }
}
