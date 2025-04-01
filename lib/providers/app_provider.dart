import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/features/bookings/domain/entity/booking_form.dart';
import 'package:prudential_tems/features/home/data/repositories/user_repository.dart';
import 'package:prudential_tems/features/projects/data/models/project_api_response.dart';
import 'package:prudential_tems/features/projects/data/repositories/project_repository.dart';

import '../features/bookings/data/models/booking_api_response.dart';
import '../features/bookings/data/models/global_app_data.dart';
import '../features/bookings/data/repositories/booking_repository.dart';
import '../features/dashboard/data/model/user.dart';
import '../features/dashboard/data/repository/users_repository.dart';
import '../features/environments/data/models/environment_api_response.dart';
import '../features/environments/data/repositories/environment_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/config/api_config.dart';

// Dio Provider for Dependency Injection
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
});

final environmentRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return EnvironmentRepositoryImpl(dio);
} );

final bookingRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return BookingRepository(dio);
} );

final projectRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return ProjectRepository(dio);
} );

final userRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return UsersRepository(dio);
} );

final environmentProvider = FutureProvider<List<Environment>>((ref) async {
  final repository = ref.watch(environmentRepositoryProvider);
  return repository.fetchAllEnvironments();
});

final bookingProvider = FutureProvider<BookingApiResponse>((ref) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.fetchAllBookings();
});

final projectProvider = FutureProvider<ProjectApiResponse>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.fetchAllProjects();
});

final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.fetchUsers();
});

final globalDataProvider = FutureProvider<GlobalAppData>((ref) async {
  final environmentData = await ref.watch(environmentProvider.future);
  final bookingData = await ref.watch(bookingProvider.future);
  final projectData = await ref.watch(projectProvider.future);
  final usersData = await ref.watch(usersProvider.future);

  return GlobalAppData(
    environmentData: environmentData,
    bookingData: bookingData,
    projectData: projectData,
    userData: usersData
  );
});


// AsyncNotifierProvider for making API call
final createBookingProvider =
AsyncNotifierProvider<CreateBookingNotifier, Booking?>(
      () => CreateBookingNotifier(),
);

class CreateBookingNotifier extends AsyncNotifier<Booking?> {
  @override
  Future<Booking?> build() async {
    return null; // Initial state
  }

  // Function to create a new booking
  Future<AsyncValue<Booking?>> createBooking(BookingForm booking) async {
    state = const AsyncValue.loading(); // Set loading state
    try {
      final service = ref.read(bookingRepositoryProvider);
      final newBooking = await service.createBooking(booking);

      if (newBooking != null) {
        state = AsyncValue.data(newBooking); // Success state
      } else {
        state = AsyncValue.error("Booking creation failed", StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Error state
    }
    return state; // Return the updated state
  }
}

final userProvider = StateProvider<UserModel?>((ref) => null);
