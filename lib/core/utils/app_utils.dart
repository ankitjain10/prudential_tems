import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

enum Status { APPROVED, PENDING, CANCELLED,NONE }

class StatusUtils {

  // Function to get color based on status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.cyan;
      case "on hold":
      case 'pending':
        return Colors.orange;
      case 'completed':
      case 'active':
        return Colors.green;
      case "in-progress":
      case "in progress":
        return Colors.blue;
      case "not started":
      case "cancelled":
      case "in active":
      case "rejected":
        return Colors.red;

      // case Status.APPROVED:
      //   return Colors.green;
      // case Status.PENDING:
      //   return Colors.orange;
      // case Status.CANCELLED:
      //   return Colors.red;
      // case Status.NONE:
      //   return Colors.grey;
      default:
        return Colors.grey; // Default color for unknown status
    }
  }

  // Convert string to enum
  static Status stringToStatus(String statusString) {
    // debugPrint('statusString: $statusString');
    return Status.values.firstWhere(
      (e) =>
          e.toString().split('.').last.toLowerCase().trim() ==
          statusString.toLowerCase().trim(),
      orElse: () => Status.NONE, // Default value if string is invalid
    );
  }

  // Convert enum to Camel Case string (e.g., "Approved", "Pending", "Cancelled")
  static String statusToString(Status status) {
    String rawString =
        status.toString().split('.').last.toLowerCase(); // Convert to lowercase
    return rawString[0].toUpperCase() +
        rawString.substring(1); // Capitalize first letter
  }

  /// Returns a color based on the project status
  static Color getEnvironmentStatusColor(String status) {
    switch (status) {
      case "Maintenance":
        return Colors.orange;
      case "In Use":
        return Colors.blue;
      case "Available":
        return Colors.green;
      case "On Hold":
        return Colors.red;
      case "In-Progress":
        return Colors.blue;
      case "Completed":
        return Colors.green;
      case "Not Started":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
