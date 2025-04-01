
class BookingApiResponse {
  final List<EnvironmentCount> environmentCount;
  final List<Booking> bookingList;

  BookingApiResponse({
    required this.environmentCount,
    required this.bookingList,
  });

  factory BookingApiResponse.fromJson(Map<String, dynamic> json) {
    return BookingApiResponse(
      environmentCount: (json['environmentCount'] as List?)
          ?.map((e) => EnvironmentCount.fromJson(e))
          .toList() ??
          [],
      bookingList: (json['bookingList'] as List?)
          ?.map((e) => Booking.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environmentCount': environmentCount.map((e) => e.toJson()).toList(),
      'bookingList': bookingList.map((e) => e.toJson()).toList(),
    };
  }
}

class EnvironmentCount {
  final String environmentName;
  final int count;

  EnvironmentCount({
    required this.environmentName,
    required this.count,
  });

  factory EnvironmentCount.fromJson(Map<String, dynamic> json) {
    return EnvironmentCount(
      environmentName: json['environmentName'] ?? 'Unknown',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environmentName': environmentName,
      'count': count,
    };
  }
}

class Booking {
  final String projectName;
  final String startDate;
  final String endDate;
  final String status;
  final String owner;
  final String purpose;
  final String notes;
  final String environmentName;
  final String projectId;
  final int version;
  final String bookingId;

  Booking({
    required this.projectName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.owner,
    required this.purpose,
    required this.notes,
    required this.environmentName,
    required this.projectId,
    required this.version,
    required this.bookingId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      projectName: json['project_name'] ?? 'Unknown',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? 'Unknown',
      owner: json['owner'] ?? 'Unknown',
      purpose: json['purpose'] ?? 'Unknown',
      notes: json['notes'] ?? '',
      environmentName: json['environment_name'] ?? 'Unknown',
      projectId: json['project_id'] ?? '',
      version: json['version'] ?? 0,
      bookingId: json['booking_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_name': projectName,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'owner': owner,
      'purpose': purpose,
      'notes': notes,
      'environment_name': environmentName,
      'project_id': projectId,
      'version': version,
      'booking_id': bookingId,
    };
  }

}

extension BookingCopy on Booking {
  Booking copy() {
    return Booking(
      projectName: this.projectName,
      startDate: this.startDate,
      endDate: this.endDate,
      status: this.status,
      owner: this.owner,
      purpose: this.purpose,
      notes: this.notes,
      environmentName: this.environmentName,
      projectId: this.projectId,
      version: this.version,
      bookingId: this.bookingId,
    );
  }
}