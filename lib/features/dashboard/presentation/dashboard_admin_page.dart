import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prudential_tems/core/utils/app_utils.dart';
import 'package:prudential_tems/features/bookings/data/models/global_app_data.dart';
import 'package:prudential_tems/features/dashboard/data/model/user.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/admin/environment_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/admin/environment_table_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/admin/recent_activity_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/admin/system_health_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/admin/user_card.dart';

import '../../environments/data/models/environment_api_response.dart';
import '../../projects/data/models/project_api_response.dart';

class DashboardAdminPage extends StatefulWidget {
  final GlobalAppData globalData;

  const DashboardAdminPage({super.key, required this.globalData});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  List<Map<String, dynamic>> taskSummary = [
    {'label': 'Total Tasks', 'count': '156', 'color': Colors.green},
    {'label': 'Completed', 'count': '89', 'color': Colors.blue},
    {'label': 'Pending', 'count': '67', 'color': Colors.orange},
  ];

  // List<Map<String, dynamic>> userList = [
  //   {'name': 'Sarah Johnson', 'profile': '', 'role': 'Project Manager'},
  //   {'name': 'Mike Chen', 'profile': '', 'role': 'Engineer'},
  // ];

  late List<UserModel>? userList = [];

  late List<Environment> environmentData = <Environment>[];
  late List<Environment> environmentCardData = <Environment>[];
  late List<Environment>? mList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateProjectCounts(
      widget.globalData.environmentData,
      widget.globalData.projectData.projectDTOList,
    );

    // for (var environment
    //     in widget.globalData.environmentData) {
    //    debugPrint('${environment.environment}:: ${environment.projectCount}');
    // }
    environmentData = widget.globalData.environmentData;
    userList = widget.globalData.userData;
    environmentCardData= removeDuplicatesByEnvironment(environmentData);

    mList = environmentData.sublist(0, min(5, environmentData.length));
  }

  void updateProjectCounts(
    List<Environment> environmentList,
    List<ProjectModel> projectList,
  ) {
    // Create a map to store counts of projects per environment
    Map<String, int> projectCountMap = {};

    // Count projects based on their environment
    for (var project in projectList) {
      projectCountMap[project.environment] =
          (projectCountMap[project.environment] ?? 0) + 1;
    }

    // Update the _projectCount in the Environment objects
    for (var environment in environmentList) {
      environment.projectCount = projectCountMap[environment.environment] ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // FIXED: Prevents infinite height
          children: [
            // First Row - Environment Cards
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SelectableText(
                        "Environments",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(thickness: 1), // Divider below title
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 150,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: environmentCardData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right:
                                  index < environmentCardData.length - 1 ? 24.0 : 0,
                            ),
                            child: EnvironmentCard(
                              title:
                              environmentCardData[index].environment,
                              status: environmentCardData[index].status,
                              item: environmentCardData[index],
                              statusColor: StatusUtils.getStatusColor(
                                environmentCardData[index].status,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            if (mList != null && mList!.isNotEmpty)
              EnvironmentTableCard(dataList: mList!),

            // Second Row - Wide Cards
            // IntrinsicHeight(
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to max height
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Expanded(flex: 1,child: _buildBookingSummaryCard('Booking Summary')),
            //       SizedBox(width: 16),
            //       Expanded(flex: 1,
            //         child: JiraCard(
            //           title: 'Jira Integration',
            //           data: taskSummary,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 16),

            // Third Row - Small Cards
            IntrinsicHeight(
              child: Row(
                children: [
                  Flexible(
                    child: UserCard(
                      title: 'User Management',
                      data: userList ?? [],
                    ),
                  ),
                  SizedBox(width: 16),
                  Flexible(child: SystemHealthCard()),
                  SizedBox(width: 16),
                  Flexible(child: RecentActivityCard()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Wide Card Widget
  Widget _buildBookingSummaryCard(String title) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  List<Environment> removeDuplicatesByEnvironment(List<Environment> environments) {
    final seen = <String>{}; // Set to track unique environment values
    return environments.where((env) => seen.add(env.environment)).toList();
  }
}
