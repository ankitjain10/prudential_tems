import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/engine_model.dart';

final engineDetailsViewModelProvider =
StateNotifierProvider<EngineDetailsViewModel, AsyncValue<Engine>>(
      (ref) => EngineDetailsViewModel(),
);

class EngineDetailsViewModel extends StateNotifier<AsyncValue<Engine>> {
  EngineDetailsViewModel() : super(const AsyncValue.loading());

  // Simulate fetching engine details (in a real app, this would be a network call)
  void loadEngineDetails(Engine engine) {
    try {
      state = AsyncData(engine);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}


