class UserDto {
  final int userId;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final int currentXp;
  final LevelDto currentLevel;
  final String? firstName;
  final String? lastName;
  final String? nickname;
  final DateTime? dateOfBirth;
  final String? gender;
  final double? weight;
  final double? height;
  final String? fitnessGoal;
  final String? experienceLevel;
  final bool? hasCompletedOnboarding;
  final DateTime? onboardingCompletedAt;
  final int? totalRoutinesCompleted;
  final int? totalAchievements;
  final int? currentStreak;

  UserDto({
    required this.userId,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    required this.currentXp,
    required this.currentLevel,
    this.firstName,
    this.lastName,
    this.nickname,
    this.dateOfBirth,
    this.gender,
    this.weight,
    this.height,
    this.fitnessGoal,
    this.experienceLevel,
    this.hasCompletedOnboarding,
    this.onboardingCompletedAt,
    this.totalRoutinesCompleted,
    this.totalAchievements,
    this.currentStreak,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['userId'] as int,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      currentXp: json['currentXp'] as int,
      currentLevel:
          LevelDto.fromJson(json['currentLevel'] as Map<String, dynamic>),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      nickname: json['nickname'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'] as String?,
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      height:
          json['height'] != null ? (json['height'] as num).toDouble() : null,
      fitnessGoal: json['fitnessGoal'] as String?,
      experienceLevel: json['experienceLevel'] as String?,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool?,
      onboardingCompletedAt: json['onboardingCompletedAt'] != null
          ? DateTime.tryParse(json['onboardingCompletedAt'])
          : null,
      totalRoutinesCompleted: json['totalRoutinesCompleted'] as int?,
      totalAchievements: json['totalAchievements'] as int?,
      currentStreak: json['currentStreak'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'currentXp': currentXp,
      'currentLevel': currentLevel.toJson(),
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'weight': weight,
      'height': height,
      'fitnessGoal': fitnessGoal,
      'experienceLevel': experienceLevel,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'onboardingCompletedAt': onboardingCompletedAt?.toIso8601String(),
      'totalRoutinesCompleted': totalRoutinesCompleted,
      'totalAchievements': totalAchievements,
      'currentStreak': currentStreak,
    };
  }
}

class LevelDto {
  final int levelId;
  final String name;
  final int xpMin;
  final int xpMax;
  final String? badgeImage;

  LevelDto({
    required this.levelId,
    required this.name,
    required this.xpMin,
    required this.xpMax,
    this.badgeImage,
  });

  factory LevelDto.fromJson(Map<String, dynamic> json) {
    return LevelDto(
      levelId: json['levelId'] as int,
      name: json['name'] as String,
      xpMin: json['xpMin'] as int,
      xpMax: json['xpMax'] as int,
      badgeImage: json['badgeImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelId': levelId,
      'name': name,
      'xpMin': xpMin,
      'xpMax': xpMax,
      'badgeImage': badgeImage,
    };
  }
}
