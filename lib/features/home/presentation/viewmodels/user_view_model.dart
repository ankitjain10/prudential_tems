import 'package:prudential_tems/features/home/data/models/engine_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/users_usecase.dart';

final StateNotifierProvider<UserViewModel, AsyncValue<List<Engine>>>
userViewModelProvider =
    StateNotifierProvider<UserViewModel, AsyncValue<List<Engine>>>((ref) {
      final GetUserUseCase fetchUsersUseCase = ref.read(
        fetchUsersUseCaseProvider,
      );
      return UserViewModel(fetchUsersUseCase);
    });

class UserViewModel extends StateNotifier<AsyncValue<List<Engine>>> {
  final GetUserUseCase _getUsersUseCase;

  UserViewModel(this._getUsersUseCase) : super(const AsyncLoading());

  Future<void> fetchEngineList() async {
    try {
      final List<Engine> engines = await _getUsersUseCase.getEngines();
      state = AsyncData(engines);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
