
import 'package:dio/dio.dart';
import 'package:prudential_tems/features/projects/data/models/project_api_response.dart';



class ProjectRepository {
  final Dio _dio;

  ProjectRepository(this._dio);

  Future<ProjectApiResponse> fetchAllProjects() async {
    try {
      Response response = await _dio.get('/project/all');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data == null || data.isEmpty) {
          throw Exception("Received empty response from the server.");
        }
        return ProjectApiResponse.fromJson(data);
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
