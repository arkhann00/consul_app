import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'api_exception.dart';
import 'json_map.dart';
import 'token_storage.dart';

class ApiClient {
  ApiClient({
    TokenStorage? tokenStorage,
    Dio? dio,
  })  : _tokenStorage = tokenStorage ?? TokenStorage(),
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.apiUrl,
                connectTimeout: const Duration(seconds: 20),
                receiveTimeout: const Duration(seconds: 20),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  final TokenStorage _tokenStorage;
  final Dio _dio;

  Dio get dio => _dio;
  TokenStorage get tokenStorage => _tokenStorage;

  Future<void>? _refreshInFlight;

  static bool _isAuthPath(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh');
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthPath(options.path)) {
      final access = await _tokenStorage.readAccessToken();
      if (access != null && access.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access';
      }
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final status = error.response?.statusCode;
    if (status != 401) {
      handler.next(error);
      return;
    }

    final opts = error.requestOptions;
    if (_isAuthPath(opts.path) || opts.extra['retried'] == true) {
      handler.next(error);
      return;
    }

    try {
      await _refreshTokensOnce();
      final access = await _tokenStorage.readAccessToken();
      opts.extra['retried'] = true;
      if (access != null && access.isNotEmpty) {
        opts.headers['Authorization'] = 'Bearer $access';
      }
      final response = await _dio.fetch(opts);
      handler.resolve(response);
    } catch (_) {
      await _tokenStorage.clear();
      handler.next(error);
    }
  }

  Future<void> _refreshTokensOnce() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final future = _doRefresh();
    _refreshInFlight = future;
    return future.whenComplete(() => _refreshInFlight = null);
  }

  Future<void> _doRefresh() async {
    final refresh = await _tokenStorage.readRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      throw ApiException(statusCode: 401, message: 'Invalid or expired refresh token');
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refresh_token': refresh},
      options: Options(extra: {'skipAuth': true}),
    );

    final data = requireJsonMap(response.data, context: 'ответ refresh');

    final access = data['access_token'] as String?;
    final newRefresh = data['refresh_token'] as String?;
    if (access == null || newRefresh == null) {
      throw ApiException(message: 'Некорректный ответ refresh');
    }

    await _tokenStorage.saveTokens(
      accessToken: access,
      refreshToken: newRefresh,
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(path, data: data, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
