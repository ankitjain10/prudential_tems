class ProjectApiResponse {
  final int activeProjectCount;
  final List<ProjectModel> projectDTOList;

  ProjectApiResponse({
    required this.activeProjectCount,
    required this.projectDTOList,
  });

  factory ProjectApiResponse.fromJson(Map<String, dynamic> json) {
    return ProjectApiResponse(
      activeProjectCount: json['activeProjectCount'] ?? 0,
      projectDTOList: (json['projectDTOList'] as List<dynamic>?)
          ?.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeProjectCount': activeProjectCount,
      'projectDTOList': projectDTOList.map((e) => e.toJson()).toList(),
    };
  }
}

class ProjectModel {
  final String projectId;
  final String projectName;
  final String projectManager;
  final String environment;
  final String status;
  final String startDate;
  final String endDate;
  final int version;

  ProjectModel({
    required this.projectId,
    required this.projectName,
    required this.projectManager,
    required this.environment,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.version,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['projectId'] ?? '',
      projectName: json['projectName'] ?? 'Unknown',
      projectManager: json['projectManager'] ?? 'Unknown',
      environment: json['environment_name'] ?? json['environmentName'] ??'Unknown',
      status: json['status'] ?? 'Unknown',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      version: json['version'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'projectManager': projectManager,
      'environment_name': environment,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'version': version,
    };
  }
}
extension ProjectModelCopy on ProjectModel {
  ProjectModel copyWith({
    String? projectId,
    String? projectName,
    String? projectManager,
    String? environment,
    String? status,
    String? startDate,
    String? endDate,
    int? version,
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      projectManager: projectManager ?? this.projectManager,
      environment: environment ?? this.environment,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      version: version ?? this.version,
    );
  }
}

