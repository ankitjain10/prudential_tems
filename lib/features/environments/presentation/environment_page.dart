import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/features/environments/presentation/viewmodels/environment_view_model.dart';
import 'package:prudential_tems/features/environments/presentation/widgets/custom_dropdown.dart';
import 'package:prudential_tems/features/environments/presentation/widgets/custom_header.dart';
import 'package:prudential_tems/features/environments/presentation/widgets/custom_table_cell.dart';
import 'package:prudential_tems/features/environments/presentation/widgets/pagination_widget.dart';

import '../../../core/utils/app_utils.dart';
import '../../../core/utils/utils.dart';
import '../../../providers/app_provider.dart';
import '../data/models/environment_api_response.dart';

class EnvironmentPage extends ConsumerStatefulWidget {
  const EnvironmentPage({super.key});

  @override
  ConsumerState<EnvironmentPage> createState() => _EnvironmentPageState();
}

class _EnvironmentPageState extends ConsumerState<EnvironmentPage> {
  final TextEditingController _searchController = TextEditingController();
  String? currentlyOpenDropdown;

  String selectedStatus = "All Status";
  String selectedEnvType = "All Types";
  String selectedProject = "All Projects";

  late List<Environment>? mList;
  List<Environment> fullEnvironmentList=[];

  int currentPage = 1;
  late List<String> uniqueStatuses;
  late List<String> uniqueTypes;
  late List<String> uniqueProjects;


  List<String> getUniqueStatuses(List<Environment> environments) => [
    "All Status",
    ...{for (var e in environments) e.status},
  ];

  List<String> getUniqueType(List<Environment> environments) => [
    "All Types",
    ...{for (var e in environments) e.type},
  ];

  List<String> getUniqueProject(List<Environment> environments) => [
    "All Projects",
    ...{for (var e in environments) e.projectName},
  ];
  bool _isFirstRun = true;

  var filterEnabled=false;

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
    final environmentData = ref.watch(environmentViewModelProvider);

    return environmentData.when(
      data: (environmentApiResponse) {
        if (environmentApiResponse==null||environmentApiResponse.isEmpty) {
          return _buildNoDataMessage(); // Handle empty data case
        }

        if (_isFirstRun) {
          firstRunMethod(environmentApiResponse);
          _isFirstRun = false; // ✅ Prevents calling again
        }

        return _buildUI();
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => _buildErrorMessage(err.toString()),
    );


  }

  /// Displays an error message when API fails
  Widget _buildErrorMessage(String error) {
    debugPrint("Failed to load data: $error");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          Text(
            "Failed to load data: $error",
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => ref.refresh(environmentProvider),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  /// Shows a message if no data is available
  Widget _buildNoDataMessage() {
    return const Center(
      child: Text(
        "No environments found.",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }


  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
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
                hintText: "Search environments...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CustomDropdown(
            label: "Status",
            options: uniqueStatuses,
            onChanged: (val) {
              setState(() {
                debugPrint('environments : onChanged called');
                selectedStatus = val!;
                _filterTable();
              });
            },
          ),
          const SizedBox(width: 12),
          CustomDropdown(
            label: "Environment Type",
            options: uniqueTypes,
            onChanged: (val) {
              setState(() {
                selectedEnvType = val!;
                _filterTable();
              });
            },
          ),
          const SizedBox(width: 12),
          CustomDropdown(
            label: "Project",
            options: uniqueProjects,
            onChanged: (val) {
              setState(() {
                selectedProject = val!;
                _filterTable();
              });
            },
          ),
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
            ...?mList?.map((env) => _buildTableRow(env)),
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
            title: "Environment Name",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'id');
            },
            onSortDescending: () {
              _sortTable(param: 'id');
            },
          ),
          CustomTableHeader(
            title: "Type",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'type');
            },
            onSortDescending: () {
              _sortTable(param: 'type');
            },
          ),
          CustomTableHeader(
            title: "Project Name",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'project');
            },
            onSortDescending: () {
              _sortTable(param: 'project');
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
          ),
          CustomTableHeader(
            title: "End Date",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'endDate');
            },
            onSortDescending: () {
              _sortTable(param: 'endDate');
            },
          ),
          CustomTableHeader(
            title: "Status",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'status');
            },
            onSortDescending: () {
              _sortTable(param: 'status');
            },
          ),
          CustomTableHeader(
            title: "Assigned Engineer",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'engineer');
            },
            onSortDescending: () {
              _sortTable(param: 'engineer');
            },
          ),
          CustomTableHeader(
            title: "Action",
            onSortAscending: () {},
            onSortDescending: () {},
            isAction: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Environment env) {
    GlobalKey actionKey = GlobalKey(); // Unique key for each row action button

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
          CustomTableCell(text: env.environment),
          CustomTableCell(text: env.type),
          CustomTableCell(text: env.projectName),
          CustomTableCell(text: formatDate(env.startDate)),
          CustomTableCell(text: formatDate(env.endDate)),
          CustomTableCell(
            text: env.status,
            isStatus: true,
            color: StatusUtils.getStatusColor(env.status),
          ),
          CustomTableCell(text: env.assignedEngineer),
          CustomTableCell(
            text: 'Action',
            isAction: true,
            actionIcon: Icons.more_vert,
            actionKey: actionKey,
            onActionClick: () {
              _showMenu(context, actionKey);
            },
          ),
        ],
      ),
    );
  }

  void _filterTable() {
    String query = _searchController.text.toLowerCase();
    List<Environment> copiedList = fullEnvironmentList.map((p) => p.copy()).toList();
    setState(() {
      mList = copiedList.where((env) {
        final matchesStatus = selectedStatus == "All Status" || env.status == selectedStatus;
        final matchesEnvType = selectedEnvType == "All Types" || env.type == selectedEnvType;
        final matchesProject = selectedProject == "All Projects" || env.projectName == selectedProject;
        final matchesSearch = query.isEmpty ||
            env.environment.toLowerCase().contains(query)/* ||
            env.type.toLowerCase().contains(query) ||
            env.status.toLowerCase().contains(query)*/;

        return matchesStatus && matchesEnvType && matchesProject && matchesSearch;
      }).toList();
      if(mList?.isNotEmpty??false){
        filterEnabled=true;
      }


    });
  }

  void _sortTable({required String param, bool isAscending = false}) {
    final order = isAscending ? 1 : -1;

    int compare<T extends Comparable>(T a, T b) => a.compareTo(b) * order;

    setState(() {
      fullEnvironmentList.sort((a, b) {
        switch (param) {
          case 'id':
            return compare(a.environment, b.environment);
          case 'type':
            return compare(a.type, b.type);
          case 'project':
            return compare(a.projectName, b.projectName);
          case 'startDate':
            return compare(
              dateFormat.parse(a.startDate),
              dateFormat.parse(b.startDate),
            );
          case 'endDate':
            return compare(dateFormat.parse(a.endDate), dateFormat.parse(b.endDate));
          case 'status':
            return compare(a.status, b.status);
          case 'engineer':
            return compare(a.assignedEngineer, b.assignedEngineer);
          default:
            return 0;
        }
      });
      mList = fullEnvironmentList.sublist(0, min(10, fullEnvironmentList.length));
      setFiltersToDefault();

    });
  }

  void _showMenu(BuildContext context, GlobalKey key) async {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'Open',
          child: ListTile(
            leading: Icon(Icons.open_in_new, color: Colors.blue),
            title: SelectableText('Open'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.orange),
            title: SelectableText('Edit'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: SelectableText('Delete'),
          ),
        ),
      ],
    );

    if (result != null) {
      _handleMenuSelection(result);
    }
  }

  // Callback method for each menu option
  void _handleMenuSelection(String option) {
    switch (option) {
      case 'Open':
        print("Open clicked!");
        break;
      case 'Edit':
        print("Edit clicked!");
        break;
      case 'Delete':
        print("Delete clicked!");
        break;
    }
  }

  Widget _buildUI() {
    int totalPages = (fullEnvironmentList.length / 10).ceil();
    // print('envi: ${fullEnvironmentList.length}');
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row(children: [
            //   ElevatedButton.icon(
            //     onPressed: () {
            //       // Handle Export to Excel
            //     },
            //     icon: const Icon(Icons.download,color: Colors.white,),
            //     label: const SelectableText(
            //       "Export to Excel",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            //   ),
            //   const SizedBox(width: 12),
            //   const CircleAvatar(child: Icon(Icons.person)),
            //   const SizedBox(width: 16),
            // ],),
            // SizedBox(height: 20,),
            _buildFilters(),
            const SizedBox(height: 12),
            Flexible(fit: FlexFit.loose, child: _buildListView()),
            PaginationWidget(
              filterEnabled:filterEnabled,
              currentPage: currentPage,
              totalPages: totalPages,
              totalResults: fullEnvironmentList.length,
              resultsPerPage: 10,
              onPageChanged: (newPage) {
                setState(() {
                  currentPage = newPage;

                  int startIndex = (currentPage - 1) * 10;
                  int endIndex = startIndex + 10;

                  // Ensure the endIndex does not exceed the list length
                  if (endIndex > fullEnvironmentList.length) {
                    endIndex = fullEnvironmentList.length;
                  }

                  mList = fullEnvironmentList.sublist(startIndex, endIndex);

                });
              },
            ),
            // _buildPagination(),
          ],
        ),
      ),
    );
  }

  void firstRunMethod(List<Environment> environmentApiResponse) {
    fullEnvironmentList = environmentApiResponse;
    mList = fullEnvironmentList.sublist(0, min(10, fullEnvironmentList.length));
    uniqueStatuses = getUniqueStatuses(fullEnvironmentList);
    uniqueTypes = getUniqueType(fullEnvironmentList);
    uniqueProjects = getUniqueProject(fullEnvironmentList);
    mList = fullEnvironmentList.sublist(0, min(10, fullEnvironmentList.length));

  }

  void setFiltersToDefault() {
    _searchController.clear();
     selectedStatus = "All Status";
     selectedEnvType = "All Types";
     selectedProject = "All Projects";
    filterEnabled=false;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      selectedStatus = "All Status";
      selectedEnvType = "All Types";
      selectedProject = "All Projects";
      filterEnabled=false;
      mList = fullEnvironmentList.sublist(0, min(10, fullEnvironmentList.length));
    });
  }

}
