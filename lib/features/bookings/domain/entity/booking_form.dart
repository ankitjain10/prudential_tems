class BookingForm {
  final String projectName;
  final String startDate;
  final String endDate;
  final String owner;
  final String purpose;
  final String notes;
  final String environmentName;
  final String projectId;

  BookingForm({
    required this.projectName,
    required this.startDate,
    required this.endDate,
    required this.owner,
    required this.purpose,
    required this.notes,
    required this.environmentName,
    required this.projectId,
  });

  // Factory method to create an instance from JSON
  factory BookingForm.fromJson(Map<String, dynamic> json) {
    return BookingForm(
      projectName: json['project_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      owner: json['owner'] ?? '',
      purpose: json['purpose'] ?? '',
      notes: json['notes'] ?? '',
      environmentName: json['environment_name'] ?? '',
      projectId: json['project_id'] ?? '',
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      "project_name": projectName,
      "start_date": startDate,
      "end_date": endDate,
      "owner": owner,
      "purpose": purpose,
      "notes": notes,
      "environment_name": environmentName,
      "project_id": projectId,
    };
  }

  @override
  String toString() {
    return "BookingForm(projectName: $projectName, startDate: $startDate, endDate: $endDate, owner: $owner, purpose: $purpose, notes: $notes, environmentName: $environmentName, projectId: $projectId)";
  }
}
