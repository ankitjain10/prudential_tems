import 'package:flutter/material.dart';
import 'package:prudential_tems/core/utils/app_utils.dart';
import 'package:prudential_tems/core/utils/utils.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../../data/models/booking_api_response.dart';

class WeekCalendarPage extends StatefulWidget {
  final VoidCallback onPressed;
  final int minDays;
  final int maxDays;
  final List<Booking>? fullBookingList;

  const WeekCalendarPage( {
    super.key,
    this.fullBookingList,
    required this.onPressed,
    required this.minDays,
    required this.maxDays,
  });
  @override
  State<WeekCalendarPage> createState() => _WeekCalendarPageState();
}

class _WeekCalendarPageState extends State<WeekCalendarPage> {
  DateTime currentWeek = DateTime.now();
  final Random random = Random();
  // Define min and max date range (Example: 1 year range)
  late final DateTime minDate;
  late final DateTime maxDate;

  List<Color> eventColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    // Define min and max date range (Example: 1 year range)
    minDate = DateTime.now().subtract(Duration(days: widget.minDays));
    maxDate = DateTime.now().add(Duration(days: widget.maxDays));
  }

  List<DateTime> getWeekDays(DateTime date) {
    int currentWeekday = date.weekday;
    DateTime monday = date.subtract(Duration(days: currentWeekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays = getWeekDays(currentWeek);

    return Column(
      mainAxisSize:
          MainAxisSize.min, // Ensures column only takes needed space
      children: [
        // Week Navigation
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed:
                      () => setState(() {
                        currentWeek = currentWeek.subtract(Duration(days: 7));
                      }),
                ),
                SelectableText(
                  "${DateFormat('d MMM, yyyy').format(getWeekDays(currentWeek).first)} - ${DateFormat('d MMM, yyyy').format(getWeekDays(currentWeek).last)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed:
                      () => setState(() {
                        currentWeek = currentWeek.add(Duration(days: 7));
                      }),
                ),

                Spacer(),
                ElevatedButton(
                  onPressed: widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, color: Colors.white),
                      const SizedBox(width: 8),
                      const SelectableText(
                        'New Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Week Calendar
        Flexible(
          fit: FlexFit.loose,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              child: Column(
                children: [
                  // Row for Weekdays (Day Name + Date)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children:
                          weekDays.asMap().entries.map((entry) {
                            int idx = entry.key;
                            DateTime date = entry.value;
                            return Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        SelectableText(
                                          DateFormat('EEE').format(date),
                                          // Day Name
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SelectableText(
                                          '${date.day}', // Date
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (idx < weekDays.length - 1)
                                    Container(
                                      width: 1,
                                      height: 20,
                                      color: Colors.grey,
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  Divider(thickness: 1, color: Colors.grey),

                  // Row for Events under each date
                  Container(
                    constraints: BoxConstraints(
                      // minHeight: 250, // Minimum height of 100
                      maxHeight: 500, // Maximum height of 200
                    ),
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            weekDays.asMap().entries.map((entry) {
                              DateTime date = entry.value;

                              // Filter bookings for the current date
                              List<Booking>? bookingsForDate =
                              widget.fullBookingList?.where((booking) {
                                    DateTime bookingDate = dateFormat.parse(booking.startDate ?? '');
                                    return bookingDate.year == date.year &&
                                        bookingDate.month == date.month &&
                                        bookingDate.day == date.day;
                                  }).toList();

                              return Expanded(
                                child: Container(
                                  decoration: bookingsForDate != null && bookingsForDate.isNotEmpty
                                      ? BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  )
                                      : const BoxDecoration(),
                                  // Remove decoration if no events
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 2,
                                  ),
                                  margin: EdgeInsets.all(2),

                                  // Small margin to separate columns
                                  child: Column(
                                    children: [
                                      ...?(bookingsForDate?.map((booking) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 8,
                                          ),
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color:
                                                StatusUtils.getStatusColor(booking.status),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SelectableText(
                                                '${booking.projectName}\n\n${booking.purpose}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
