
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prudential_tems/features/bookings/domain/entity/booking_form.dart';

import '../models/booking_api_response.dart';


class BookingRepository {
  final Dio _dio;

  BookingRepository(this._dio);

  Future<BookingApiResponse> fetchAllBookings() async {
    try {
      Response response = await _dio.get('/booking/all');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data == null || data.isEmpty) {
          throw Exception("Received empty response from the server.");
        }
        debugPrint('BookingApiResponse fetched');

        return BookingApiResponse.fromJson(data);
      } else {
        throw Exception("Failed to load environments");
      }
    } on DioException catch (e) {
      throw Exception("Network Error: ${e.message}");
    }  catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Booking> createBooking(BookingForm booking) async {
    try {
      debugPrint('booking form : ${booking.toJson()}');
      Response response = await _dio.post('/booking/create',
          options: Options(headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
          }),
          data: booking.toJson() );
      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final data = response.data;

        if (data == null || data.isEmpty) {
          throw Exception("Received empty response from the server.");
        }
        return Booking.fromJson(data);
      } else {
        throw Exception("Failed to load environments");
      }
    } on DioException catch (e) {
      throw Exception("Network Error: ${e.message}");
    }  catch (e) {
      throw Exception("Error: $e");
    }
  }


}
