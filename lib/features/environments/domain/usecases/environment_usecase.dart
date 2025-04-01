import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/features/environments/data/models/environment_api_response.dart';
import 'package:prudential_tems/providers/app_provider.dart';

import '../repositories/environment_repo.dart';

class EnvironmentUseCase {
  late final EnvironmentRepository _environmentRepository;

  EnvironmentUseCase(this._environmentRepository);

  Future<List<Environment>> fetchAllEnvironments() async {
    return await _environmentRepository.fetchAllEnvironments();
  }
}

final fetchEnvironmentUseCaseProvider = Provider<EnvironmentUseCase>((ref) {
  final environmentRepository = ref.read(environmentRepositoryProvider);
  return EnvironmentUseCase(environmentRepository);
});
