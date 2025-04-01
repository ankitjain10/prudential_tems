import '../../../dashboard/data/model/user.dart';
import '../../../environments/data/models/environment_api_response.dart';
import '../../../projects/data/models/project_api_response.dart';
import 'booking_api_response.dart';

class GlobalAppData {
  final List<Environment> environmentData;
  final BookingApiResponse bookingData;
  final ProjectApiResponse projectData;
  final List<UserModel>? userData;

  GlobalAppData({
    required this.environmentData,
    required this.bookingData,
    required this.projectData,
    required this.userData,
  });
}
