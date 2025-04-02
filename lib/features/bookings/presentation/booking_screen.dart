import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/features/bookings/presentation/widget/new_booking_sheet.dart';
import 'package:prudential_tems/providers/app_provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../core/utils/app_utils.dart';
import '../../../core/utils/utils.dart';
import '../../environments/presentation/widgets/custom_dropdown.dart';
import '../../environments/presentation/widgets/custom_header.dart';
import '../../environments/presentation/widgets/custom_table_cell.dart';
import '../../environments/presentation/widgets/pagination_widget.dart';
import '../data/models/booking_api_response.dart';
import 'widget/calendar_view.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}


class _BookingScreenState extends ConsumerState<BookingScreen> {
  // Generate dummy data list
  final TextEditingController _searchController = TextEditingController();
  String? currentlyOpenDropdown;

  String selectedStatus = "All Status";
  String selectedEnvType = "All Types";
  String selectedProject = "All Projects";

  List<Booking> fullBookingList=[];
  late List<Booking>? bookingList;

  int currentPage = 1;
  int totalPages=0;
  late List<String> uniqueStatuses;
  late List<String> uniqueTypes;
  late List<String> uniqueProjects;

  List<String> getUniqueStatuses(List<Booking> dummyBookings) => [
    "All Status",
    ...{for (var e in dummyBookings) e.status},
  ];

  List<String> getUniqueType(List<Booking> dummyBookings) => [
    "All Types",
    ...{for (var e in dummyBookings) e.environmentName},
  ];

  List<String> getUniqueProject(List<Booking> dummyBookings) => [
    "All Projects",
    ...{for (var e in dummyBookings) e.projectName},
  ];

  bool _isFirstRun = true;

  bool filterEnabled=false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTable); // ✅ Listen for text input changes
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingData = ref.watch(bookingProvider);

    return bookingData.when(
      data: (bookingData) {
        // debugPrint('build called');
        if (_isFirstRun) {
          firstRunMethod(bookingData);
          _isFirstRun = false; // ✅ Prevents calling again
        }
        return _buildContent();
      },
      loading: () => const Center(child: CircularProgressIndicator()), // Show Loader
      error: (error, stackTrace) => Center(child: Text('Error: $error')), // Show Error
    );

  }

  Widget _buildFilters() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search Projects...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CustomDropdown(label: "Project",options:  uniqueProjects, onChanged:(val) {
            setState(() {
              selectedProject = val!;
              _filterTable();
            });
          }),
          const SizedBox(width: 12),
          CustomDropdown(label: "Environment Type",options:  uniqueTypes, onChanged:(val) {
            setState(() {
              selectedEnvType = val!;
              _filterTable();
            });
          }),
          const SizedBox(width: 12),
          CustomDropdown(label: "Status",options:  uniqueStatuses, onChanged: (val) {
            setState(() {
              selectedStatus = val!;
              _filterTable();
            });
          }),
          const SizedBox(width: 12),
          /// 🔹 Clear Filters Button
          ElevatedButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear, size: 20,color: Colors.white,),
            label: const Text("Clear"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      selectedProject = "All Projects";
      selectedEnvType = "All Types";
      selectedStatus = "All Status";
      filterEnabled=false;
      bookingList = fullBookingList.sublist(0, min(10, fullBookingList.length));
    });
  }
  /// Builds a ListView wrapped in a Card with rounded corners and a white background.
  Widget _buildListView() {
    return Card(
      elevation: 4, // Adds shadow for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      color: Colors.white, // Background color
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        child: ListView(
          shrinkWrap: true,
          // Prevents unnecessary scrolling if used inside another scrollable widget
          physics: ClampingScrollPhysics(),
          // Prevents unnecessary scrolling issues
          children: [
            _buildTableHeader(),
            ...?bookingList?.map((env) => _buildTableRow(env)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.blueGrey,
      child: Row(
        children: [
          CustomTableHeader(
            title: "Project",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'project');
            },
            onSortDescending: () {
              _sortTable(param: 'project');
            },
            flex: 1,
          ),
          CustomTableHeader(
            title: "Environment",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'environment');
            },
            onSortDescending: () {
              _sortTable(param: 'environment');
            },
          ),

          CustomTableHeader(
            title: "Start Date",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'startDate');
            },
            onSortDescending: () {
              _sortTable(param: 'startDate');
            },
            flex: 1,
          ),
          CustomTableHeader(
            title: "End Date",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'endDate');
            },
            onSortDescending: () {
              _sortTable(param: 'endDate');
            },
            flex: 1,
          ),
          CustomTableHeader(
            title: "Status",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'status');
            },
            onSortDescending: () {
              _sortTable(param: 'status');
            },
            flex: 1,
          ),

        ],
      ),
    );
  }

  Widget _buildTableRow(Booking env) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ), // Grey Divider
        ),
      ),
      child: Row(
        children: [
          CustomTableCell(text:env.projectName),
          CustomTableCell(text:env.environmentName),
          CustomTableCell(text:formatDate(env.startDate)),
          CustomTableCell(text:formatDate(env.endDate)),
          CustomTableCell(text:env.status, isStatus: true,color: StatusUtils.getStatusColor(env.status)),
        ],
      ),
    );
  }



  void _sortTable({required String param, bool isAscending = false}) {
    final order = isAscending ? 1 : -1;

    int compare<T extends Comparable>(T a, T b) => a.compareTo(b) * order;
    // List<Booking> copiedList = fullBookingList.map((p) => p.copy()).toList();
    setState(() {
      fullBookingList.sort((a, b) {
        switch (param) {
          case 'project':
            return compare(a.projectName, b.projectName);
          case 'environment':
            return compare(a.environmentName, b.environmentName);
          case 'startDate':
            return compare(
              dateFormat.parse(a.startDate),
              dateFormat.parse(b.startDate),
            );
          case 'endDate':
            return compare(dateFormat.parse(a.endDate), dateFormat.parse(b.endDate));
          case 'status':
            return compare(a.status, b.status);
          default:
            return 0;
        }
      });
      bookingList = fullBookingList.sublist(0, min(10, fullBookingList.length));
      setFiltersToDefault();
    });
  }


  void _filterTable() {
    String query = _searchController.text.toLowerCase();
    List<Booking> copiedList = fullBookingList.map((p) => p.copy()).toList();

    setState(() {
      bookingList = copiedList.where((env) {
        final matchesStatus = selectedStatus == "All Status" || env.status == selectedStatus;
        final matchesEnvType = selectedEnvType == "All Types" || env.environmentName == selectedEnvType;
        final matchesProject = selectedProject == "All Projects" || env.projectName == selectedProject;
        final matchesSearch = query.isEmpty ||
            env.projectName.toLowerCase().contains(query) /*||
            env.environmentName.toLowerCase().contains(query) ||
            env.status.toLowerCase().contains(query)*/;

        return matchesStatus && matchesEnvType && matchesProject && matchesSearch;
      }).toList();

      if(bookingList?.isNotEmpty??false){
        filterEnabled=true;
      }
    });
  }


  // Displays the new booking form in a side sheet
  void _showNewBookingSideSheet(BuildContext context) {
    WoltModalSheet.show(
      context: context,
      pageListBuilder:
          (context) => [
            WoltModalSheetPage(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              hasTopBarLayer: true,
              topBarTitle: const SelectableText("New Booking"),
              trailingNavBarWidget: IconButton(
                icon: const Icon(Icons.close),
                onPressed:
                    () => Navigator.pop(context), // Closes the side sheet
              ),
              child: NewBookingSheet(fullBookingList:fullBookingList),
            ),
          ],
      enableDrag: false, // Prevents dragging to close
      modalTypeBuilder: (context) {
        return WoltSideSheetType().copyWith(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
        );
      }, // Displays as a side sheet
    );
  }

  // Builds the weekly calendar view
  Widget _buildCalendarView(BuildContext context) {

    return WeekCalendarPage(fullBookingList: fullBookingList,onPressed:(){
      _showNewBookingSideSheet(
        context,
      );
    },
      minDays:-30 ,maxDays: 30,
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child:  Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Builds the top calendar navigation controls
            _buildCalendarView(context),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: SelectableText(
                'Recent Bookings',
                style: TextStyle(color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,),
              ),
            ),
            SizedBox(height: 12),

            _buildFilters(),

            const SizedBox(height: 12),
            Flexible(fit: FlexFit.loose, child: _buildListView()),
            PaginationWidget(
              filterEnabled:filterEnabled,
              currentPage: currentPage,
              totalPages: totalPages,
              totalResults: fullBookingList.length,
              resultsPerPage: 10,
              onPageChanged: (newPage) {
                // print("Switched to page: $newPage");
                setState(() {
                  currentPage = newPage;

                  int startIndex = (currentPage - 1) * 10;
                  int endIndex = startIndex + 10;

                  // Ensure we don't go out of bounds
                  if (endIndex > fullBookingList.length) {
                    endIndex = fullBookingList.length;
                  }

                  bookingList = fullBookingList.sublist(startIndex, endIndex);

                });
              },
            ),

          ],
        ),
      ),
    );

  }

  void firstRunMethod(bookingData) {
    fullBookingList = bookingData.bookingList;

    uniqueStatuses = getUniqueStatuses(fullBookingList);
    uniqueTypes = getUniqueType(fullBookingList);
    uniqueProjects = getUniqueProject(fullBookingList);

    bookingList = fullBookingList.sublist(0, min(10, fullBookingList.length));
    totalPages = (fullBookingList.length / 10).ceil();
  }

  void setFiltersToDefault() {
     _searchController.clear();
     selectedStatus = "All Status";
     selectedEnvType = "All Types";
     selectedProject = "All Projects";
     filterEnabled=false;

  }



}


