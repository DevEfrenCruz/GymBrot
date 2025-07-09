class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String? avatarUrl;

  RegisterRequest({
    required this.email,
    required this.password,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'avatarUrl': avatarUrl,
    };
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class CompleteProfileRequest {
  final String email;
  final String? firstName;
  final String? lastName;
  final String? nickname;
  final DateTime? dateOfBirth;
  final String? gender;
  final double? weight;
  final double? height;
  final String? fitnessGoal;
  final String? experienceLevel;

  CompleteProfileRequest({
    required this.email,
    this.firstName,
    this.lastName,
    this.nickname,
    this.dateOfBirth,
    this.gender,
    this.weight,
    this.height,
    this.fitnessGoal,
    this.experienceLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'weight': weight,
      'height': height,
      'fitnessGoal': fitnessGoal,
      'experienceLevel': experienceLevel,
    };
  }
}
