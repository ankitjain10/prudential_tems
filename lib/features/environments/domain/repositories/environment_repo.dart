
import 'package:prudential_tems/features/environments/data/models/environment_api_response.dart';

abstract class EnvironmentRepository {
  Future<List<Environment>> fetchAllEnvironments();
}