
import 'package:dio/dio.dart';
import 'package:prudential_tems/features/environments/domain/repositories/environment_repo.dart';

import '../models/environment_api_response.dart';

class EnvironmentRepositoryImpl implements EnvironmentRepository  {
  final Dio _dio;

  EnvironmentRepositoryImpl(this._dio);

  @override
  Future<List<Environment>> fetchAllEnvironments() async {
    try {
      Response response = await _dio.get('/environment/all');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data == null || data.isEmpty) {
          throw Exception("Received empty response from the server.");
        }
        List<Environment> users = Environment.fromJsonList(response.data);
        return users;
      } else {
        throw Exception("Failed to load environments");
      }
    } on DioException catch (e) {
      throw Exception("Network Error: ${e.message}");
    }  catch (e) {
      throw Exception("Error: $e");
    }
  }
}
