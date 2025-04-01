import 'package:flutter/material.dart';
import 'package:prudential_tems/features/home/presentation/screen/engine_details_screen.dart';
import 'package:prudential_tems/features/home/presentation/screen/engine_list_screen.dart';
import '../../features/home/data/models/engine_model.dart';

class AppRoutes {
  static const String engineListScreen = '/engineList';
  static const String engineDetailScreen = '/engineDetails';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case engineListScreen:
        return MaterialPageRoute(builder: (_) => const EngineListScreen());
      case engineDetailScreen:
        final Engine engine = settings.arguments as Engine;
        return MaterialPageRoute(
          builder: (_) => EngineDetailsScreen(selectedEngine: engine),
        );
      default:
        return MaterialPageRoute(builder: (_) => const EngineListScreen());
    }
  }
}
