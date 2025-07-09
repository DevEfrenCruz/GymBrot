class XpTransactionDto {
  final int xpId;
  final int userId;
  final int amount;
  final String reason;
  final DateTime createdAt;

  XpTransactionDto({
    required this.xpId,
    required this.userId,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });

  factory XpTransactionDto.fromJson(Map<String, dynamic> json) {
    return XpTransactionDto(
      xpId: json['xpId'] as int,
      userId: json['userId'] as int,
      amount: json['amount'] as int,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class AchievementDto {
  final int achievementId;
  final String code;
  final String name;
  final String description;
  final int xpReward;
  final String? badgeImage;

  AchievementDto({
    required this.achievementId,
    required this.code,
    required this.name,
    required this.description,
    required this.xpReward,
    this.badgeImage,
  });

  factory AchievementDto.fromJson(Map<String, dynamic> json) {
    return AchievementDto(
      achievementId: json['achievementId'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      xpReward: json['xpReward'] as int,
      badgeImage: json['badgeImage'] as String?,
    );
  }
}

class UserAchievementDto {
  final int userId;
  final int achievementId;
  final DateTime earnedAt;
  final AchievementDto? achievement;

  UserAchievementDto({
    required this.userId,
    required this.achievementId,
    required this.earnedAt,
    this.achievement,
  });

  factory UserAchievementDto.fromJson(Map<String, dynamic> json) {
    return UserAchievementDto(
      userId: json['userId'] as int,
      achievementId: json['achievementId'] as int,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
      achievement: json['achievement'] != null
          ? AchievementDto.fromJson(json['achievement'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ChallengeDto {
  final int challengeId;
  final String name;
  final String goalType;
  final int goalValue;
  final DateTime weekStart;
  final String? description;

  ChallengeDto({
    required this.challengeId,
    required this.name,
    required this.goalType,
    required this.goalValue,
    required this.weekStart,
    this.description,
  });

  factory ChallengeDto.fromJson(Map<String, dynamic> json) {
    return ChallengeDto(
      challengeId: json['challengeId'] as int,
      name: json['name'] as String,
      goalType: json['goalType'] as String,
      goalValue: json['goalValue'] as int,
      weekStart: DateTime.parse(json['weekStart'] as String),
      description: json['description'] as String?,
    );
  }
}

class UserChallengeDto {
  final int userId;
  final int challengeId;
  final int progress;
  final DateTime? completedAt;
  final ChallengeDto? challenge;

  UserChallengeDto({
    required this.userId,
    required this.challengeId,
    required this.progress,
    this.completedAt,
    this.challenge,
  });

  factory UserChallengeDto.fromJson(Map<String, dynamic> json) {
    return UserChallengeDto(
      userId: json['userId'] as int,
      challengeId: json['challengeId'] as int,
      progress: json['progress'] as int,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      challenge: json['challenge'] != null
          ? ChallengeDto.fromJson(json['challenge'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RewardDto {
  final int rewardId;
  final String name;
  final String type; // virtual / físico
  final int costXp;
  final String? description;
  final String? imageUrl;

  RewardDto({
    required this.rewardId,
    required this.name,
    required this.type,
    required this.costXp,
    this.description,
    this.imageUrl,
  });

  factory RewardDto.fromJson(Map<String, dynamic> json) {
    return RewardDto(
      rewardId: json['rewardId'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      costXp: json['costXp'] as int,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class UserRewardDto {
  final int userId;
  final int rewardId;
  final DateTime redeemedAt;
  final String status;
  final RewardDto? reward;

  UserRewardDto({
    required this.userId,
    required this.rewardId,
    required this.redeemedAt,
    required this.status,
    this.reward,
  });

  factory UserRewardDto.fromJson(Map<String, dynamic> json) {
    return UserRewardDto(
      userId: json['userId'] as int,
      rewardId: json['rewardId'] as int,
      redeemedAt: DateTime.parse(json['redeemedAt'] as String),
      status: json['status'] as String,
      reward: json['reward'] != null
          ? RewardDto.fromJson(json['reward'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DailyStatDto {
  final int statId;
  final int userId;
  final DateTime statDate;
  final int caloriesIn;
  final int caloriesOut;
  final int steps;
  final int? routinesCompleted;
  final int? xpEarned;
  final int? minutesActive;
  final double? weight;
  final String? notes;

  DailyStatDto({
    required this.statId,
    required this.userId,
    required this.statDate,
    required this.caloriesIn,
    required this.caloriesOut,
    required this.steps,
    this.routinesCompleted,
    this.xpEarned,
    this.minutesActive,
    this.weight,
    this.notes,
  });

  factory DailyStatDto.fromJson(Map<String, dynamic> json) {
    return DailyStatDto(
      statId: json['statId'] as int,
      userId: json['userId'] as int,
      statDate: DateTime.parse(json['statDate'] as String),
      caloriesIn: json['caloriesIn'] as int,
      caloriesOut: json['caloriesOut'] as int,
      steps: json['steps'] as int,
      routinesCompleted: json['routinesCompleted'] as int?,
      xpEarned: json['xpEarned'] as int?,
      minutesActive: json['minutesActive'] as int?,
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'statDate': statDate.toIso8601String(),
      'caloriesIn': caloriesIn,
      'caloriesOut': caloriesOut,
      'steps': steps,
      'routinesCompleted': routinesCompleted,
      'xpEarned': xpEarned,
      'minutesActive': minutesActive,
      'weight': weight,
      'notes': notes,
    };
  }
}

class UpdateChallengeProgressRequest {
  final int progress;

  UpdateChallengeProgressRequest({
    required this.progress,
  });

  Map<String, dynamic> toJson() {
    return {
      'progress': progress,
    };
  }
}
