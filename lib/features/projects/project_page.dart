import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/core/utils/app_utils.dart';
import 'package:prudential_tems/features/environments/presentation/widgets/pagination_widget.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:prudential_tems/features/environments/presentation/widgets/custom_dropdown.dart';
import 'package:prudential_tems/features/environments/presentation/widgets/custom_header.dart';
import 'package:prudential_tems/features/environments/presentation/widgets/custom_table_cell.dart';

import '../../core/utils/utils.dart';
import '../../providers/app_provider.dart';
import '../environments/presentation/widgets/custom_dropdown.dart';
import 'data/models/project_api_response.dart';

class ProjectPage extends ConsumerStatefulWidget {
  const ProjectPage({super.key});

  @override
  ConsumerState<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends ConsumerState<ProjectPage> {
  final TextEditingController _searchController = TextEditingController();
  String? currentlyOpenDropdown;

  String selectedStatus = "All Status";
  String selectedEnvType = "All Types";
  String selectedProject = "All Managers";

  late List<ProjectModel>? mList;
  List<ProjectModel> fullProjectList=[];
  int totalPages=0;
  int currentPage = 1;
  late List<String> uniqueStatuses;
  late List<String> uniqueTypes;
  late List<String> uniqueProjectManagers;

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


  List<String> getUniqueStatuses(List<ProjectModel> projects) => [
    "All Status",
    ...{for (var e in projects) e.status},
  ];

  List<String> getUniqueType(List<ProjectModel> projects) => [
    "All Types",
    ...{for (var e in projects) e.environment},
  ];

  List<String> getUniqueProject(List<ProjectModel> projects) => [
    "All Managers",
    ...{for (var e in projects) e.projectManager},
  ];
  bool _isFirstRun = true;


  @override
  Widget build(BuildContext context) {
    final projectData = ref.watch(projectProvider);
    return projectData.when(
        data: (projectData) {
          if (_isFirstRun) {
            firstRunMethod(projectData);
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
                hintText: "Search projects...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CustomDropdown(label:"Status",options:   uniqueStatuses, onChanged:(val) {
            setState(() {
              selectedStatus = val!;
              _filterTable();
            });
          }),
          const SizedBox(width: 12),
          CustomDropdown(label:"Environment Type",options:   uniqueTypes, onChanged:(val) {
            setState(() {
              selectedEnvType = val!;
              _filterTable();
            });
          }),
          const SizedBox(width: 12),
          CustomDropdown(label:"Project Manager",options:   uniqueProjectManagers,onChanged: (val) {
            setState(() {
              selectedProject = val!;
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
            title: "Project ID",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'id');
            },
            onSortDescending: () {
              _sortTable(param: 'id');
            },
          ),
          CustomTableHeader(
            title: "Project Name",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'name');
            },
            onSortDescending: () {
              _sortTable(param: 'name');
            },

          ),
          CustomTableHeader(
            title: "Project Manager",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'manager');
            },
            onSortDescending: () {
              _sortTable(param: 'manager');
            },

          ),
          CustomTableHeader(
            title: "Environments",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'environmentType');
            },
            onSortDescending: () {
              _sortTable(param: 'environmentType');
            },

          ),
          CustomTableHeader(
            title: "Assigned Periods",
            onSortAscending: () {},
            onSortDescending: () {},
            isAction: true,

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
            title: "Duration",
            onSortAscending: () {
              _sortTable(isAscending: true, param: 'duration');
            },
            onSortDescending: () {
              _sortTable(param: 'duration');
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

  void _filterTable() {
    String query = _searchController.text.toLowerCase();
    List<ProjectModel> copiedList = fullProjectList.map((p) => p.copyWith()).toList();

    setState(() {
      mList = copiedList.where((env) {
        final matchesStatus = selectedStatus == "All Status" || env.status == selectedStatus;
        final matchesEnvType = selectedEnvType == "All Types" || env.environment == selectedEnvType;
        final matchesProject = selectedProject == "All Managers" || env.projectName == selectedProject;
        final matchesSearch = query.isEmpty ||
            env.projectName.toLowerCase().contains(query)/* ||
            env.environment.toLowerCase().contains(query) ||
            env.status.toLowerCase().contains(query)*/;

        return matchesStatus && matchesEnvType && matchesProject && matchesSearch;
      }).toList();

    });
  }

  void _sortTable({required String param, bool isAscending = false}) {
    final dateFormat = DateFormat("MMM dd, yyyy");
    final order = isAscending ? 1 : -1;

    int compare<T extends Comparable>(T a, T b) => a.compareTo(b) * order;

    setState(() {
      fullProjectList.sort((a, b) {
        switch (param) {
          case 'id':
            return compare(a.projectId, b.projectId);
          case 'name':
            return compare(a.projectName, b.projectName);
          case 'manager':
            return compare(a.projectManager, b.projectManager);
          case 'environmentType':
            return compare(a.environment, b.environment);
          case 'endDate':
            return compare(
              dateFormat.parse(a.endDate),
              dateFormat.parse(b.endDate),
            );
          case 'status':
            return compare(a.status, b.status);
          case 'duration':
            return compare(
              calculateDurationInDays(
                startDate: a.startDate,
                endDate: a.endDate,
              ),
              calculateDurationInDays(
                startDate: b.startDate,
                endDate: b.endDate,
              ),
            );
          default:
            return 0;
        }
      });

      mList = fullProjectList.sublist(0, min(10, fullProjectList.length));
      setFiltersToDefault();

    });
  }


  Widget _buildTableRow(ProjectModel env) {
    GlobalKey actionKey = GlobalKey(); // Unique key for each row action button
    GlobalKey action2Key = GlobalKey(); // Unique key for each row action button

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          CustomTableCell(text:env.projectId, ),
          CustomTableCell(text:env.projectName, ),
          CustomTableCell(text:env.projectManager, ),
          CustomTableCell(text:env.environment, ),
          CustomTableCell(text:
            formatDateRange(startDate: env.startDate, endDate: env.endDate),

          ),
          CustomTableCell(text:env.status,  isStatus: true,color: StatusUtils.getStatusColor(env.status),),
          CustomTableCell(text:
            calculateDuration(startDate: env.startDate, endDate: env.endDate),

          ),
          CustomTableCell(text:
            'Action',
              actionIcon: Icons.remove_red_eye_sharp,
              action2Icon: Icons.edit_calendar,
            isAction: true,
            actionKey: actionKey,
            action2Key: action2Key,
            onActionClick: () {
              toastification.show(
                context: context,
                title: SelectableText('onActionClick'),
                description: SelectableText('This is a toast notification!'),
                type: ToastificationType.success,
                // success, error, warning, info
                autoCloseDuration: Duration(seconds: 2),
                // Auto close after 3 seconds
                alignment: Alignment.topRight,
                // Position: topRight, bottomLeft, etc.
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icon(Icons.check_circle, color: Colors.white),
              );
              // _showMenu(context, actionKey);
            },
            onAction2Click: () {
              toastification.show(
                context: context,
                title: SelectableText('onAction2Click'),
                description: SelectableText('This is a toast notification!'),
                type: ToastificationType.success,
                // success, error, warning, info
                autoCloseDuration: Duration(seconds: 2),
                // Auto close after 3 seconds
                alignment: Alignment.topRight,
                // Position: topRight, bottomLeft, etc.
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icon(Icons.check_circle, color: Colors.white),
              );
              // _showMenu(context, action2Key);
            },
          ),
        ],
      ),
    );
  }

  // Widget CustomTableCell(
  //   String text, {
  //   int flex = 1,
  //   bool isStatus = false,
  //   bool isAction = false,
  //   GlobalKey? actionKey,
  //   GlobalKey? action2Key,
  //   VoidCallback? onActionClick,
  //   VoidCallback? onAction2Click,
  // }) {
  //   return Expanded(
  //     flex: flex,
  //     child:
  //         isAction
  //             ? Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 GestureDetector(
  //                   key: actionKey, // Assign key to action button
  //                   onTap: onActionClick,
  //                   child: const Icon(
  //                     Icons.remove_red_eye_sharp,
  //                     size: 18,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 SizedBox(width: 10),
  //                 GestureDetector(
  //                   key: action2Key, // Assign key to action button
  //                   onTap: onAction2Click,
  //                   child: const Icon(
  //                     Icons.edit_calendar,
  //                     size: 18,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //               ],
  //             )
  //             : Container(
  //               margin: EdgeInsets.symmetric(horizontal: 12),
  //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //               decoration:
  //                   isStatus
  //                       ? BoxDecoration(
  //                         color: _getStatusColor(text),
  //                         borderRadius: BorderRadius.circular(12),
  //                       )
  //                       : null,
  //               child: SelectableText(
  //                 text,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.normal,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ),
  //   );
  // }

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
        debugPrint("Open clicked!");
        break;
      case 'Edit':
        debugPrint("Edit clicked!");
        break;
      case 'Delete':
        debugPrint("Delete clicked!");
        break;
    }
  }

  /// Returns a color based on the project status
  // Color _getStatusColor(String status) {
  //   switch (status) {
  //     case "Pending":
  //       return Colors.orange;
  //     case "Completed":
  //       return Colors.blue;
  //     case "Approved":
  //       return Colors.green;
  //     case "On Hold":
  //       return Colors.red;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  Widget _buildContent() {
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
              currentPage: currentPage,
              totalPages: totalPages,
              totalResults: fullProjectList.length,
              resultsPerPage: 10,
              onPageChanged: (newPage) {
                debugPrint("Switched to page: $newPage");
                setState(() {
                  currentPage = newPage;
                  if (currentPage == 1) {
                    mList = fullProjectList.sublist(
                      (currentPage - 1) * 10,
                      (currentPage) * 10,
                    );
                  } else if (currentPage == totalPages) {
                    mList = fullProjectList.sublist((currentPage - 1) * 10 + 1);
                  } else {
                    mList = fullProjectList.sublist(
                      (currentPage - 1) * 10 + 1,
                      (currentPage) * 10,
                    );
                  }
                });
              },
            ),
            // _buildPagination(),
          ],
        ),
      ),
    );
  }

  void firstRunMethod(ProjectApiResponse projectData) {
    fullProjectList = projectData.projectDTOList;

    uniqueStatuses = getUniqueStatuses(fullProjectList);
    uniqueTypes = getUniqueType(fullProjectList);
    uniqueProjectManagers = getUniqueProject(fullProjectList);

    mList = fullProjectList.sublist(0, min(10, fullProjectList.length));
    totalPages = (fullProjectList.length / 10).ceil();

  }

  void setFiltersToDefault() {
     selectedStatus = "All Status";
     selectedEnvType = "All Types";
     selectedProject = "All Managers";

  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      selectedProject = "All Managers";
      selectedEnvType = "All Types";
      selectedStatus = "All Status";
      mList = fullProjectList.sublist(0, min(10, fullProjectList.length));
    });
  }
}
