class UserModel {
  final int id;
  final String userName;
  final String email;
  final String userRole;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.userRole,
  });

  // Factory constructor to create an instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      userRole: json['userRole'],
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'userRole': userRole,
    };
  }

  // Create a list of users from JSON array
  static List<UserModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }
}
