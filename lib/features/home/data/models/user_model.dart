enum UserRole { PROJECT_MANAGER, ENGINEER, ADMIN }

String formatEnum(UserRole? role) {
  return role?.name
      .toLowerCase() // Convert to lowercase
      .split('_') // Split at underscores
      .map((word) => word[0].toUpperCase() + word.substring(1)) // Capitalize each word
      .join(' ')??'NA'; // Join words with spaces
}

class User {
  final String name;
  final String profilePic;
  final UserRole role;

  User({
    required this.name,
    required this.profilePic,
    required this.role,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      profilePic: json['profilePic'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.' + json['role']),
    );
  }

  // Convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profilePic': profilePic,
      'role': role.toString().split('.').last,
    };
  }
}

// Example users
final User userManager = User(name: "Alice Johnson", profilePic: "alice.jpg", role: UserRole.PROJECT_MANAGER);
final User userEngineer = User(name: "John Doe", profilePic: "bob.jpg", role: UserRole.ENGINEER);
final User userAdmin = User(name: "Charlie Davis", profilePic: "charlie.jpg", role: UserRole.ADMIN);