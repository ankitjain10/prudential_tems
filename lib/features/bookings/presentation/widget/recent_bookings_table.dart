import 'package:flutter/material.dart';
import 'package:prudential_tems/features/bookings/presentation/widget/booking_item_row.dart';

import '../../data/models/booking_api_response.dart';

class RecentBookingsTable extends StatelessWidget{
  final List<Booking> bookingList;
  const RecentBookingsTable({super.key, required this.bookingList});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      elevation: 2,
      // Shadow effect
      margin: EdgeInsets.all(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              'Recent Bookings',
              style: TextStyle(color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 10),
            // Table header row
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    flex: 2,
                    child: SelectableText(
                      'Environment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SelectableText('Project', style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    flex: 2,
                    child: SelectableText(
                      'Start Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SelectableText(
                      'End Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: SelectableText(
                        'Status',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Booking entries list
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bookingList.length,
                itemBuilder: (context, index) {
                  final item = bookingList[index];
                  return _buildListRow(bookingModel: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListRow({required Booking bookingModel}) {
    return BookingItemRow(bookingModel: bookingModel);
  }

}