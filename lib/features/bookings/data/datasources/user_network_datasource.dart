import 'package:prudential_tems/features/home/data/models/engine_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_service.dart';

final userNetworkDatasourceProvider = Provider<UserNetworkDatasource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return UserNetworkDatasource(networkService);
});

class UserNetworkDatasource {
  final NetworkService _networkService;

  UserNetworkDatasource(this._networkService);

  Future<List<Engine>> getEngines() async {
    return await _networkService.fetchEngineList();
  }
}
