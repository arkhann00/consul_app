import '../../../core/api/api_client.dart';
import '../../../models/doctor.dart';

class DoctorsApi {
  DoctorsApi(this._client);

  final ApiClient _client;

  Future<List<DoctorModel>> list({int skip = 0, int limit = 100}) async {
    final res = await _client.get<List<dynamic>>(
      '/doctors',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final raw = res.data ?? [];
    return raw
        .map((e) => DoctorModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<DoctorModel> getById(int id) async {
    final res = await _client.get<Map<String, dynamic>>('/doctors/$id');
    return DoctorModel.fromJson(res.data!);
  }
}
