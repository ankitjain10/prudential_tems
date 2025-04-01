import 'package:flutter/material.dart';
import 'package:prudential_tems/core/utils/app_utils.dart';
import 'package:prudential_tems/features/bookings/data/models/global_app_data.dart';
import 'package:prudential_tems/features/dashboard/presentation/widgets/manager/status_row.dart';
import 'package:prudential_tems/features/home/data/models/progress_item_model.dart';

import '../../../../bookings/data/models/booking_api_response.dart';

class ProgressCard extends StatefulWidget {
  final GlobalAppData globalData;

  const ProgressCard({super.key, required this.globalData});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  List<ProgressItem> progressItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progressItems = getProgressItems(widget.globalData.bookingData.bookingList);
  }

  /// Utility method to pick color based on status
  // Color getStatusColor(String status) {
  //   switch (status.toLowerCase()) {
  //     case 'approved':
  //       return Colors.cyan;
  //     case 'pending':
  //       return Colors.orange;
  //     case 'in progress':
  //       return Colors.blue;
  //     case 'completed':
  //       return Colors.green;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  /// Function to generate a list of ProgressItems
  List<ProgressItem> getProgressItems(List<Booking> bookings) {
    if (bookings.isEmpty) return [];

    // Count occurrences of each status
    Map<String, int> statusCounts = {};
    for (var booking in bookings) {
      statusCounts[booking.status] = (statusCounts[booking.status] ?? 0) + 1;
    }

    int totalBookings = bookings.length;

    // Convert counts into ProgressItem list
    List<ProgressItem> progressItems =
        statusCounts.entries.map((entry) {
          return ProgressItem(
            label: entry.key,
            progress:
                entry.value / totalBookings, // Convert count to percentage
            color: StatusUtils.getStatusColor(entry.key),
          );
        }).toList();

    // Sort by label in ascending order
    progressItems.sort((a, b) => a.label.compareTo(b.label));

    return progressItems;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 320,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ), // Padding between cards
        child: Card(
          elevation: 4, // Adds shadow for depth
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  "Booking Status Distribution",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20), // Spacing between text and progress bar
                // List of HorizontalProgressBars
                Expanded(
                  child: ListView.builder(
                    itemCount: progressItems.length,
                    itemBuilder: (context, index) {
                      return StatusRow(item: progressItems[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
