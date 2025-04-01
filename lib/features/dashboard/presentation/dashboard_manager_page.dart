import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prudential_tems/core/theme/app_colors.dart';
import 'package:prudential_tems/core/utils/utils.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/manager/booking_table_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/manager/pie_chart_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/manager/progress_card.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/manager/tile_card.dart';
import 'package:prudential_tems/features/home/data/models/progress_item_model.dart';

import '../../bookings/data/models/booking_api_response.dart';
import '../../bookings/data/models/global_app_data.dart';

class DashboardManagerPage extends StatefulWidget {
  final GlobalAppData globalData;

  const DashboardManagerPage({super.key, required this.globalData});

  @override
  State<DashboardManagerPage> createState() => _DashboardManagerPageState();
}

class _DashboardManagerPageState extends State<DashboardManagerPage> {
  final Random random = Random();
  late List<Booking>? bookingList;
  List<Booking> totalBookingList = [];

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
                  title: 'Total Bookings',
                  count: (totalBookingList.length).toString(),
                  color: AppColors.purple,
                ),
                TileCard(
                  title: 'Active Projects',
                  count: getActiveProject(),
                  color: AppColors.cyan,
                ),
                TileCard(
                  title: 'Pending Approvals',
                  count: getPendingProject(),
                  color: AppColors.prudentialGray,
                ),
              ],
            ),
          ),
          if (bookingList != null && bookingList!.isNotEmpty)
            BookingTableCard(dataList: bookingList!),
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
        .where((e) => e.status == "Pending")
        .length
        .toString();
  }
}
