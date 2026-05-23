import '../../../core/api/api_client.dart';
import '../../../models/news_item.dart';

class NewsApi {
  NewsApi(this._client);

  final ApiClient _client;

  Future<List<NewsModel>> list({int skip = 0, int limit = 100}) async {
    final res = await _client.get<List<dynamic>>(
      '/news',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final raw = res.data ?? [];
    return raw
        .map((e) => NewsModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<NewsModel> getById(int id) async {
    final res = await _client.get<Map<String, dynamic>>('/news/$id');
    return NewsModel.fromJson(res.data!);
  }
}
