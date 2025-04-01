// import 'package:intl/intl.dart';
//
// class ProjectModel {
//   final String id;
//   final String name;
//   final String manager;
//   final String environmentType;
//   final String startDate;
//   final String endDate;
//   final String status;
//
//   ProjectModel({
//     required this.id,
//     required this.name,
//     required this.manager,
//     required this.environmentType,
//     required this.startDate,
//     required this.endDate,
//     required this.status,
//   });
//
//   // Factory constructor for creating a new instance from a map
//   factory ProjectModel.fromJson(Map<String, dynamic> json) {
//     return ProjectModel(
//       id: json['id'],
//       name: json['name'],
//       manager: json['manager'],
//       environmentType: json['environmentType'],
//       startDate: json['startDate'],
//       endDate: json['endDate'],
//       status: json['status'],
//     );
//   }
//
//   // Method to convert an instance into a map
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'manager': manager,
//       'environmentType': environmentType,
//       'startDate': startDate,
//       'endDate': endDate,
//       'status': status,
//     };
//   }
// }
//
// final List<ProjectModel> projects = List.generate(112, (index) {
//   final List<String> projectNames = [
//     "Project Alpha",
//     "Project Beta",
//     "Project Gamma",
//     "Project Delta",
//     "Project Epsilon",
//     "Project Zeta",
//     "Project Theta",
//     "Project Omega",
//   ];
//   final List<String> managers = [
//     "James Robert Smith",
//     "Robert Johnson",
//     "Michael J. Williams",
//     "David Michael Brown",
//     "Mary David Jones",
//     "Jennifer Garcia",
//     "William Joseph Martinez",
//     "Elizabeth William Lee",
//     "Joseph William Wilson",
//     "Susan William Anderson",
//     "David Michael Thomas",
//     "Sarah M. White",
//   ];
//   final List<String> environmentTypes = ["DEV", "SIT", "UAT", "E2E", "PROD"];
//   final List<String> statuses = ["Pending", "Approved", "Completed", "On Hold"];
//   String getEndDate(int index) {
//     String month = (index % 2 == 0) ? "Feb" : "Jan";
//     int day = (index % 28) + 1;
//     return "$month $day, 2025";
//   }
//
//   return ProjectModel(
//     id: "PROJ-${index + 1}",
//     name: projectNames[index % projectNames.length],
//     manager: managers[index % managers.length],
//     environmentType: environmentTypes[index % environmentTypes.length],
//     startDate: "Jan ${(index % 28) + 1}, 2025",
//     endDate: getEndDate(index),
//     status: statuses[index % statuses.length],
//   );
// });
