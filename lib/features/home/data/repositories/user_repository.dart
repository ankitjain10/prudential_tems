import 'package:prudential_tems/features/home/data/models/engine_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/user_network_datasource.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final networkDatasource = ref.read(userNetworkDatasourceProvider);
  return UserRepository(networkDatasource);
});

class UserRepository {
  final UserNetworkDatasource networkDatasource;

  UserRepository(this.networkDatasource);

  Future<List<Engine>> getEngines() async {
    try {
      return await networkDatasource.getEngines();
    } catch (e) {
      throw Exception('Error fetching engine data: $e');
    }
  }
}
