//
// /// Represents an environment model used in a project
// class EnvironmentModel {
//   final String id;
//   final String type;
//   final String project;
//   final String start;
//   final String end;
//   final String status;
//   final String engineer;
//
//   EnvironmentModel({
//     required this.id,
//     required this.type,
//     required this.project,
//     required this.start,
//     required this.end,
//     required this.status,
//     required this.engineer,
//   });
//
//   /// Factory constructor to create an instance from JSON
//   factory EnvironmentModel.fromJson(Map<String, dynamic> json) {
//     return EnvironmentModel(
//       id: json['id'] as String? ?? 'Unknown-ID',
//       type: json['type'] as String? ?? 'Unknown-Type',
//       project: json['project'] as String? ?? 'Unknown-Project',
//       start: json['start'] ,
//       end: json['end'] ,
//       status: json['status'] as String? ?? 'Unknown-Status',
//       engineer: json['engineer'] as String? ?? 'Unknown-Engineer',
//     );
//   }
//
//   /// Converts the model instance to a JSON object
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'type': type,
//       'project': project,
//       'start': start,
//       'end': end,
//       'status': status,
//       'engineer': engineer,
//     };
//   }
// }
//
// /// Generates a list of sample EnvironmentModel instances
// final List<EnvironmentModel> environments = List.generate(126, (index) {
//   final List<String> types = ["DEV", "SIT", "UAT", "E2E", "PROD"];
//   final List<String> projects = [
//     "Project Alpha", "Project Beta", "Project Gamma", "Project Delta",
//     "Project Epsilon", "Project Zeta", "Project Theta", "Project Omega"
//   ];
//   final List<String> statuses = ["Available", "Maintenance", "In Use","On Hold"];
//   final List<String> commonNames = [
//     "James Smith", "Robert Johnson", "Michael Williams", "David Brown",
//     "Mary Jones", "Jennifer Garcia", "William Martinez", "Elizabeth Lee"
//   ];
//
//   return EnvironmentModel(
//     id: "ENV-${index + 1}",
//     type: types[index % types.length],
//     project: projects[index % projects.length],
//     start: "Jan ${(index%28)+1}, 2025",
//     end: "Feb ${(index%28)+1}, 2025",
//     status: statuses[index % statuses.length],
//     engineer: commonNames[index % commonNames.length],
//   );
// });
//
// /// Converts a list of JSON objects to a list of EnvironmentModel instances
// List<EnvironmentModel> parseEnvironmentList(List<dynamic> jsonList) {
//   return jsonList.map((json) => EnvironmentModel.fromJson(json)).toList();
// }
