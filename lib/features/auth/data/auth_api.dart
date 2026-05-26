import '../../../core/api/api_client.dart';
import '../../../core/api/auth_debug.dart';
import '../../../core/api/json_map.dart';
import '../../../core/api/phone_util.dart';
import '../../../models/app_user.dart';
import '../../../models/token_pair.dart';

class AuthApi {
  AuthApi(this._client);

  final ApiClient _client;

  Future<TokenPair> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'name': name.trim(),
        'phone': normalizePhone(phone),
        'password': password,
      },
    );
    return TokenPair.fromJson(
      requireJsonMap(
        res.data,
        context: 'ответ регистрации',
        statusCode: res.statusCode,
      ),
    );
  }

  Future<TokenPair> login({
    required String phone,
    required String password,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'phone': normalizePhone(phone),
        'password': password,
      },
    );
    logAuthStep(
      'login response: ${describeAuthResponse(statusCode: res.statusCode, data: res.data)}',
    );
    return TokenPair.fromJson(
      requireJsonMap(
        res.data,
        context: 'ответ входа',
        statusCode: res.statusCode,
      ),
    );
  }

  Future<AppUser> me() async {
    final res = await _client.get<Map<String, dynamic>>('/auth/me');
    return AppUser.fromJson(
      requireJsonMap(
        res.data,
        context: 'профиль пользователя',
        statusCode: res.statusCode,
      ),
    );
  }
}
