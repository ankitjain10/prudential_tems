
import 'package:dio/dio.dart';

import '../model/user.dart';



class UsersRepository {
  final Dio _dio;

  UsersRepository(this._dio);

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dio.get('/users/all');

      if (response.statusCode == 200) {
        // Parse JSON into a list of UserModel
        List<UserModel> users = UserModel.fromJsonList(response.data);
        return users;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

}
