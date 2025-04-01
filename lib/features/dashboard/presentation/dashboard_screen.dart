
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/features/dashboard/presentation/dashboard_admin_page.dart';
import 'package:prudential_tems/features/dashboard/presentation/dashboard_manager_page.dart';
import 'package:prudential_tems/features/home/data/models/user_model.dart';

import '../../../providers/app_provider.dart';
import 'dashboard_engineer_page.dart';

enum LegendShape { circle, rectangle }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    // Trigger fetching data in initState
    Future.microtask(() => ref.read(globalDataProvider));
  }

  @override
  Widget build(BuildContext context) {
    final globalDataState = ref.watch(globalDataProvider);
    final user = ref.watch(userProvider); // Watch user changes
    if(user==null){
      return Center(child: Text('Error: User Not Found!'));
    }
    return globalDataState.when(
        data: (globalData) {

          // User user = userManager; // Example user, replace with actual user data
          // User user = userAdmin; // Example user, replace with actual user data
          // User user = userEngineer; // Example user, replace with actual user data

          switch (user.userRole) {
            case "Manager":
              return DashboardManagerPage(globalData: globalData);
            case "Engineer":
              return DashboardEngineerPage(globalData: globalData,user: user);
            case "Admin":
              return DashboardAdminPage(globalData: globalData);
            default:
              return const Center(child: Text('Error: Invalid User Role!'));
          }
        },
        loading: () => Center(child: CircularProgressIndicator()), // Show Loader
        error: (error, stackTrace) {
          debugPrint('Error: $error');
          return Center(child: Text('Error: $error'));
        } , // Show Error
    );

  }
}


