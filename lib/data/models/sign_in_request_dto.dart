/// Data Transfer Object for sign-in request
class SignInRequestDto {
  final String email;
  final String password;
  final String deviceToken;
  final String deviceType;
  final String role;

  SignInRequestDto({
    required this.email,
    required this.password,
    required this.deviceToken,
    required this.deviceType,
    this.role = 'user',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceToken': deviceToken,
      'deviceType': deviceType,
      'role': role,
    };
  }
}

