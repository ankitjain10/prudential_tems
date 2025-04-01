import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prudential_tems/core/theme/app_colors.dart';
import 'package:prudential_tems/core/utils/utils.dart';
import 'package:prudential_tems/features/dashboard/data/model/user.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/engineer/assignment_table_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/manager/booking_table_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/manager/pie_chart_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/manager/progress_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/manager/tile_card.dart';
import 'package:prudential_tems/features/environments/data/models/environment_api_response.dart';
import 'package:prudential_tems/features/home/data/models/progress_item_model.dart';
import 'package:prudential_tems/features/home/data/models/user_model.dart';

import '../../bookings/data/models/booking_api_response.dart';
import '../../bookings/data/models/global_app_data.dart';

class DashboardEngineerPage extends StatefulWidget {
  final GlobalAppData globalData;
  final UserModel user;
  const DashboardEngineerPage({super.key, required this.globalData, required this.user});

  @override
  State<DashboardEngineerPage> createState() => _DashboardEngineerPageState();
}

class _DashboardEngineerPageState extends State<DashboardEngineerPage> {
  final Random random = Random();
  late List<Booking>? bookingList;
  List<Booking> totalBookingList = [];
  List<Environment>? environmentList = [];

  // Generate a list of ProgressItem objects
  List<ProgressItem> progressList = List.generate(5, (index) {
    return ProgressItem(
      label: generateRandomString(3, 20), // Random string
      progress: generateRandomDouble(), // Random progress (0.0 to 1.0)
      color:
          Colors.primaries[Random().nextInt(
            Colors.primaries.length,
          )], // Random color
    );
  });



  @override
  void initState() {
    super.initState();
    totalBookingList = widget.globalData.bookingData.bookingList;
    bookingList = totalBookingList.sublist(0, min(5, totalBookingList.length));
    environmentList=widget.globalData.environmentData.where((_element)=> widget.user.userName==_element.assignedEngineer).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Generate dummy data list
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TileCard(
                  title: 'Assignment Environments',
                  count: (totalBookingList.length).toString(),
                  color: AppColors.purple,
                ),
                TileCard(
                  title: 'Active in Progress',
                  count: getActiveProject(),
                  color: AppColors.cyan,
                ),
                TileCard(
                  title: 'Under Maintenance',
                  count: getPendingProject(),
                  color: AppColors.prudentialRed,
                ),
              ],
            ),
          ),
          if (environmentList != null && environmentList!.isNotEmpty)
            AssignmentTableCard(dataList: environmentList),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Ensures spacing
            children: [
              ProgressCard(globalData: widget.globalData),
              PieChartCard(globalData: widget.globalData),
            ],
          ),
        ],
      ),
    );
  }

  String getActiveProject() {
    return totalBookingList
        .where((e) => e.status == "In Progress")
        .length
        .toString();
  }

  String getPendingProject() {
    return totalBookingList
        .where((e) => e.status == "Not Started")
        .length
        .toString();
  }
}
