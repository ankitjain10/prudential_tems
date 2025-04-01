import 'dart:convert';

import '../../../bookings/data/models/booking_api_response.dart';

class EnvironmentApiResponse {
  final List<EnvironmentCount> environmentCount;
  final List<Environment> environmentDTOList;

  EnvironmentApiResponse({
    required this.environmentCount,
    required this.environmentDTOList,
  });

  factory EnvironmentApiResponse.fromJson(Map<String, dynamic> json) {
    return EnvironmentApiResponse(
      environmentCount: (json['environmentCount'] as List?)
          ?.map((e) => EnvironmentCount.fromJson(e))
          .toList() ??
          [],
      environmentDTOList: (json['environmentDTOList'] as List?)
          ?.map((e) => Environment.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environmentCount': environmentCount.map((e) => e.toJson()).toList(),
      'environmentDTOList': environmentDTOList.map((e) => e.toJson()).toList(),
    };
  }
}


class Environment {
  final String environment;
  final String type;
  final String projectName;
  final String projectId;
  final String startDate;
  final String endDate;
  final String status;
  final String assignedEngineer;
  final int version;
  late int _projectCount;

  int get projectCount => _projectCount;

  set projectCount(int value) {
    _projectCount = value;
  }

  Environment({
    required this.environment,
    required this.type,
    required this.projectName,
    required this.projectId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.assignedEngineer,
    required this.version,
  });

  factory Environment.fromJson(Map<String, dynamic> json) {
    return Environment(
      environment: json['environmentName'] ?? '',
      type: json['environmentType'] ?? '',
      projectName: json['projectName'] ?? '',
      projectId: json['projectId'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      status: json['statusName'] ?? '',
      assignedEngineer: json['assignedEngineer'] ?? '',
      version: json['version'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environment': environment,
      'type': type,
      'projectName': projectName,
      'projectId': projectId,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'assignedEngineer': assignedEngineer,
      'version': version,
    };
  }

  // Create a list of users from JSON array
  static List<Environment> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Environment.fromJson(json)).toList();
  }
}



extension EnvironmentCopy on Environment {
  Environment copy() {
    return Environment(
      environment:  this.environment,
      type: this.type,
      projectName: this.projectName,
      projectId: this.projectId,
      startDate: this.startDate,
      endDate: this.endDate,
      status: this.status,
      assignedEngineer: this.assignedEngineer,
      version: this.version,

    );
  }
}
