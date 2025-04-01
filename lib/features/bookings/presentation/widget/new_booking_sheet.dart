import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/features/bookings/data/models/booking_api_response.dart';
import 'package:prudential_tems/features/bookings/data/models/global_app_data.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/utils/utils.dart';
import '../../../../providers/app_provider.dart';
import '../../domain/entity/booking_form.dart';

// Stateful widget for creating a new booking entry
class NewBookingSheet extends ConsumerStatefulWidget {
  final List<Booking>? fullBookingList;

  const NewBookingSheet({super.key, required this.fullBookingList});

  @override
  ConsumerState<NewBookingSheet> createState() => _NewBookingSheetState();
}

class _NewBookingSheetState extends ConsumerState<NewBookingSheet> {
  final _formKey = GlobalKey<FormState>();

  // Variables to store selected values and text input controllers
  late String? selectedEnvironment = "";
  late String? selectedProject = "";
  late String? selectedOwner = "";
  late String? selectedProjectID = "";
  TextEditingController purposeController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  late List<String> environmentList = [];

  late List<String> projectList = [];

  late List<String> managerList = [];

  late GlobalAppData globalData;

  late List<Booking> selectedEnvironmentList = [];

  DateTime? startDate;
  DateTime? endDate;
  PickerDateRange? _selectedRange; // Moved to class-level state variable
  List<DateTimeRange> blockedDateRanges = [];

  bool isFirstRun = true;

  @override
  void initState() {
    super.initState();
    // Trigger fetching data in initState
    Future.microtask(() => ref.read(globalDataProvider));
  }

  @override
  Widget build(BuildContext context) {
    final globalDataState = ref.watch(globalDataProvider);
    return globalDataState.when(
      data: (data) {
        // Validate if data is null or empty
        if (data.projectData.projectDTOList.isEmpty == true) {
          return const Center(child: Text("No data available"));
        }
        if (isFirstRun) {
          firstRunInit(data);
          isFirstRun = false;
        }
        // debugPrint('new booking build called');

        return _buildForm();
      },
      loading: () => Center(child: CircularProgressIndicator()), // Show Loader
      error:
          (error, stackTrace) =>
              Center(child: Text('Error: $error')), // Show Error
    );
  }

  // Widget for building a dropdown field
  Widget _buildDropdown<T>(
    String label,
    List<T> items,
    T? selectedValue,
     {
       Function(T?)? onChanged,
    bool showAsText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12,),
          child:
              showAsText
                  ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      selectedValue?.toString() ?? "N/A",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )
                  : DropdownButtonFormField<T>(
                    value:
                        (items.contains(selectedValue) ? selectedValue : null),
                    items:
                        items.map((T item) {
                          return DropdownMenuItem<T>(
                            value: item,
                            child: Text(
                              item.toString(),
                            ), // Ensure it's displayable
                          );
                        }).toList(),
                    onChanged: onChanged,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Widget for building a text input field
  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Widget for building a date input field with date picker
  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () {
            _showDatePickerDialog(context);
            /*_selectDate(context, controller)*/
          },
          decoration: InputDecoration(
            hintText: "MM/DD/YYYY",
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey, // Attach the form key(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown for Environment selection
            _buildDropdown(
              "Environment",
              environmentList,
              selectedEnvironment,
              onChanged:(value) {
                setState(() {
                  selectedEnvironment = value;
                  selectedEnvironmentList =
                      globalData.bookingData.bookingList
                          .where(
                            (e) => e.environmentName == selectedEnvironment,
                          )
                          .toList();
                });
              },
            ),
            // Dropdown for Project selection
            _buildDropdown("Project", projectList, selectedProject, onChanged:(value) {
              setState(() {
                selectedProject = value;
                selectedProjectID =
                    globalData.projectData.projectDTOList
                        .firstWhere((e) => e.projectName == selectedProject)
                        .projectId;

                var selectedManager =
                    globalData.projectData.projectDTOList
                        .firstWhere((e) => e.projectName == selectedProject)
                        .projectManager;
                managerList.clear();
                managerList.add(selectedManager);
                selectedOwner = selectedManager;
                debugPrint(
                  'selectedProject:: $selectedProject :: selectedProjectID: $selectedProjectID',
                );
              });
            }),
            // Dropdown for Owner selection
            _buildDropdown("Owner", managerList, selectedOwner, showAsText: true),
            // Purpose text field
            _buildTextField("Purpose", "Enter Purpose", purposeController),
            // Row containing Start and End date fields
            Row(
              children: [
                Expanded(
                  child: _buildDateField("Start Date", startDateController),
                ),
                const SizedBox(width: 8),
                Expanded(child: _buildDateField("End Date", endDateController)),
              ],
            ),
            // Notes text field
            _buildTextField(
              "Notes",
              "Enter Notes",
              notesController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Submit button
            ElevatedButton(
              onPressed: () {
                _submitForm(context);
                // Handle booking submission
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Submit Booking Request"),
            ),
            const SizedBox(height: 8),
            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Cancel"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (!validateFields(context)) {
        return; // Stop submission if validation fails
      }
      BookingForm newBookingForm = BookingForm(
        environmentName: selectedEnvironment!,
        projectName: selectedProject!,
        projectId: selectedProjectID!,
        owner: selectedOwner!,
        purpose: purposeController.text.trim(),
        notes: notesController.text.trim(),
        startDate: formattedDate(startDateController.text.trim()),
        endDate: formattedDate(endDateController.text.trim()),
      );

      // Use a separate BuildContext for the dialog
      BuildContext? dialogContext;

      try {
        final result = await ref
            .read(createBookingProvider.notifier)
            .createBooking(newBookingForm);

        result.when(
          data: (booking) {
            // Close the loading dialog
            // Close the loading dialog safely
            if (dialogContext != null && dialogContext!.mounted) {
              Navigator.of(dialogContext!).pop();
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Booking submitted successfully!")),
            );

            // Close the sheet and return success
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          },
          loading: () {
            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dContext) {
                // Assign dialogContext inside a microtask to avoid null issues
                Future.microtask(() => dialogContext = dContext);
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text("Submitting booking... Please wait"),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            // Close the loading dialog safely
            if (dialogContext != null && dialogContext!.mounted) {
              Navigator.of(dialogContext!).pop();
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Booking submission failed: $error")),
            );
          },
        );
      } catch (error) {
        // Close the loading dialog
        // Close the loading dialog safely
        if (dialogContext != null && dialogContext!.mounted) {
          Navigator.of(dialogContext!).pop();
        }

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking submission failed: $error")),
        );
      } finally {
        debugPrint("API call completed (success or failure).");
      }
    }
  }

  bool validateFields(BuildContext context) {
    if (selectedEnvironment == null || selectedEnvironment!.isEmpty) {
      showValidationMessage(context, "Please select an environment.");
      return false;
    }
    if (selectedProject == null || selectedProject!.isEmpty) {
      showValidationMessage(context, "Please select a project.");
      return false;
    }
    if (selectedProjectID == null || selectedProjectID!.isEmpty) {
      showValidationMessage(context, "Project ID is missing.");
      return false;
    }
    if (selectedOwner == null || selectedOwner!.isEmpty) {
      showValidationMessage(context, "Please select an owner.");
      return false;
    }

    if (startDateController.text.trim().isEmpty) {
      showValidationMessage(context, "Please select a start date.");
      return false;
    }
    if (formattedDate(startDateController.text.trim()) == 'Invalid Date') {
      showValidationMessage(context, "Please select a start date.");
      return false;
    }
    if (endDateController.text.trim().isEmpty) {
      showValidationMessage(context, "Please select an end date.");
      return false;
    }
    if (formattedDate(endDateController.text.trim()) == 'Invalid Date') {
      showValidationMessage(context, "Please select a end date.");
      return false;
    }
    return true; // All fields are valid
  }

  // Function to show a validation message as a SnackBar
  void showValidationMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _showDatePickerDialog(BuildContext context) async {
    debugPrint('_showDatePickerDialog');
    _initializeBlockedRanges();

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
                  initialSelectedRange: PickerDateRange(
                    _selectedRange?.startDate ?? today,
                    _selectedRange?.endDate ?? today,
                  ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      _selectedRange != null &&
                              _selectedRange!.startDate != null &&
                              _selectedRange!.endDate != null
                          ? () {
                            setState(() {
                              debugPrint('ok pressed');
                              startDate = _selectedRange!.startDate;
                              endDate = _selectedRange!.endDate;
                              startDateController.text =dateTime2String(startDate);

                              endDateController.text =dateTime2String(endDate);
                                  ;
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


  void _initializeBlockedRanges() {
    if (selectedEnvironmentList.isNotEmpty) {
      blockedDateRanges =
          selectedEnvironmentList.map((project) {
            return DateTimeRange(
              start: DateTime.parse(
                project.startDate,
              ), // Ensure startDate is valid
              end: DateTime.parse(project.endDate), // Ensure endDate is valid
            );
          }).toList();
      for (var _element in blockedDateRanges) {
        debugPrint('_element: ${_element.start}::${_element.end}');
      }
    } else {
      blockedDateRanges = [];
    }
  }

  void firstRunInit(GlobalAppData data) {
    // Assign globalData properly
    globalData = data;
    environmentList =
        data.environmentData
            .map((e) => e.environment)
            .toSet() // Remove duplicates
            .toList();
    projectList =
        data.projectData.projectDTOList
            .map((e) => e.projectName)
            .toSet()
            .toList();
    managerList =
        data.projectData.projectDTOList
            .map((e) => e.projectManager)
            .toSet()
            .toList();

    selectedEnvironment =
        environmentList.contains(selectedEnvironment)
            ? selectedEnvironment
            : (environmentList.isNotEmpty ? environmentList.first : "");

    selectedEnvironmentList =
        globalData.bookingData.bookingList
            .where((e) => e.environmentName == selectedEnvironment)
            .toList();

    selectedProject =
        projectList.contains(selectedProject)
            ? selectedProject
            : (projectList.isNotEmpty ? projectList.first : "");

    selectedOwner =
        managerList.contains(selectedOwner)
            ? selectedOwner
            : (managerList.isNotEmpty ? managerList.first : "");

    selectedProjectID =
        globalData.projectData.projectDTOList
            .firstWhere((e) => e.projectName == selectedProject)
            .projectId;
    var selectedManager =
        globalData.projectData.projectDTOList
            .firstWhere((e) => e.projectName == selectedProject)
            .projectManager;
    managerList.clear();
    managerList.add(selectedManager);
    selectedOwner = selectedManager;
    debugPrint('new booking firstRunInit called');
  }
}
