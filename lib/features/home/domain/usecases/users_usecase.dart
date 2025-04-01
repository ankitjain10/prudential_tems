import 'package:prudential_tems/features/home/data/models/engine_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository.dart';

class GetUserUseCase {
  late final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  Future<List<Engine>> getEngines() async {
    return await _userRepository.getEngines();
  }
}

final fetchUsersUseCaseProvider = Provider<GetUserUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserUseCase(userRepository);
});
