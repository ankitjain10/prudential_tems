import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/usecases/users_usecase.dart';
import '../../data/models/environment_api_response.dart';
import '../../domain/usecases/environment_usecase.dart';

final environmentViewModelProvider =
StateNotifierProvider<EnvironmentProvider, AsyncValue<List<Environment>>>((ref) {
  final EnvironmentUseCase fetchUsersUseCase = ref.read(
    fetchEnvironmentUseCaseProvider,
  );
  return EnvironmentProvider(fetchUsersUseCase);
});

class EnvironmentProvider extends StateNotifier<AsyncValue<List<Environment>>> {
  final EnvironmentUseCase _getUsersUseCase;

  EnvironmentProvider(this._getUsersUseCase) : super(const AsyncLoading());

  Future<void> fetchAllEnvironments() async {
    try {
      final List<Environment> engines = await _getUsersUseCase.fetchAllEnvironments();
      state = AsyncData(engines);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
