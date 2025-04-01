import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion Date Picker',
      home: DatePickerScreen(),
    );
  }
}

class DatePickerScreen extends StatefulWidget {
  @override
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime? startDate;
  DateTime? endDate;
  PickerDateRange? _selectedRange; // Moved to class-level state variable

  final List<Map<String, String>> blockedRanges = [
    {"start_date": "2025-02-20", "end_date": "2025-02-25"},
    {"start_date": "2025-03-12", "end_date": "2025-03-28"},
    {"start_date": "2025-04-02", "end_date": "2025-05-20"},
  ];

  List<DateTimeRange> blockedDateRanges = [];

  @override
  void initState() {
    super.initState();
    _initializeBlockedRanges();
  }

  void _initializeBlockedRanges() {
    blockedDateRanges =
        blockedRanges
            .map(
              (range) => DateTimeRange(
            start: DateTime.parse(range["start_date"]!),
            end: DateTime.parse(range["end_date"]!),
          ),
        )
            .toList();
  }

  Future<void> _showDatePickerDialog() async {
    DateTime today = DateTime.now();
    DateTime endOfYear = DateTime(
      today.year,
      12,
      31,
    ); // Set max date to end of current year

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Select Date Range"),
              content: SizedBox(
                width: 300,
                height: 350,
                child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.range,
                  // initialSelectedRange: PickerDateRange(today, today),
                  minDate: today,
                  maxDate: endOfYear,
                  enablePastDates: false,
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    blackoutDateTextStyle: TextStyle(
                      color: Colors.red,
                      // Change the text color of blocked dates
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                    ),
                    // blackoutDatesDecoration: _getBlockedDateDecoration(),
                    blackoutDatesDecoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      // Change background color for blocked dates
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  selectionShape: DateRangePickerSelectionShape.circle,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    blackoutDates: _getBlockedDates(),
                  ),

                  rangeSelectionColor: Colors.blue,
                  startRangeSelectionColor: Colors.blue,
                  endRangeSelectionColor: Colors.blue,
                  selectableDayPredicate: (date) => !_isDateBlocked(date),
                  onSelectionChanged: (
                      DateRangePickerSelectionChangedArgs args,
                      ) {
                    debugPrint('onSelectionChanged called: ${args.value}');

                    setDialogState(() {
                      if (args.value is PickerDateRange) {
                        debugPrint('PickerDateRange');
                        if (args.value.startDate == null ||
                            args.value.endDate == null) {
                          return;
                        }
                        _selectedRange = args.value;
                        debugPrint(
                          'selectedRange : ${_selectedRange?.startDate}:: ${_selectedRange?.endDate}',
                        );
                      } else if (args.value is DateTime) {
                        debugPrint('DateTime');
                        // _selectedDate = args.value.toString();
                      } else if (args.value is List<DateTime>) {
                        debugPrint('List<DateTime>');
                        // _dateCount = args.value.length.toString();
                      } else {
                        debugPrint('else');
                        // _rangeCount = args.value.length.toString();
                      }
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed:
                  _selectedRange != null &&
                      _selectedRange!.startDate != null &&
                      _selectedRange!.endDate != null
                      ? () {
                    setState(() {
                      debugPrint('ok pressed');
                      startDate = _selectedRange!.startDate;
                      endDate = _selectedRange!.endDate;
                    });
                    Navigator.pop(context);
                  }
                      : null,
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<DateTime> _getBlockedDates() {
    List<DateTime> disabledDates = [];
    for (var range in blockedDateRanges) {
      for (
      var day = range.start;
      day.isBefore(range.end.add(Duration(days: 1)));
      day = day.add(Duration(days: 1))
      ) {
        disabledDates.add(day);
      }
    }
    return disabledDates;
  }

  bool _isDateBlocked(DateTime date) {
    for (var range in blockedDateRanges) {
      if (date.isAfter(range.start.subtract(Duration(days: 1))) &&
          date.isBefore(range.end.add(Duration(days: 1)))) {
        return false; // Disable selection
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Syncfusion Date Picker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              startDate != null && endDate != null
                  ? "Selected Range: ${DateFormat.yMMMd().format(startDate!)} - ${DateFormat.yMMMd().format(endDate!)}"
                  : "No Date Selected",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showDatePickerDialog,
              child: Text("Pick Date Range"),
            ),
          ],
        ),
      ),
    );
  }

  Map<DateTime, BoxDecoration> _getBlockedDateDecoration() {
    Map<DateTime, BoxDecoration> decorations = {};

    for (var range in blockedDateRanges) {
      List<DateTime> blockedDays = [];

      for (
      var day = range.start;
      day.isBefore(range.end.add(Duration(days: 1)));
      day = day.add(Duration(days: 1))
      ) {
        blockedDays.add(day);
      }

      for (var i = 0; i < blockedDays.length; i++) {
        DateTime date = blockedDays[i];

        if (i == 0) {
          // Start of range (rounded left)
          decorations[date] = BoxDecoration(
            color: Colors.green.withOpacity(0.6),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
          );
        } else if (i == blockedDays.length - 1) {
          // End of range (rounded right)
          decorations[date] = BoxDecoration(
            color: Colors.green.withOpacity(0.6),
            borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
          );
        } else {
          // Middle of the range
          decorations[date] = BoxDecoration(
            color: Colors.green.withOpacity(0.6),
          );
        }
      }
    }

    return decorations;
  }
}


