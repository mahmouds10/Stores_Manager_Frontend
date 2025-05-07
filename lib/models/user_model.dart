class UserModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String? gender;
  final int? level;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.gender,
    this.level,
  });

  // Convert Dart object to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'email': email,
      'level': level,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
