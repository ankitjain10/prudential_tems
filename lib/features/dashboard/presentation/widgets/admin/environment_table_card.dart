import 'package:flutter/material.dart';
import 'package:prudential_tems/core/common_widgets/rounded_text.dart';
import 'package:prudential_tems/core/theme/app_colors.dart';
import 'package:prudential_tems/features/environments/data/models/environment_api_response.dart';

import '../../../../../core/utils/app_utils.dart';
import '../../../../../core/utils/utils.dart';

class EnvironmentTableCard extends StatelessWidget {
  List<Environment>? dataList;

  EnvironmentTableCard({super.key, required this.dataList});

  List<String> headers = [
    "Environment",
    "Type",
    "Project Name",
    "Start Date",
    "End Date",
    "Status",
    "Assigned Engineer",
  ];

  Map<int, TableColumnWidth>? headerWidth = {
    0: FlexColumnWidth(1),
    1: FlexColumnWidth(1),
    2: FlexColumnWidth(1),
    3: FlexColumnWidth(1),
    4: FlexColumnWidth(1),
    5: FlexColumnWidth(1),
    6: FlexColumnWidth(1),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SelectableText(
                  "Environments",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 1), // Divider below title
              // Table with rounded header
              // Table with rounded header and row dividers
              Container(
                // padding: const EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.borderGray,
                    width: 0.5,
                  ), // Black border
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildTableHeader(headers), // Header with rounded corners
                      ...dataList != null
                          ? List.generate(
                            dataList!.length,
                            (index) => _buildTableRow(
                              index + 1,
                              index == 4,
                              dataList![index],
                            ),
                          )
                          : [], // 5 Rows with dividers
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(List<String> headers) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.prudentialGray,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Table(
        columnWidths: headerWidth,
        children: [
          TableRow(
            children: List.generate(
              headers.length,
              (index) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: SelectableText(
                  headers[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(int rowNumber, bool isLastRow, Environment data) {
    return Container(
      decoration: BoxDecoration(
        border:
            isLastRow
                ? null // No border for last row
                : Border(
                  bottom: BorderSide(color: Colors.black26, width: 1),
                ), // Divider line
      ),
      child: Table(
        columnWidths: headerWidth,
        children: [
          TableRow(
            children: [
              _tableCell(text: data.environment),
              _tableCell(text: data.type),
              _tableCell(text: data.projectName),
              _tableCell(text: formatDate(data.startDate)),
              _tableCell(text: formatDate(data.endDate)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RoundedTextWidget(status: data.status ?? ''),
              ),
              _tableCell(text: data.assignedEngineer),

            ],
          ),
        ],
      ),
    );
  }

  // Helper function to style table cells
  Widget _tableCell({String? text}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SelectableText(
        text ?? 'N/A', // Show 'N/A' if value is null
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
