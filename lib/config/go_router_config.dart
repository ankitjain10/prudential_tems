import 'package:flutter/material.dart';
import 'package:prudential_tems/features/dashboard/presentation/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

import '../core/common_widgets/main_layout.dart';
import '../features/bookings/presentation/booking_screen.dart';
import '../features/environments/presentation/environment_page.dart';
import '../features/projects/project_page.dart';

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

class GoRouterConfig {
  static final GoRouter goRouter = GoRouter(
    initialLocation: '/home',
    routes: [


      ShellRoute(
        // parentNavigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/bookings',
            builder: (context, state) => BookingScreen(),
          ),
          GoRoute(
            path: '/environment',
            builder: (context, state) => const EnvironmentPage(),
          ),
          GoRoute(
            path: '/projects',
            builder: (context, state) => const ProjectPage(),
          ),
        ],
      ),
    ],
  );
}
