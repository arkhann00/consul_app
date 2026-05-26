import 'package:flutter/foundation.dart';

import '../core/api/api_client.dart';
import '../core/api/api_exception.dart';
import '../core/api/auth_debug.dart';
import '../core/config/api_config.dart';
import '../features/auth/data/auth_api.dart';
import '../features/doctors/data/doctors_api.dart';
import '../features/news/data/news_api.dart';
import '../models/token_pair.dart';

export '../models/app_user.dart';
export '../models/doctor.dart';
export '../models/news_item.dart';

import '../models/app_user.dart';
import '../models/doctor.dart';
import '../models/news_item.dart';

class HomeFeed {
  final List<DoctorModel> doctors;
  final List<NewsModel> news;

  const HomeFeed({required this.doctors, required this.news});
}

class ConsulRepository {
  ConsulRepository({ApiClient? client}) : _client = client ?? ApiClient() {
    _auth = AuthApi(_client);
    _doctors = DoctorsApi(_client);
    _news = NewsApi(_client);
  }

  factory ConsulRepository.shared() {
    return _instance ??= ConsulRepository();
  }

  static ConsulRepository? _instance;

  final ApiClient _client;
  late final AuthApi _auth;
  late final DoctorsApi _doctors;
  late final NewsApi _news;

  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);

  String resolveMediaUrl(String? path) {
    final url = ApiConfig.resolveMediaUrl(path);
    return url.isEmpty ? '' : url;
  }

  Future<void> bootstrap() async {
    final access = await _client.tokenStorage.readAccessToken();
    if (access == null || access.isEmpty) {
      isAuthenticated.value = false;
      return;
    }
    try {
      await _auth.me();
      isAuthenticated.value = true;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) {
        await _client.tokenStorage.clear();
      }
      isAuthenticated.value = false;
    }
  }

  Future<AppUser?> fetchCurrentProfile() async {
    if (!isAuthenticated.value) return null;
    try {
      return await _auth.me();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await signOut();
      }
      rethrow;
    }
  }

  Future<void> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    logAuthStep('signInWithPhone: start');
    final tokens = await _auth.login(phone: phone, password: password);
    logAuthStep('signInWithPhone: tokens received');
    await _saveTokens(tokens);
    logAuthStep('signInWithPhone: tokens saved');
    isAuthenticated.value = true;
  }

  Future<void> signUpWithPhone({
    required String name,
    required String phone,
    required String password,
  }) async {
    final tokens = await _auth.register(name: name, phone: phone, password: password);
    await _saveTokens(tokens);
    isAuthenticated.value = true;
  }

  Future<void> signOut() async {
    await _client.tokenStorage.clear();
    isAuthenticated.value = false;
  }

  Future<void> _saveTokens(TokenPair tokens) {
    return _client.tokenStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
  }

  Future<List<DoctorModel>> fetchDoctors({int skip = 0, int limit = 100}) {
    return _doctors.list(skip: skip, limit: limit);
  }

  Future<List<NewsModel>> fetchNews({int skip = 0, int limit = 50}) {
    return _news.list(skip: skip, limit: limit);
  }

  Future<HomeFeed> fetchHomeFeed() async {
    final doctors = await fetchDoctors(limit: 100);
    final news = await fetchNews(limit: 30);
    return HomeFeed(doctors: doctors, news: news);
  }

  Future<DoctorModel> fetchDoctorById(int id) => _doctors.getById(id);

  Future<NewsModel> fetchNewsById(int id) => _news.getById(id);
}
